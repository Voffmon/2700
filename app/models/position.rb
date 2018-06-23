class Position < ApplicationRecord

  # Relations
  belongs_to :category
  has_many :plan_months
  has_many :transactions

  # Scopes for each state
  scope :active,   -> {where(active_state: "active")}
  scope :inactive, -> {where(active_state: "inactive")}
  scope :archived, -> {where(active_state: "archived")}
  scope :deleted,  -> {where(active_state: "deleted")}

  # Validations
  validates :name, :length => {:minimum => 1, :maximum => 300}
  validates :active_state, :inclusion => {:in => %w(active inactive archived deleted)}
  validates :sales_method, :allow_blank => true, :inclusion => {:in => %w(quantity_times_price subscriptions absolute_amounts)}
  validates :costs_method, :allow_blank => true, :inclusion => {:in => %w(per_unit absolute_amounts no_direct_costs)}

  # Retrieves all setups in which this position occurs
  def find_in_setups
    positions = []
    self.category.setup.venture.setups.each do |setup|
      positions << setup.positions.where(name: self.name).first
    end
    positions.compact
  end
end
