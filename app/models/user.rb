# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  include DeviseTokenAuth::Concerns::User

  has_many :items, foreign_key: :seller_id
  has_many :orders, foreign_key: :buyer_id
  has_one :point
  has_many :trade_logs

  validates :email, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true, if: :password

  after_create :reward_sign_up_bonus

  private
  def reward_sign_up_bonus
    bonus = Bonus.find_by bonus_type: :point, reward_type: :sign_up
    point = Point.find_or_initialize_by user: self
    point.save!
    point.increment_point quantity: bonus&.amount.to_i, log_type: :point, action: :reward
  end
end
