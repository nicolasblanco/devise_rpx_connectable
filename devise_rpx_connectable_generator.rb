puts "loading generator..."

class DeviseRpxConnectableGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)
	  
  def copy_migration
    migration_template "migration.rb", "db/migrate/devise_add_identifiers.rb"
  end
end

puts "loaded"