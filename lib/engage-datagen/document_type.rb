module EngageDatagen
  class DocumentType
    def initialize(name, opts={})
      opts = self.class.default_opts.merge opts

      @name = name
      @metadata = opts[:metadata]
      @defaults = opts[:defaults]
      @id_prefix = opts[:id_prefix] || name.to_s.pluralize
      @next_id = opts[:initial_id]
      @dsl_class = opts[:dsl_class]
    end

    def next_id
      id = @next_id
      @next_id += 1
      "#{@id_prefix}/#{id}"
    end

    %w(name metadata defaults dsl_class).each do |meth|
      attr_reader meth.to_sym
    end

    class << self
      def default_opts
        {
          metadata: {},
          defaults: {},
          id_prefix: nil,
          initial_id: 1000,
          dsl_class: DocumentDSL
        }
      end
    end
  end
end