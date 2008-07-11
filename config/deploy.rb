set :application, "musicman"

set :user, "mm"
# ssh_options[:port] = 2222
ssh_options[:paranoid] = false
set :scm, :git
set :repository, "git@github.com:dcparker/musicman.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/mm/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "192.168.1.109"
role :web, "192.168.1.109"
role :db,  "192.168.1.109", :primary => true

desc "Link in the production extras and Migrate the Database ;)"
task :after_update_code do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/config/init.rb #{release_path}/config/init.rb"
  # run "ln -nfs #{shared_path}/config/app_config.rb #{release_path}/config/app_config.rb"
  run "ln -nfs #{shared_path}/log #{release_path}/log"
  # run "cp #{shared_path}/bliss/account_sharing.rb #{release_path}/bliss/"
  # run "cp #{shared_path}/bliss/application_controller.rb #{release_path}/bliss/"
  # run "cp #{shared_path}/bliss/signin_controller.rb #{release_path}/bliss/"
  #if you use ActiveRecord, migrate the DB
  #deploy.migrate
end

task :soft_deploy do
  run "cd #{current_path};git pull"
  run "cd #{current_path};./script/stop_merb"
  run "cd #{current_path};./script/start_merb"
end

desc "Merb it up with"
deploy.task :restart do
  run "cd #{current_path};./script/stop_merb"
# To run message cluster:
  # run "cd #{current_path};env EVENT=1 merb -c 4"
  run "cd #{current_path};./script/start_merb"
# If you want to run standard mongrel use this:
# run "cd #{current_path};merb -c 4"
end

deploy.task :stop do
  run "cd #{current_path};./script/stop_merb"
end

deploy.task :start do
  run "cd #{current_path};./script/start_merb"
end

#Overwrite the default deploy.migrate as it calls: 
#rake RAILS_ENV=production db:migrate
#desc "MIGRATE THE DB! ActiveRecord"
#deploy.task :migrate do
#  run "cd #{release_path}; rake db:migrate MERB_ENV=production"
#end