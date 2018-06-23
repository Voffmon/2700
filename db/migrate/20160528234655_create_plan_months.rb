class CreatePlanMonths < ActiveRecord::Migration[5.0]
  def change
    create_table :plan_months do |t|

      # Each plan month belongs to a position
      t.references :position

      # The month [1..12]
      t.integer :month

      # We provide a number of columns to save the table values
      # They are mapped via the plan helper
      t.decimal :col1
      t.decimal :col1_forecast
      t.boolean :col1_is_user_generated
      t.boolean :col1_is_user_generated_forecast

      t.decimal :col2
      t.decimal :col2_forecast
      t.boolean :col2_is_user_generated
      t.boolean :col2_is_user_generated_forecast

      t.decimal :col3
      t.decimal :col3_forecast
      t.boolean :col3_is_user_generated
      t.boolean :col3_is_user_generated_forecast

      t.decimal :col4
      t.decimal :col4_forecast
      t.boolean :col4_is_user_generated
      t.boolean :col4_is_user_generated_forecast

      # Note
      t.text :note

      # Forecast note
      t.text :note_forecast

      # Timestamps
      t.timestamps null: false
    end
  end
end
