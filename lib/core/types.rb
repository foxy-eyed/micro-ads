# frozen_string_literal: true

module Core
  module Types
    include Dry.Types()

    SequelDataset = Types.Instance(Sequel::Dataset)
    Entity = Types::Nominal::Class
  end
end
