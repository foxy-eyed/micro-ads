# frozen_string_literal: true

module BulletinBoard
  module Types
    include Dry.Types()

    Id = Params::Integer.constrained(gt: 0)

    # Types for Ad
    AdTitle = String.constrained(min_size: 1, max_size: 255, format: /\A[[:ascii:]]+\z/)
    AdCity = String.constrained(min_size: 1, max_size: 255, format: /\A[[:ascii:]]+\z/)
    AdDescription = String.constrained(min_size: 1, max_size: 5_000)
  end
end
