set :stage, :production


server 'localhost',
  user: 'stefan',
  roles: %w{web app db sidekiq},
    # keys: %w(~/.ssh/id_rsa),
    forward_agent: true,
    auth_methods: %w(publickey)
  # }
# setting per server overrides global ssh_options

# fetch(:default_env).merge!(rails_env: :production)
