require 'spec_helper'

describe PagesController do
  render_views
  specify 'index' do
    podcast = Fabricate(:podcast)
    source = Fabricate(:source, podcast: podcast)
    opml_file = Fabricate(:opml_file, type: 'OpmlFile')
    opml_file.sources << source

    Podcast.listened.count.should == 1

    get :index
    response.should be_success
    response.body.should include podcast.title
  end
end
