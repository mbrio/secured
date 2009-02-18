class CreateSecured < ActiveRecord::Migration
  def self.up
    create_table :applications, :force => true do |t|
      t.timestamps
      t.string :name
    end
    add_index :applications, [:name], :unique => true
    
    create_table :users, :force => true do |t|
      t.timestamps
      t.references :application
      t.string :name
    end
    add_index :users, [:name, :application_id], :unique => true
    
    create_table :roles, :force => true do |t|
      t.timestamps
      t.references :application
      t.string :name
    end
    add_index :roles, [:name, :application_id], :unique => true
    
    create_table :roles_users, :id => false, :force => true do |t|
      t.references :user, :role
    end
    add_index :roles_users, [:role_id, :user_id], :unique => true
  end

  def self.down
    remove_index :roles_users, [:role_id, :user_id]
    drop_table :roles_users
    
    remove_index :roles, [:name, :application_id]
    drop_table :roles
    
    remove_index :users, [:name, :application_id]
    drop_table :users
    
    remove_index :applications, [:name]
    drop_table :applications
  end
end
