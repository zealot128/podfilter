require "spec_helper"
describe OpmlImport do
  let(:owner) { Fabricate(:owner) }
  let(:opml)  { File.open('spec/fixtures/hacker.opml') }
  let(:service) { OpmlImport.new(owner, file) }
  specify do
    service.owner.should == owner
    service.text.should include '<?xml'

  end

end
