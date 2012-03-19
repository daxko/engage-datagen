module EngageDatagen
  class Dataset
    class << self
      def register_set(name, set)
        registrations[name.to_sym] = set
      end

      def [](name)
        registrations[name.to_sym]
      end

      def []=(name, set)
        register_set name, set
      end

      def each
        registrations.each {|r| yield r }
      end

      include Enumerable

      private
        def registrations
          @registrations ||= {}
        end
    end

    def initialize(name=nil, &block)
      @docs = []
      self.class.register_set name, self if name
      DatasetDSL.new self, &block if block
    end

    def each
      @docs.each {|i| yield i }
    end

    include Enumerable

    def add(doc)
      @docs.push doc
      self
    end

    def create(document_type_name, specifics = {}, &block)
      doc = build document_type_name, specifics, &block
      add doc
      doc
    end

    def build(document_type_name, specifics = {}, &block)
      assert_valid_document_type document_type_name
      document_type = document_type document_type_name

      defaults = Hash.new.replace(document_type.defaults)
      data = defaults.rmerge(specifics)

      doc = Document.new document_type.next_id, data, document_type.metadata
      if block
        document_type.dsl_class.new doc, self, &block
      end

      doc
    end

    def method_missing(meth, *args, &block)
      method = meth.to_s
      if method =~ /^build_(.+)$/
        build($1, *args, &block)
      elsif method =~ /^create_(.+)$/
        create($1, *args, &block)
      else
        super
      end
    end

    private
      def assert_valid_document_type(document_type_name)
        sym = document_type_name.to_sym
        raise "unknown document type: #{sym}" unless document_types.has_key? sym
      end

      def document_types
        TypeRegistry.document_types
      end

      def document_type name
        TypeRegistry.document_type name
      end
  end

  private
    class DatasetDSL
      def initialize(dataset, &block)
        @dataset = dataset
        instance_eval &block
      end

      def add(document)
        @dataset.add document
      end

      def add_document(document_type, *args, &block)
        @dataset.create document_type.to_sym, *args, &block
      end

      def method_missing(meth, *args, &block)
        method = meth.to_s
        doc_type_names = TypeRegistry.document_type_names
        if method =~ /^add_(.+)$/ and doc_type_names.include? $1
          add_document $1, *args, &block
        elsif doc_type_names.include? method
          add_document method, *args, &block
        else
          super
        end
      end
    end
end

class Hash
  # adapted from https://gist.github.com/6391
  def rmerge(other_hash)
    r = {}
    r.rmerge_internal self
    r.rmerge_internal other_hash
    r
  end

  protected

  def rmerge_internal(other_hash)
    other_hash.keys.each do |key|
      if other_hash[key].is_a? Hash
        if has_key? key and self[key].is_a? Hash
          self[key] = self[key].rmerge other_hash[key]
        else
          self[key] = Hash.new.replace(other_hash[key])
        end
      elsif other_hash[key].is_a? Array
        self[key] = other_hash[key].dup
      else
        self[key] = other_hash[key]
      end
    end
    self
  end
end