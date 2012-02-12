set :output, "/var/rapp/mail_whale/current/log/cron.log"

job_type :command, "cd :path && bundle exec :task :output"

every 1.minute do
  command "ruby mail_whale.rb"
end
