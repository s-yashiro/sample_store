class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :status, :seller_id
end
