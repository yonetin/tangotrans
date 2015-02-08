require 'sinatra'
require 'bundler'
require 'rubygems'
require 'sinatra/reloader'
require "sinatra/activerecord"
require 'rexml/document'
require 'rexml/parseexception'
require 'kconv'
require 'uri'
require 'open-uri'
require 'nokogiri'


ActiveRecord::Base.configurations = YAML.load_file('config/database.yml')
ActiveRecord::Base.establish_connection('development')

class Tango < ActiveRecord::Base
end

# 意味を調べるメソッド
def get_Japanese_mean(word)
  enc_word = URI.encode(word)
  
  # dejizouのURL
  url = "http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite?Dic=EJdict&Word=#{enc_word}&Scope=HEADWORD&Match=EXACT&Merge=OR&Prof=XHTML&PageSize=20&PageIndex=0"
  xml = open(url).read
  doc = Nokogiri::XML(xml)
  item_id = doc.search('ItemID').first.inner_text rescue nil
  # 英単語のItemIDから日本語訳を取得
  url = "http://public.dejizo.jp/NetDicV09.asmx/GetDicItemLite?Dic=EJdict&Item=#{item_id}&Loc=&Prof=XHTML"
  xml = open(url).read
  doc = Nokogiri::XML(xml)
  text = doc.search('Body').inner_text rescue nil
  text.gsub!(/(\r\n|\r|\n|\t|\s)/, '')
  if text == "" then "スペルミスか辞書に登録がありません"
  else return text end
end

get '/' do
  @tangos = Tango.all
  erb :index
end

get '/erb_templete_page' do
  erb :erb_templete_page
end

post '/' do
  @tango = @params[:word]
  box = Tango.new
  box.word = @tango
  puts @tango
  mean = get_Japanese_mean(@tango)
  box.mean1 = "#{mean}"
  box.save
  redirect '/'
end

puts get_Japanese_mean("hello")
