# frozen_string_literal: true

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Base.include_root_in_json = true

migrate_path = File.expand_path("../../rails_app/db/migrate/", __FILE__)
if Devise::Test.rails71_and_up?
  ActiveRecord::MigrationContext.new(migrate_path).migrate
elsif Devise::Test.rails6_and_up?
  ActiveRecord::MigrationContext.new(migrate_path, ActiveRecord::SchemaMigration).migrate
elsif Devise::Test.rails52_and_up?
  ActiveRecord::MigrationContext.new(migrate_path).migrate
else
  ActiveRecord::Migrator.migrate(migrate_path)
end

class ActiveSupport::TestCase
  if Devise::Test.rails5_and_up?
    self.use_transactional_tests = true
  else
    # Let `after_commit` work with transactional fixtures, however this is not needed for Rails 5.
    require 'test_after_commit'
    self.use_transactional_fixtures = true
  end

  self.use_instantiated_fixtures  = false
end
