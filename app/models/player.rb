class Player < ActiveRecord::Base
  belongs_to :team
  validates_inclusion_of :talent, in: 0..100
  after_create :generate_face

  def generate_face
    self.face = Face.new.generate
    self.save
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