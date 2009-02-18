class SecuredMigration < ActiveRecord::Migration
  def self.up
    CreateSecured.up
  end

  def self.down
    CreateSecured.down
  end
end
