App::Application.routes.draw do

	resources :static_page_contents

	namespace :api, :defaults => {:format => :json} do
		namespace :v1 do

			post '/sessions/login' => 'sessions#create'
			post '/users/create' => 'users#create'

			resources :sessions
			resources :users
		end
	end

	resources :users
	resources :sessions, only: [:new, :create, :destroy]
	resources :password_resets
	resources :sessions

	devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

	root "static_pages#home"

	get "about" => "static_pages#about"
	get "terms" => "static_pages#terms"
	get "contact" => "static_pages#contact"

	match "/signup", to: "users#new", via: "get"
	match "/login", to: "sessions#new", via: "get"
	match "/logout", to: "sessions#destroy", via: "delete"

	match "/profile", to: "users#show", via: "get"
	match "/profile/edit", to: "users#edit", via: "get"
end
