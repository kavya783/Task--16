class Hospital < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_one_attached :image
  belongs_to :user
  has_many :doctors, dependent: :destroy
  has_many :patients, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_secure_password
  
  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :city, presence: true
  
  before_create :generate_api_token

  def generate_api_token
    self.api_token = SecureRandom.hex(20)
  end
end