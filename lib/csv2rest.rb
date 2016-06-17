require "csv2rest/version"
require 'csvlint/csvw/csv2json/csv2json'

module Csv2rest
  def self.generate csv, schema
    
    t = Csvlint::Csvw::Csv2Json::Csv2Json.new( csv, {}, schema, { :minimal => true, :validate => true } )
    json = JSON.parse(t.result)
    
    h = {}

    json.each do |object|
      h["/tomato-types/"+object["type"]] = object
    end

    h["/tomato-types"] = []
    json.each do |object|
      h["/tomato-types"] << {
        "type" => object["type"],
        "url" => "/tomato-types/"+object["type"]
      }
    end

    h
  end
end
