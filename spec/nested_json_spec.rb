describe Csv2rest do
  context 'nested JSON' do
    before :all do
      @fixtures_dir = File.join(File.dirname(__FILE__), 'fixtures')
      @schema = Csvlint::Schema.load_from_json(File.join(@fixtures_dir, 'countries.csv-metadata.json'))
    end

    it 'generates nested JSON output' do
      g = Csv2rest.generate @schema, base_url: 'file:'+@fixtures_dir

      expect(g[""]).to eq (
        [
          {
           "resource"=>"schema:Country",
           "url"=>"schema:Country"
          }
        ]
      )

      expect(g["schema:Country"]).to eq (
        [
          {"url"=>"http//example-org/country/at"},
          {"url"=>"http//example-org/country/be"},
          {"url"=>"http//example-org/country/bg"}
        ]
      )

      expect(g['http//example-org/country/at']).to eq (
        {
          "@id" => "http://example.org/country/at",
          "@type" => "schema:Country",
          "schema:name" => ["Austria", "Autriche", "Osterreich"],
          "schema:geo" => {
            "@id" => "http://example.org/country/at#geo",
            "schema:latitude" => 47.6965545,
            "schema:longitude" => 13.34598005,
            "@type" => "schema:GeoCoordinates",
          },
        }
      )
      
      expect(g['http//example-org/country/be']).to eq (
        {
          "@id" => "http://example.org/country/be",
          "@type" => "schema:Country",
          "schema:name" => ["Belgium", "Belgique", "Belgien"],
          "schema:geo" => {
            "@id" => "http://example.org/country/be#geo",
            "schema:latitude" => 50.501045,
            "schema:longitude" =>4.47667405,
            "@type" => "schema:GeoCoordinates",
          }
        }
      )
      
    end
  end
end
