if RUBY_VERSION < '2.0'
  module Hivonic
    module Common
      module StringHelper
        def randcase
          dup.split('').map do |char|
            if rand(1..10) > 5
              char.upcase
            else
              char.downcase
            end
          end.join
        end

        def classify
          self.split('_').collect(&:capitalize).join
        end

        def underscore
          self.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
        end

        def titleize
          self.gsub(/\b('?[a-z])/) { $1.capitalize }
        end

        def titleize_words
          self.gsub(/\w+/) { |s| s.capitalize }
        end
      end
    end
  end

  class String
    include Hivonic::Common::StringHelper
  end
else
  module Hivonic
    module Common
      module StringHelper
        refine ::String do
          def randcase
            dup.split('').map do |char|
              if rand(1..10) > 5
                char.upcase
              else
                char.downcase
              end
            end.join
          end

          def classify
            self.split('_').collect(&:capitalize).join
          end

          def underscore
            self.gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase
          end

          def titleize
            self.gsub(/\b('?[a-z])/) { $1.capitalize }
          end

          def titleize_words
            self.gsub(/\w+/) { |s| s.capitalize }
          end
        end
      end
    end
  end
end
