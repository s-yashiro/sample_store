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
end