class CreateTransaction < ActiveRecord::Migration
  def change
    create_table :transactions do |t|

      # Each transaction belongs to a position
      t.references :position

      # Each transaction belongs to a venture (for easy access)
      t.references :venture

      # Date of transaction.
      # The year always equals the year of position
      t.datetime :date

      # Title
      t.string :title

      # Amount of money
      t.decimal :amount, null: false

      # Value added tax in percent
      t.integer :vat, null: false

      # Note for transaction
      t.text :note

      # Timestamps
      t.timestamps null: false
    end
  end
end
