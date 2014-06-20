module OauthAdapter
  def self.run(provider, owner, auth)
    klass = case provider
    when 'github' then Github
    when 'twitter' then Twitter
    when 'facebook' then Facebook
    when 'gplus' then Gplus
    end

    klass.new(owner, auth).run

  end

  class Base
    attr_reader :auth, :owner
    def initialize(owner, auth)
      @owner = owner
      @auth = auth
    end

    def run
      if identity = Identity.where(provider: provider, uid: uid).first
        identity.owner
      else
        owner.save! validate: false
        i = owner.identities.create! provider: provider, uid: uid, email: email, name: name, remote_image_url: process_uri(image)
        owner.primary_identity = i
        owner.token = nil
        owner.save! validate: false
        if owner.opml_files.count == 0
          owner.opml_files.create! name: 'Standard'
          owner.ignore_file
        end
        owner
      end
    end
    def uid; @auth.uid end
    def name; @auth.info.name end
    def email; @auth.info.email end
    def image; @auth.info.image end
    def process_uri(uri)
      return nil if uri.nil?
      require 'open-uri'
      require 'open_uri_redirections'
      open(uri, :allow_redirections => :safe) do |r|
        r.base_uri.to_s
      end
    end
  end

  class Github < Base
    def provider; 'github' end
  end

  class Twitter < Base
    def provider; 'twitter' end
    def email; nil end
  end

  class Facebook < Base
    def provider; 'facebook' end
  end

  class Gplus < Base
    def provider; 'gplus' end
  end
end
