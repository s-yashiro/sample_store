require 'rails_helper'

RSpec.describe Bonus, type: :model do
  describe "enum" do
    context "bonus_type" do
      let(:enum) { %i(point) }
      it {is_expected.to define_enum_for(:bonus_type).with_values enum}
    end
    context "reward_type" do
      let(:enum) { %i(sign_up) }
      it {is_expected.to define_enum_for(:reward_type).with_values enum}
    end
  end
end
