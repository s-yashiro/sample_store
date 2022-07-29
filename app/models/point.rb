class Point < ApplicationRecord
  belongs_to :user

  class BalanceOutOfRangeError < StandardError; end

  def insufficient? price
    self.balance - price < 0
  end

  def increment_point quantity: 0, log_type: nil, action: nil, order_id: nil
    return if quantity == 0
    raise BalanceOutOfRangeError if quantity < 0

    ActiveRecord::Base.transaction do
      self.increment! :balance, quantity
      CreateTradeLogService.new(self.user, log_type, action, order_id, quantity, self.balance).call
      touch
    end
  end

  def decrement_point quantity: 0, log_type: nil, action: nil, order_id: nil
    return if quantity == 0
    raise BalanceOutOfRangeError if quantity < 0
    raise BalanceOutOfRangeError if self.balance - quantity < 0

    ActiveRecord::Base.transaction do
      self.decrement! :balance, quantity
      CreateTradeLogService.new(self.user, log_type, action, order_id, quantity, self.balance).call
      touch
    end
  end
end
