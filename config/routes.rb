Egranary::Application.routes.draw do

  mount ReportsKit::Engine, at: '/'

  root :to => 'dashboard#dashboard_home'

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

  get "dashboard_home" => "dashboard#dashboard_home", :as => :dashboard_home
  get "dashboard_farmers" => "dashboard#dashboard_farmers", :as => :dashboard_farmers
  get "dashboard_argonomy" => "dashboard#dashboard_argonomy", :as => :dashboard_argonomy
  get "dashboard_farmer_groups" => "dashboard#dashboard_farmer_groups", :as => :dashboard_farmer_groups
  get "dashboard_communications" => "dashboard#dashboard_communications", :as => :dashboard_communications
  get "dashboard_loans" => "dashboard#dashboard_loans", :as => :dashboard_loans


  get "farmers_table" => "dashboard#farmers_table", :as => :farmers_table
  get "farmer_groups_table" => "dashboard#farmer_groups_table", :as => :farmer_groups_table
  get "rice_reports_table" => "dashboard#rice_reports_table", :as => :rice_reports_table
  get "nerica_rice_reports_table" => "dashboard#nerica_rice_reports_table", :as => :nerica_rice_reports_table
  get "maize_reports_table" => "dashboard#maize_reports_table", :as => :maize_reports_table
  get "beans_reports_table" => "dashboard#beans_reports_table", :as => :beans_reports_table
  get "green_grams_reports_table" => "dashboard#green_grams_reports_table", :as => :green_grams_reports_table
  get "black_eyed_beans_reports_table" => "dashboard#black_eyed_beans_reports_table", :as => :black_eyed_beans_reports_table
  get "soya_beans_reports_table" => "dashboard#soya_beans_reports_table", :as => :soya_beans_reports_table
  get "pigeon_peas_reports_table" => "dashboard#pigeon_peas_reports_table", :as => :pigeon_peas_reports_table
  get "rice_inputs_table" => "dashboard#rice_inputs_table", :as => :rice_inputs_table
  get "nerica_rice_inputs_table" => "dashboard#nerica_rice_inputs_table", :as => :nerica_rice_inputs_table
  get "maize_inputs_table" => "dashboard#maize_inputs_table", :as => :maize_inputs_table
  get "beans_inputs_table" => "dashboard#beans_inputs_table", :as => :beans_inputs_table
  get "green_grams_inputs_table" => "dashboard#green_grams_inputs_table", :as => :green_grams_inputs_table
  get "black_eyed_beans_inputs_table" => "dashboard#black_eyed_beans_inputs_table", :as => :black_eyed_beans_inputs_table
  get "soya_beans_inputs_table" => "dashboard#soya_beans_inputs_table", :as => :soya_beans_inputs_table
  get "pigeon_peas_inputs_table" => "dashboard#pigeon_peas_inputs_table", :as => :pigeon_peas_inputs_table
  get "loans_table" => "dashboard#loans_table", :as => :loans_table
  get "payments_table" => "dashboard#payments_table", :as => :payments_table
  get "loans_summary" => "dashboard#loans_summary"
  get "float_account" => "egranary_float#dashboard"
  get "ageing_reports" => "dashboard#ageing_reports", :as => :ageing_reports_table
  get "upload_farmer_data" => "farmers#upload_button"
  post "post_upload_farmer_data" => "farmers#upload_data"
  get "users_table" => "dashboard#users_table", :as => :users_table
  get "send_sms" => "dashboard#send_sms", :as => :send_sms
  get "post_send_sms" => "dashboard#post_send_sms", :as => :post_send_sms
  post "disburse_loan" => "payments#disburse_loan"

  post "post_upload_audited_financials" => "farmer_groups#post_upload_audited_financials"
  post "post_upload_management_accounts" => "farmer_groups#post_upload_management_accounts"
  post "post_upload_certificate_of_registration" => "farmer_groups#post_upload_certificate_of_registration"


  get "upload_crop_data" => "crop#upload_button"
  post "post_upload_crop_data" => "crop#upload_data"

  post "farmers/:id/create_loan" => "farmers#create_loan", :as => :create_loan
  post "float_account/create_float_txn" => "egranary_float#create_float_txn", :as => :create_float_txn

  get "ussd"    => "ussd#inbound"
  post "ussd"   => "ussd#inbound"

  post "mpesa/incoming" => "payments#incoming"
  get  "mpesa/incoming" => "payments#incoming"
  post "mpesa/b2c" => "payments#b2c"

  get "users/invite" => "users#invite", :as => :invite_user
  post "users/post_invite" => "users#post_invite", :as => :post_invite

  post "blast"  => "dashboard#blast", :as => "blast"

  get "farmer_data_by_country" => "dashboard#farmer_data_by_country"
  get "farmer_data_per_crop_by_country" => "dashboard#farmer_data_per_crop_by_country"
  get "planting_harvesting_data_by_country" => "dashboard#planting_harvesting_data_by_country"
  post "farmers/:id/reset_pin" => 'farmers#reset_pin'
  post "assign_loans" => 'dashboard#assign_loans', :as => :assign_loans

  resources :sessions
  resources :users
  resources :farmers
  resources :farmer_groups
  resources :loans
  resources :egranary_float
  resources :maize_reports
  resources :rice_reports
  resources :nerica_rice_reports
  resources :green_grams_reports
  resources :black_eyed_beans_reports
  resources :beans_reports
  resources :soya_beans_reports
  resources :pigeon_peas_reports
  resources :maize_inputs
  resources :rice_inputs
  resources :nerica_rice_inputs
  resources :green_grams_inputs
  resources :black_eyed_beans_inputs
  resources :beans_inputs
  resources :soya_beans_inputs
  resources :pigeon_peas_inputs

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
