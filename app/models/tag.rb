class Tag < ApplicationRecord
  has_many :tagmaps, dependent: :destroy
  has_many :book, through: :tagmaps
end
