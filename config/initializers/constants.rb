module Constants
  # 降水確率の下限値
  MIN_PER = 10

  # 天気予報情報提供元のURL
  WEATHER_NEWS_URL = 'https://www.drk7.jp/weather/xml/13.xml'

  # 天気予報のエリアは東京都を指定
  target_area = 'area[4]'

  # 結果XMLにおける時間ごとの降水確率の階層
  XML_PATH_06_12 = "weatherforecast/pref/#{target_area}/info/rainfallchance/period[2]"
  XML_PATH_12_18 = "weatherforecast/pref/#{target_area}/info/rainfallchance/period[3]"
  XML_PATH_18_24 = "weatherforecast/pref/#{target_area}/info/rainfallchance/period[4]"
end