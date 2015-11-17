require 'matrix'

class Match < ActiveRecord::Base
  PLAY_TIME_SCALE = 3
  MAX_PLAYER_TO_BALL_DIST = 15
  MAX_PLAYER_TO_HOME_DIST = 30
  TEAM_A_DIR = Vector[1,0]
  TEAM_B_DIR = Vector[-1,0]
  IMG_FOLDER = Rails.root.join('resources', 'match-images')

  belongs_to :league

  belongs_to :teamA, class_name: 'Team'
  belongs_to :teamB, class_name: 'Team'

  enum status: { scheduled: 0, started: 1, ended: 2, cancelled: 3 }

  def glyphicon
    case status
      when 'scheduled'
        "glyphicon-pencil"
      when 'started'
        "glyphicon-ok"
      when 'ended'
        "glyphicon-flag"
      when 'cancelled'
        "glyphicon-remove"
    end
  end

  def getTimeDifference(time)
    delta = (time - Time.now).abs

    minutes = (delta / 60) % 60
    hours = (delta / (60 * 60)) % 24
    days = (delta / (60 * 60 * 24))

    time > Time.now ? format("%dd %dh %dm", days, hours, minutes) : format("-(%dd %dh %dm)", days, hours, minutes)
  end

  attr_accessor :png, :ball, :playersA, :playersB, :img_counter, :goalieA, :goalieB
  attr_accessor :all_players
  attr_accessor :actions
  attr_accessor :rand, :gif

  FIELD_DIMS = [100,60]

  def simulate
    raise BadStateException if self.status != "scheduled"
    self.status = "started"
    @gif = Magick::ImageList.new
    self.scoreA = 0
    self.scoreB = 0
    @actions = []
    @img_counter = 0
    flip_team_B
    @rand = Random.new() if @rand.nil?
    @ball = Ball.new(self)

    @playersA = []
    @playersB = []
    @all_players = []
    self.teamA.players.each do |player|
      player.rand = @rand
      player.set_position(player.fieldX,player.fieldY,TEAM_A_DIR)
      @playersA<<player unless player.position[0] == -1
      @all_players<<player unless player.position[0] == -1
      player.is_goalie = false

      player.fitness = 50
      player.stamina = 70
      player.goalkeep = 40
      player.defense = 40
      player.midfield = 40
      player.attack = 40

      player.save

    end

    @playersA.sort!{|a,b| a.fieldX <=> b.fieldX}

    self.teamB.players.each do |player|
      player.rand = @rand
      player.set_position(player.fieldX,player.fieldY,TEAM_B_DIR)
      @playersB<<player unless player.position[0] == -1
      @all_players<<player unless player.position[0] == -1
      player.is_goalie = false

      player.fitness = 50
      player.stamina = 70
      player.goalkeep = 40
      player.defense = 40
      player.midfield = 40
      player.attack = 40

      player.save

    end

    @playersB.sort!{|a,b| -a.fieldX <=> -b.fieldX}

    @goalieA = @playersA[0]
    @goalieB = @playersB[0]

    @goalieA.is_goalie = true
    @goalieB.is_goalie = true

    @actions = []

    500.times do |i|
      @all_players.shuffle!(random: @rand)
      @actions.clear
      @goalieA.try_save(@ball)
      @goalieB.try_save(@ball)

      #conglomerate, randomize and kick direction
      @all_players.each do |player|
        player.move(@ball)
      end

      @all_players.shuffle!(random: @rand)


      @all_players.each do |player|
        #puts player.team
        action = player.try_something(@ball)
        @actions << action unless action.nil?
      end
      #puts i
      #drawPitch
      @actions.shuffle!(random: @rand)
      act = @actions.first
      #puts @actions.count
      unless act.nil?
        if act.player.perform_action(act.action,ball) == :failed and !@ball.carrier.nil?
          action = @ball.carrier.try_something(@ball)
          @ball.carrier.perform_action(action.action, @ball) unless action.nil?
        end
      end
      if @ball.carrier.nil?
        #puts"ball is rolling #{@ball.roll_dir}"
        @ball.roll
      end
      if !is_in_bounds?(@ball.position[0],@ball.position[1])
        check_goal(@ball.position[0],@ball.position[1],i)
        @ball.position = Vector[50,30]
        @ball.roll_dir = Vector[0,0]
        @ball.carrier = nil
      end
      drawPitch
    end
    puts "result: #{self.scoreA}-#{self.scoreB}"
    self.imgurLink = storeGif
    puts self.imgurLink
    self.status = "ended"
    flip_team_B

  end

  def check_goal(x,y,i)
    if y < 36 and y > 24
      if x < 0.0
        self.scoreB += 1
        #puts "#{i}: B (#{teamB}) scored: #{@ball.position}"
      end
      if x > 100.0
        self.scoreA += 1
        #puts "#{i}: A (#{teamA}) scored: #{@ball.position}"
      end
    end
  end

  def flip_team_B
    teamB.players.each do |player|
      if(is_in_bounds?(player.fieldX, player.fieldY))
        player.fieldX = FIELD_DIMS[0]-player.fieldX
        player.fieldY = FIELD_DIMS[1]-player.fieldY
      end
    end
  end

  def storeGif
    uploader = ImageUploader.new()
    @gif.write(IMG_FOLDER.join 'GIF.gif')
    uploader.upload(IMG_FOLDER.join 'GIF.gif')
  end

  def drawPitch
    #@png = ChunkyPNG::Image.new(101, 61, ChunkyPNG::Color::WHITE)
    png = Magick::Image.new(101,61)
    @playersA.each do |player|
      #puts "Team A: X: #{player.fieldX}, Y: #{player.fieldY}"
      if(is_in_bounds?(player.position[0].round,player.position[1].round))
        #@png[player.position[0].round,player.position[1].round] = ChunkyPNG::Color('red') if(is_in_bounds?(player.fieldX, player.fieldY))
        png.pixel_color(player.position[0].round,player.position[1].round, 'red') if(is_in_bounds?(player.fieldX, player.fieldY))
      end
    end


    playersB.each do |player|
      #puts "Team B: X: #{player.fieldX}, Y: #{player.fieldY}"
      if(is_in_bounds?(player.position[0].round,player.position[1].round))
      png.pixel_color(player.position[0].round,player.position[1].round,'blue') if(is_in_bounds?(player.fieldX, player.fieldY))
      end
    end

    png.pixel_color(ball.position[0].round,ball.position[1].round,'green')
    @gif << png
    out_path = IMG_FOLDER.join("pitch#{@img_counter}.png")
    #png.write(out_path)
    @img_counter += 1
  end

  def is_in_bounds?(x,y)
    return false if x < 0 or y <0 or x > FIELD_DIMS[0] or y > FIELD_DIMS[1]
    true
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
      minval = @carrier.nil? ? 0.1 : @carrier.defend_tackle*2.5
      return_sym = :taken_from_noone if @carrier.nil?
      return :failed if(rand_val<minval)
      #puts "tackled #{return_sym}"
      @carrier = player
      @count_no_touch = 0
      return_sym
    end

    def kick(direction)
      @roll_dir = direction
      #@position +=direction
      @carrier = nil
      @count_no_touch = 0
    end

    def roll
      @count_no_touch += 1
      @position += @roll_dir
      @roll_dir *= 0.9
      @roll_dir = 0.2*@roll_dir.normalize if @roll_dir.r<0.2 and @roll_dir.r >0
      if @count_no_touch > 40
        self.roll_dir = Vector[@match.rand.rand(2.0)-1,@match.rand.rand(2.0)-1] * 8
        puts "no touch for a while, moving ball"
        @count_no_touch = 0
      end
      @carrier = nil
    end

  end

end
