require 'csv2rest'
require 'pp'

module Csv2rest
  class CLI < Thor
    desc 'version', 'Print csv2rest version'
    def version
      puts "csv2rest version #{VERSION}"
    end

    desc 'generate', 'generate JSON from CSVs'
    def generate csv, json
      pp Csv2rest.generate csv, Csvlint::Schema.load_from_json(json)
    end
  end
end
