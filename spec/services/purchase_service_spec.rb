require 'rails_helper'

RSpec.describe PurchaseService do
  let(:buyer) { create :user, email: "test@example.com", password: "password" }
  let(:seller) { create :user, email: "test2@example.com", password: "password" }
  let(:item) { create :item, price: 100, seller: seller }

  describe "Buy item" do
    let(:item_serializable) do
      ItemSerializer.new(item).to_json
    end
    subject do
      PurchaseService.new(buyer, item)
    end
    context "success" do
      before do
        buyer.point.update(balance: 100)
        seller.point.update(balance: 0)
        subject.call
      end
      it "return item object" do
        expect(subject.responses[:item].to_json).to eq item_serializable
      end
      it "return receipt object" do
        expect(subject.responses[:receipt][:user_id]).to eq buyer.id
        expect(subject.responses[:receipt][:log_type]).to eq "point"
        expect(subject.responses[:receipt][:action]).to eq "pay"
        expect(subject.responses[:receipt][:order_id]).to eq item.order_detail.order_id
        expect(subject.responses[:receipt][:quantity]).to eq item.price
        expect(subject.responses[:receipt][:total]).to eq buyer.point.balance - item.price
      end
      it "paid to seller" do
        expect(seller.point.reload.balance).to eq item.price
      end
      it "creates trade log of seller too" do
        expect(seller.trade_logs.last.user_id).to eq seller.id
        expect(seller.trade_logs.last.order_id).to eq item.order_detail.order_id
        expect(seller.trade_logs.last.log_type).to eq "point"
        expect(seller.trade_logs.last.action).to eq "sell"
        expect(seller.trade_logs.last.quantity).to eq item.price
        expect(seller.trade_logs.last.total).to eq item.price
      end
    end

    context "failure" do
      before do
        buyer.point.update(balance: 100)
        seller.point.update(balance: 0)
      end
      context "already sold out" do
        let(:item) { create :item, price: 100, seller: seller, status: :sold }
        it do
          expect{subject.call}.to raise_error PurchaseService::PointPurchaseError, I18n.t("errors.purchase.sold_out")
        end
      end
      context "already purchased" do
        before do
          order = buyer.orders.new
          order.order_details.new item: item, seller_id: item.seller.id, buyer_id: buyer.id
          order.save!
        end
        it do
          expect{subject.call}.to raise_error PurchaseService::PointPurchaseError, I18n.t("errors.purchase.duplicated")
        end
      end
      context "insufficient funds" do
        before do
          buyer.point.update(balance: 99)
        end
        it do
          expect{subject.call}.to raise_error PurchaseService::PointPurchaseError, I18n.t("errors.purchase.insufficient")
        end
      end
    end
  end
end
