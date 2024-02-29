# frozen_string_literal: true

# Schema Information
# Table name: promotions
# id           :bigint  not null, primary key
# name         :string  not null
# discount     :integer not null - percentage discount to apply
# quantity     :integer not null - number of products that need to be in the cart for the promotion to apply
# product_id   :bigint  not null
#
class Promotion < ApplicationRecord
  belongs_to :product

  validates :name, :discount, :quantity, presence: true
  validates :discount, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than: 1 }
end
