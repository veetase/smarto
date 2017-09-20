require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina_sidekiq/tasks'
require 'mina/puma'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)
# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'bixuange.com'
set :deploy_to, '/alidata/www/api'
set :repository, 'git@github.com:veetase/smarto.git'
set :branch, 'master'
set :term_mode, nil

# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/mongoid.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['.env', 'log', 'config/puma.rb', 'config/database.yml', 'public/uploads', 'tmp/pids']

# Optional settings:
set :user, 'root'    # Username in the server to SSH to.
set :rvm_path, '/usr/local/rvm/scripts/rvm'
#   set :port, '30000'     # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby 2.2@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}"]

  queue! %[touch "#{deploy_to}/#{shared_path}/.env"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/.env'."]
 # puma.rb
  queue! %[touch "#{deploy_to}/shared/config/puma.rb"]
  queue  %[echo "-----> Be sure to edit 'shared/config/puma.rb'."]

  # tmp/sockets/puma.state
  queue! %[touch "#{deploy_to}/shared/tmp/sockets/puma.state"]
  queue  %[echo "-----> Be sure to edit 'shared/tmp/sockets/puma.state'."]

  # log/puma.stdout.log
  queue! %[touch "#{deploy_to}/shared/log/puma.stdout.log"]
  queue  %[echo "-----> Be sure to edit 'shared/log/puma.stdout.log'."]

  # log/puma.stderr.log
  queue! %[touch "#{deploy_to}/shared/log/puma.stderr.log"]
  queue  %[echo "-----> Be sure to edit 'shared/log/puma.stderr.log'."]

  # sidekiq needs a place to store its pid file and log file
  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  # puma bind sock file place
  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    # stop accepting new workers
    invoke :'sidekiq:quiet'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'prepare:static_page'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'prepare:do_copy'
    invoke :'deploy:cleanup'

    to :launch do
      invoke :'sidekiq:restart'
      # invoke :'puma:phased_restart'
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
  end
end

namespace :prepare do
  desc 'prepare static page shengmaodou, so that it can be served directly by ngnix'
  task :static_page do
    queue %[cd #{deploy_to}/#{current_path}/app && cp views/static/shengmaodou.html.erb assets/html/dou.html.erb]
  end

  task :do_copy do
    queue! %[cd #{deploy_to}/#{current_path}/public && for d in assets/dou-*.html; do cp $d dou.html; done]
    queue  %[echo "-----> copy public html done"]
  end
end

desc "Shows logs."
task :logs do
  queue %[cd #{deploy_to}/#{current_path} && tail -f log/production.log]
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
