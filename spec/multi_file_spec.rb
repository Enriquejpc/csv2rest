require 'spec_helper'

describe Csv2rest do

  context 'given a CSV with schema it' do

    before :all do
      @fixtures_dir = File.join(File.dirname(__FILE__), 'fixtures')
      @schema = Csvlint::Schema.load_from_json(File.join(@fixtures_dir, 'tomatoes.csv-metadata.json'))
    end

    it 'parameterizes entity names' do
      g = Csv2rest.generate @schema, base_url: 'file:'+@fixtures_dir

      expect(g['tomatoes/black-cherry']).to eq (
        {
          "@id" => "tomatoes/black%20cherry",
          "@type" => "tomatoes",
          'common_name' => 'black cherry',
          'botanical name' => 'Lycopersicon esculentum',
          'tomato_type' => 'cordon'
        }
      )

      expect(g['tomatoes']).to include(
        {
          'url' => 'tomatoes/black-cherry'
        }
      )
    end

  end
end
