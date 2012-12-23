Nerdnews::Application.routes.draw do
  root :to => "stories#index"
  
  # delayed job web inteface
  match "/delayed_job" => DelayedJobWeb, :anchor => false

  # External Auth
  match '/auth/:provider/callback' => 'identities#create'
  match '/auth/failure' => 'identities#failure'

  # Identities (Used for OmniAuth)
  resources :identities, :only => [:index, :create, :destroy] do
    collection do
      get 'signup'
    end
  end

  # Other Resources
  resources :ratings
  resources :password_resets
  resources :pages
  resources :tags
  resources :mypage, only: :index

  # Sessions
  get "/login" => "sessions#new", as: "new_session"
  post "/login" => "sessions#create", as: "sessions"
  delete "/logout" => "sessions#destroy", as: "session"

  # Users
  resources :users, path_names: { new: 'sign_up' } do
    get 'posts', on: :member
    get 'comments', on: :member
    get 'favorites', on: :member
    post 'add_to_favorites', on: :member
    resources :messages, except: [:edit, :update, :show]
  end

  # Stories
  resources :stories do
    resources :votes, :defaults => { :voteable => 'stories' }
    resources :comments do
      resources :votes, :defaults => { :voteable => 'comments' }
    end
    get 'unpublished', :on => :collection
    put 'publish', :on => :member
  end

  get "/:permalink" => "pages#show", as: "page_by_permalink"


  namespace :admin do
    get '', to: 'dashboard#index'
  end

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
