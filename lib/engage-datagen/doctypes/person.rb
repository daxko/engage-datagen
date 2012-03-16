module EngageDatagen
  module DocTypes
    class PersonDocumentDSL < DocumentDSL
      def note(values={})
        data = note_defaults.merge(values)
        @doc[:Notes].push(data)
        data
      end

      def notes(list=[])
        list.each {|item| note item}
      end

      def facility_usage(values={})
        data = facility_usage_defaults.merge(values)
        facility_usage_history[:FacilityUsage].push(data)
        data
      end

      def facility_usages(list=[])
        list.each {|item| facility_usage item}
      end

      private
        def note_defaults
          {
            Type: 'General',
            NoteBy: 'Test User',
            NoteTimeStamp: DateTime.current,
            Notes: 'Sample note'
          }
        end

        def facility_usage_defaults
          {
            CheckInDateTime: DateTime.current,
            Branch: 'Local Family YMCA',
            Denied: false
          }
        end

        def facility_usage_history
          unless @facility_usage_history
            @facility_usage_history = @dataset.create :facility_usage_history
            @facility_usage_history[:Person] = @doc.id
          end
          @facility_usage_history
        end
    end

    TypeRegistry.add_document_type :facility_usage_history, {
      metadata: {
        :'Raven-Entity-Name' => "FacilityUsageHistories",
        :'Raven-Clr-Type' => "Daxko.Relate.Model.FacilityUsageHistory, Daxko.Relate.Model"
      },
      defaults: {
        Person: '',
        FacilityUsage: []
      }
    }

    TypeRegistry.add_document_type :person, {
      metadata: {
        :'Raven-Entity-Name' => "People",
        :'Raven-Clr-Type' => "Daxko.Relate.Model.Person, Daxko.Relate.Model"
      },
      defaults: {
        FirstName: "John",
        MiddleName: "Q",
        LastName: "Tester",
        Suffix: "",
        Address1: "1234 Main St",
        Address2: "",
        City: "Anytown",
        State: "ST",
        Zip: "12345",
        MemberPhone: "(800) 555-1212",
        BusinessPhone: "",
        CellPhone: "",
        Email: "",
        Gender: "M",
        Race: "B",
        DateOfBirth: "1962-02-04T00:00:00.0000000",
        Membership: {
          Branch: "Local Family YMCA",
          MemID: 82667,
          MemberID: "192005996-00",
          MemberUnitID: "192005996",
          MemUnitID: 49666,
          RelationToPrimary: "",
          MemberType: "Adult",
          Active: true,
          JoinDate: "2006-02-08T00:00:00.0000000",
          JoinReason: "",
          AllowEmail: true,
          RecognitionFlags: [:Reciprocity]
        },
        OperationsId: 82667,
        Unit: "",
        PhotoKey: "",
        Notes: [],
        Statistics: {
          StatisticsDate: "0001-01-01T00:00:00.0000000",
          Afci14: 0.0,
          Afci30: 0.0,
          Afci60: 0.0,
          Afci90: 0.0,
          Afci180: 0.0,
          Afci365: 0.0,
          AfciYTD: 0.0
        }
      },
      dsl_class: PersonDocumentDSL
    }
  end
end