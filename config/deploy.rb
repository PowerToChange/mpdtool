set :keep_releases, '20'
set :user, 'deploy'
set :use_sudo, false
set :scm, 'git'
set :repository, "git://github.com/PowerToChange/mpdtool.git"
set :deploy_via, :checkout
set :git_enable_submodules, false
#set :git_shallow_clone, true

after "deploy", "deploy:cleanup"

def link_shared(p, o = {})
  if o[:overwrite]
    run "rm -Rf #{release_path}/#{p}"
  end

  run "ln -s #{shared_path}/#{p} #{release_path}/#{p}"
end

task :production do
  role :app, 'pat.powertochange.org'
  set :rails_env, 'production'
  set :application, 'mpdtool'
  set :title, 'mpdtool'
  set :branch, 'master'
  set :deploy_to, "/var/www/mpdtool.powertochange.org"
end

before :"deploy:create_symlink", :"deploy:before_symlink"
deploy.task :before_symlink do
  # set up tmp dir
  run "mkdir -p -m 770 #{shared_path}/tmp/{cache,sessions,sockets,pids}"
  run "rm -Rf #{release_path}/tmp"
  link_shared 'tmp'

  # other shared files / folders
  link_shared 'log', :overwrite => true
  link_shared 'config/database.yml', :overwrite => true
  link_shared 'config/initializers/analytics.rb', :overwrite => true
  link_shared 'config/initializers/cas.rb', :overwrite => true
  link_shared 'config/initializers/email.rb', :overwrite => true
  link_shared 'config/initializers/hoptoad.rb', :overwrite => true
  link_shared 'config/initializers/i18n.rb', :overwrite => true

  run "cd #{release_path} && git submodule init"
  run "cd #{release_path} && git submodule update"
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:reload, :start, :stop].each do |t|
    desc "#{t} task is not applicable to Passenger"
    task t, :roles => :app do ; end
  end
end
