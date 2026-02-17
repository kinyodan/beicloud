class Beiapp < ApplicationRecord
  belongs_to :beispace, optional: true
  has_many   :onboardings, dependent: :destroy

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true

  after_create :create_initial_onboarding

  private

  def create_initial_onboarding
    onboardings.create!(
      uuid:   SecureRandom.uuid,
      status: 'created',
      state:  'created'
    )
  end
end