require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :description }
  it { should validate_presence_of :project_id }
  it { should validate_uniqueness_of(:name).scoped_to(:project_id) }
end
