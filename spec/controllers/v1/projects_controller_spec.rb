require "rails_helper"

RSpec.describe V1::ProjectsController, :type => :controller do
  describe "GET index" do
    it "returns a list of projects" do
      project1 = Project.create!(name: "Test", description: "Testing")
      project2 = Project.create!(name: "Test2", description: "Testing2")
      project1_attr = project1.attributes.except("created_at", "updated_at").symbolize_keys.merge(state: project1.state)
      project2_attr = project2.attributes.except("created_at", "updated_at").symbolize_keys.merge(state: project2.state)
      get :index
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response[:current_page_number]).to eq(1)
      expect(parsed_response[:count]).to eq(2)
      expect(parsed_response[:total_page_count]).to eq(1)
      expect(parsed_response[:projects]).to match_array([project1_attr, project2_attr])
      expect(response.status).to eq(200)
    end
  end

  describe "GET show" do
    it "returns a project" do
      project1 = Project.create!(name: "Test", description: "Testing")
      project1_attr = project1.attributes.except("created_at", "updated_at").symbolize_keys.merge(state: project1.state)
      get :show, {"id" => project1.id}
      parsed_response = JSON.parse(response.body, symbolize_names: true).except(:created_at, :updated_at)
      expect(parsed_response).to eq(project1_attr)
      expect(response.status).to eq(200)
    end
  end

  describe "POST create" do
    it "creates a project" do
      post :create, {"project" => { "name" => "Test Project", "description" => "Test Description"} }
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response).to include(name: "Test Project", description: "Test Description", state: "active")
      expect(response.status).to eq(201)
    end

    it "returns a status 400 when data is invalid" do
      post :create, {"project" => { "description" => "something" } }
      expect(response.status).to eq(400)
    end
  end

  describe "PUT update" do
    it "updates a project" do
      project1 = Project.create!(name: "Test", description: "Testing")
      put :update, {"id" => project1.id, "project" => { "name" => "Test Project", "description" => "Test Description"} }
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response).to include(name: "Test Project", description: "Test Description", state: "active")
      expect(response.status).to eq(200)
    end

    it "returns a status 404 when project is not found" do
      put :update, {"id" => "1", "project" => { "name" => "Test Project", "description" => "Test Description"} }
      expect(response.status).to eq(404)
    end

    it "returns a status 400 when project has invalid data" do
      project1 = Project.create!(name: "Test", description: "Testing")
      put :update, {"id" => project1.id, "project" => { "name" => nil, "description" => "Test Description"} }
      expect(response.status).to eq(400)
    end
  end

  describe "DELETE destroy" do
    it "updates a project to be disabled" do
      project1 = Project.create!(name: "Test", description: "Testing")
      delete :destroy, {"id" => project1.id}
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response).to include(name: "Test", description: "Testing", state: "disabled")
      expect(response.status).to eq(200)
    end

    it "returns a status 404 when project is not found" do
      delete :destroy, {"id" => "1", "project" => { "name" => "Test Project", "description" => "Test Description"} }
      expect(response.status).to eq(404)
    end
  end
end