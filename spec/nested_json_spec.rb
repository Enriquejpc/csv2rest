describe Csv2rest do
  context 'nested JSON' do
    before :all do
      @base_url = File.join(File.dirname(__FILE__), 'fixtures')
      @schema = Csvlint::Schema.load_from_json(File.join(@base_url, 'countries.csv-metadata.json'))
    end

    it 'generates nested JSON output' do
      g = Csv2rest.generate @schema, base_url: 'file:' + @base_url
    end
  end
end
