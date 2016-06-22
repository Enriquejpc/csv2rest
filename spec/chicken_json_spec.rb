describe Csv2rest do
  context 'nested JSON' do
    before :all do
      @fixtures_dir = File.join(File.dirname(__FILE__), 'fixtures')
      @schema = Csvlint::Schema.load_from_json(File.join(@fixtures_dir, 'chickens.csv-metadata.json'))
    end

    it 'generates nested JSON output' do
      g = Csv2rest.generate @schema, base_url: 'file:' + @fixtures_dir

      expect(g["/"]).to eq (
        [
          {
           "@type"=>"/inspections",
           "url"=>"/inspections"
          }
        ]
      )

      expect(g["/inspections"]).to eq (
        [
          {
            "@id"=>"/inspections/6782",
            "url"=>"/inspections/6782"
          },
          {
            "@id"=>"/inspections/6785",
            "url"=>"/inspections/6785"
          },
          {
            "@id"=>"/inspections/6787",
            "url"=>"/inspections/6787"
          }
        ]
      )

      expect(g["/inspections/6782"]).to eq (
        {
          "@id"=>"/inspections/6782",
          "HeaderID"=>6782,
          "AppNo"=>5011,
          "AbattoirName"=>"2 SISTERS FOOD GROUP LTD",
          "AnimalSource"=>"Producer: 24/655/0001 Arden Old Urn Farm",
          "SpeciesCategory"=>"Poultry",
          "Species"=>"Broilers",
          "HerdMark"=>"689268",
          "InspectionDate"=>"2016-02-15",
          "ArrivalDate"=>"2016-02-15",
          "SlaughterFromDate"=>"2016-02-15",
          "SlaughterToDate"=>"2016-02-15",
          "AnimalsReported"=>4752,
          "AnimalsPresented"=>4752,
          "AnimalsSlaughtered"=>4465,
          "Status"=>"Complete",
          "StatusDate"=>"2016-02-15T05:09:00",
          "Poultry_House"=>"2",
          "Poultry_NoInHouse"=>4500,
          "Poultry_ProductionSystem"=>"Organic",
          "Broiler_StockingDensity"=>"Not > 33kg",
          "Broiler_Breed"=>"Hubbard",
          "Broiler_Line"=>"Not Provided",
          "Poultry_Age"=>73,
          "Poultry_HouseMortality"=>1.97,
          "Poultry_CumulativeMortality"=>3.42,
          "@type"=>"/inspections",
          "conditions" => [
            {
              "Condition"=>"Cellulitis",
              "InspectionType"=>"Conditions",
              "AmountDescription"=>"Whole",
              "Amount"=>6.0
            }
          ]
        }
      )

    end
  end
end
