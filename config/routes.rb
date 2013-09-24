Sampleapp::Application.routes.draw do

  #devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get "group/index"

  devise_for :users do
    match '/users/sign_out', :to => 'devise/sessions#destroy'
    match '/users/sign_up/:invitation_token', :to => 'registrations#validate'
    match '/users/sign_up', :to => 'devise/registrations#new'
  end

  get "users/new"

  authenticated :user do
    root :to => 'users#index'
  end
  root :to => 'users#index'

  match '/home', :to => 'users#index'
  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'

  resources :users
  resources :groups
  resources :invitations

  resources :bills do
    collection do
      get :get_users
      post :create_bill
      post :edit_bill
    end
  end
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end