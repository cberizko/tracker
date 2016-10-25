require "rails_helper"

RSpec.describe V1::TasksController, :type => :controller do
	describe "GET index" do
		it "returns a list of tasks for a project" do
      project = Project.create!(name: "Test", description: "Testing")
      task1 = project.tasks.create!(name: "Test Task", description: "Testing Task")
      task2 = project.tasks.create!(name: "Test Task2", description: "Testing Task2")
      task1_attr = task1.attributes.except("created_at", "updated_at", "project_id").symbolize_keys.merge(state: task1.state)
      task2_attr = task2.attributes.except("created_at", "updated_at", "project_id").symbolize_keys.merge(state: task2.state)
			get :index, {"project_id" => project.id}
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response[:current_page_number]).to eq(1)
      expect(parsed_response[:count]).to eq(2)
      expect(parsed_response[:total_page_count]).to eq(1)
      expect(parsed_response[:tasks]).to match_array([task1_attr, task2_attr])
			expect(response.status).to eq(200)
		end

    it "returns a status 404 when project can't be found" do
      get :index, {"project_id" => 1}
      expect(response.status).to eq(404)
    end
	end

  describe "GET show" do
    it "returns a task" do
      project = Project.create!(name: "Test", description: "Testing")
      task1 = project.tasks.create!(name: "Test Task", description: "Testing Task")
      task1_attr = task1.attributes.except("created_at", "updated_at").symbolize_keys.merge(state: task1.state)
      get :show, {"id" => task1.id}
      parsed_response = JSON.parse(response.body, symbolize_names: true).except(:created_at, :updated_at)
      expect(parsed_response).to eq(task1_attr)
      expect(response.status).to eq(200)
    end
  end

  describe "POST create" do
    it "creates a task for a project" do
      project = Project.create!(name: "Test", description: "Testing")
      post :create, {"project_id" => project.id, "task" => { "name" => "Test Task", "description" => "Test Description", "state" => "in_progress" } }
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response).to include(name: "Test Task", description: "Test Description", state: "in_progress", project_id: project.id)
      expect(response.status).to eq(201)
      expect(Task.first).not_to be_nil
    end

    it "returns a status 404 when project can't be found" do
      post :create, {"project_id" => 1}
      expect(response.status).to eq(404)
    end

    it "returns a status 400 when data is invalid" do
      project = Project.create!(name: "Test", description: "Testing")
      post :create, {"project_id" => project.id, "task" => { "name" => "something" } }
      expect(response.status).to eq(400)
    end
  end
end