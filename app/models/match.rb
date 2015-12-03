require 'matrix'

class Match < ActiveRecord::Base
  PLAY_TIME_SCALE = 3
  MAX_PLAYER_TO_BALL_DIST = 15
  MAX_PLAYER_TO_HOME_DIST = 30
  TEAM_A_DIR = Vector[1,0]
  TEAM_B_DIR = Vector[-1,0]
  IMG_FOLDER = Rails.root.join('resources', 'match-images')
  BASE_PITCH = Rails.root.join('app', 'assets', 'images', 'soccerPitch.png')

  belongs_to :league

  belongs_to :teamA, class_name: 'Team'
  belongs_to :teamB, class_name: 'Team'

  scope :overdue, -> { Match.scheduled.where('starts_at < ?', Time.now) }
  enum status: { scheduled: 0, started: 1, ended: 2, cancelled: 3 }


  attr_accessor :png, :ball, :players_a, :playersB, :img_counter, :goalie_a, :goalie_b
  attr_accessor :all_players
  attr_accessor :actions
  attr_accessor :rand, :gif
  attr_accessor :weather_fetcher
  attr_accessor :images

  FIELD_DIMS = [100,60]

  def simulate
    raise BadStateException if self.status != "scheduled"
    @images = []
    self.status = "started"
    self.weather_string, self.temperature = self.compute_weather_string_and_temp

    self.scoreA = 0
    self.scoreB = 0
    self.save
    @actions = []
    @img_counter = 0
    flip_team_b
    @rand = Random.new if @rand.nil?
    @ball = Ball.new(self)

    @ball.slowdown = get_ball_slowdown

    @players_a = []
    @players_b = []
    @all_players = []
    self.teamA.players.each do |player|
      player.rand = @rand
      player.set_position(player.fieldX,player.fieldY,TEAM_A_DIR)
      @players_a<<player unless player.position[0] == -1
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

    @players_a.sort!{|a,b| a.fieldX <=> b.fieldX}

    self.teamB.players.each do |player|
      player.rand = @rand
      player.set_position(player.fieldX,player.fieldY,TEAM_B_DIR)
      @players_b<<player unless player.position[0] == -1
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

    @players_b.sort!{|a,b| -a.fieldX <=> -b.fieldX}

    @goalie_a = @players_a[0]
    @goalie_b = @players_b[0]

    @goalie_a.is_goalie = true
    @goalie_b.is_goalie = true

    @actions = []

    500.times do |i|
      if i == 250
        15.times do draw_pitch i end
        @ball.position = Vector[50 , 30]
        @ball.roll_dir = Vector[0 , 0]
        reset_players
      end
      @all_players.shuffle!(random: @rand)
      @actions.clear
      @goalie_a.try_save(@ball, @ball.slowdown == 0.9 ? 1 : 0.7)
      @goalie_b.try_save(@ball, @ball.slowdown == 0.9 ? 1 : 0.7)

      #conglomerate, randomize and kick direction
      @all_players.each do |player|
        player.move(@ball,@ball.slowdown > 0.8 ? 1 : 0.7)
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
      unless is_in_bounds?(@ball.position[0], @ball.position[1])
        check_goal(@ball.position[0], @ball.position[1], i)
        @ball.position = Vector[50, 30]
        @ball.roll_dir = Vector[0, 0]
        @ball.carrier = nil
      end
      draw_pitch i
    end
    30.times do draw_pitch 500 end
    @all_players.each do |player|
      player.regenerate_stamina
      player.save
    end
    puts "result: #{self.scoreA}-#{self.scoreB}"
    puts "weather: #{formatted_weather}"
    self.imgurLink = store_gif
    puts self.imgurLink
    self.status = 'ended'
    self.save
    flip_team_b
  end

  def reset_players
    @ball.carrier = nil
    self.teamA.players.each do |player|
      player.set_position(player.fieldX,player.fieldY,TEAM_A_DIR)
    end
    self.teamB.players.each do |player|
      player.set_position(player.fieldX,player.fieldY,TEAM_B_DIR)
    end
  end
  def check_goal(x,y,i)
    if y < 36 and y > 24
      if x < 0.0
        self.scoreB += 1
        15.times do draw_pitch i end
        reset_players
        #puts "#{i}: B (#{teamB}) scored: #{@ball.position}"
      end
      if x > 100.0
        self.scoreA += 1
        15.times do draw_pitch i end
        reset_players
        #puts "#{i}: A (#{teamA}) scored: #{@ball.position}"
      end
    end
  end

  def flip_team_b
    teamB.players.each do |player|
      if is_in_bounds?(player.fieldX, player.fieldY)
        player.fieldX = FIELD_DIMS[0]-player.fieldX
        player.fieldY = FIELD_DIMS[1]-player.fieldY
      end
    end
  end

  def store_gif
    uploader = ImageUploader.new
    TaskHelpers::encode_gif(IMG_FOLDER)
    #@gif = Magick::ImageList.new(*@images)
    #@gif.write(IMG_FOLDER.join 'GIF.gif')
    uploader.upload(IMG_FOLDER.join 'output.gif')
  end

  def draw_pitch ( timestep )
    puts timestep
    #@png = ChunkyPNG::Image.new(101, 61, ChunkyPNG::Color::WHITE)
    #png = Magick::Image.new(FIELD_DIMS[0]*2+1,FIELD_DIMS[1]*2+1)
    image = Magick::Image.read("app/assets/images/soccerPitch.png").first

    @players_a.each do |player|
      #puts "Team A: X: #{player.fieldX}, Y: #{player.fieldY}"
      if is_in_bounds?(player.position[0].round, player.position[1].round)
        #@png[player.position[0].round,player.position[1].round] = ChunkyPNG::Color('red') if(is_in_bounds?(player.fieldX, player.fieldY))
        #png.pixel_color((4*player.position[0]).round,(4*player.position[1]).round, 'red') if(is_in_bounds?(player.fieldX, player.fieldY))
        gc = Magick::Draw.new
        gc.stroke('red')
        gc.ellipse((4*player.position[0]).round,(4*player.position[1]).round, 4 , 4, 0, 360) if(is_in_bounds?(player.fieldX, player.fieldY))
        gc.draw(image)
      end
    end


    @players_b.each do |player|
      #puts "Team B: X: #{player.fieldX}, Y: #{player.fieldY}"
      if is_in_bounds?(player.position[0].round, player.position[1].round)
      #png.pixel_color((4*player.position[0]).round,(4*player.position[1]).round,'blue') if(is_in_bounds?(player.fieldX, player.fieldY))
      gc = Magick::Draw.new
      gc.stroke('blue')
      gc.ellipse((4*player.position[0]).round,(4*player.position[1]).round, 4 , 4, 0, 360) if(is_in_bounds?(player.fieldX, player.fieldY))
      gc.draw(image)
      end
    end

    gc = Magick::Draw.new
    gc.stroke('black')
    gc.fill('white')
    gc.ellipse((4*ball.position[0]).round,(4*ball.position[1]).round, 2 , 2, 0, 360) if(is_in_bounds?(ball.position[0], ball.position[1]))
    gc.draw(image)


    watermark_text = Magick::Draw.new
    watermark_text.annotate(image, 400,20,0,241, "#{scoreA} - #{scoreB}") do
      watermark_text.gravity = Magick::CenterGravity
      self.pointsize = 18
      self.font_family = 'Arial'
      #self.font_weight = BoldWeight
      self.stroke = 'none'
      self.fill = 'white'
    end
    watermark_text.annotate(image, 400,20,1,241, "#{(timestep.to_f / 500.0 * 90).to_i}:00") do
      watermark_text.gravity = Magick::WestGravity
      self.pointsize = 18
      self.font_family = 'Arial'
      #self.font_weight = BoldWeight
      self.stroke = 'none'
      self.fill = 'white'
    end
    #watermark_text.draw(png)


    #@gif << png

    out_path = IMG_FOLDER.join("pitch#{@img_counter}.jpg"){self.quality = 30}
    @images << out_path
    image = image.minify
    image.write(out_path)
    @img_counter += 1
  end

  def is_in_bounds?(x,y)
    return false if x < 0 or y <0 or x > FIELD_DIMS[0] or y > FIELD_DIMS[1]
    true
  end

  def get_ball_slowdown
    @weather_fetcher = WeatherFetcher.new if weather_fetcher.nil?
    precipitation = @weather_fetcher.fetch_precipitation
    temp = @weather_fetcher.fetch_temp
    if precipitation > 0.0
      if temp < 0
        return 0.6
      else
        return 0.95
      end
    else
      return 0.9
    end

  end

  def formatted_weather
    "#{self.weather_string} at #{self.temperature}°C"
  end

  def compute_weather_string_and_temp
    @weather_fetcher = WeatherFetcher.new if weather_fetcher.nil?
    weather_string = 'clear'
    precipitation_string = @weather_fetcher.fetch_temp < 0.0 ? 'snowfall' : 'rain'
    sunshine = @weather_fetcher.fetch_sunshine
    if sunshine < 10 and sunshine > 5
      weather_string = 'cloudy'
    end
    if sunshine <= 5
      weather_string = 'overcast'
    end
    precipitation = @weather_fetcher.fetch_precipitation
    if precipitation > 0.0 and precipitation <= 0.25
      weather_string = "light #{precipitation_string}"
    end
    if precipitation > 0.25 and precipitation <= 1.25
      weather_string = "moderate #{precipitation_string}"
    end
    if precipitation > 1.25
      weather_string = "heavy #{precipitation_string}"
    end
    return weather_string, @weather_fetcher.fetch_temp
  end

  class BadStateException < RuntimeError
    attr :message
    def initialize
      @message = 'Match is not scheduled'
    end
  end

  class Ball
    attr_accessor :carrier, :position, :roll_dir, :match
    attr_accessor :count_no_touch, :slowdown

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
      @roll_dir *= @slowdown
      @roll_dir = 0.2*@roll_dir.normalize if @roll_dir.r<0.2 and @roll_dir.r >0
      if @count_no_touch > 40
        self.roll_dir = Vector[@match.rand.rand(2.0)-1,@match.rand.rand(2.0)-1] * 8
        #puts 'no touch for a while, moving ball'
        @count_no_touch = 0
      end
      @carrier = nil
    end

  end

end
