class Player < ActiveRecord::Base
  belongs_to :team
  validates_inclusion_of :talent, in: 0..100
  after_create :generate_face
  attr_accessor :position, :play_direction
  attr_accessor :is_goalie
  attr_accessor :rand

  def generate_face
    self.face = Face.new.generate
    self.save
  end

  def set_position(x,y, play_dir)
    @position = Vector[x,y]
    @play_direction = play_dir
  end

  def move(ball)
    return if is_goalie

    real_speed = scale_with_time( scale(self.speed)  )

    ball_direction = ball.position - @position
    home_direction = Vector[self.fieldX,self.fieldY] - @position
    goal_direction = @play_direction
    goal_direction = Vector[play_direction[0]*100,30] - @position if @position[0] * @play_direction[0] >75

    heading = home_direction*(home_direction.r/100)
    heading = ball_direction if ball_direction.r<Match::MAX_PLAYER_TO_BALL_DIST

    unless ball.carrier.nil?
      heading = (ball_direction + home_direction) * 0.5 if ball.carrier.team == self.team
    end
    heading = home_direction*(home_direction.r/100) if home_direction.r > Match::MAX_PLAYER_TO_HOME_DIST

    heading = goal_direction if ball.carrier == self

    heading = heading.normalize if heading.r>1

    self.stamina -= (heading.r / Match::PLAY_TIME_SCALE) * scale(self.stamina) * 0.4 * (1 - scale(self.fitness))
    #puts self.stamina

    heading*=real_speed

    @position += heading
    ball.position = @position if ball.carrier == self
    #puts "walking with ball" if ball.carrier == self
  end

  def try_save(ball)
    dist = (ball.position - @position).r
    ball_speed = ball.roll_dir.r
    return if dist > 6
    #puts "#{self.team} trying save"
    distance_difficulty = dist / 6.0
    speed_difficulty = ball_speed / 3.0 / Match::PLAY_TIME_SCALE
    difficulty = distance_difficulty * speed_difficulty
    #puts "#{self.team} trying save with difficulty #{difficulty}"
    #puts difficulty
    randval = @rand.rand(1.0) * scale(self.goalkeep)
    if randval > difficulty
      #puts "saved ball"
      ball.kick(@play_direction * 5 + Vector[0,@rand.rand(10.0)-5.0])
    else
      ball.position+= @play_direction * -50
      #puts ball.position
      ball.carrier = nil
    end
  end

  def perform_action(action_symbol, ball)
    method(action_symbol).call(ball)
    self.stamina -= scale(self.stamina) * 2 * (1 - scale(self.fitness))
  end

  #best method name ever... open for suggestions
  def try_something(ball)
    dist = (ball.position - @position).r

    if ball.carrier == self
      return Action.new(self,:kick_forward) if @rand.rand(1.0)>0.9
      return Action.new(self,:shoot_at_goal) if @rand.rand(1.0)>0.75 and (Vector[@play_direction[0]*100,30] - @position).r<30
      return nil
    elsif dist<1.5
      if ball.carrier.nil?
        return Action.new(self, :tackle)
      else
        return Action.new(self, :tackle) unless ball.carrier.team == self.team
      end
    end
    return nil
  end

  def kick_forward(ball)
    dir = (@play_direction + (@rand.rand(6.0)-3)*Vector[0,1]).normalize * 1.5 * Match::PLAY_TIME_SCALE
    ball.kick(dir)
    #puts "#{self.team} kicked #{@play_direction}, #{dir.r}"
  end

  def shoot_at_goal(ball)
    #puts "shooting at goal"
    goal_direction = Vector[@play_direction[0]*100,30 + (@rand.rand(12.0 * scale(self.attack))-6.0*scale(self.attack))] - @position
    ball.kick(goal_direction.normalize * 1 * scale_with_time(scale(self.attack)))
  end

  def tackle(ball)
    #puts "trying tackle"
    randval = @rand.rand(1.0) * scale(self.defense)
    kick_forward(ball) if ball.try_take(self, randval) == :taken_from_player and @rand.rand(1.0)>0.6
  end

  def defend_tackle
    randval = @rand.rand(1.0)*scale([self.defense, self.midfield, self.attack].max)
    randval
  end

  def scale(param)
    (1 - (1-param/100.0)**1.75) * (1 - (1-self.stamina/100.0)**1.75)
  end

  def scale_with_time (param)
    param * Match::PLAY_TIME_SCALE
  end

  class Action
    attr_accessor :player
    attr_accessor :action
    def initialize(player, action)
      @player = player
      @action = action
    end
  end
  class Face
    COUNT = { head: 1, eyebrow: 1, eye: 4, nose: 3, mouth: 5, hair: 5 }

    attr_accessor :fatness, :mouth_id, :color, :head_id, :eyebrow_id, :eye_id, :eye_angle,
                  :nose_id, :nose_size, :nose_flip, :hair_id

    def initialize
      self.fatness = 0
      self.mouth_id = 0
      self.color = ['#acafcc', '#f68d7a', '#dfe5b7', '#ffeb7f', '#f2d6cb', '#ce967d', '#aa816f', '#74453d'].sample
      self.head_id = 0
      self.eyebrow_id = 0
      self.eye_id = [0, 1, 2, 3].sample
      self.eye_angle = [-15, 15].sample
      self.nose_id = [0, 1, 2].sample
      self.nose_size = [0.0, 0.25, 0.5, 0.75, 1.0].sample
      self.nose_flip = [true, false].sample
      self.hair_id = [0, 1, 2, 3, 4].sample
    end

    def generate
      {
          fatness: fatness,
          mouth: { id: mouth_id, cx: 200, cy: 400},
          color: color,
          head: { id: head_id	},
          eyebrows: [
              {id: eyebrow_id, lr: "l", cx: 135, cy: 250},
              {id: eyebrow_id, lr: "r", cx: 265, cy: 250}
          ],
          eyes: [
              {id: eye_id, lr: "l", cx: 135, cy: 280, angle: eye_angle},
              {id: eye_id, lr: "r", cx: 265, cy: 280, angle: eye_angle}
          ],
          nose: { id: nose_id, lr: "l", cx: 200, cy: 330, size: nose_size, flip: nose_flip },
          hair: {id: hair_id}
      }
    end

  end

end