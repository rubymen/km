require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :user, 'admin'
set :application, 'km'
set :stages, %w(staging production)
set :default_stage, 'production'

load 'config/deploy/recipes/check'
load 'config/deploy/recipes/mysql'
load 'config/deploy/recipes/unicorn'
load 'config/deploy/recipes/uploads'
load 'deploy/assets'

set :deploy_via, :remote_cache
set :use_sudo, false
set :normalize_asset_timestamps, false

set :scm, 'git'
set :repository, "git@github.com:rubymen/#{application}.git"
set :branch, 'develop'
set :git_enable_submodules, 1

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

default_run_options[:pty] = true

set :unicorn_bin, 'unicorn_rails'
set :keep_releases, 2
after 'deploy', 'deploy:cleanup'
