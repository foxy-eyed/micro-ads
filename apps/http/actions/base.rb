# frozen_string_literal: true

require "hanami/validations"

module HTTP
  module Actions
    class Base < Hanami::Action
      include Dry::Monads[:result]

      def render_json(object, req)
        case object
        in { collection:, stats: }
          collection_json(collection, stats, req)
        else
          single_resource_json(object)
        end
      end

      private

      def collection_json(collection, stats, req)
        {
          data: collection.map { |entity| serialize_resource(entity) },
          meta: { total: stats[:total] },
          links: stats[:pages].transform_values { |v| page_link(req, v) }
        }.to_json
      end

      def single_resource_json(entity)
        { data: serialize_resource(entity) }.to_json
      end

      def serialize_resource(entity)
        {
          type: entity.type,
          id: entity.id,
          attributes: entity.to_h.except(:id)
        }
      end

      def page_link(req, page)
        params = req.params.to_h.merge(page: page)
        URI::HTTP.build(host: req.env["SERVER_NAME"],
                        port: req.env["SERVER_PORT"],
                        query: ::Rack::Utils.build_query(params)).to_s
      end
    end
  end
end
