require "csv2rest/version"
require 'csvlint/csvw/csv2json/csv2json'

module Csv2rest
  def self.generate csv, schema
    
    base_path = File.dirname(csv)
    
    t = Csvlint::Csvw::Csv2Json::Csv2Json.new( csv, {}, schema, { :validate => true } )
    json = JSON.parse(t.result)
    
    h = {}
    
    # Create individual resources
    json["tables"][0]["row"].each do |object|
      obj = object["describes"][0]
      path = obj["@id"].gsub("#{base_path}/","") # NASTINESS - replace with base URL somehow
      resource_name = obj["@type"].gsub("#{base_path}/","") # NASTINESS - replace with base URL somehow
      # Dump metadata we don't want in the JSON representation of the object
      obj.delete("@id")
      obj.delete("@type")
      # Store object
      h[path] = obj
      # Add to object list
      h["#{resource_name}"] ||= []
      h["#{resource_name}"] << {
        "url" => path
      }
      # Add resource to root
      h[""] ||= []
      h[""] << {
        "resource" => resource_name,
        "url" => "#{resource_name}"
      }
    end
    
    # Easier than checking for duplication as we go
    h[""].uniq!
    
    # Done
    h
  end
end
