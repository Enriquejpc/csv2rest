require 'csv2rest/version'
require 'csvlint/csvw/csv2json/csv2json'
require 'thor'
require 'json'
require 'active_support/inflector'
require 'uri'

module Csv2rest
  def self.generate schema, options = {}

    t = Csvlint::Csvw::Csv2Json::Csv2Json.new '', {}, schema, { validate: true }
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
        path = fix_path obj
        h[path] ||= {
          "data" => []
        }
        h[path]["data"] << obj

        # Add to resource index
        resource_index_path = path.split('/').slice(0..-2).join('/')
        h[resource_index_path] ||= []
        h[resource_index_path] << {
          '@id' => obj['@id'],
          'url' => path
        }
        h[resource_index_path].uniq!

        # Add resource to root
        h['/'] ||= []
        h['/'] << {
          '@type' => obj['@type'],
          'url' => resource_index_path
        }
      end
    end

    # Pass over and normalise
    h.each do |path, object|
      if object.is_a?(Hash) && object["data"]
        # Get each key in the first data object (they will all be the same)
        keys = object["data"].first.keys
        # For each key, see if the values are all the same across the data array
        keys.each do |key|
          unique_values = object["data"].map{|x| x[key]}.uniq
          if unique_values.count == 1
            # If they are, store the value in the root rather than the data array
            object[key] = unique_values.first
            # And then clean the values out of the data array
            object["data"].each do |obj|
              obj.delete(key)
            end
            # Remove empty data objects and the entire array if it's not needed
            object["data"].delete_if{|x| x.empty?}
            object.delete("data") if object["data"].empty?
          end
        end
      end
    end

    # Easier than checking for duplication as we go
    h['/'].uniq!

    # Done
    h
  end

  def self.fix_path obj
    URI.parse(obj['@id']).path.split('/').map do |x|
      URI.decode(x).parameterize
    end.join('/')
  end

  def self.write_json files, output_dir
    files.each do |name, content|
      # Index
      name = 'index' if name == '/'
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
