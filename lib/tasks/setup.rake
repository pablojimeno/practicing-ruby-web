require 'rails_setup'

desc 'Setup Practicing Ruby for development'
setup_task :setup do

  puts # Empty Line
  puts "#{heart} You are awesome #{heart}"

  section "Configuration Files" do
    database = Rails.root.join('config', 'database.yml').to_s
    
    find_or_create_file(database, "Database config", true)
    done "database.yml"

    find_or_create_file("#{Rails.root}/.env", ".env")
    done(".env")
  end

  section "Database" do
    begin
      # Check if there are pending migrations
      silence { Rake::Task["db:abort_if_pending_migrations"].invoke }
      done "Skip: Database already setup"
    rescue Exception
      silence do
        Rake::Task["db:create"].invoke
        Rake::Task["db:schema:load"].invoke
      end
      done "Database setup"
    end
  end
  
  section "Dependencies" do
    `easy_install Pygments`
    
    done "Pygments installed"
  end

  puts # Empty Line
  puts %{#{'===='.color(:green)} Setup Complete #{'===='.color(:green)}}
  puts # Empty Line

  if console.agree("Would you like to run the test suite? (y/n)")
    silence { Rake::Task["db:test:load"].invoke }
    ENV["TRAVIS"] = 'TRUE' # Skip tests that won't run on travis
    Rake::Task["test"].invoke
  end

end
