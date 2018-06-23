class PlanMonth < ApplicationRecord

  # Relations
  belongs_to :position

  # Validations
  validates :note, :note_forecast, :allow_blank => true, :length => {:minimum => 0, :maximum => 5000}
  validates :month, :inclusion => {:in => 1..12}

  # Todo for later, rewrite those getters and setters
  def col1=(col1)
    self[:col1] = col1.to_s.gsub(",", ".").to_f
  end

  def col2=(col2)
    self[:col2] = col2.to_s.gsub(",", ".").to_f
  end

  def col3=(col3)
    self[:col3] = col3.to_s.gsub(",", ".").to_f
  end

  def col4=(col4)
    self[:col4] = col4.to_s.gsub(",", ".").to_f
  end

  def col1_forecast=(col1_forecast)
    self[:col1_forecast] = col1_forecast.to_s.gsub(",", ".").to_f
  end

  def col2_forecast=(col2_forecast)
    self[:col2_forecast] = col2_forecast.to_s.gsub(",", ".").to_f
  end

  def col3_forecast=(col3_forecast)
    self[:col3_forecast] = col3_forecast.to_s.gsub(",", ".").to_f
  end

  def col4_forecast=(col4_forecast)
    self[:col4_forecast] = col4_forecast.to_s.gsub(",", ".").to_f
  end
end
