class Choice < ApplicationRecord
  belongs_to :question, optional: true
end
