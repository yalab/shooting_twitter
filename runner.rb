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
  @ip_address = @env['REMOTE_ADDR']
end

get "/" do
  streams[@ip_address] = TwitterStream.new unless streams[@ip_address]
  @posts = []
  1.times do
    @posts << streams[@ip_address].pool_data.deq
  end
  haml :index
end

get "/message" do
  streams[@ip_address].pool_data.deq.to_json
end
