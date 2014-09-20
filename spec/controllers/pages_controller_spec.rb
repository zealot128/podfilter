require 'spec_helper'

describe PagesController do
  render_views
  specify 'index' do
    podcast = Fabricate(:podcast)
    source = Fabricate(:source, podcast: podcast)
    source.opml_files << Fabricate(:opml_file, type: 'OpmlFile')
    source.opml_files << Fabricate(:opml_file, type: 'OpmlFile')
    source.opml_files << Fabricate(:opml_file, type: 'OpmlFile')
    source.save

    expect(Podcast.listened.count).to be == 1

    get :index
    expect(response).to be_success
    expect(response.body).to include podcast.title
  end
end
