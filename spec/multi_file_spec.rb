require 'spec_helper'

describe Csv2rest do

  context 'given a CSV with schema it' do
    
    before :all do
      @csv = "file:" + File.join(File.dirname(__FILE__), "fixtures", "tomatoes.csv")
      @schema = Csvlint::Schema.load_from_json(File.join(File.dirname(__FILE__), "fixtures", "tomatoes.csv-metadata.json"))
    end
    
    it "parameterizes entity names" do
      g = Csv2rest.generate @csv, @schema
      
      expect(g['tomatoes/black-cherry']).to eq (
        {
          "common_name" => "black cherry",
          "botanical name" => "Lycopersicon esculentum",
          "tomato_type" => "cordon"
        }
      )

      expect(g['tomatoes']).to include(
        {
          "url" => "tomatoes/black-cherry"
        }
      )
    end
  
  end
end
