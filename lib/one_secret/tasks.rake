namespace :one_secret do
  task :set => :environment do
    key, value = *ARGV[1..2]
    puts OneSecret.set(Rails.env, key, value)

    disable_tasks(key, value)
  end

  task :get => :environment do
    key = ARGV[1]
    puts OneSecret.get(Rails.env, key)

    disable_tasks(key)
  end

  def disable_tasks(*tasks)
    tasks.each do |task_name|
      task task_name.to_sym do ; end
    end
  end
end
