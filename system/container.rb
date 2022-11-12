# frozen_string_literal: true

require "dry/system/container"

require "zeitwerk"

class Container < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch("APP_ENV", :development).to_sym }
  use :zeitwerk

  # --- Dry-rb requirements ---
  require "dry-types"
  Dry::Types.load_extensions(:monads)

  require "dry-schema"
  Dry::Schema.load_extensions(:monads)

  require "dry-struct"

  require "dry/monads"
  require "dry/monads/do"

  configure do |config|
    config.inflector = Dry::Inflector.new do |inflections|
      inflections.acronym("RPC")
    end

    # libraries
    config.component_dirs.add "lib" do |dir|
      dir.memoize = true
    end

    # business logic
    config.component_dirs.add "contexts" do |dir|
      dir.memoize = true

      dir.auto_register = proc do |component|
        !component.identifier.include?("entities") && !component.identifier.include?("types")
      end

      dir.namespaces.add "bulletin_board", key: "contexts.bulletin_board"
    end

    # transport
    config.component_dirs.add "apps" do |dir|
      dir.memoize = true

      dir.auto_register = proc do |component|
        !component.identifier.include?("base")
      end

      dir.namespaces.add "http", key: "http"
    end
  end
end

Import = Container.injector
