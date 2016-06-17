require "csv2rest/version"

module Csv2rest
  def self.generate schema
    h = {}
    h['/tomato-types/cordon'] = {
      "type": "cordon",
      "also called": "indeterminate",
      "description": "grows very tall"
    }

    h['/tomato-types/bush'] = {
      "type": "bush",
      "also called": "determinate",
      "description": "does not require pruning"
    }

    h
  end
end
