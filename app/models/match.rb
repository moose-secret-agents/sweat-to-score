
require 'matrix'
class Match < ActiveRecord::Base
  MAX_PLAYER_TO_BALL_DIST = 15
  MAX_PLAYER_TO_HOME_DIST = 35
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
    @img_counter = 0
    flip_team_B
    @rand = Random.new() if @rand.nil?
    @ball = Ball.new(self)

    @playersA = []
    @playersB = []
    teamA.players.each do |player|
      player.rand = @rand
      player.set_position(player.fieldX,player.fieldY,TEAM_A_DIR)
      @playersA<<player unless player.position[0] == -1
    end
    teamB.players.each do |player|
      player.rand = @rand
      player.set_position(player.fieldX,player.fieldY,TEAM_B_DIR)
      @playersB<<player unless player.position[0] == -1
    end

    puts @playersA.count

    100.times do |i|
      @actions = []
      @playersA.each do |player|
        player.move(@ball,TEAM_A_DIR)
        action = player.try_something(@ball)
        @actions << action unless action.nil?
      end
      @playersB.each do |player|
        player.move(@ball,TEAM_B_DIR)
        action = player.try_something(@ball)
        @actions << action unless action.nil?
      end
      drawPitch
      act = @actions.first
      puts @actions.count
      @actions.shuffle!
      unless act.nil?
        play_dir = @playersA.include?(act.player) ? TEAM_A_DIR : TEAM_B_DIR
        if act.player.perform_action(act.action,ball,play_dir) == :failed and !@ball.carrier.nil?
          play_dir = @playersA.include?(@ball.carrier) ? TEAM_A_DIR : TEAM_B_DIR
          action = @ball.carrier.try_something(@ball)
          @ball.carrier.perform_action(action.action, @ball, play_dir) unless action.nil?
        end
      end
      if @ball.carrier.nil?
        puts"ball is rolling #{@ball.roll_dir}"
        @ball.roll
      end
      if !is_in_bounds?(@ball.position[0],@ball.position[1])
        ball.position = Vector[50,30]
        ball.roll_dir = Vector[0,0]
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
    attr_accessor :carrier, :position, :roll_dir, :match
    attr_accessor :count_no_touch

    def initialize(match)
      @match = match
      @position = Vector[50,30]
      @roll_dir = Vector[0,0]
      @carrier = nil
      @count_no_touch = 0
    end

    def try_take(player, rand_val)
      return_sym = :taken_from_player
      minval = @carrier.nil? ? 0.1 : 0.9
      return_sym = :taken_from_noone if @carrier.nil?
      return :failed if(rand_val<minval)
      self.carrier = player
      @count_no_touch = 0
      return_sym
    end

    def kick(direction)
      @roll_dir = direction
      @position +=direction
      @carrier = nil
      @count_no_touch = 0
    end

    def roll
      @count_no_touch += 1
      @position += @roll_dir
      @roll_dir*=0.9
      @roll_dir = 0.2*@roll_dir.normalize if @roll_dir.r<0.2 and @roll_dir.r >0
      if @count_no_touch > 50
        self.roll_dir = Vector[@match.rand.rand(2.0)-1,@match.rand.rand(2.0)-1] * 8
        puts "no touch for a while, moving ball"
        @count_no_touch = 0
      end
    end

  end

end
