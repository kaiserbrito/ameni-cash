# frozen_string_literal: true

# Schema Information
# Table name: products
# id           :bigint  not null, primary key
# name         :string  not null
# code         :string  not null
# price_cents  :integer not null
# currency     :enum    not null, default("eur")
#
class Product < ApplicationRecord
  validates :name, :code, :price_cents, :currency, presence: true
  validates :code, uniqueness: true
  validates :price_cents, numericality: { greater_than: 0 }

  enum currency: { eur: "eur", gbp: "gbp", usd: "usd" }, _default: "eur"
end
