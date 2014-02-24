namespace :uploads do
  desc 'Creates the upload folders unless they exist'
  task :setup, except: { no_release: true } do
    dirs = uploads_dirs.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
  end

  desc 'Creates the symlink to uploads shared folder for the most recently deployed version.'
  task :symlink, except: { no_release: true } do
    run "rm -rf #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end

  desc 'Computes uploads directory paths and registers them in Capistrano environment.'
  task :register_dirs do
    set :uploads_dirs,    %w(uploads)
    set :shared_children, fetch(:shared_children) + fetch(:uploads_dirs)
  end

  after       'deploy:finalize_update', 'uploads:symlink'
  on :start,  'uploads:register_dirs',  except: stages + ['multistage:prepare']
end
