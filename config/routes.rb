Rails.application.routes.draw do
  devise_for :users
  resources :courses
  resources :course_details

#get '/courses',to: 'courses#index',as: 'courses'
#post '/courses',to: 'courses#create'
#patch '/courses/:id',to: 'courses#update',as: 'course'
#put '/courses/:id',to: 'courses#update'
#delete '/courses/:id', to: 'courses#destroy'

#get '/course_details',to: 'course_details#index',as: 'course_details'
#post '/course_details',to: 'course_details#create'
#patch '/course_details/:id',to: 'course_details#update',as: 'course_detail'
#put '/course_details/:id',to: 'course_details#update'
#delete '/course_details/:course_id/:course_details_id', to: 'course_details#destroy'
delete '/course_details', to: 'course_details#destroy'

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
