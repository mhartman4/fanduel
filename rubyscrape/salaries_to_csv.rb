require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'CSV'

fanduel_url = "https://www.fanduel.com/e/Game/9107?tableId=3159199"

class Player
  attr_reader :player_id, :position, :name, :salary, :fppg, :games_played, :yahoo_url

    def initialize(player_id, position, name, salary, fppg, games_played, yahoo_url)
      @player_id = player_id
      @position = position
      @name = name
      @salary = salary
      @fppg = fppg
      @games_played = games_played
      @yahoo_url = yahoo_url
    end
end


doc = Nokogiri::HTML(open(fanduel_url))
s = doc.to_s
#puts s
a = s.index('FD.playerpicker.allPlayersFullData')+37
b =  s.index('FD.playerpicker.teamIdToFixtureCompactString')-6
excerpt = s[a..b]

players = []

num = excerpt.count('[')
i = 0
while i < num do
  c = excerpt.index('[')
  d = excerpt.index(']')
  player_string = excerpt[1..d]
  excerpt = excerpt[d+1..excerpt.length-1]
  player_string = player_string.delete('"')
  player_string = player_string.delete('[')
  player_string = player_string.delete(']')

  temp_id = player_string[0..player_string.index(':')-1].to_i
  player_string = player_string[player_string.index(':')+1..player_string.length-1]

  temp_position = player_string[0..player_string.index(',')-1]
  player_string = player_string[player_string.index(',')+1..player_string.length-1]

  temp_name = player_string[0..player_string.index(',')-1]
  player_string = player_string[player_string.index(',')+1..player_string.length-1]

  player_string = player_string[player_string.index(',')+1..player_string.length-1]
  player_string = player_string[player_string.index(',')+1..player_string.length-1]
  player_string = player_string[player_string.index(',')+1..player_string.length-1]

  temp_salary = player_string[0..player_string.index(',')-1].to_i
  player_string = player_string[player_string.index(',')+1..player_string.length-1]

  temp_fppg = player_string[0..player_string.index(',')-1]
  player_string = player_string[player_string.index(',')+1..player_string.length-1]

  temp_games_played = player_string[0..player_string.index(',')-1]
  player_string = player_string[player_string.index(',')+1..player_string.length-1]

  temp_yahoo_url = player_string[0..player_string.index(',')-1]
  player_string = player_string[player_string.index(',')+1..player_string.length-1]

  temp_player = Player.new(temp_id, temp_position, temp_name, temp_salary, temp_fppg, temp_games_played, temp_yahoo_url)
  players << temp_player
  i +=1
end

CSV.open("/Users/michael-orderup/Google Drive/Fanduel/salaries.csv", "ab") do |csv|
  csv << []
  players.each do |player|
    csv << ["#{Date.today}", "#{player.position}", "#{player.name}", "#{player.salary}"]
    puts "#{player.name} added to the csv"
  end
end

=begin
CSV.open("/Users/michael-orderup/Google Drive/Fanduel/salary_history.csv", "wb") do |csv|
  players.each do |player|
    csv << ["#{Date.today+1}","#{player.position}", "#{player.name}", "#{player.salary}"]
    puts "#{player.name} added to the csv"
  end
end
=end


