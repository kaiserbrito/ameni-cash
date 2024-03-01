# frozen_string_literal: true

# Schema Information
# Table name: cart_products
# id          :bigint  not null, primary key
# quantity    :integer not null
# total_cents :integer default(0), not null
# currency    :string  default("eur"), not null
# product_id  :bigint  not null
# cart_id     :bigint  not null
#
class CartProduct < ApplicationRecord
end
