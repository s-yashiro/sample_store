class Bonus < ApplicationRecord
  enum bonus_type: [:point]
  enum reward_type: [:sign_up]
end
