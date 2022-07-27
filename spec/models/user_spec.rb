require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Create User" do
    context "Success" do
      it "with valid email、password and password_confirmation" do
        user = build(:user)
        expect(user).to be_valid
      end
    end
    context "Fail" do
      it "with all blank" do
        user = build(:user, email: nil, password: nil, password_confirmation: nil)
        expect(user).to be_invalid
      end
      it "without email" do
        user = build(:user, email: nil)
        expect(user).to be_invalid
      end
      it "without password" do
        user = build(:user, password: nil)
        expect(user).to be_invalid
      end
      it "without password_confirmation" do
        user = build(:user, password_confirmation: nil)
        expect(user).to be_invalid
      end
    end
  end

  describe "Callbacks" do
    context "Create point" do
      let(:bonus) {create :bonus, bonus_type: :point, amount: 10000, reward_type: :sign_up}
      let(:user) {create :user}
      before do
        bonus
        user
      end
      it "success" do
        expect(user.point).to be_present
      end
      it "reward bonus points" do
        expect(user.point.balance).to eq 10000
      end
      it "trade log records quantity" do
        expect(user.trade_logs.last.quantity).to eq 10000
      end
      it "trade log records action" do
        expect(user.trade_logs.last.action).to eq "reward"
      end
    end
  end
end