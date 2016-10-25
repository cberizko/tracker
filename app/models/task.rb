# == Schema Information
#
# Table name: tasks
#
#  id          :uuid             not null, primary key
#  name        :string
#  description :text
#  state       :integer          default(1)
#  project_id  :uuid
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_tasks_on_project_id_and_name  (project_id,name) UNIQUE
#

class Task < ActiveRecord::Base
  validates :name, :description, :project_id, presence: true
  validates :name, uniqueness: {scope: :project_id}
  belongs_to :project

  enum state: {
    todo: 1,
    in_progress: 2,
    done: 3
  }
end
