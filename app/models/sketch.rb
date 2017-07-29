class Sketch < ApplicationRecord
  belongs_to :user, optional: true
  has_many :snippets, dependent: :destroy
  accepts_nested_attributes_for :snippets, allow_destroy: true, reject_if: :all_blank

  before_save :validate_code

  validates :title, presence: true

  # at least one snippet
  validates :snippets, presence: true

  private
    def validate_code
      true
    end
end
