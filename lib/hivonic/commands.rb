require 'time'

using Hivonic::Common::StringHelper unless RUBY_VERSION < '2.0'

module Hivonic::Commands
  def self.run(cmd, opts, args)
    handler            = handler_for cmd
    output, exitstatus = handler.run opts, args

    # Send Subcommand output to STDOUT
    puts output unless output.nil? || output.empty?

    # Return exit status
    exitstatus
  end

  def self.normalize_cmd(cmd)
    cmd.to_s.downcase
  end

  def self.handler_for(cmd)
    if @handlers
      @handlers[normalize_cmd(cmd)]
    else
      raise 'Uh Oh!'
    end
  end

  def self.register_handler_for(cmd, handler=nil)
    normalized_cmd = normalize_cmd(cmd)
    handler        = Hivonic::Commands.const_get(normalized_cmd.classify) if handler.nil?

    @handlers ||= {}
    @handlers[normalized_cmd] = handler
  end

  class Subcommand
    attr_reader :regexp
    attr_reader :time_format
    attr_reader :time_group_index
    attr_reader :ttl
    attr_reader :query
    attr_reader :subcommand
    attr_reader :dry_run
    attr_reader :exitstatus

    def initialize(opts, args)
      @regexp           = Regexp.new opts['regexp']
      @time_format      = opts['time-format']
      @time_group_index = opts['time-group-index'].to_i
      @ttl              = opts['ttl'].to_i
      @dry_run          = opts['dry-run']
      @exitstatus       = 1
    end

    def self.run(opts, args)
      output, exitstatus = self.new(opts, args).run
      return output, exitstatus
    end

    def subcommand
      @subcommand = nil
    end

    def output(stdout)
      stdout
    end

    def run
      raise "subcommand can't be nil" if subcommand.nil?

      if dry_run
        stdout      = "DRY RUN: Subcommand => #{subcommand}"
        @exitstatus = 0
      else
        stdout      = `#{subcommand}`
        @exitstatus = $?.exitstatus
      end

      return output(stdout), self.exitstatus
    end

    def successful?
      self.exitstatus == 0
    end

    def is_successful?(status)
      status == 0
    end
  end

  class HiveQueryCommand < Subcommand
    attr_reader :hive_opts
    attr_reader :db

    def initialize(opts, args)
      super
      @hive_opts = opts['hive-opts']
      @db        = args[0]
    end

    def query
      @query = nil
    end

    def subcommand
      @subcommand = "hive #{self.hive_opts} -e \"#{self.query}\""
    end
  end

  class ListTables < HiveQueryCommand
    def is_expired?(time)
      (Time.now.utc - self.ttl) > time
    end

    def is_table_expired?(table)
      match = table.match self.regexp

      if match.nil?
        false
      else
        is_expired? Time.strptime(match[self.time_group_index], self.time_format)
      end
    end

    def filter(stdout)
      lines = stdout.split(/\n/)

      lines.select do |line|
        is_table_expired? line
      end.join("\n")
    end

    def output(stdout)
      if dry_run
        super
      else
        filter(stdout)
      end
    end

    def query
      @query = "USE #{self.db}; SHOW TABLES;"
    end
  end

  register_handler_for :list_tables

  class DropTable < HiveQueryCommand
    attr_reader :table

    def initialize(opts, args)
      super
      @table = args[1]
    end

    def query
      @query = "DROP TABLE #{self.db}.#{self.table};"
    end
  end

  register_handler_for :drop_table

  class CleanupTables < HiveQueryCommand
    def list_tables
      opts                     = {}
      opts['regexp']           = self.regexp
      opts['time-format']      = self.time_format
      opts['time-group-index'] = self.time_group_index
      opts['ttl']              = self.ttl
      opts['hive-opts']        = self.hive_opts

      output, status = ListTables.run opts, [self.db]
      raise 'Uh oh!' unless is_successful? status
      output.split(/\n/)
    end

    def filter(tables)
      tables.select do |table|
        is_table_expired? table
      end
    end

    def build_query
      tables = list_tables

      tables.map do |table|
        opts           = {}
        opts['regexp'] = self.regexp

        DropTable.new(opts, [self.db, table]).query
      end.join(' ')
    end

    def query
      @query = build_query
    end

    def subcommand
      if self.query.nil? || self.query.empty?
        puts 'Nothing to cleanup!'
        Kernel.exit! 0
      else
        super
      end
    end
  end

  register_handler_for :cleanup_tables
end
