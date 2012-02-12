require "bundler"
Bundler.require

mail_whale = Newman::Application.new do
  helpers do
    def load_list(name)
      store = Newman::Store.new(settings.application.database)
      Newman::MailingList.new(name, store)
    end
  end

  match :list_id, ".+"

  to(:tag, "{list_id}") do
    list = load_list(params[:list_id])
    reply_to ="#{settings.application.inbox}+#{params[:list_id]}@#{domain}"

    if list.subscriber?(sender)
      forward_message :bcc => list.subscribers.join(", "),
                      :reply_to => reply_to
    else
      respond :subject => "You are not subscribed",
              :body => template("non-subscriber-error")
    end
  end

  default do
    respond(:subject => "FAILURE")
  end
end

settings = Newman::Settings.from_file("config/environment.rb")
mailer = Newman::Mailer.new(settings)

server = Newman::Server.new(settings, mailer)
server.apps << Newman::RequestLogger << mail_whale << Newman::ResponseLogger

server.tick
