# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:ads) do
      primary_key :id
      Integer :user_id, null: false
      String :title, null: false
      String :city, null: false
      String :description, text: true, null: false
      Time :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      Time :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(:ads)
  end
end
