class Venture < ApplicationRecord

  # Relations
  belongs_to :user
  has_many :setups
  has_many :categories, :through => :setups
  has_many :positions, :through => :categories
  has_many :transactions
  has_many :presets

  # Validations
  validates :name, :length => {:minimum => 1, :maximum => 300}
  validates :currency, :inclusion => {:in => %w(EUR USD)}
  validates :description, :length => {:minimum => 0, :maximum => 5000}

  # Create first setup
  after_create :create_setup, :create_presets

  private

    # Whenever a venture is created, also create the first setup
    def create_setup
      Setup.create!(venture_id: self.id, year: Time.now.year)
    end

    # Whenever a venture is created, also create smart presets
    def create_presets
      Preset.create!("venture_id": self.id, name: "Test", data: [{level: "main", identifier: "sales", color: 1}, {level: "main", identifier: "costs", color: 2}].to_json)
    end
end
