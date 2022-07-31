class PurchaseService
  attr_reader :user, :item, :order_id

  class PointPurchaseError < StandardError; end

  def initialize user, item
    @user = user
    @item = item
    @order_id = nil
  end

  def call
    ActiveRecord::Base.transaction do
      pre_process
      purchase
      post_process
    rescue => e
      raise PointPurchaseError, e.message.start_with?("Mysql2::Error: Duplicate entry") ? msg("duplicated") : e
    end
  end

  def responses
    {
      item: ItemSerializer.new(@item),
      receipt: TradeLog.find_by(user: user, action: :pay, order_id: order_id)
    }
  end

  private

  def pre_process
    case true
    when item.sold?
      raise PointPurchaseError, (item.order_detail&.buyer_id == user.id) ? msg("duplicated") : msg("sold_out")
    when item.discarded?
      raise PointPurchaseError, msg("discarded")
    when user.point.insufficient?(item.price)
      raise PointPurchaseError, msg("insufficient")
    else
    end
  end

  def purchase
    order = user.orders.new
    order.order_details.new item: item, seller_id: item.seller.id, buyer_id: user.id
    order.save!
    @order_id = order.id
    point = Point.find_by user: user
    point.decrement_point quantity: item.price, log_type: :point, action: :pay, order_id: order_id
  end

  def post_process
    item.update(status: :sold)
    seller_point = Point.find_by user: item.seller
    seller_point.increment_point quantity: item.price, log_type: :point, action: :sell, order_id: order_id
  end

  def msg type
    I18n.t("errors.purchase.#{type}")
  end
end
