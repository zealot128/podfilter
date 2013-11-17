set :stage, :production


server 'podfilter.de',
  user: 'stefan',
  roles: %w{web app db sidekiq},
  ssh_options: {
    user: 'stefan', # overrides user setting above
    keys: %w(~/.ssh/id_rsa),
    forward_agent: false,
    auth_methods: %w(publickey password)
  }
# setting per server overrides global ssh_options

# fetch(:default_env).merge!(rails_env: :production)
