# frozen_string_literal: true

module BulletinBoard
  module Types
    include Dry.Types()

    CITY_REGEX = /\A[[:alpha:]]+([\s\-]?[[:alpha:]]+)*\z/

    Id = Params::Integer.constrained(gt: 0)

    # Types for Ad
    AdTitle = String.constrained(min_size: 1, max_size: 255)
    AdCity = String.constrained(min_size: 1, max_size: 255, format: CITY_REGEX)
    AdDescription = String.constrained(min_size: 1, max_size: 5_000)
  end
end
