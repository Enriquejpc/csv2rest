require 'csv2rest'
require 'pp'
require 'fileutils'

module Csv2rest
  class CLI < Thor
    desc 'version', 'Print csv2rest version'
    def version
      puts "csv2rest version #{VERSION}"
    end

    desc 'generate', 'generate JSON from CSVs'
    method_option :output_dir,
                  aliases: '-o',
                  description: 'Where to output files'
    def generate csv, json
      files = Csv2rest.generate "file:"+csv, Csvlint::Schema.load_from_json(json)
      Csv2rest.write_json files, options
    end
  end
end
