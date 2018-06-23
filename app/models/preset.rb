class Preset < ApplicationRecord

  # Relations
  belongs_to :venture

  # Validations
  validates :name, :length => {:minimum => 1, :maximum => 300}
end
