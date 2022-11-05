Sequel.migration do
  change do
    create_table(:ads) do
      primary_key :id
      column :user_id, "integer", :null=>false
      column :title, "text", :null=>false
      column :city, "text", :null=>false
      column :description, "text", :null=>false
      column :created_at, "timestamp without time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :updated_at, "timestamp without time zone", :default=>Sequel::CURRENT_TIMESTAMP, :null=>false
      column :latitude, "double precision"
      column :longitude, "double precision"
    end
    
    create_table(:schema_info) do
      column :version, "integer", :default=>0, :null=>false
    end
  end
end
