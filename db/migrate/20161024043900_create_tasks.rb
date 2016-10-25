class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :name
      t.text :description
      t.integer :state, default: 1
      t.uuid :project_id
      t.index [:project_id, :name], unique: true

      t.timestamps
    end
  end
end
