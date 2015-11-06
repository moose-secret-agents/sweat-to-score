
require 'matrix'
class Match < ActiveRecord::Base
  MAX_PLAYER_TO_BALL_DIST = 15
  MAX_PLAYER_TO_HOME_DIST = 20
  TEAM_A_DIR = Vector[1,0]
  TEAM_B_DIR = Vector[-1,0]
  belongs_to :league

  belongs_to :teamA, class_name: 'Team'
  belongs_to :teamB, class_name: 'Team'

  enum status: { scheduled: 0, started: 1, ended: 2, cancelled: 3 }

  attr_accessor :png, :ball, :playersA, :playersB, :img_counter
  attr_accessor :actions
  attr_accessor :rand

  FIELD_DIMS = [100,60]

  def simulate
    raise BadStateException if self.status != "scheduled"
    @actions = []
    @ball = Ball.new
    @img_counter = 0
    flip_team_B
    @rand = Random.new() if @rand.nil?

    @playersA = []
    @playersB = []
    teamA.players.each do |player|
      player.set_position(player.fieldX,player.fieldY)
      @playersA<<player unless player.position[0] == -1
    end
    teamB.players.each do |player|
      player.set_position(player.fieldX,player.fieldY)
      @playersB<<player unless player.position[0] == -1
    end

    puts @playersA.count

    100.times do |i|
      @actions = []
      @playersA.each do |player|
        player.move(@ball)
        action = player.try_something(@ball)
        @actions << action unless action.nil?
      end
      @playersB.each do |player|
        player.move(@ball)
        action = player.try_something(@ball)
        @actions << action unless action.nil?
      end
      drawPitch
      act = @actions.first
      puts @actions.count
      @actions.shuffle!
      unless act.nil?
        play_dir = @playersA.include?(act.player) ? TEAM_A_DIR : TEAM_B_DIR
        if act.player.perform_action(act.action,ball,play_dir,@rand) == :failed and !@ball.carrier.nil?
          play_dir = @playersA.include?(@ball.carrier) ? TEAM_A_DIR : TEAM_B_DIR
          @ball.carrier.perform_action(@ball.carrier.try_something(@ball).action, @ball, play_dir,@rand)
        end
      end
      if @ball.carrier.nil?
        puts"ball is rolling #{@ball.roll_dir}"
        @ball.roll
      end
      if !is_in_bounds?(@ball.position[0],@ball.position[1])
        ball.position = Vector[50,30]
      end
      drawPitch
    end

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

  def drawPitch
    @png = ChunkyPNG::Image.new(101, 61, ChunkyPNG::Color::WHITE)
    @playersA.each do |player|
      #puts "Team A: X: #{player.fieldX}, Y: #{player.fieldY}"
      @png[player.position[0].round,player.position[1].round] = ChunkyPNG::Color('red') if(is_in_bounds?(player.fieldX, player.fieldY))
    end

    playersB.each do |player|
      #puts "Team B: X: #{player.fieldX}, Y: #{player.fieldY}"
      @png[player.position[0].round,player.position[1].round] = ChunkyPNG::Color('blue') if(is_in_bounds?(player.fieldX, player.fieldY))
    end
    @png[ball.position[0].round,ball.position[1].round] = ChunkyPNG::Color('green')
    @png.save("OutputImgs/pitch#{@img_counter}.png", :interlace => true) unless Rails.env.production?
    @img_counter+=1
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
    attr_accessor :carrier, :position, :roll_dir

    def initialize
      @position = Vector[50,30]
      @roll_dir = Vector[0,0]
      @carrier = nil
    end
    def roll
      @position += @roll_dir
      @roll_dir*=0.9
    end
  end

end
