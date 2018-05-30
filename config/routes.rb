Egranary::Application.routes.draw do
  root :to => 'home#index'

  get "home/about"
  get "home/index"

  get "login"   => "sessions#new",        :as => :login
  get "logout"  => "sessions#destroy",    :as => :logout
  #get "signup"  => "users#new",           :as => :signup
  get 'activate/:id' => 'sessions#activate'
  get 'reset_password_form/' => 'sessions#reset_password_form'
  post 'post_reset_password_form/' => 'sessions#post_reset_password_form'
  get 'reset_password/:id' => 'sessions#reset_password'
  post 'post_reset_password/' => 'sessions#post_reset_password'


  get "app"     => "dashboard#index", :as => :app
  get "farmers_table" => "dashboard#farmers_table", :as => :farmers_table
  get "rice_reports_table" => "dashboard#rice_reports_table", :as => :rice_reports_table
  get "nerica_rice_reports_table" => "dashboard#nerica_rice_reports_table", :as => :nerica_rice_reports_table
  get "maize_reports_table" => "dashboard#maize_reports_table", :as => :maize_reports_table
  get "beans_reports_table" => "dashboard#beans_reports_table", :as => :beans_reports_table
  get "green_grams_reports_table" => "dashboard#green_grams_reports_table", :as => :green_grams_reports_table
  get "black_eyed_beans_reports_table" => "dashboard#black_eyed_beans_reports_table", :as => :black_eyed_beans_reports_table
  get "soya_beans_reports_table" => "dashboard#soya_beans_reports_table", :as => :soya_beans_reports_table
  get "pigeon_peas_reports_table" => "dashboard#pigeon_peas_reports_table", :as => :pigeon_peas_reports_table
  get "loans_table" => "dashboard#loans_table", :as => :loans_table
  get "loans_summary" => "dashboard#loans_summary"
  get "float_account" => "egranary_float#dashboard"
  get "ageing_reports" => "dashboard#ageing_reports", :as => :ageing_reports_table
  get "upload_farmer_data" => "farmers#upload_button"
  post "post_upload_farmer_data" => "farmers#upload_data"

  post "farmers/:id/create_loan" => "farmers#create_loan", :as => :create_loan

  get "ussd"    => "ussd#inbound"
  post "ussd"   => "ussd#inbound"

  post "mpesa/customer_payment" => "payments#customer_payment"

  post "blast"  => "dashboard#blast", :as => "blast"

  resources :sessions
  resources :users
  resources :farmers
  resources :loans
  resources :maize_reports
  resources :rice_reports
  resources :nerica_rice_reports
  resources :green_grams_reports
  resources :black_eyed_beans_reports
  resources :beans_reports
  resources :soya_beans_reports
  resources :pigeon_peas_reports

  # API
  namespace :api do
    namespace :v1 do
      get "farmers/:phone_number" => "farmers#show"
    end
  end

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
