class CreatePosition < ActiveRecord::Migration
  def change
    create_table :positions do |t|

      # Each position belongs to a category
      t.references :category

      # Name of the position
      t.string :name, null: false

      # VAT
      t.integer :vat

      # Active state can be active, inactive, archived or deleted
      t.string :active_state, default: "active"

      # Active state before setup gets locked
      t.string :active_state_before_locked

      # Needs attention
      t.boolean :needs_attention

      # Planning methods
      t.string :sales_method
      t.string :costs_method

      # We provide a number of columns to save the plan settings
      # They are mapped via the plan helper
      t.string :field1
      t.string :field1_forecast

      t.string :field2
      t.string :field2_forecast

      t.string :field3
      t.string :field3_forecast

      t.string :field4
      t.string :field4_forecast

      t.string :field5
      t.string :field5_forecast

      # Special fields for funding
      t.boolean :has_to_be_repayed

      # Order
      t.integer :order

      # Timestamps
      t.timestamps null: false
    end
  end
end
