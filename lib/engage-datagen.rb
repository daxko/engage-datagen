def require_all_in_folder folder
  Dir[File.dirname(__FILE__) + "/#{folder}/*.rb"].each do |filename|
    require filename.chomp('.rb')
  end
end

require 'active_support/inflector'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/time/calculations'
require 'active_support/core_ext/numeric/time'
require 'active_support/json/encoding'
require 'rest-client'
require_all_in_folder 'engage-datagen'
require_all_in_folder 'engage-datagen/doctypes'
