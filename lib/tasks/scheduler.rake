desc 'This task is called by the Heroku scheduler add-on'
task :update_feed => :environment do
  require 'line/bot'  # gem 'line-bot-api'
  require 'open-uri'
  require 'kconv'
  require 'rexml/document'

  include LinebotHelper

  client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
  }

  res_hash = createText

  # res_codeが1の場合(降水確率が一定以上)のみメッセージ送信
  if (res_hash[:res_code] == 1)

    # 送信先IDは登録した自分の1件のみ
    user_id = ENV['MY_USER_ID']
    message = {
      type: 'text',
      text: "#{res_hash[:res_text]}\nこれは自動実行。"
    }
    response = client.push_message(user_id, message)
  end
  "OK"
end
