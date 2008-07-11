require 'server_init'

# Dependencies.
use_orm :datamapper

# Merb Config.
Merb::Config.use { |c|
  c[:environment]         = 'production',
  c[:framework]           = {},
  c[:log_level]           = 'debug',
  c[:use_mutex]           = false,
  c[:session_store]       = 'cookie',
  c[:session_id_key]      = '_musicbox_session',
  c[:session_secret_key]  = '47c411379e862346b1cb1f45bf1aee15e780f702',
  c[:exception_details]   = true,
  c[:reload_classes]      = true,
  c[:reload_time]         = 0.5
}

# App Config.
APP = YAML.load_file('config/music.yml')

# Routes.
Merb::Router.prepare do |r|
  r.match('/').to(:controller => 'music_man', :action => 'index')
  r.match('/:action').to(:controller => 'music_man')
end
