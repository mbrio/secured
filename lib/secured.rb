require File.join(File.dirname(__FILE__), "secured", "specifications")

Dir.glob(File.join(File.dirname(__FILE__), "db", "migrate", "*")).each do |file|
  require file
end