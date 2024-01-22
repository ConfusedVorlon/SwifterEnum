module SwifterEnum
  class Railtie < Rails::Railtie
    # ActiveRecord integration
    initializer 'swifter_enum.active_record' do
      ActiveSupport.on_load(:active_record) do
        include SwifterEnum
      end
    end

    # adding autoload paths
    initializer 'swifter_enum.add_autoload_paths', before: :set_autoload_paths do |app|
      app.config.autoload_paths += Dir[Rails.root.join('app', 'models', 'swifter_enum')]
    end
  end
end
