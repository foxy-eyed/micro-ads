# frozen_string_literal: true

module BulletinBoard
  module Entities
    class Ad < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, BulletinBoard::Types::Id
      attribute :user_id, BulletinBoard::Types::Id
      attribute :title, BulletinBoard::Types::AdTitle
      attribute :description, BulletinBoard::Types::AdDescription
      attribute :city, BulletinBoard::Types::AdCity

      def type
        "ads"
      end
    end
  end
end
