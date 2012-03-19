require "rspec"
require "engage-datagen"

type_registry = EngageDatagen::TypeRegistry

describe "example syntax declaring dataset" do
  dataset = nil
  before(:each) do
    dataset = EngageDatagen::Dataset.new do
      unit(Membership: {NextDraftDate: "2011-03-17T00:00:00.0000000"}) do

        history_item Description: 'New history entry', OldMembershipType: 'Individual Membership Comcast Trial Promotion', NewMembershipType: 'Individual Corporate Discount', DateTimeStamp: "2011-02-14T00:00:00.0000000"

        primary(:FirstName => "Bruce", LastName: "Campbell", DateOfBirth: "1962-03-17T00:00:00.0000000", Email: "bruce@campbell.com", Membership: {Active: true, JoinDate: "2012-04-16T00:00:00.0000000"}) do
          note(Type: "Behavior", Notes: "My name is Bruce.", NoteBy: "Bruce Wayne", NoteTimeStamp: "2011-03-16T00:00:00.0000000")
          note(Type: "Medical", Notes: "Bruce broke his leg slipping on the ice over Christmas break, so keep an eye out for balance problems. He should be taking it easy.", NoteBy: "Glenda the Good Witch", NoteTimeStamp: "2011-01-01T00:00:00.0000000")
          note(Type: "General", Notes: "Bruce has a romance forming with one of the ladies from Spin class. So cute!", NoteBy: "Debbie Frontdesker", NoteTimeStamp: "2011-02-14T00:00:00.0000000")
          note(Type: "Interests", Notes: "Loves swimming. Would consider Spin class. ARR", NoteBy: "Debbie Frontdesker", NoteTimeStamp: "2010-07-18T06:00:00.0000000")
          note(Type: "Childcare", Notes: "Bruce doesn't have kids but he loves to play Brucey the Clown for children's events.", NoteBy: "Cassie Childcare", NoteTimeStamp: "2009-09-13T10:00:00.0000000")
          note(Type: "Financial Assistance", Notes: "Bruce receives a disabled veteran discount.", NoteBy: "Modern Major General", NoteTimeStamp: "2010-09-13T06:00:00.0000000")
          note(Type: "Aquatics", Notes: "Turns out Bruce sinks more than he swims. Might consider signing him up for adult swim lessons. Do we offer those at this point? I'm not sure. -Nancy Newbie", NoteBy: "Nancy Newbie", NoteTimeStamp: "2011-10-31T00:00:00.0000000")
          note(Type: "Bad Debt", Notes: "We had some trouble collecting when Bruce was between films.", NoteBy: "Bernie Books", NoteTimeStamp: "2011-11-12T00:00:00.0000000")
          note(Type: "Billing", Notes: "Bruce got his finances sorted out, so he has access again.", NoteBy: "Bernie Books", NoteTimeStamp: "2011-11-15T00:00:00.0000000")
          note(Type: "Guest Passes", Notes: "Bring A Friend Day was a success!", NoteBy: "Gina Greeter", NoteTimeStamp: "2011-12-01T00:00:00.0000000")
          note(Type: "Volunteer", Notes: "Bruce wants to be removed from the volunteer list. Kids don't laugh at Brucey the Clown's act.", NoteBy: "Cassie Childcare", NoteTimeStamp: "2012-01-01T00:00:00.0000000")
          note(Type: "Employment", Notes: "Bruce applied for a job, but he would prefer to work at the association-level.", NoteBy: "Elvira Employee", NoteTimeStamp: "2012-01-15T00:00:00.0000000")
          note(Type: "Affiliations", Notes: "Bruce converted to Judaism, so he's taking his membership to the JCC in the future.", NoteBy: "Amy Affiliate", NoteTimeStamp: "2012-03-16T00:00:00.0000000")
          note(Type: "Impact Services", Notes: "Impact Services rep Jody called Bruce to ask about his Y experience. Took survey.", NoteBy: "Iris Impact", NoteTimeStamp: "2011-03-16T00:00:00.0000000")
          note(Type: "Staff Action", Notes: "We had to cut Bruce's lock off of a locker in the men's locker room. Need to talk about chainsaw hand storage with Bruce.", NoteBy: "Stacey Staffer", NoteTimeStamp: "2011-03-16T00:00:00.0000000")
          note(Type: "NPS", Notes: "Bruce is a promoter!", NoteBy: "Norman NPS", NoteTimeStamp: "2011-03-16T00:00:00.0000000")
          note(Type: "Legacy Data", Notes: "Bruce had some data in the old system, but it was too corrupted to convert.", NoteBy: "Lucy Legacy", NoteTimeStamp: "2012-03-16T00:00:00.0000000")
        end

        member(:FirstName => "Jane", LastName: "Campbell", DateOfBirth: "1965-11-11T00:00:00.0000000", Email: "jane@campbell.com", Membership: {Active: false, JoinDate: "2012-03-16T00:00:00.0000000", AllowEmail: false}) do
          note(Type: "Legacy Data", Notes: "Jane needs her own notes in the new system.", NoteBy: "Lucy Legacy", NoteTimeStamp: "2012-03-16T00:00:00.0000000")
        end
      end

      person(Unit: "Units/4", :FirstName => "Mary", LastName: "Lane", DateOfBirth: "1985-11-11T00:00:00.0000000", Email: "mary_lane@cuteasabutton.com", Membership: {Active: false, JoinDate: "2012-03-16T00:00:00.0000000", AllowEmail: false})
      person(Unit: "Units/4", :FirstName => "Jimmy", LastName: "Harper", DateOfBirth: "1985-01-23T00:00:00.0000000", Email: "jimmy_harper@victimofcircumstance.com", Membership: {Active: false, JoinDate: "2012-03-16T00:00:00.0000000", AllowEmail: false})
    end
  end

  it "should not accumulate notes" do
    bruce = dataset.find {|doc| doc[:FirstName] == "Bruce" }
    jane = dataset.find {|doc| doc[:FirstName] == "Jane" }
    mary = dataset.find {|doc| doc[:FirstName] == "Mary" }
    jimmy = dataset.find {|doc| doc[:FirstName] == "Jimmy" }

    type_registry.document_type(:person).defaults[:Notes].count.should == 0
    bruce[:Notes].count.should == 17
    jane[:Notes].count.should == 1
    mary[:Notes].count.should == 0
    jimmy[:Notes].count.should == 0
  end

end