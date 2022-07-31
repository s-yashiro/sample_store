require 'rails_helper'

RSpec.describe CreateTradeLogService do
  let(:user) { create :user }
  let(:log_type) { :point }
  let(:action) { :reward }
  let(:order_id) { 1 }
  let(:quantity) { 300 }
  let(:total) { 1000 }

  describe "Creates trade log" do
    subject do
      CreateTradeLogService.new(user, log_type, action, order_id, quantity, total).call
    end
    it do
      is_expected.not_to be nil
    end
    it do
      expect{ subject }.to change{TradeLog.count}.by 1
    end
    it do
      subject
      expect(TradeLog.last.user_id).to eq user.id
      expect(TradeLog.last.log_type).to eq log_type.to_s
      expect(TradeLog.last.action).to eq action.to_s
      expect(TradeLog.last.order_id).to eq order_id
      expect(TradeLog.last.quantity).to eq quantity
      expect(TradeLog.last.total).to eq total
    end
  end
end
