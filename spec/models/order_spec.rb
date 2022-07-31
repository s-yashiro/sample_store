require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "Associations" do
    it do
      is_expected.to belong_to(:buyer)
    end
  end
end
