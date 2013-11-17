require 'spec_helper'

describe OpmlFilesController, sidekiq: :fake do
  it 'uploads file' do
    post :create, file: File.open('spec/fixtures/my.opml') , format: :json

    data = JSON.load(response.body)

    expect(data['url']).to be_present
    expect(data['log']).to be_present
    expect(OpmlFile.count).to eq(1)
    expect(session[:owner_id]).to be_present
    expect(controller.send(:current_user)).to eq(OpmlFile.first.owner)
    expect(Source.count).to be > 0
  end
end
