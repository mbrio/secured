ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.join(File.dirname(__FILE__), '..', '..', '..', '..')

require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require 'active_record/fixtures'
require 'action_controller'
require 'action_controller/test_process'

require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config', 'environment.rb'))

log_dir = File.join(File.dirname(__FILE__), 'log')
Dir.mkdir(log_dir) unless File.exists?(log_dir)

db_dir = File.join(File.dirname(__FILE__), 'db')
Dir.mkdir(db_dir) unless File.exists?(db_dir)

config = YAML::load(IO.read(File.join(File.dirname(__FILE__), 'config', 'database.yml')))
ActiveRecord::Base.logger = Logger.new(File.join(log_dir, 'test.log'))
ActiveRecord::Base.establish_connection(config['test'])

I18n.load_path = Dir[File.join(File.dirname(__FILE__), 'config', 'locales', '*.{rb,yml}')]
I18n.default_locale = :en
I18n.reload!

require File.join(File.dirname(__FILE__), '..', 'init.rb')

CreateSecured.up