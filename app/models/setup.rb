class Setup < ApplicationRecord

  # Relations
  belongs_to :venture
  has_many :categories
  has_many :positions, :through => :categories

  # Validations
  validates :year, :allow_blank => true, :inclusion => { :in => 1000..9999 }

  # Since it should be possible to have uncategorized positions, we use a dummy category
  after_create :create_dummy_categories

  def lock!
    self.update(is_locked: true)
    Position.update_all("active_state_before_locked=active_state")
  end

  # Whenever a user creates a setup for a new year,
  # deepcopy structure without plan months.
  def self.copy_setup(from_setup, year)
    to_setup = Setup.new(venture_id: from_setup.venture_id, year: year)

    from_setup.categories.each do |category|
      new_category = category.dup

      category.positions.each do |position|
        new_category.positions << position.dup
      end
      to_setup.categories << new_category
    end
    to_setup.save!
    to_setup
  end

  # Whenever a user creates a setup for a new year,
  # deepcopy the whole setup structure.
  def self.copy_setup_with_plan_months(from_setup, year)
    to_setup = Setup.new(venture_id: from_setup.venture_id, year: year)

    from_setup.categories.each do |category|
      new_category = category.dup

      category.positions.each do |position|
        new_position = position.dup

        position.plan_months.each do |plan_month|

          # Only select distinct attributes for copying
          new_position.plan_months << PlanMonth.new(
            plan_month.attributes.slice(
              "month",
              "col1", "col1_is_user_generated",
              "col2", "col2_is_user_generated",
              "col3", "col3_is_user_generated",
              "col4", "col4_is_user_generated"
            )
          )
        end
        new_category.positions << new_position
      end
      to_setup.categories << new_category
    end
    to_setup.save!
    to_setup
  end



  private

    # Whenever a setup is created, also create a dummy category for each dimension.
    # Dummy categories are identified by order 0 (because they should always stay on top).
    def create_dummy_categories
      return if self.categories.exists?(order: 0)

      Category.dimensions.each do |dimension|
        Category.create(setup_id: self.id, dimension: dimension, order: 0, name: "dummy")
      end
    end

    # Whenever a setup is created, some positons should already be created.
    # def create_positions
    #   taxes = categories.where(dimension: "taxes").first
    #   Position.create(category_id: taxes.id, name: "Income taxes", active_state: "active")
    #   Position.create(category_id: taxes.id, name: "Social security", active_state: "active")
    #   Position.create(category_id: taxes.id, name: "VAT", active_state: "active")
    # end
end
