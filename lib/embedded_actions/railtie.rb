require 'rails'

module EmbeddedActions
  class Railtie < ::Rails::Railtie
    initializer "embedded_actions.include_action_controller" do
      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.send :include, ::ActionController::EmbeddedActions
        ::ActionController::Base.send :include, ::ActionController::CachesEmbedded
        ::ActionController::Base.send :include, ::ActionController::DefaultEmbeddedOptions
        Mime::Type.register "application/x-embedded_action", :embedded
      end
    end
  end
end
