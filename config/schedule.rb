set :output, "/var/rapp/mail_whale/current/log/cron.log"

every 1.minute do
  command "ruby mail_whale.rb"
end
