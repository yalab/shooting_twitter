require 'rubygems'
require 'sinatra'
require 'eventmachine'
require 'twitter/json_stream'
require 'json'
require File.dirname(File.expand_path(__FILE__)) + '/lib/twitter'

streams = {}
set :haml, {:format => :html5}
before do
  @env = request.env
  @user = @env['REMOTE_ADDR'] + @env['HTTP_USER_AGENT']
end

get "/" do
  @posts = []
  haml :index
end

post "/hashtag/:hashtag" do
  hashtag = params[:hashtag]
  yml = YAML.load_file(File.dirname(File.expand_path(__FILE__)) + '/config/config.yml')
  streams[@user] = TwitterStream.new(yml['auth'], hashtag) unless streams[@user]
  @posts = []
  1.times do
    @posts << streams[@user].pool_data.deq
  end
  haml :index
end

get "/message/:hashtag" do
  hashtag = params[:hashtag]
  queue = streams[@user].pool_data.deq
  queue[:hashtag] = hashtag
  queue.to_json
end
