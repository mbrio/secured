class SecuredGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory File.join('db/migrate')
      m.migration_template 'migration.rb', 'db/migrate'
    end
  end
  
  def file_name
    'secured_migration'
  end
end
