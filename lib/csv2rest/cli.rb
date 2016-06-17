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
    def generate json
      files = Csv2rest.generate Csvlint::Schema.load_from_json(json), base_url: "file:"+File.dirname(json)
      Csv2rest.write_json files, options
    end

    default_task :generate
  end
end
