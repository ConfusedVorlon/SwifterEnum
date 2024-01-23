require 'rails/generators/base'

module SwifterEnum
  module Generators
    class EnumGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      def create_enum_file
        template 'enum.rb.tt', File.join('app/models/swifter_enum', class_path, "#{file_name}_enum.rb")
      end
    end
  end
end
