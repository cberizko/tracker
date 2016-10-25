# == Schema Information
#
# Table name: projects
#
#  id          :uuid             not null, primary key
#  name        :string
#  description :text
#  state       :integer          default(10)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_projects_on_name  (name) UNIQUE
#

class Project < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :state, presence: true
  has_many :tasks

  after_initialize :set_default_state

  enum state: {
    disabled: -1,
    active: 10,
    archived: 20
  }

  private

  def set_default_state
    self.state ||= :active
  end
end
