using Hivonic::Common::StringHelper unless RUBY_VERSION < '2.0'

class Hivonic::CommandsTest < Test::Unit::TestCase
  context Hivonic::Commands do
    context 'run singleton method' do
      should 'pass opts and args to #run method of the handler' do
        Hivonic::Commands.expects(:handler_for).with(cmd = mock()).returns(handler = mock())
        handler.expects(:run).with(opts = mock(), args = mock()).returns([output = mock(), exitstatus = mock()])
        output.expects(:empty?).returns(false)
        assert_equal exitstatus, Hivonic::Commands.run(cmd, opts, args)
      end
    end
  end

  context 'list tables' do
    setup do
      @klass = Hivonic::Commands::ListTables
    end

    should 'register with :list_tables' do
      handlers = [:list_tables]
      handlers.each do |handler|
        Hivonic::Commands.register_handler_for handler
      end
      run_handler_assertions_for handlers
    end

    should 'have a #run singleton method that dispatches to an instance #run' do
      opts = mock()
      args = mock()
      @klass.expects(:new).with(opts, args).returns(instance = mock())
      instance.expects(:run).with.returns([output = mock(), exitstatus = mock()])
      assert_equal [output, exitstatus], @klass.run(opts, args)
    end
  end

  context 'drop table' do
    setup do
      @klass = Hivonic::Commands::DropTable
    end

    should 'register with :drop_table' do
      handlers = [:drop_table]
      handlers.each do |handler|
        Hivonic::Commands.register_handler_for handler
      end
      run_handler_assertions_for handlers
    end

    should 'have a #run singleton method that dispatches to an instance #run' do
      opts = mock()
      args = mock()
      @klass.expects(:new).with(opts, args).returns(instance = mock())
      instance.expects(:run).with.returns([output = mock(), exitstatus = mock()])
      assert_equal [output, exitstatus], @klass.run(opts, args)
    end
  end

  context 'cleanup tables' do
    setup do
      @klass = Hivonic::Commands::CleanupTables
    end

    should 'register with :cleanup_tables' do
      handlers = [:cleanup_tables]
      handlers.each do |handler|
        Hivonic::Commands.register_handler_for handler
      end
      run_handler_assertions_for handlers
    end

    should 'have a #run singleton method that dispatches to an instance #run' do
      opts = mock()
      args = mock()
      @klass.expects(:new).with(opts, args).returns(instance = mock())
      instance.expects(:run).with.returns([output = mock(), exitstatus = mock()])
      assert_equal [output, exitstatus], @klass.run(opts, args)
    end
  end

  def run_handler_assertions_for(handlers)
    handlers.each do |handler|
      handler = handler.to_s.downcase
      assert_same @klass, Hivonic::Commands.handler_for(handler.to_sym)
      assert_same @klass, Hivonic::Commands.handler_for(handler.randcase.to_sym)
      assert_same @klass, Hivonic::Commands.handler_for(handler)
      assert_same @klass, Hivonic::Commands.handler_for(handler.randcase)
    end
  end
end
