module EngageDatagen
  class TypeRegistry
    class << self
      def remove_document_type(name)
        sym = name.to_sym
        document_types.delete sym
      end

      def add_document_type(name, opts={})
        sym = name.to_sym

        #raise needs coverage in template_spec
        raise "document type already defined: #{sym}" if document_types.has_key? sym

        if opts.instance_of? Hash
          doc_type = DocumentType.new sym, opts
        elsif opts.instance_of? DocumentType
          doc_type = opts
        else
          doc_type = DocumentType.new sym
        end

        document_types[sym] = doc_type
      end

      def document_types
        @document_types ||= {}
      end

      def document_type_names
        document_types.map {|name, type| name.to_s }
      end

      def document_type name
        document_types[name.to_sym]
      end
    end
  end
end