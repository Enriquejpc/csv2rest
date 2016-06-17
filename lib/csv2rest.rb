require "csv2rest/version"
require 'csvlint/csvw/csv2json/csv2json'
require 'active_support/inflector'

module Csv2rest
  def self.generate csv, schema
    
    t = Csvlint::Csvw::Csv2Json::Csv2Json.new( csv, {}, schema, { :validate => true } )
    json = JSON.parse(t.result)
    
    h = {}
    
    resource_name = json["schema:name"].parameterize
    primary_key = "type" #hardcoded, needs changing
      
    # Create individual resources
    json["tables"][0]["row"].each do |object|
      name = object["describes"][0][primary_key].parameterize
      h["#{resource_name}/#{name}"] = object["describes"][0]
    end

    # Create resource index
    h["#{resource_name}"] = []
    json["tables"][0]["row"].each do |object|
      name = object["describes"][0][primary_key].parameterize
      h["#{resource_name}"] << {
        primary_key => name,
        "url" => "#{resource_name}/#{name}"
      }
    end

    # Create resource index
    h[""] = [
      {
        "resource" => resource_name,
        "url" => "#{resource_name}"
      }
    ]

    h
  end
end
