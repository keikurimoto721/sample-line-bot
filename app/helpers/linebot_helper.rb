module LinebotHelper
  require 'line/bot'  # gem 'line-bot-api'

  require 'open-uri'
  require 'kconv'
  require 'rexml/document'

  def createText
    # xmlデータを取得してパース
    res_doc = REXML::Document.new(open(Constants::WEATHER_NEWS_URL).read.toutf8)

    # 時間ごとの降水確率取得
    per06to12 = res_doc.elements[Constants::XML_PATH_06_12].text
    per12to18 = res_doc.elements[Constants::XML_PATH_12_18].text
    per18to24 = res_doc.elements[Constants::XML_PATH_18_24].text

    # メッセージを発信する降水確率の下限値の設定
    min_per = Constants::MIN_PER

    if (per06to12.to_i >= min_per || per12to18.to_i >= min_per || per18to24.to_i >= min_per)
      resText = "この道を行けばどうなるものか。\n 6〜12時 #{per06to12}％\n12〜18時 #{per12to18}％\n18〜24時 #{per18to24}％"
    else
      resText = '案ずるでない。気にせず行け。'
    end
    return resText
  end

end
