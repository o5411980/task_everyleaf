class AddIndexToTasksId < ActiveRecord::Migration[5.2]
  def change
    add_index :tasks, :id
  end
end
