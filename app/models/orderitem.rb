class Orderitem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :cart
end
