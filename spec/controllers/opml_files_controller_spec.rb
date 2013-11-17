require 'spec_helper'

describe OpmlFilesController, sidekiq: :fake do
  it 'uploads file' do
    post :create, file: File.open('spec/fixtures/my.opml') , format: :json

    data = JSON.load(response.body)

    data['url'].should be_present
    data['log'].should be_present
    OpmlFile.count.should == 1
    session[:owner_id].should be_present
    controller.send(:current_user).should == OpmlFile.first.owner
    Source.count.should > 0
  end
end
