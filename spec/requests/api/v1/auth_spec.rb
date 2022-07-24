require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  describe "Create user" do
    context "Success" do
      let(:valid_params) do
        {
          "email": "email@example.com",
          "password": "password",
          "password_confirmation": "password"
        }
      end
      it "with valid email、password and password_confirmation" do
        expect{ post '/api/v1/auth', params: valid_params }.to change(User, :count).by(+1)
        expect(response.status).to eq(200)
      end
    end
    context "Fail" do
      let(:invalid_params) do
        {
          "email": "email@example.com",
          "password": nil,
          "password_confirmation": nil
        }
      end
      it "without any of email、password" do
        post '/api/v1/auth', params: invalid_params
        expect(response.status).to eq(422)
      end
    end
  end
end