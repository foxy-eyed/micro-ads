# frozen_string_literal: true

module Core
  module Types
    include Dry.Types()

    COORDINATES_RANGE = {
      lat: -90.0..90.0,
      lng: -180.0..180.0
    }.freeze

    SequelDataset = Types.Instance(Sequel::Dataset)
    Entity = Types::Nominal::Class

    Latitude = Params::Decimal.constrained(included_in: COORDINATES_RANGE[:lat])
    Longitude = Params::Decimal.constrained(included_in: COORDINATES_RANGE[:lng])
  end
end
