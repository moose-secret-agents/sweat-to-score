class Player < ActiveRecord::Base
  belongs_to :team
  validates_inclusion_of :talent, in: 0..100
  after_create :generate_face
  attr_accessor :position
  attr_accessor :is_goalie
  attr_accessor :rand

  def generate_face
    self.face = Face.new.generate
    self.save
  end

  def set_position(x,y)
    @position = Vector[x,y]
  end

  def move(ball)
    return if(@position[0] < 0) or is_goalie

    ball_direction = ball.position - @position
    home_direction = Vector[self.fieldX,self.fieldY] - @position

    heading = home_direction
    heading = ball_direction if ball_direction.r<Match::MAX_PLAYER_TO_BALL_DIST
    heading = home_direction if home_direction.r>Match::MAX_PLAYER_TO_HOME_DIST

    heading *= (1/heading.r*1) if heading.r>0

    @position += heading
  end

  def perform_action(action_symbol, ball, play_direction, rand)
    @rand = rand
    method(action_symbol).call(ball, play_direction)
  end

  #best method name ever... open for suggestions
  def try_something(ball)
    dist = (ball.position - @position).r
    if ball.carrier == self
      return Action.new(self,:kick_forward)
    elsif dist<3
      return Action.new(self, :tackle)
    end
    return nil
  end

  def kick_forward(ball, play_direction)
    puts "kicked"
    ball.roll_dir = (play_direction + (@rand.rand(2.0)-1)*Vector[0,1]).normalize * 4
    ball.carrier = nil
  end

  def tackle(ball, play_direction)
    puts "trying tackle"
    randval = @rand.rand(1.0)
    minval = ball.carrier.nil? ? 0.1 : 0.9
    return :failed if(randval<minval)
    ball.carrier = self
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