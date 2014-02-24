set :unicorn_pid, "/home/#{user}/apps/#{application}_#{rails_env}/shared/pids/unicorn.pid"

namespace :unicorn do
  task :start, roles: :app do
    run "cd #{current_path} && bundle exec #{unicorn_bin} -E #{rails_env} -D -p 8083"
  end

  task :force_stop, roles: :app do
    run "if [ -e #{unicorn_pid} ]; then echo 'Forcing stop...'; kill -9 $(cat #{unicorn_pid}); fi"
  end

  task :stop, roles: :app do
    run "if [ -e #{unicorn_pid} ]; then echo 'Stopping...'; kill $(cat #{unicorn_pid}); fi"
  end

  task :reload, roles: :app do
    run " if [ -e #{unicorn_pid} ]; then echo 'Reloading...'; kill -s USR2 $(cat #{unicorn_pid}); fi"
  end

  task :restart, roles: :app do
    run "echo 'Restarting...'; if [ -e #{unicorn_pid} ]; then echo ' Forcing stop...'; kill -9 $(cat #{unicorn_pid}); sleep 5; fi; echo ' Starting...'; cd #{current_path} && bundle exec #{unicorn_bin} -E #{rails_env} -D -p 8083"
  end

  %w(start stop restart).each do |command|
    after "deploy:#{command}", "unicorn:#{command}"
  end
end
