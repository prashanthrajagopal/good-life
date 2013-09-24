#set :rvm_ruby_string, '1.9.3'                     # Or:
set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"") # Read from local system
require "rvm/capistrano"                               # Load RVM's capistrano plugin.
set :rvm_type, :system  # Copy the exact line. I really mean :system here

set :use_sudo, false

set :application, "good-life"

desc "Staging for development environment"
task :development do
  set :user, `whoami`.chomp
  set :rails_env,"development"
  set :repository,  "/home/#{user}/good-life/.git"
  set :deploy_to, "/home/#{user}/site"
  set :branch, 'master'
  set :scm, :git

  role :web, "localhost"
  role :app, "localhost"
  role :db,  "localhost", :primary => true
  default_run_options[:pty] = true

  after "deploy:restart", "deploy:cleanup"
  after 'deploy', 'unicorn:restart'   # app IS NOT preloaded

end
namespace :deploy do
  task :print_variables do 
    puts "#{current_path}"
	end

	desc <<-DESC
    Prepares one or more servers for deployment. Before you can use any \
    of the Capistrano deployment tasks with your project, you will need to \
    make sure all of your servers have been prepared with `cap deploy:setup'. When \
    you add a new server to your cluster, you can easily run the setup task \
    on just that server by specifying the HOSTS environment variable:

      $ cap HOSTS=new.server.com deploy:setup

    It is safe to run this task on servers that have already been set up; it \
    will not destroy any deployed revisions or data.
  DESC
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, releases_path, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d.split('/').last) }
    run " mkdir -p #{dirs.join(' ')}"
  end
end

namespace :unicorn do
  desc "Zero-downtime restart of Unicorn"
  task :restart, :except => { :no_release => true } do
    #run "kill -s USR2 `cat #{shared_path}/pids/unicorn.pid`"
    stop if File.exist? "#{shared_path}/pids/unicorn.pid"
    start
  end

  desc "Start unicorn"
  task :start, :except => { :no_release => true } do
    run "cd #{current_path} ; bundle exec unicorn_rails -c #{current_path}/config/unicorn/#{rails_env}.rb -D -E #{rails_env}"
  end

  desc "Stop unicorn"
  task :stop, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{shared_path}/pids/unicorn.pid`"
  end
end