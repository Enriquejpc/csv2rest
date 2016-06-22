require 'spec_helper'

describe Csv2rest do
  it 'has a version number' do
    expect(Csv2rest::VERSION).not_to be nil
  end

  context 'given a CSV with schema it' do

    before :all do
      @fixtures_dir = File.join(File.dirname(__FILE__), 'fixtures')
      @schema = Csvlint::Schema.load_from_json(File.join(@fixtures_dir, 'tomato-types.csv-metadata.json'))
    end

    it 'generates individual JSON files' do
      g = Csv2rest.generate @schema, base_url: 'file:'+@fixtures_dir

      expect(g['tomato-types/cordon']).to eq (
        {
          '@id' => "tomato-types/cordon",
          '@type' => "tomato-types",
          'type' => 'cordon',
          'also called' => 'indeterminate',
          'description' => 'grows very tall'
        }
      )

      expect(g['tomato-types/bush']).to eq (
        {
          '@id' => "tomato-types/bush",
          '@type' => "tomato-types",
          'type' => 'bush',
          'also called' => 'determinate',
          'description' => 'does not require pruning'
        }
      )
    end

    it 'generates an index for a resource' do
      g = Csv2rest.generate @schema, base_url: 'file:'+@fixtures_dir

      expect(g['tomato-types']).to eq (
        [
          {
            'url' => 'tomato-types/cordon'
          },
          {
            'url' => 'tomato-types/bush'
          },
        ]
      )
    end

    it 'generates a list of all resources' do
      g = Csv2rest.generate @schema, base_url: 'file:'+@fixtures_dir

      expect(g['']).to eq (
        [
          {
            'resource' => 'tomato-types',
            'url' => 'tomato-types'
          }
        ]
      )
    end
  end
end
