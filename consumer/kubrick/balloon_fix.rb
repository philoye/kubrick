require 'csv'

class BalloonFix
  include Mongoid::Document
  
  def self.create_from_csv(buffer)
    puts buffer
    # -31.81223,115.73761,20101113,9393500,11.30,19.79,2.26
    CSV.parse(buffer) do |(callsign,lat,lng,date,time,alt,course,speed)|
      if callsign == "HOUSTON"
        create(
          :lat => lat,
          :lng => lng,
          :date => date,
          :time => time,
          :alt => alt,
          :course => course,
          :speed => speed
        )
      end
    end
  end
end