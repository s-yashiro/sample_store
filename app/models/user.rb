# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  include DeviseTokenAuth::Concerns::User

  has_many :items, foreign_key: :seller_id
  has_many :orders, foreign_key: :buyer_id
  has_many :points
  has_many :trade_logs

  validates :email, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true, if: :password
end
