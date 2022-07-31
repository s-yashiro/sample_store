require 'rails_helper'

RSpec.describe Point, type: :model do
  describe "Associations" do
    it do
      is_expected.to belong_to(:user)
    end
  end

  describe "Uniqueness" do
    context "of user_id" do
      let(:user) { create :user }

      context "point should bave already been created by user callback" do
        it do
          expect(user.point).to be_present
        end
      end

      context "second point can not be created" do
        let(:second_point) { create :point, user: user }
        it do
          expect{second_point}.to raise_error(ActiveRecord::RecordNotUnique)
        end
      end
    end
  end

  describe "#insufficient?" do
    let(:user) { create :user }
    before do
      user.point.update(balance: 10)
    end
    subject do
      user.point.reload.insufficient? price
    end

    context "insufficient funds" do
      let(:price) { 11 }
      it do
        expect(subject).to be_truthy
      end
    end

    context "there is a balance" do
      let(:price) { 9 }
      it do
        expect(subject).to be_falsey
      end
    end

    context "use up the point" do
      let(:price) { 10 }
      it do
        expect(subject).to be_falsey
      end
    end
  end

  describe "#increment_point" do
    let(:user) { create :user }
    let(:log_type) { :point }
    let(:action) { :reward }
    let(:order_id) { nil }

    subject do
      user.point.increment_point quantity: quantity, log_type: log_type, action: action, order_id: order_id
    end

    context "quantity is zero" do
      let(:quantity) { 0 }
      before { subject }
      it do
        expect(user.point.balance).to eq nil
      end
    end

    context "quantity is negative number" do
      let(:quantity) { -10 }
      it do
        expect{ subject }.to raise_error Point::BalanceOutOfRangeError
      end
    end

    context "quantity is positive number" do
      let(:quantity) { 200 }
      before { subject }
      it { expect(user.point.balance).to eq 200 }
    end

    context "create trade log" do
      let(:quantity) { 300 }
      before do
        user.point.update balance: 200
        subject
      end
      it { expect(user.trade_logs.last.quantity).to eq quantity }
      it { expect(user.trade_logs.last.log_type).to eq log_type.to_s }
      it { expect(user.trade_logs.last.action).to eq action.to_s }
      it { expect(user.trade_logs.last.total).to eq 500 }
    end
  end

  describe "#decrement_point" do
    let(:user) { create :user }
    let(:log_type) { :point }
    let(:action) { :pay }
    let(:order_id) { nil }

    subject do
      user.point.decrement_point quantity: quantity, log_type: log_type, action: action, order_id: order_id
    end

    context "quantity is zero" do
      let(:quantity) { 0 }
      before { subject }
      it do
        expect(user.point.balance).to eq nil
      end
    end

    context "quantity is negative number" do
      let(:quantity) { -10 }
      it do
        expect{ subject }.to raise_error Point::BalanceOutOfRangeError
      end
    end

    context "quantity is positive number" do
      let(:quantity) { 200 }
      before do
        user.point.update(balance: 1000)
        subject
      end
      it { expect(user.point.balance).to eq 800 }
    end

    context "create trade log" do
      let(:quantity) { 300 }
      before do
        user.point.update balance: 1000
        subject
      end
      it { expect(user.trade_logs.last.quantity).to eq quantity }
      it { expect(user.trade_logs.last.log_type).to eq log_type.to_s }
      it { expect(user.trade_logs.last.action).to eq action.to_s }
      it { expect(user.trade_logs.last.total).to eq 700 }
    end
  end
end
