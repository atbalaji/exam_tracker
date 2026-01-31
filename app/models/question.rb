class Question < ApplicationRecord
  belongs_to :section
  belongs_to :created_by, class_name: "User"
end
