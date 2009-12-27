require 'rubygems'
require 'eventmachine'
require 'twitter/json_stream'
require 'json'
require 'yaml'
require 'pp'
class TwitterStream
  attr_accessor :pool_data
  MaxPool = 100
  def initialize(auth, hashtag='')
    hashtag = 'track=' + hashtag
    @pool_data = Queue.new
    trhead = Thread.new {
      EventMachine::run do
        stream = Twitter::JSONStream.connect(:auth    => auth,
                                             :method  => 'POST',
                                             :path    => '/1/statuses/filter.json',
                                             #:path    => '/1/statuses/sample.json',
                                             :content => hashtag
                                             #:content => ''
                                             )

        stream.each_item do |item|
          return unless item = JSON.parse(item)
          pp item
          @pool_data << item
          if @pool_data.length > MaxPool
            @pool_data.unshift
          end
        end

        stream.on_error do |message|
          $stdout.print "error: #{message}\n"
          $stdout.flush
        end

        stream.on_reconnect do |timeout, retry_count|
          $stdout.print "reconnectiong: #{timeout} seconds, retry #{retry_count}\n"
          $stdout.flush
        end
      end
    }
  end
end
