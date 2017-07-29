class Snippet < ApplicationRecord
  belongs_to :sketch

  validates :language, presence: true
end
