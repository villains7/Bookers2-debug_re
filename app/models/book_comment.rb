class BookComment < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :notifications, dependent: :destroy
end
