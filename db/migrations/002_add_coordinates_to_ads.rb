# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table(:ads) do
      add_column :latitude, "double precision"
      add_column :longitude, "double precision"
    end
  end

  down do
    alter_table(:ads) do
      drop_column :latitude
      drop_column :longitude
    end
  end
end
