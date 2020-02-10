h = {"fo"=>"comp", "tru"=>"hague", "dek"=>"crase"}
f = ["fo", "tru"]
p h.slice(*f)
g = [3,6,7]

r = f+g
p r
require 'csv'
@path = File.join(File.dirname(__FILE__), "nba_player_data.csv")
@table = CSV.parse(File.read(@path), headers: true)
p @table.headers