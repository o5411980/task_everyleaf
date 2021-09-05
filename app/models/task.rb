class Task < ApplicationRecord
  validates :task_name, presence: true
  validates :detail, presence: true

  scope :search_task_name_and_status, -> (task_name, status){where('task_name LIKE ?', "%#{task_name}%").where(status: status)}
  scope :search_status, -> (status){where(status: status)}
  scope :search_task_name, -> (task_name){where('task_name LIKE ?', "%#{task_name}%")}
  scope :sort_deadline, -> {order(deadline: :asc)}
  scope :sort_priority, -> {order(priority: :desc)}
  scope :sort_created_at, -> {order(created_at: :desc)}

  belongs_to :user
  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings
end
