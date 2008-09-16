Merb::Config.use { |c|
  c[:framework] = {
    :application => "application.rb",
    :view => "views",
    :config => "config",
    :public => "public"
  }
  c[:log_level] = 'debug'
  c[:log_file] = 'config/development.log'
}
