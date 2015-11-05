
require 'matrix'
class Match < ActiveRecord::Base

  belongs_to :league

  belongs_to :teamA, class_name: 'Team'
  belongs_to :teamB, class_name: 'Team'

  enum status: { scheduled: 0, started: 1, ended: 2, cancelled: 3 }

  FIELD_DIMS = [100,60]
  ball = nil

  def simulate
    raise BadStateException if self.status != "scheduled"

    ball = Ball.new

    png = ChunkyPNG::Image.new(101, 61, ChunkyPNG::Color::WHITE)

    flip_team_B

    playersA = teamA.players
    playersB = teamB.players

    playersA.each do |player|
      #puts "Team A: X: #{player.fieldX}, Y: #{player.fieldY}"
      png[player.fieldX,player.fieldY] = ChunkyPNG::Color('red') if(is_in_bounds?(player.fieldX, player.fieldY))
    end

    playersB.each do |player|
      #puts "Team B: X: #{player.fieldX}, Y: #{player.fieldY}"
      png[player.fieldX,player.fieldY] = ChunkyPNG::Color('blue') if(is_in_bounds?(player.fieldX, player.fieldY))
    end
    png[ball.position[0],ball.position[1]] = ChunkyPNG::Color('green')
    png.save('pitch.png', :interlace => true) unless Rails.env.production?

    flip_team_B

  end

  def flip_team_B
    teamB.players.each do |player|
      if(is_in_bounds?(player.fieldX, player.fieldY))
        player.fieldX = FIELD_DIMS[0]-player.fieldX
        player.fieldY = FIELD_DIMS[1]-player.fieldY
      end
    end
  end

  def is_in_bounds?(x,y)
    return false if x < 0 or y <0 or x > FIELD_DIMS[0] or y > FIELD_DIMS[1]
    return true
  end

  class BadStateException < RuntimeError
    attr :message
    def initialize
      @message = "Match is not scheduled"
    end
  end

  class Ball
    attr_accessor :carrier, :position

    def initialize
      @position = [50,30]
      @carrier = nil
    end
  end

end
