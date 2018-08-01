module LinebotHelper
  require 'line/bot'  # gem 'line-bot-api'

  require 'open-uri'
  require 'kconv'
  require 'rexml/document'

  def createText
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
      resText = "この道を行けばどうなるものか。\n　  6〜12時　#{per06to12}％\n　12〜18時　 #{per12to18}％\n　18〜24時　#{per18to24}％"
    else
      resText = '案ずるでない。気にせず行け。'
    end
    return resText
  end
  
end
