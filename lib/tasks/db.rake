# frozen_string_literal: true

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |_t, args|
    Sequel::Migrator.run(Container["persistence.db"], "db/migrations", target: args[:version]&.to_i)
  end
end
