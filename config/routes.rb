Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'admin/sessions#new'
  get '/api_help'   => 'api_help#index'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  namespace :admin do
    resources :users
    resources :properties
    resources :beacons
    resources :bleapps do
      member do
        post :add_more_image
      end
    end
    resources :highlights
    resources :images
    get   '/'                   => "sessions#new"
    post  '/create'             => "sessions#create"
    get   '/destroy'            => "sessions#destroy"
    get   '/list'               => "users#list"
    post  '/login_permission'   => "users#login_permission"
    get   '/check_email_validation' => "users#check_email_validation"
    # get   '/show_images'        => "properties#show_images"
    # get   '/change_image'       => "properties#change_image"
    # post  '/update_image'       => "properties#update_image"
    # get   '/edit_bleapp'        => "properties#edit_bleapp"
    # post  '/update_bleapp'      => "properties#update_bleapp"
    # get   '/edit_highlight'     => "properties#edit_highlight"
    # post  '/update_highlight'   => "properties#update_highlight"
    # post  '/destroy_bleapp'     => "properties#destroy_bleapp"
    # post  '/destroy_highlight'  => "properties#destroy_highlight"
    post  '/change_status'      => "properties#change_status"
    get   '/feedbacks'          => "feedbacks#index"
    delete  '/feedbacks'        => "feedbacks#destroy"
    get   '/analytics'          => "analytics#index"
    get   '/mile_setting'       => "analytics#mile_setting"
    post  '/update_setting'     => "analytics#update_setting"
    get   '/upload_csv'         => "beacons#upload_csv"
    post  '/import_csv'         => "beacons#import_csv"
    get   '/error_data'         => "beacons#error_data"
    get   '/get_assign_beacon'  => "bleapps#get_assign_beacon" 
    get   '/get_beacon'         => 'beacons#get_beacon'
    get   '/ble_images'         => 'bleapps#images'
    post  '/delete_image'       => 'bleapps#delete_image'
    get   '/ble_audio'          => 'bleapps#ble_audio'
    post  '/ble_audio'          => 'bleapps#add_audio'
    delete  '/ble_audio'        => 'bleapps#delete_audio'
  end
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  namespace :api, :defaults => {:format => 'json'} do
    namespace :v1 do
      post '/create'            => "session#create"
      post '/destroy'           => "session#destroy"
      post '/user_register'     => "user#register_user"
      post '/agent_register'    => "user#register_agent"
      post '/edit_user_account' => "user#edit_user_account"
      post '/edit_agent_account'=> "user#edit_agent_account"
      post '/change_password'   => "user#change_password"
      get  '/user_list'         => "user#user_list"
      get  '/agent_list'        => "user#agent_list" 
      post '/delete_user'       => "user#destroy"
      post '/forgot_password'   => "user#forgot_password"
      post '/create_feedback'   => "user#create_feedback"
      get  '/get_feedback'      => "user#get_feedback"
      get  '/view_feedback'     => "user#view_feedback" 
      post '/add_property'      => "property#create"
      post '/add_images'        => "property#add_images"
      post '/add_documents'     => "property#add_documents"
      post '/add_bleapp'        => "property#add_bleapp"
      post '/create_favorite'   => "property#create_favorite" 
      get  '/view_listing'      => "property#index" 
      get  '/take_tour'         => "property#show"
      get  '/my_listing'        => "property#my_listing"
      get  '/my_favorite'       => "property#my_favorite"
      get  '/view_bleapp'       => "property#view_bleapp"
      get  '/view_highlight'    => "property#view_highlight"
      get  '/highlighted_property' => "property#highlighted_property"
      post '/edit_property'     => "property#edit" 
      post '/edit_image'        => "property#edit_image"
      post '/edit_document'     => "property#edit_document"
      post '/edit_bleapp'       => "property#edit_bleapp"
      post '/edit_bleapp_images'=> "property#edit_bleapp_images"
      post '/create_highlight'  => "property#create_highlight"
      post '/edit_highlight'    => "property#edit_highlight"
      post '/delete_property'   => "property#destroy"
      post '/destroy_favorite'  => "property#destroy_favorite"
      post '/destroy_bleapp'    => "property#destroy_bleapp"
      post '/destroy_highlight' => "property#destroy_highlight"
      get  '/get_property_attribute'        => "property#get_property_attribute"
      get  '/get_bleapp_tags'   => "property#get_bleapp_tags"
      post '/filter_property'   => "property#filter_property"
      post '/search_property'   => "property#search_property"
      get  '/get_beacon'        => "property#get_beacon"
      post '/visit_beacon'      => "property#visit_beacon"
      post '/register_visit'    => "property#register_visit"
      get  '/get_used_beacon'   => "property#get_used_beacon"
      get  '/get_property'      => "property#get_property_by_beacon"
      get  '/get_agent_beacon'  => "property#get_agent_beacon"
    end
  end    

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
