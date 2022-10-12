# frozen_string_literal: true

module BulletinBoard
  module Commands
    class CreateAd
      include Dry::Monads[:result, :try]
      include Dry::Monads::Do.for(:call)
      include Import[ads_repo: "contexts.bulletin_board.repositories.ad"]

      AdSchemaValidator = Dry::Schema.Params do
        required(:user_id).value(BulletinBoard::Types::Id)
        required(:title).value(BulletinBoard::Types::AdTitle)
        required(:description).value(BulletinBoard::Types::AdDescription)
        required(:city).value(BulletinBoard::Types::AdCity)
      end

      def call(params)
        data = yield validate_inspection(params)
        create_ad(data.to_h)
      end

      private

      def validate_inspection(params)
        AdSchemaValidator.call(**params)
                         .to_monad
                         .or { |result| Failure([:unprocessable_entity, result.errors.to_h]) }
      end

      def create_ad(data)
        Try[Sequel::Error] { ads_repo.create(data) }.to_result
                                                    .or { |result| Failure([:db_error, result.exception.message]) }
      end
    end
  end
end
