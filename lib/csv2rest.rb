require 'csv2rest/version'
require 'csvlint/csvw/csv2json/csv2json'
require 'thor'
require 'json'
require 'active_support/inflector'
require 'uri'

module Csv2rest
  def self.generate schema, options = {}
    base_url = options[:base_url]

    t = Csvlint::Csvw::Csv2Json::Csv2Json.new( '', {}, schema, { :validate => true } )
    json = JSON.parse(t.result)

    h = {}

    # Create individual resources
    json['tables'].each do |table|
      table['row'].each do |object|
        obj = object['describes'][0]
        # Hacky things for removing the base URL when generating file paths and IDs
        obj['@id'].gsub!("#{base_url}/",'')
        obj['@type'].gsub!("#{base_url}/",'')
        # Store object
        path = obj['@id'].split('/').map{|x| URI.decode(x).parameterize}.join('/')
        h[path] = obj
        # Add to object list
        h[obj['@type']] ||= []
        h[obj['@type']] << {
          'url' => path
        }
        # Add resource to root
        h[''] ||= []
        h[''] << {
          'resource' => obj['@type'],
          'url' => obj['@type']
        }
      end
    end

    # Easier than checking for duplication as we go
    h[''].uniq!

    # Done
    h
  end

  def self.write_json files, output_dir
    files.each do |name, content|
      # Index
      name = 'index' if name == ''
      # Filename
      filename = name + '.json'
      FileUtils.mkdir_p output_dir
      Dir.chdir(output_dir) do
        # Create directories
        FileUtils.mkdir_p File.dirname(filename)
        # Write
        File.write(filename, JSON.pretty_generate(content))
      end
    end
  end

end
