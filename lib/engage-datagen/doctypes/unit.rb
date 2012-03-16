module EngageDatagen
  module DocTypes
    class UnitDocumentDSL < DocumentDSL
      def primary(values={}, &block)
        person = member values, &block
        @doc[:PrimaryMember] = person.id
        @doc[:Email] = person[:Email]
        person
      end

      def member(values={}, &block)
        person = @dataset.create_person values, &block
        person[:Unit] = @doc.id
        person
      end

      def history_item(values={})
        data = history_defaults.merge values
        @doc[:History].push data
        data
      end

      def mem_unit_id value
        @doc[:Membership][:MemUnitID] = value
      end

      def member_unit_id value
        @doc[:Membership][:MemberUnitID] = value
      end

      def ops_id value
        @doc[:OperationsId] = value
      end

      def status value
        @doc[:Membership][:UnitStatus] = value
      end
      
      private
        def history_defaults
          {
            HistoryType: "Spurious Test Record",
            ChangeDateTime: "2001-10-25T00:00:00.0000000",
            ChangeReason: "",
            Description: "",
            AdminName: "",
            OldMembershipType: "",
            NewMembershipType: "",
            OldCategoryType: "",
            NewCategoryType: "",
            OldBranchName: "",
            NewBranchName: "",
            DateTimeStamp: "2001-10-25T00:00:00.0000000"
          }
        end
      
    end
    
    TypeRegistry.add_document_type :unit, {
      metadata: {
        :'Raven-Entity-Name' => "Units",
        :'Raven-Clr-Type' => "Daxko.Relate.Model.Unit, Daxko.Relate.Model"
      },
      defaults: {
        Membership: {
          ClientID: 0,
          Branch: "Local Family YMCA",
          MemUnitID: 2828522,
          MemberUnitID: "300140564",
          UnitStatus: "Active",
          BillCycle: "Monthly",
          BillingMethod: "",
          NextDraftDate: 12.days.from_now,
          AllowEmail: true
        },
        History: [],
        Email: "",
        OperationsId: 2828770
      },
      dsl_class: UnitDocumentDSL
    }
  end
end