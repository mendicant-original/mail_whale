require 'bundler/capistrano'

set :application, "mail_whale"
set :repository,  "git://github.com/mendicant-university/mail_whale.git"

set :scm, :git
set :deploy_to, "/var/rapp/#{application}"

set :user, "git"
set :use_sudo, false

set :deploy_via, :remote_cache

set :branch, "master"
server "mendicantuniversity.org", :app, :web, :db, :primary => true

# before 'deploy:update_code' do
#   run "sudo god stop mail_whale"
# end

after 'deploy:update_code' do
  run "ln -nfs #{shared_path}/mail_whale.store #{release_path}/data/mail_whale.store"
  run "ln -nfs #{shared_path}/environment.rb #{release_path}/config/environment.rb"
end

# after 'deploy' do
#   run "sudo god load #{release_path}/config/mail_whale.god"
#   run "sudo god start mail_whale"
# end

after "deploy", 'deploy:cleanup'