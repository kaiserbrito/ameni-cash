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
end
