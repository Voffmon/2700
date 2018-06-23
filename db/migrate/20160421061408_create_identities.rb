class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
      create_table :identities do |t|

        # Each realty belongs to a user
        t.references :user, index: true, foreign_key: true

        # Provider name
        t.string :provider, null: false

        # Uid is unique for each provider
        t.string :uid, null: false

        # Timestamps
        t.timestamps null: false
      end

      add_index :identities, :uid
  end
end
