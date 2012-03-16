require "rspec"
require "engage-datagen"

registry = EngageDatagen::TypeRegistry
dataset = EngageDatagen::Dataset.new

describe "Document types" do
  describe "Given there is not a registered document type known as unit" do
    before(:each) do
      registry.remove_document_type :unit
    end

    it "should not allow me to create a unit document" do
      lambda {dataset.build_unit}.should raise_error("unknown document type: unit")
    end
  end

  describe "when I register a simple document type" do
    before(:each) do
      registry.add_document_type :unit
    end

    describe "when I build a document from the simple type" do
      output = nil

      before(:each) do
        output = dataset.build_unit
      end

      it "should output a unit doc with appropriate values" do
        output.should_not be_nil
      end
    end
  end

  describe "when I register a document type with metadata and defaults" do
    before(:each) do
      registry.add_document_type :doc_with_meta_and_defaults,
                                metadata: { :'Raven-Clr-Type' => 'clrtype'},
                                defaults: { foo: 'bar' }
    end

    describe "when I build a document from the simple type" do
      output = nil

      before(:each) do
        output = dataset.build_doc_with_meta_and_defaults baz: 'bam'
      end

      it "should output a doc with appropriate values" do
        output.should_not be_nil
        output.metadata[:'Raven-Clr-Type'].should == 'clrtype'
        output[:foo].should == 'bar'
        output[:baz].should == 'bam'
      end
    end
  end

  describe "when I register a document type with a specific DSL" do
    before(:each) do
      class SampleDSL < EngageDatagen::DocumentDSL
        def trigger
          @doc[:triggered] = true
        end
      end

      registry.remove_document_type :doc_with_dsl
      registry.add_document_type :doc_with_dsl,
                                :dsl_class => SampleDSL
    end

    describe "when I build a new document with the dsl" do
      doc = nil
      before(:each) do
        doc = dataset.build_doc_with_dsl do
          trigger
        end
      end

      it "should handle dsl calls as expected" do
        doc[:triggered].should == true
      end
    end
  end

  describe "id generation" do
    describe "given I have defined a document type with default id params" do
      before(:each) do
        registry.remove_document_type :person
        registry.add_document_type :person
      end

      describe "when I build a document" do
        doc = nil
        before(:each) do
          doc = dataset.build_person
        end

        it "should have an id" do
          doc.id.should_not be_nil
        end

        it "should namespace the id with the pluralized name" do
          prefix = doc.id.split('/').first
          prefix.should == 'people'
        end

        it "should use the default first numeric id" do
          suffix = doc.id.split('/').last
          suffix.should == 1000.to_s
        end

        describe "when I build another document" do
          doc2 = nil
          before(:each) do
            doc2 = dataset.build_person
          end

          it "should increment the id" do
            doc2.id.should == 'people/1001'
          end
        end
      end
    end

    describe "given I have defined a document type with configured id params" do
      before(:each) do
        registry.remove_document_type :person
        registry.add_document_type :person, id_prefix: 'members', initial_id: 3000
      end

      describe "when I build a document" do
        doc = nil
        before(:each) do
          doc = dataset.build_person
        end

        it "should have an id" do
          doc.id.should_not be_nil
        end

        it "should namespace the id with the configured name" do
          prefix = doc.id.split('/').first
          prefix.should == 'members'
        end

        it "should use the configured first numeric id" do
          suffix = doc.id.split('/').last
          suffix.should == 3000.to_s
        end

        describe "when I build another document" do
          doc2 = nil
          before(:each) do
            doc2 = dataset.build_person
          end

          it "should increment the id" do
            doc2.id.should == 'members/3001'
          end
        end
      end
    end
  end
end

describe "Generating document from defaults and specifics" do
  output = nil

  before(:each) do
    registry.remove_document_type :person
    registry.add_document_type :person
  end

  it "should output the composed doc" do
    output = dataset.build_person
    output.should_not be_nil
  end

  describe "Given defaults for a field" do
    before(:each) do
      registry.document_type(:person).defaults[:foo] = 'default_value'
    end

    describe "Given no specifics" do
      before(:each) do
        output = dataset.build_person
      end

      it "should output a document reflecting the defaults" do
        output[:foo].should == 'default_value'
      end
    end

    describe "Given specifics" do
      before(:each) do
       output = dataset.build_person foo: 'specific_value'
      end

      it "should output a document reflecting the specifics" do
        output[:foo].should == 'specific_value'
      end
    end
  end

  describe "Given no defaults for a field" do
    before(:each) do
      registry.document_type(:person).defaults.delete :foo
    end

    describe "Given specifics for a field" do
      before(:each) do
       output = dataset.build_person foo: 'specific_value'
      end

      it "should output a document reflecting the specifics" do
        output[:foo].should == 'specific_value'
      end
    end

    describe "Given no specifics" do
      before(:each) do
        output = dataset.build_person
      end

      it "should not have a value for the unspecified field" do
        output[:foo].should be_nil
      end
    end
  end

  describe "Deep merging" do
    describe "Given I have defined a document type with nested hashes in defaults" do
      before(:each) do
        registry.remove_document_type :member
        registry.add_document_type :member, defaults: {
          name: 'Willy Wonka',
          membership: {
            original_join_date: '2012-01-01',
            type: 'Individual',
            history: []
          }
        }
      end

      describe "given I have created a document instance overriding a deep attribute" do
        output = nil

        before(:each) do
          output = dataset.build_member membership: { type: 'Family'}
        end

        it "should override the specified property in the nested hash" do
          output[:membership][:type].should == 'Family'
        end

        it "should retain the defaults for properties in the nested hash that weren't specified" do
          output[:name].should == 'Willy Wonka'
          output[:membership][:original_join_date].should == '2012-01-01'
          output[:membership][:history].should == []
        end
      end
    end

  end
end

describe "Document metadata" do
  describe "given I have defined a document type with metadata" do
    before(:each) do
      registry.remove_document_type :person
      registry.add_document_type :person,
                                metadata: {:'Raven-Clr-Type' => 'Relate.Model.Person'},
                                defaults: {foo: 'bar'}
    end

    describe "when I build a document" do
      output = nil
      before(:each) do
        output = dataset.build_person :somekey => 'value'
      end

      it "should have the configured metadata" do
        output.metadata.should_not be_nil
        output.metadata[:'Raven-Clr-Type'].should == 'Relate.Model.Person'
      end

      it "should have configured default data" do
        output[:foo].should == 'bar'
      end

      it "should have supplied instance data" do
        output[:somekey].should == 'value'
      end
    end
  end
end