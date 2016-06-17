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
      begin
        files = Csv2rest.generate Csvlint::Schema.load_from_json(json), base_url: "file:#{File.dirname(json)}"
      rescue Errno::ENOENT => e
        if e.message.match /No such file or directory/
          puts "File '#{json}' does not exist"
          exit 1
        else
          puts "Something went wrong"
          exit 1
        end
      end

      if options[:output_dir]
        Csv2rest.write_json files, options[:output_dir]
      else
        pp files
      end
    end
  end
end
