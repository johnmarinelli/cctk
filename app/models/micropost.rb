class Micropost < ApplicationRecord
  validates :content, length: { maximum: 140 }, presence: true
  validates :user_id, presence: true
  default_scope -> { order(created_at: :desc) }

  belongs_to :user
end
