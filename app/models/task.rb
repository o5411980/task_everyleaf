class Task < ApplicationRecord
  validates :task_name, presence: true
  validates :detail, presence: true
end
