require 'spec_helper'

describe AdminController do
  before :each do
    session[:owner_id] = Fabricate(:admin)
  end
  it 'merges 3 sources' do
    s1 = Fabricate :source
    s2 = Fabricate :source
    s3 = Fabricate :source
    post :merge, sources: [s1.id, s2.id, s3.id]
    s1.reload.child_ids.sort.should == [ s2.id, s3.id ].sort
  end

end
