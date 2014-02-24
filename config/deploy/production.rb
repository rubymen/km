server 'km.epnet.fr', :web, :app, :db, primary: true

set :rails_env, 'production'
set :unicorn_env, 'production'
set :app_env, fetch(:rails_env)
set :deploy_to, "/home/#{user}/apps/#{application}_#{stage}"
set :host_name, 'km.epnet.fr'
set :branch, 'develop'
