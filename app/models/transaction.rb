class Transaction < ApplicationRecord

  # Relations
  belongs_to :position
  belongs_to :venture

  # Validations
  validates :amount, :numericality => {:greater_than => 0}
  validates :vat, :inclusion => {:in => 0..100}
  validates :note, :length => {:minimum => 0, :maximum => 5000}
  validates :title, :length => {:minimum => 0, :maximum => 300}

  def amount=(amount)
    self[:amount] = amount.to_s.gsub(",", ".").to_f
  end
end
