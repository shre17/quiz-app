class Submission < ApplicationRecord
  belongs_to :test, optional: true
  belongs_to :user, optional: true
end
