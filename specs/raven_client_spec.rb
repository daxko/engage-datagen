require "rspec"
require "engage-datagen"

describe "Raven client" do
  client = nil
  before(:each) do
    client = EngageDatagen::RavenClient.new 'http://localhost:8080'

    EngageDatagen::TypeRegistry.remove_document_type :foo
    EngageDatagen::TypeRegistry.add_document_type :foo,
        defaults: {Bar: 'baz'},
        metadata: {:'Raven-Entity-Name' => 'Foos', :'Raven-Clr-Type' => 'Daxko.Relate.Models.Foo, Daxko.Relate.Models'}

  end

  it "should do something" do
    ds = EngageDatagen::Dataset.new :ds_name do
      foo Bar: 'bam' do
        #DocumentDSL here
      end
    end

    ds.first.id.should == 'Foos/1000' #default id generation

    client.store(EngageDatagen::Dataset[:ds_name])
  end
end