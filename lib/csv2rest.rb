require "csv2rest/version"
require 'csvlint/csvw/csv2json/csv2json'

module Csv2rest
  def self.generate csv, schema
    
    t = Csvlint::Csvw::Csv2Json::Csv2Json.new( csv, {}, schema, { :validate => true } )
    json = JSON.parse(t.result)
    
    h = {}
    
    json["tables"][0]["row"].each do |object|
      h["/tomato-types/"+object["describes"][0]["type"]] = object["describes"][0]
    end

    h["/tomato-types"] = []
    json["tables"][0]["row"].each do |object|
      h["/tomato-types"] << {
        "type" => object["describes"][0]["type"],
        "url" => "/tomato-types/"+object["describes"][0]["type"]
      }
    end

    h
  end
end
