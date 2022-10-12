# frozen_string_literal: true

module Core
  module Repository
    module ClassMethods
      attr_reader :entity_name

      def entity(name)
        @entity_name = name
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    def collection(scope)
      Core::Entities::SequelCollection.new(
        scope: scope,
        entity: entity
      )
    end

    def model(row)
      entity.new(row)
    end

    def entity
      self.class.entity_name
    end
  end
end
