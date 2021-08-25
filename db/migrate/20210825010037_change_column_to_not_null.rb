class ChangeColumnToNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tasks, :task_name, false
    change_column_null :tasks, :detail, false
  end
end
