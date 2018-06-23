class CreateSetups < ActiveRecord::Migration
  def change
    create_table :setups do |t|

      # Each setup belongs to a venture
      t.references :venture

      # Each setup has a year
      t.integer :year

      # A position is locked if the setup is frozen
      t.boolean :is_locked, default: false

      # Timestamps
      t.timestamps null: false
    end
  end
end
