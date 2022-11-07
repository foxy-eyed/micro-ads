# frozen_string_literal: true

module BulletinBoard
  module Repositories
    class Ad
      include Core::Repository
      include Import[db: "persistence.db"]

      DEFAULT_PER_PAGE = 10

      entity BulletinBoard::Entities::Ad

      def all(params = {})
        page = params.fetch(:page, 1)
        per_page = params.fetch(:per_page, DEFAULT_PER_PAGE)
        collection(ads.order(:created_at).reverse.paginate(page, per_page))
      end

      def find(id)
        row = ads.first(id: id)
        model(row)
      end

      def update(id, data)
        ads.where(id: id).update(**data)
        find(id)
      end

      def create(data)
        id = ads.insert(**data)
        find(id)
      end

      private

      def ads
        @ads ||= db[:ads]
      end
    end
  end
end
