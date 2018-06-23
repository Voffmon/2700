class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|

      # Each category belongs to a setup
      t.references :setup

      # Name of the category
      t.string :name, null: false

      # Dimension: sales, costs, investments, fundings
      t.string :dimension, null: false

      # Order
      t.integer :order

      # Timestamps
      t.timestamps null: false
    end
  end
end
