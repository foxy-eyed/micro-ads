# frozen_string_literal: true

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |_t, args|
    db = Container["persistence.db"]
    db.extension :schema_dumper

    migrations = File.expand_path("../../db/migrations", __dir__)
    Sequel::Migrator.run(db, migrations, target: args[:version]&.to_i)

    schema_file = File.join(File.expand_path("../../db", __dir__), "schema.rb")
    File.write(schema_file, db.dump_schema_migration(same_db: true))
  end
end
