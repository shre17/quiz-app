class Question < ApplicationRecord
  belongs_to :test, optional: true
  has_many :choices, inverse_of: :question
  accepts_nested_attributes_for :choices, reject_if: :all_blank, allow_destroy: true
end
