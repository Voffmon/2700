class CreateVentures < ActiveRecord::Migration
  def change
    create_table :ventures do |t|

      # Each venture belongs to a user
      t.references :user

      # Name of the venture
      t.string :name, null: false

      # Description
      t.text :description

      # Currency of the venture
      t.string :currency, null: false

      # Taxes report cycle
      t.string :taxes_report_cycle

      # Default vat
      t.integer :vat

      # Timestamps
      t.timestamps null: false
    end
  end
end
