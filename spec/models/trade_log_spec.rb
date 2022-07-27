require 'rails_helper'

RSpec.describe TradeLog, type: :model do
  describe "Associations" do
    it do
      is_expected.to belong_to(:user)
    end
  end

  describe "enum" do
    context "log_type" do
      let(:enum) { %i(point) }
      it {is_expected.to define_enum_for(:log_type).with_values enum}
    end
    context "action" do
      let(:enum) { %i(pay sell reward) }
      it {is_expected.to define_enum_for(:action).with_values enum}
    end
  end
end
