# frozen_string_literal: true

module Core
  module Entities
    class SequelCollection < Dry::Struct
      transform_keys(&:to_sym)

      attribute :scope, Core::Types::SequelDataset
      attribute :entity, Core::Types::Entity

      def to_a
        scope.map { |row| map_to_entity(row) }
      end

      def pages
        return {} if scope.count.zero?

        {
          first: 1,
          self: scope.current_page,
          next: scope.next_page,
          prev: scope.prev_page,
          last: scope.page_count
        }.compact
      end

      def total
        scope.pagination_record_count
      end

      private

      def map_to_entity(raw_attributes)
        entity.new(raw_attributes)
      end
    end
  end
end
