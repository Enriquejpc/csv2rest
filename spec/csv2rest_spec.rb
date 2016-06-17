require 'spec_helper'

describe Csv2rest do
  it 'has a version number' do
    expect(Csv2rest::VERSION).not_to be nil
  end

  it 'turns a simple CSV into simple JSON' do
    g = Csv2rest.generate 'tomato-types.csv-metadata.yaml'

    expect(g['/tomato-types/cordon']).to eq (
      {
        "type": "cordon",
        "also called": "indeterminate",
        "description": "grows very tall"
      }
    )

    expect(g['/tomato-types/bush']).to eq (
      {
        "type": "bush",
        "also called": "determinate",
        "description": "does not require pruning"
      }
    )
  end
end
