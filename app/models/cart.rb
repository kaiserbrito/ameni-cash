# frozen_string_literal: true

# Schema Information
# Table name: carts
# id          :bigint   not null, primary key
# total_cents :integer  default(0), not null
# currency    :string   default("eur"), not null
#
class Cart < ApplicationRecord
end
