class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  require 'open-uri'
  require 'kconv'
  require 'rexml/document'

  include LinebotHelper

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text

          # event.message['text']：ユーザーから送られたメッセージ
          input = event.message['text']
          url  = "https://www.drk7.jp/weather/xml/13.xml"
          xml  = open( url ).read.toutf8
          doc = REXML::Document.new(xml)
          xpath = 'weatherforecast/pref/area[4]/'

          # 当日朝のメッセージの送信の下限値は20％としているが、明日・明後日雨が降るかどうかの下限値は30％としている
          min_per = 30
          
          per06to12 = doc.elements[xpath + 'info/rainfallchance/period[2]l'].text
          per12to18 = doc.elements[xpath + 'info/rainfallchance/period[3]l'].text
          per18to24 = doc.elements[xpath + 'info/rainfallchance/period[4]l'].text
          
          if per06to12.to_i >= min_per || per12to18.to_i >= min_per || per18to24.to_i >= min_per

            push = "今日は雨降りそう。\n　  6〜12時　#{per06to12}％\n　12〜18時　 #{per12to18}％\n　18〜24時　#{per18to24}％"
          else
            push = '今日は晴れ。'
          end

          message = {
            type: 'text',
            text: push
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    }

    head :ok
  end
end
