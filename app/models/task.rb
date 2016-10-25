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
	belongs_to :project
  validates :name, :description, :project_id, :project, presence: true
  validates :name, uniqueness: {scope: :project_id}

  enum state: {
    todo: 1,
    in_progress: 2,
    done: 3
  }
end
