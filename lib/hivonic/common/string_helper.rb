module Hivonic
  module Common
    module StringHelper
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
