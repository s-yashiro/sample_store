require 'rails_helper'

RSpec.describe "Api::V1::Purchases", type: :request do
  let(:email) { "test@example.com" }
  let(:password) { "password" }
  let!(:user_param) { { email: email, password: password } }
  let(:post_path) { "/api/v1/purchase" }
  let(:headers) { sign_in user_param }

  describe "Item purchase" do
    let(:user) { User.find_by(email: headers["uid"]) }
    let!(:item) { create :item, name: "valid name", price: 100, status: :selling, seller_id: user.id }
    let(:params) do
      {
        id: item.id
      }
    end
    context "success" do
      let(:user2) { create :user, email: "test2@example.com" }
      before do
        item.update!(seller: user2)
        user.point.update(balance: 101)
        post post_path, params: params, as: :json, headers: headers
      end
      it do
        expect(response.status).to eq 201
      end
    end
    context "failure with insufficient funds" do
      let(:user2) { create :user, email: "test2@example.com" }
      before do
        item.update!(seller: user2, price: 11)
        user.point.update(balance: 10)
        post post_path, params: params, as: :json, headers: headers
      end
      it do
        expect(response.status).to eq 400
      end
      it do
        expect(response.body).to include "ポイント残高が不足しています"
      end
    end
    context "failure with already purchased" do
      let(:user2) { create :user, email: "test2@example.com" }
      before do
        item.update!(seller: user2)
        user.point.update(balance: 101)
        order = user.orders.new
        order.order_details.new item: item, seller_id: item.seller.id, buyer_id: user.id
        order.save!
        post post_path, params: params, as: :json, headers: headers
      end
      it do
        expect(response.status).to eq 400
      end
      it do
        expect(response.body).to include "既に購入済みです"
      end
    end
    context "failure with invalid item" do
      let(:params) do
        {
          id: nil
        }
      end
      before do
        post post_path, params: params, as: :json, headers: headers
      end
      it do
        expect(response.status).to eq 404
      end
      it do
        expect(response.body).to include "商品が見つかりません"
      end
    end
    context "failure with invalid user (can not buy own item)" do
      before do
        post post_path, params: params, as: :json, headers: headers
      end
      it do
        expect(response.status).to eq 404
      end
      it do
        expect(response.body).to include "商品が見つかりません"
      end
    end
  end
end
