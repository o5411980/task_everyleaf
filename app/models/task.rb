class Task < ApplicationRecord
  validates :task_name, presence: true
  validates :detail, presence: true

  scope :sort_created_at, -> {order(created_at: :desc)}
end
