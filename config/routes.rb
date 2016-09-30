Egranary::Application.routes.draw do
  root :to => 'home#index'

  get "home/about"
  get "home/index"

  get "login"   => "sessions#new",        :as => :login
  get "logout"  => "sessions#destroy",    :as => :logout
  #get "signup"  => "users#new",           :as => :signup
  get "app"     => "dashboard#index", :as => :app
  get "farmers_table" => "dashboard#farmers_table", :as => :farmers_table
  get "rice_reports_table" => "dashboard#rice_reports_table", :as => :rice_reports_table
  get "nerica_rice_reports_table" => "dashboard#nerica_rice_reports_table", :as => :nerica_rice_reports_table
  get "maize_reports_table" => "dashboard#maize_reports_table", :as => :maize_reports_table
  get "beans_reports_table" => "dashboard#beans_reports_table", :as => :beans_reports_table
  get "green_grams_reports_table" => "dashboard#green_grams_reports_table", :as => :green_grams_reports_table
  get "black_eyed_beans_reports_table" => "dashboard#black_eyed_beans_reports_table", :as => :black_eyed_beans_reports_table

  get "ussd"    => "ussd#inbound"
  post "ussd"   => "ussd#inbound"

  post "blast"  => "dashboard#blast", :as => "blast"

  resources :sessions
  resources :users
  resources :farmers
  resources :maize_reports
  resources :rice_reports
  resources :nerica_rice_reports
  resources :green_grams_reports
  resources :black_eyed_beans_reports
  resources :beans_reports

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
