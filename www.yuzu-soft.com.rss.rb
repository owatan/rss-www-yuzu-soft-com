#!/usr/bin/env ruby

require "rubygems"
require "nokogiri"
require "open-uri"
require "date"

URL = "http://www.yuzu-soft.com/"

html = open(URL) do |f|
  f.read
end

# header
puts <<EOF
<rss version='2.0'>
  <channel>
    <title>新着情報 | ゆずソフト</title>
    <link>http://www.yuzu-soft.com/</link>
    <description />
EOF

res = Nokogiri::HTML.parse(html, nil, "utf-8")
res.xpath('//div[@class="update-frame"]/dl').first(10).each_with_index do |obj, i|
  # item
  puts "<item>"

  # title
  puts "<title>" + obj.xpath('//dd')[i].text + "</title>"

  # link
  if obj.xpath('//dd/a/@href')[i].include?("http://")
    # http(s) が含まれる
    # => だいたい絶対リンク
      link = obj.xpath('//dd/a/@href')[i]
  else
    # http(s) が含まれない
    # => だいたい同ドメイン内の相対リンク
      link = "http://www.yuzu-soft.com/" + obj.xpath('//dd/a/@href')[i]
  end
  puts "<link>" + link + "</link>"

  # pubDate
  date = DateTime.parse( obj.xpath('//dt')[i].text + " 00:00 JST" )
  puts "<pubDate>" + date.rfc2822 + "</pubDate>"

  # /item
  puts "</item>"
end

# footer
puts <<EOF
  </channel>
</rss>
EOF
