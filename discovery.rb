# encoding: utf-8
Encoding.default_external = 'utf-8'
Encoding.default_internal = 'utf-8'
require 'rubygems'
require 'bundler'
Bundler.require

require 'open-uri'
require 'set'

unless (@api_key = ARGV.first)
  puts "usage: ruby #{__FILE__} GITHUB_OAUTH_TOKEN   # Generate yours at https://github.com/settings/applications"
  exit
end

     @directions = [:followers, :following] # the traversable relation directions
  @checked_users = []                       # an ever growing list of login names
@unchecked_users = [:efi]                   # setup the center(s) of your (graph) universe
          @delay = 0.8                      # 800ms is enough to stay well below the rate limit of 5k req/hour

@directions.each{|d| Dir.mkdir("./#{d}") unless File.exists?("./#{d}")}

def neighbours_of user_login, force_api_loading=false
  result = Hash.new []
  @directions.each do |type|
    if !File.exists?(cache="./#{type}/#{user_login}.json") || force_api_loading
      File.open(cache,"w"){|c| c.write begin;open("https://api.github.com/users/#{user_login}/#{type}",http_basic_authentication:[@api_key,"x-oauth-basic"]){|i|i.read};rescue;end||"[]"}
      sleep @delay
    end
    result[type] = begin;JSON.load(File.open(cache).read).map{|u|u["login"]};rescue;end||[]
  end
  return result
end

while !@unchecked_users.empty? do
  user = @unchecked_users.shift
  puts "#{@checked_users.size} / #{@unchecked_users.size} - #{user}"
  user_neighbours = neighbours_of user
  @unchecked_users |= @directions.map{|d| user_neighbours[d].map(&:to_sym)}.inject(&:|)
  @checked_users |= [user]
end