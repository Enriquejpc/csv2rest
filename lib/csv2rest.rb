require "csv2rest/version"
require 'csvlint/csvw/csv2json/csv2json'
require 'active_support/inflector'

module Csv2rest
  def self.generate csv, schema
    
    base_path = File.dirname(csv)
    
    t = Csvlint::Csvw::Csv2Json::Csv2Json.new( csv, {}, schema, { :validate => true } )
    json = JSON.parse(t.result)
    
    h = {}
    
    resource_name = json["schema:name"].parameterize

    # Resource list
    h["#{resource_name}"] = []
      
    # Create individual resources
    json["tables"][0]["row"].each do |object|
      obj = object["describes"][0]
      path = obj["@id"].gsub("#{base_path}/","")
      # Dump metadata we don't want in here
      obj.delete("@id")
      # Store object
      h[path] = obj
      # Add to object list
      h["#{resource_name}"] << {
        "url" => path
      }
    end
    
    # Create resource list
    h[""] = [
      {
        "resource" => resource_name,
        "url" => "#{resource_name}"
      }
    ]
    
    h
  end
end
