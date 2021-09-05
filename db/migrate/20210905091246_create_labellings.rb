class CreateLabellings < ActiveRecord::Migration[5.2]
  def change
    create_table :labellings do |t|
      t.references :task
      t.references :label

      t.timestamps
    end
  end
end
