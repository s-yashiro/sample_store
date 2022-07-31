require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "Associations" do
    it do
      is_expected.to belong_to(:seller)
    end
  end
  describe "enum" do
    context "status" do
      let(:enum) { %i(selling sold) }
      it {is_expected.to define_enum_for(:status).with_values enum}
    end
  end
  describe "Validations" do
    let(:user) { create :user }
    context "create succuess with invalid params" do
      let(:item) { build :item, name: "valid name", price: 100, status: :selling, seller: user }
      it do
        expect(item).to be_valid
      end
    end
    context "raise error with invalid values any of name and price" do
      let(:item) { build :item, name: nil, price: nil }
      it do
        expect(item).to be_invalid
      end
    end
  end
end
