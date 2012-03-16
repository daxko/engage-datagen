module EngageDatagen
  class Document
    def initialize(id, data, metadata={})
      @id = id
      @data = data
      @metadata = metadata
    end

    def [](sym)
      @data[sym]
    end

    def []=(sym, value)
      @data[sym] = value
    end

    [:id, :data, :metadata].each {|sym| attr_reader sym}
  end

  class DocumentDSL
    def initialize(doc, dataset, &block)
      @doc = doc
      @dataset = dataset
      instance_eval &block
    end
  end
end
