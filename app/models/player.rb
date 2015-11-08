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

  def move(ball, play_direction)
    return if(@position[0] < 0) or is_goalie

    real_speed = (1 - (1-self.speed/100.0)**2.5) * Match::PLAY_TIME_SCALE

    ball_direction = ball.position - @position
    home_direction = Vector[self.fieldX,self.fieldY] - @position
    goal_direction = play_direction
    goal_direction = Vector[play_direction[0]*100,30] - @position if @position[0] * @play_direction[0] >75

    heading = home_direction
    heading = ball_direction if ball_direction.r<Match::MAX_PLAYER_TO_BALL_DIST

    unless ball.carrier.nil?
      heading = (ball_direction + home_direction) * 0.5 if ball.carrier.team == self.team
    end
    heading = home_direction if home_direction.r > Match::MAX_PLAYER_TO_HOME_DIST

    heading = goal_direction if ball.carrier == self

    heading = heading.normalize if heading.r>0

    heading*=real_speed

    @position += heading
    ball.position = @position if ball.carrier == self
    puts "walking with ball" if ball.carrier == self
  end

  def perform_action(action_symbol, ball, play_direction)
    method(action_symbol).call(ball, play_direction)
  end

  #best method name ever... open for suggestions
  def try_something(ball)
    dist = (ball.position - @position).r
    if self.is_goalie and dist < 6
      puts "trying save"
    end
    if ball.carrier == self
      return Action.new(self,:kick_forward) if @rand.rand(1.0)>0.95
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

  def kick_forward(ball, play_direction)
    puts "kicked"
    ball.kick((@play_direction + (@rand.rand(6.0)-3)*Vector[0,1]).normalize * 2 * Match::PLAY_TIME_SCALE)
  end

  def shoot_at_goal(ball, play_direction)
    puts "shooting at goal"
    goal_direction = Vector[play_direction[0]*100,30] - @position
    ball.kick(goal_direction.normalize * 3 * Match::PLAY_TIME_SCALE)
  end

  def tackle(ball, play_direction)
    puts "trying tackle"
    randval = @rand.rand(1.0)
    kick_forward(ball,play_direction) if ball.try_take(self, randval) == :taken_from_player and randval>0.6
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