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

# herokuへのアップロード時にコメント化した
#
#ActiveRecord::Base.configurations = YAML.load_file('config/database.yml')
#ActiveRecord::Base.establish_connection('development')

# heroku postgresqlの接続用コード
ActiveRecord::Base.establish_connection(ENV['postgres://sdezcgxojqsddd:tMzk-k8yYm_vKQ2YTxYODK90lD@ec2-107-21-93-97.compute-1.amazonaws.com:5432/d8esrjg5rn2qde'])

#use ActiveRecord::ConnectionAdapters::ConnectionManagement
#run Sinatra::Application

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

# 削除ボタン
get '/delete/:id' do
  @d_tango = Tango.find(params[:id])
  erb :delete
end

# キャンセルボタンを押してもレコードが削除されちゃう
post '/delete/:id' do
  word = Tango.find(params[:id])
  word.destroy
  redirect '/'
end


# herokuへのアップロード

