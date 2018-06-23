class CreatePresets < ActiveRecord::Migration[5.0]
  def change
    create_table :presets do |t|

      # Each preset belongs to a venture
      t.references :venture

      # Name
      t.string :name

      # Preset
      t.json :data

      # Timestamps
      t.timestamps
    end
  end
end
