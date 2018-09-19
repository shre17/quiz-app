class Test < ApplicationRecord
  has_many :questions, inverse_of: :test
  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true
  has_many :submissions
  has_many :users, through: :submissions
end
