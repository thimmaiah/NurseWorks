# Load DSL and Setup Up Stages
require 'capistrano/deploy'
require 'capistrano/setup'
require 'capistrano/rails/migrations'
require 'capistrano/rails/assets'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git
require 'capistrano/rvm'
require 'capistrano/bundler'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
# Load DSL and Setup Up Stages

require 'capistrano/puma'
require 'capistrano/puma/monit'
install_plugin Capistrano::Puma  # Default puma tasks
#install_plugin Capistrano::Puma::Workers  # if you want to control the workers (in cluster mode)
#install_plugin Capistrano::Puma::Jungle # if you need the jungle tasks
install_plugin Capistrano::Puma::Monit 
#install_plugin Capistrano::Puma::Nginx  # if you want to upload a nginx site template