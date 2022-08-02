class Api::V1::ItemsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :load_item, only: [:update, :destroy]

  def create
    @item = Item.new item_params.merge(seller: current_api_v1_user, status: :selling)
    if @item.save
      render json: { data: ItemSerializer.new(@item) }, status: :created
    else
      render json: { error: @item.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if @item.update item_params
      render json: { data: ItemSerializer.new(@item) }, status: :ok
    else
      render json: { error: @item.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    @item.discard!
    render json: { data: {} }, status: :ok
  end

  private
  def item_params
    params.require(:item).permit :name, :price
  end

  def load_item
    unless @item = Item.find_by(id: params[:id], seller: current_api_v1_user)
      render json: { error: I18n.t("errors.item.not_found") }, status: :not_found
    end
  end
end
