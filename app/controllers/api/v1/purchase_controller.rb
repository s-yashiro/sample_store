class Api::V1::PurchaseController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :load_item

  def create
    service = PurchaseService.new(current_api_v1_user, @item)
    service.call
    render json: { data: service.responses }, status: :created
  rescue => e
    render json: { error: e.message }, status: :bad_request
  end

  def load_item
    unless @item = Item.where.not(seller: current_api_v1_user).find_by(id: params[:id])
      render json: { error: I18n.t("errors.item.not_found") }, status: :not_found
    end
  end
end
