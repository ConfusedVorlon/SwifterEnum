require "rails/generators/base"

module SwifterEnum
  module Generators
    # Rails generator for creating new SwifterEnum classes
    #
    # This generator creates a new enum class file in app/models/swifter_enum/
    # with the appropriate boilerplate code.
    #
    # @example Generate a new enum class
    #   rails generate swifter_enum:enum OrderStatus
    #   # Creates: app/models/swifter_enum/order_status_enum.rb
    #
    # @example Generate with namespace
    #   rails generate swifter_enum:enum Admin::OrderStatus
    #   # Creates: app/models/swifter_enum/admin/order_status_enum.rb
    #
    class EnumGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      # Creates the enum file from template
      #
      # Generates a new SwifterEnum subclass with placeholder values
      # in the app/models/swifter_enum directory.
      #
      # @return [void]
      def create_enum_file
        template "enum.rb.tt", File.join("app/models/swifter_enum", class_path, "#{file_name}_enum.rb")
      end
    end
  end
end
