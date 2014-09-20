require 'spec_helper'

describe SessionsController do
  context 'github' do
    before :each do
      request.env['omniauth.auth'] = YAML.load_file 'spec/fixtures/oauth/github.yml'
    end

    it 'creates from github' do
      VCR.use_cassette 'github-gravatar', record: :new_episodes do
        get :create, provider: 'github'
      end
      controller.send(:current_user).should be_present
      Owner.first.tap do |owner|
        owner.identities.first.email.should == 'info@stefanwienert.de'
        owner.identities.first.image.should be_present
        owner.primary_identity.should == owner.identities.first
        owner.opml_files.count.should == 2
      end
    end

    it 'relogins' do
      VCR.use_cassette 'github-gravatar', record: :new_episodes do
        get :create, provider: 'github'
      end

      session[:owner_id] = nil
      get :create, provider: 'github'
      Owner.count.should == 1
      Identity.count.should == 1
      session[:owner_id].should == Owner.first.id
    end

    it 'merges accounts' do
      old = Owner.create
      session[:owner_id] = old.id

      VCR.use_cassette 'github-gravatar', record: :new_episodes do
        get :create,  provider: 'github'
      end

      Owner.count.should == 1
      Owner.first.token.should be_nil
      Identity.count.should == 1
      session[:owner_id].should == old.id
    end

  end
  context 'twitter' do
    before :each do
      request.env['omniauth.auth'] = YAML.load_file 'spec/fixtures/oauth/twitter.yml'
    end
    it 'creates from oauth' do
      allow_any_instance_of(OauthAdapter::Base).to receive(:process_uri).and_return(nil)
      VCR.use_cassette 'twitter-profile', record: :new_episodes do
        get :create, provider: 'twitter'
      end
      controller.send(:current_user).should be_present
      Owner.first.tap do |owner|
        # owner.identities.first.image.should be_present
        owner.primary_identity.should == owner.identities.first
      end

      session[:owner_id] = nil
      get :create, provider: 'twitter'
      session[:owner_id].should == Owner.first.id
      Owner.count.should == 1
      Identity.count.should == 1
    end
  end
  context 'facebook' do
    before :each do
      request.env['omniauth.auth'] = YAML.load_file 'spec/fixtures/oauth/facebook.yml'
    end

    specify 'creates from oauth and relogin' do
      allow_any_instance_of(OauthAdapter::Base).to receive(:process_uri).and_return(nil)
      VCR.use_cassette 'facebook-profile', record: :new_episodes do
        get :create, provider: 'facebook'
      end

      expect(controller.send(:current_user)).to be_present
      Owner.first.tap do |owner|
        expect(owner.primary_identity).to be == owner.identities.first
      end

      # re login
      session[:owner_id] = nil
      get :create, provider: 'facebook'
      expect(Owner.count).to be == 1
      expect(session[:owner_id]).to be == Owner.first.id
      expect(Identity.count).to be == 1
    end

  end
  context 'gplus' do
    before :each do
      request.env['omniauth.auth'] = YAML.load_file 'spec/fixtures/oauth/gplus.yml'
    end

    specify 'creates from oauth and relogin' do
      get :create, provider: 'gplus'

      controller.send(:current_user).should be_present
      Owner.first.tap do |owner|
        owner.identities.first.email.should be_present
        owner.primary_identity.should == owner.identities.first
      end

      # re login
      session[:owner_id] = nil
      get :create, provider: 'gplus'
      session[:owner_id].should == Owner.first.id
      Owner.count.should == 1
      Identity.count.should == 1
    end

  end
end
