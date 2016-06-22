require 'csv2rest/version'
require 'csvlint/csvw/csv2json/csv2json'
require 'thor'
require 'json'
require 'active_support/inflector'
require 'uri'

module Csv2rest
  def self.generate schema, options = {}

    t = Csvlint::Csvw::Csv2Json::Csv2Json.new( '', {}, schema, { :validate => true } )
    json = JSON.parse(t.result)

    h = {}

    # Create individual resources
    json['tables'].each do |table|
      table['row'].each do |object|
        obj = object['describes'][0]
        # Hacky things for removing the base URL when generating file paths and IDs
        if options[:base_url]
          obj['@id'].gsub!(options[:base_url],'')
          obj['@type'].gsub!(options[:base_url],'')
        end
        # Store object at a nice path for developers
        uri = URI.parse(obj['@id'])
        path = uri.path.split('/').map{|x| URI.decode(x).parameterize}.join('/')
        h[path] = obj
        # Add to resource index
        resource_index_path = path.split('/').slice(0..-2).join('/')
        h[resource_index_path] ||= []
        h[resource_index_path] << {
          '@id' => obj['@id'],
          'url' => path
        }
        # Add resource to root
        h['/'] ||= []
        h['/'] << {
          '@type' => obj['@type'],
          'url' => resource_index_path
        }
      end
    end

    # Easier than checking for duplication as we go
    h['/'].uniq!

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
