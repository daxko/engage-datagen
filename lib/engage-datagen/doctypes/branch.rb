module EngageDatagen
  module DocTypes
    class BranchDocumentDSL < DocumentDSL
      def unit(values={}, &block)
        unit = @dataset.create_unit values, &block
        unit[:Membership][:Branch] = @doc.id
        unit
      end
    end

    TypeRegistry.add_document_type :branch, {
        metadata: {
            :'Raven-Entity-Name' => "Branches",
            :'Raven-Clr-Type' => "Daxko.Relate.Model.Branch, Daxko.Relate.Model"
        },
        defaults: {
            Name: "Family YMCA"
        },
        dsl_class: BranchDocumentDSL
    }

  end
end