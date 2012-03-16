require "rspec"
require "engage-datagen"

registry = EngageDatagen::TypeRegistry
dataset_class = EngageDatagen::Dataset

describe "Dataset" do

  describe "Given document types are defined" do
    before(:each) do
      registry.remove_document_type :person
      registry.add_document_type :person, defaults: {name: 'Default'}
    end

    describe "And I have an instance of a dataset" do
      dataset = nil
      before(:each) do
        dataset = dataset_class.new
      end

      describe "when I add a document" do
        doc = nil
        before(:each) do
          doc = dataset.create_person name: 'Jimmy James'
        end

        it "should include the document" do
          dataset.should include doc
        end

        it "should be enumerable over documents" do
          docs = dataset.map {|d| d }
          docs.should include doc
        end

        it "should pass document settings through" do
          dataset.map {|d| d[:name]}.should include 'Jimmy James'
        end
      end
    end

    describe "Dataset DSL is available when building a dataset" do
      dataset = nil

      before(:each) do
        dataset = dataset_class.new do
          person name: 'Milton'
        end
      end

      it "should have initialized the dataset according to the dsl script" do
        dataset.map{|d| d[:name] }.should include 'Milton'
      end
    end

    describe "Dataset DSL script is optional when building a dataset" do
      dataset = nil

      before(:each) do
        dataset = dataset_class.new
      end

      it "should have initialized the dataset according to the dsl script" do
        dataset.should_not be_nil
      end
    end
  end
end