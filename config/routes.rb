Rails.application.routes.draw do
  crud = %i(index show create update destroy)
  immutable = %i(index show create)


  namespace :v1 do
    resources :projects, only: crud do
    	resources :tasks, only: immutable, shallow: true
    end
  end
end
