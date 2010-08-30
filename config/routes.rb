Menu::Application.routes.draw do |map|
  
  constraints :host => /^#{APP_CONFIG[:domain]}$/ do
    defaults :host => APP_CONFIG[:domain] do
      post "/" => "restaurants#create", :as => :restaurants
      get "/" => "restaurants#new", :as => :restaurants
    end
  end
  
  resources :items, :except => [:new] do
    member do
      put :expire
      put :renew
      put :up
      put :down  
    end
  end
  delete 'items' => 'items#destroy_all'
  
  get 'settings' => 'restaurants#edit', :as => :settings
  put 'settings' => 'restaurants#update', :as => :restaurant
  
  delete 'logout' => 'sessions#destroy', :as => :logout
  get  'login' => 'sessions#new', :as => :login
  post 'login' => 'sessions#create', :as => :login
  root :to => "items#index"

  

  
  
  # The priority is based upon order of creation:
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
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
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
  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
