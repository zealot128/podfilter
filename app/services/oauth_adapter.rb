module OauthAdapter
  def self.run(provider, owner, auth)
    klass = case provider
    when 'github' then Github
    when 'twitter' then Twitter
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
        owner.update_attribute :token, nil
        owner.identities.create! provider: provider, uid: uid, email: email, name: name, remote_image_url: image
        owner
      end
    end
  end

  class Github < Base
    def provider
      'github'
    end
    def email
      @auth.info.email
    end
    def image
      @auth.info.image
    end
    def uid
      @auth.uid
    end
    def name
      @auth.info.name
    end
  end

  class Twitter < Base
    def provider
      'twitter'
    end
  end
end
