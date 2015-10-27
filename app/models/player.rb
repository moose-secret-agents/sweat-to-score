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

    attr_accessor :fatness, :color, :head_id, :eyebrow_id, :eye_id, :eye_angle,
                  :nose_id, :nose_size, :nose_flip, :mouth_id, :hair_id

    def initialize
      self.fatness = 0.5
      self.color = ["#f2d6cb", "#ddb7a0", "#ce967d", "#bb876f", "#aa816f", "#a67358", "#ad6453", "#74453d", "#5c3937"].first
      self.head_id = 0
      self.eyebrow_id = 0
      self.eye_id = 0
      self.eye_angle = 0
      self.nose_id = 0
      self.nose_size = 0.5
      self.nose_flip = true
      self.mouth_id = 0
      self.hair_id = 0
    end

    def generate
      {
          fatness: fatness,
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
          mouth: { id: mouth_id, cx: 200, cy: 400},
          hair: {id: hair_id}
      }
    end
  end

end
