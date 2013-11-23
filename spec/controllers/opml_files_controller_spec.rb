require 'spec_helper'

describe OpmlFilesController, sidekiq: :fake do
  render_views
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

  context '#show' do
    let(:opml_file) {  Fabricate(:opml_file) }
    let(:cast)      {  Fabricate(:source) }

    it 'displays html' do
      opml_file.sources << cast
      get :show, id: opml_file.id
      assigns(:sources).should include cast
      response.body.should include cast.title
    end

    it 'displays opml file' do
      opml_file.sources << cast
      get :show, format: :xml, id: opml_file.id
      response.body.should include cast.title
    end

  end

  context 'logged in user' do
    let(:owner) { Fabricate(:owner) }
    let(:source) { Fabricate(:source)  }
    let(:opml) { Fabricate(:opml_file, owner: owner) }
    before :each do
      session[:owner_id] = owner.id
    end

    it 'can be added to opml file' do
      post :add_source, id: opml.id, source_id: source.id
      opml.reload.sources.count.should == 1
    end

    it 'can remove sources from opml file' do
      opml.sources << source
      post :remove_source, id: opml.id, source_id: source.id
      opml.reload.sources.count.should == 0
    end
  end


end
