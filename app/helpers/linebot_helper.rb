module LinebotHelper
  require 'line/bot'  # gem 'line-bot-api'

  require 'open-uri'
  require 'kconv'
  require 'rexml/document'

  def createText
    # xmlデータを取得してパース
    res_doc = REXML::Document.new(open(Constants::WEATHER_NEWS_URL).read.toutf8)

    # 時間ごとの降水確率取得
    xml_date = res_doc.elements[Constants::XML_PATH_DATE].text
    str_date = xml_date.strftime("%Y年 %m月 %d日 %w曜日")

    # 時間ごとの降水確率取得
    per06to12 = res_doc.elements[Constants::XML_PATH_06_12].text
    per12to18 = res_doc.elements[Constants::XML_PATH_12_18].text
    per18to24 = res_doc.elements[Constants::XML_PATH_18_24].text

    # 気温の取得
    max_temp = res_doc.elements[Constants::XML_PATH_MAX].text
    min_temp = res_doc.elements[Constants::XML_PATH_MIN].text

    # メッセージを発信する降水確率の下限値の設定
    min_per = Constants::MIN_PER

    res_hash = if (per06to12.to_i >= min_per || per12to18.to_i >= min_per || per18to24.to_i >= min_per)
      {:res_code => 1,
       :res_text => "#{str_date}\n傘忘れるなよ。\n  6〜12時 #{per06to12}％\n12〜18時 #{per12to18}％\n18〜24時 #{per18to24}％\n最高気温 #{max_temp}\n最低気温 #{min_temp}"}
    else
      {:res_code => 0,
       :res_text => "#{str_date}\n多分雨降らないよ。\n  6〜12時 #{per06to12}％\n12〜18時 #{per12to18}％\n18〜24時 #{per18to24}％\n最高気温 #{max_temp}\n最低気温 #{min_temp}"}
    end
    return res_hash
  end

end
