class CreateTradeLogService
  attr_reader :user, :log_type, :action, :order_id, :quantity, :total

  def initialize user, log_type, action, order_id, quantity, total
    @user = user
    @log_type = log_type
    @action = action
    @order_id = order_id
    @quantity = quantity
    @total = total
  end

  def call
    save_log
  end

  def save_log
    user.trade_logs.create! user: user, log_type: log_type, action: action,
      order_id: order_id, quantity: quantity, total: total
  end
end
