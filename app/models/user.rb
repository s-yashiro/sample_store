# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  include DeviseTokenAuth::Concerns::User

  has_many :items, foreign_key: :seller_id, dependent: :destroy
  has_many :orders, foreign_key: :buyer_id, dependent: :destroy
  has_one :point, dependent: :destroy
  has_many :trade_logs

  after_create :reward_sign_up_bonus

  private
  def reward_sign_up_bonus
    bonus = Bonus.find_by bonus_type: :point, reward_type: :sign_up
    point = Point.find_or_initialize_by user: self
    point.save!
    point.increment_point quantity: bonus&.amount.to_i, log_type: :point, action: :reward
  end
end
