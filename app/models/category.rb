class Category < ApplicationRecord

  # Relations
  belongs_to :setup
  has_many :positions

  # Available dimensions
  def self.dimensions
    ["sales", "costs_of_sales", "costs", "investments", "funding"] #, "taxes"
  end

  # Scopes for each dimension
  dimensions.each do |dimension|
    scope dimension, -> {where(dimension: dimension)}
  end

  # Validations
  validates :dimension, :inclusion => {:in => dimensions}
  validates :name, :length => {:minimum => 1, :maximum => 300}
end
