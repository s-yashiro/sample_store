require 'rails_helper'

RSpec.describe "Api::V1::Items", type: :request do
  let(:email) { "test@example.com" }
  let(:password) { "password" }
  let!(:user_param) { { email: email, password: password } }
  let(:post_path) { "/api/v1/items" }
  let(:patch_path) { "/api/v1/items/#{item.id}" }
  let(:delete_path) { "/api/v1/items/#{item.id}" }
  let(:headers) { sign_in user_param }

  describe "Item create" do
    context "returns http success" do
      let(:params) do
        {
          name: "nice item",
          price: 300
        }
      end
      before do
        post post_path, params: params, as: :json, headers: headers
      end
      it do
        expect(response.status).to eq 201
      end
    end
    context "failure with invalid params" do
      let(:params) do
        {
          name: "",
          price: nil
        }
      end
      before do
        post post_path, params: params, as: :json, headers: headers
      end
      it do
        expect(response.status).to eq 400
      end
      it do
        expect(response.body).to include "商品名 が設定されていません"
      end
      it do
        expect(response.body).to include "価格 が設定されていません"
      end
    end
  end

  describe "Item update" do
    let(:user) { User.find_by(email: headers["uid"]) }
    let!(:item) { create :item, name: "valid name", price: 100, status: :selling, seller_id: user.id }
    let(:params) do
      {
        name: "very nice item",
        price: 300
      }
    end
    context "returns http success" do
      before do
        patch patch_path, params: params, as: :json, headers: headers
      end
      it do
        expect(response.status).to eq 200
      end
    end
    context "failure with invalid user" do
      let(:user2) { create :user, email: "test2@example.com" }
      before do
        item.update!(seller: user2)
        patch patch_path, params: params, as: :json, headers: headers
      end
      it do
        expect(response.status).to eq 404
      end
      it do
        expect(response.body).to include "商品が見つかりません"
      end
    end
    context "failure with invalid params" do
      let(:params) do
        {
          name: nil
        }
      end
      before do
        patch patch_path, params: params, as: :json, headers: headers
      end
      it do
        expect(response.status).to eq 400
      end
      it do
        expect(response.body).to include "商品名 が設定されていません"
      end
    end
  end

  describe "Item destroy" do
    let(:user) { User.find_by(email: headers["uid"]) }
    let!(:item) { create :item, name: "valid name", price: 100, status: :selling, seller_id: user.id }
    let(:params) do
      {
        name: "very nice item",
        price: 300
      }
    end
    context "returns http success" do
      before do
        delete delete_path, params: params, as: :json, headers: headers
      end
      it do
        expect(response.status).to eq 200
      end
    end
    context "failure with invalid user" do
      let(:user2) { build :user }
      before do
        item.update!(seller: user2)
        delete delete_path, params: params, as: :json, headers: headers
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
