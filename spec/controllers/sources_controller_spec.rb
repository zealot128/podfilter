require 'spec_helper'

describe SourcesController do
  let(:owner) { Fabricate(:owner) }
  let(:source) { Fabricate(:source)  }
  let(:opml) { Fabricate(:opml_file, owner: owner) }

  context 'anonymous user' do
    it 'shows' do
      get :show, id: source.id
      response.should be_success
    end
  end

end
