namespace :one_secret do
  desc "Encrypts and sets a new secret in config/secrets.yml under the current environment"
  task :set => :environment do
    key, value = *ARGV[1..2]
    OneSecret.set(Rails.env, key, value)

    disable_tasks(key, value)
  end

  desc "Encrypts and displays a new secret, but does not store it in config/secrets.yml"
  task :build => :environment do
    value = ARGV[1]
    puts OneSecret.build(value).to_hash

    disable_tasks(value)
  end

  desc "Decrypts and gets a secret from the current environment in config/secrets.yml"
  task :get => :environment do
    key = ARGV[1]
    puts OneSecret.get(Rails.env, key)

    disable_tasks(key)
  end

  desc "Decrypts and gets all secrets from the current environment in config/secrets.yml"
  task :get_all => :environment do
    puts OneSecret.get_all(Rails.env)
  end

  def disable_tasks(*tasks)
    tasks.each do |task_name|
      task task_name.to_sym do ; end
    end
  end
end
