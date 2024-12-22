# == Schema Information
#
# Table name: outfit_items
#
#  id        :bigint(8)        not null, primary key
#  item_id   :integer
#  outfit_id :integer
#
class OutfitItem < ApplicationRecord
  belongs_to :outfit
  belongs_to :item
end
