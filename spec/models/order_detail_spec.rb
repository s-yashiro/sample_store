spec/models/order_detail_spec.rbrequire 'rails_helper'

RSpec.describe OrderDetail, type: :model do
  describe "Associations" do
    it do
      is_expected.to belong_to(:item)
    end
    it do
      is_expected.to belong_to(:order)
    end
  end

  describe "Uniqueness" do
    context "of item_id, buyer_id and seller_id" do
      let(:buyer) { create :user, email: "test@example.com", password: "password" }
      let(:seller) { create :user, email: "test2@example.com", password: "password" }
      let(:item) { build :item, name: "valid name", price: 100, status: :selling, seller: seller }
      let(:order) { create :order, buyer_id: buyer.id}
      let(:order_detail) { create :order_detail, order: order, item: item, buyer_id: buyer.id, seller_id: seller.id }

      context "duplicated order_detail can not be created" do
        before do
          order_detail
        end
        let(:second_order_detail) { create :order_detail, order: order, item: item, buyer_id: buyer.id, seller_id: seller.id }
        it do
          expect{second_order_detail}.to raise_error(ActiveRecord::RecordNotUnique)
        end
      end
    end
  end
end
