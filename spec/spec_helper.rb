$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'csv2rest'
require 'yaml'
require 'json'

def yaml_to_json y
  YAML.load_file(y).to_json
end
