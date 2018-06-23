class Identity < ApplicationRecord

  # Relations
  belongs_to :user

  # Validations
  validates_presence_of   :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  # Finds or creates a new identity
  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end
