lock '~> 3.19.2'

set :application, 'collect'
set :repo_url,    'https://github.com/mattantonelli/ffxiv-collect'
set :branch,      ENV['BRANCH_NAME'] || 'main'
set :deploy_to,   '/var/rails/collect'
set :default_env, { path: '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH' }

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '3.3.5'

namespace :deploy do
  desc 'Create symlinks'
  after :updating, :symlink do
    on roles(:app) do
      # Application credentials
      execute :ln, '-s', shared_path.join('master.key'), release_path.join('config/master.key')

      # Persisted logs
      execute :ln, '-s', shared_path.join("log/#{fetch(:rails_env)}.log"),
        release_path.join("log/#{fetch(:rails_env)}.log")
      execute :ln, '-s', shared_path.join('log/whenever.log'),
        release_path.join('log/whenever.log')

      # Game data
      execute :rmdir, release_path.join('vendor/xiv-data')
      execute :ln, '-s', '/var/rails/xiv-data', release_path.join('vendor/xiv-data')

      # Individual collectable images
      %w(mounts minions).each do |model|
        %w(footprint large small).each do |type|
          path = "#{model}/#{type}"
          execute :rm, '-rf', release_path.join('public/images', path)
          execute :ln, '-s', shared_path.join('public/images', path),
            release_path.join('public/images', path)
        end
      end

      %w(fashions records survey_records).each do |model|
        %w(large small).each do |type|
          path = "#{model}/#{type}"
          execute :rm, '-rf', release_path.join('public/images', path)
          execute :ln, '-s', shared_path.join('public/images', path),
            release_path.join('public/images', path)
        end
      end

      %w(achievements armoires items outfits outfit_items bardings emotes relics hairstyles facewear spells achievement_items leve_items frames occult_records).each do |model|
        execute :rm, '-rf', release_path.join('public/images', model)
        execute :ln, '-s', shared_path.join('public/images', model),
          release_path.join('public/images', model)
      end

      # Triple Triad card images
      execute :rm, '-rf', release_path.join('public/images/cards/large')
      execute :ln, '-s', shared_path.join('public/images/cards/large'),
        release_path.join('public/images/cards/large')

      execute :rm, '-rf', release_path.join('public/images/cards/small')
      execute :ln, '-s', shared_path.join('public/images/cards/small'),
        release_path.join('public/images/cards/small')

      execute :rm, '-rf', release_path.join('public/images/cards/blue')
      execute :ln, '-s', shared_path.join('public/images/cards/blue'),
        release_path.join('public/images/cards/blue')

      execute :rm, '-rf', release_path.join('public/images/cards/red')
      execute :ln, '-s', shared_path.join('public/images/cards/red'),
        release_path.join('public/images/cards/red')

      # Music samples
      execute :rm, '-rf', release_path.join('public/music')
      execute :ln, '-s', shared_path.join('public/music'), release_path.join('public/music')
    end
  end

  before :updated, :copy_images do
    on roles(:app) do
      # Copy the spritesheets from the previous deployment if they exist. Otherwise, generate them.
      if test("[ -f #{current_path.join('app/assets/images/mounts-small.png')} ]")
        execute :cp, current_path.join('app/assets/images/mounts-small.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/minions-small.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/achievements.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/achievement_items.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/emotes.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/bardings.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/armoires.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/outfits.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/outfit_items.png'),
          release_path.join('app/assets/images')
        execute :cp, '-R', current_path.join('app/assets/images/hairstyles/*.png'),
          release_path.join('app/assets/images/hairstyles')
        execute :cp, '-R', current_path.join('app/assets/images/facewear/*.png'),
          release_path.join('app/assets/images/facewear')
        execute :cp, current_path.join('app/assets/images/spells.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/relics-*.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/fashions-small.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/records-small.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/survey_records-small.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/cards-large.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/cards-small.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/images/leve_items.png'),
          release_path.join('app/assets/images')
        execute :cp, current_path.join('app/assets/stylesheets/images/*.scss'),
          release_path.join('app/assets/stylesheets/images')

        # Horizontal card spritesheets
        execute :cp, current_path.join('public/images/cards-large.png'),
          release_path.join('public/images')
        execute :cp, current_path.join('public/images/cards-red.png'),
          release_path.join('public/images')
        execute :cp, current_path.join('public/images/cards-blue.png'),
          release_path.join('public/images')
        execute :cp, current_path.join('public/images/cards-small.png'),
          release_path.join('public/images')
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
      execute 'sudo systemctl restart sidekiq-ffxiv-collect-character'
      execute 'sudo systemctl restart sidekiq-ffxiv-collect-free-company'
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
end
