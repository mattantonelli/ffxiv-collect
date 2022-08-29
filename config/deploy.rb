lock '~> 3.16.0'

set :application, 'collect'
set :repo_url,    'https://github.com/mattantonelli/ffxiv-collect'
set :branch,      ENV['BRANCH_NAME'] || 'master'
set :deploy_to,   '/var/rails/collect'
set :default_env, { path: '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH' }

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '3.1.0'

# sidekiq
set :sidekiq_configs, [
  'config/sidekiq_character.yml',
  'config/sidekiq_free_company.yml'
]
set :sidekiq_processes, 2

namespace :deploy do
  desc 'Create symlinks'
  after :updating, :symlink do
    on roles(:app) do
      # Application credentials
      execute :ln, '-s', shared_path.join('master.key'), release_path.join('config/master.key')

      # Persisted logs
      execute :ln, '-s', shared_path.join("log/#{fetch(:rails_env)}.log"), release_path.join("log/#{fetch(:rails_env)}.log")
      execute :ln, '-s', shared_path.join('log/whenever.log'), release_path.join('log/whenever.log')

      # Individual collectable images
      %w(mounts minions).each do |model|
        %w(footprint large small).each do |type|
          path = "#{model}/#{type}"
          execute :rm, '-rf', release_path.join('public/images', path)
          execute :ln, '-s', shared_path.join('public/images', path), release_path.join('public/images', path)
        end
      end

      %w(fashions records).each do |model|
        %w(large small).each do |type|
          path = "#{model}/#{type}"
          execute :rm, '-rf', release_path.join('public/images', path)
          execute :ln, '-s', shared_path.join('public/images', path), release_path.join('public/images', path)
        end
      end

      %w(achievements armoires bardings emotes relics hairstyles spells items).each do |model|
        execute :rm, '-rf', release_path.join('public/images', model)
        execute :ln, '-s', shared_path.join('public/images', model), release_path.join('public/images', model)
      end

      # Hairstyle screenshots
      execute :ln, '-s', shared_path.join('hairstyles/*'), release_path.join('app/assets/images/hairstyles/screenshots')

      # Music samples
      execute :rm, '-rf', release_path.join('public/music')
      execute :ln, '-s', shared_path.join('public/music'), release_path.join('public/music')
    end
  end

  before :updated, :update_bin do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'app:update:bin'
        end
      end
    end
  end

  before :updated, :copy_images do
    on roles(:app) do
      # Copy the spritesheets from the previous deployment if they exist. Otherwise, generate them.
      if test("[ -f #{current_path.join('app/assets/images/mounts-small.png')} ]")
        execute :cp, current_path.join('app/assets/images/mounts-small.png'), release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/minions-small.png'), release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/achievements.png'), release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/items.png'), release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/emotes.png'), release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/bardings.png'), release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/armoires.png'), release_path.join('app/assets/images')
        execute :cp, '-R', current_path.join('app/assets/images/hairstyles/*.png'),
          release_path.join('app/assets/images/hairstyles')
        execute :cp, current_path.join('app/assets/images/spells.png'), release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/relics-*.png'), release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/fashions-small.png'), release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/records-small.png'), release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/stylesheets/images/*.scss'), release_path.join('app/assets/stylesheets/images')
      else
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'spritesheets:create'
          end
        end
      end
    end
  end

  desc 'Restart application'
  after :publishing, :restart do
    on roles(:app) do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
end
