Rails.application.routes.draw do

  # 顧客用
  # URL /customers/sign_in ...
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "user/registrations",
    sessions: 'user/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  
  scope module: :user do
  root to: "homes#top"
    resources :books, only: [:new, :index, :show, :edit, :create, :update, :destroy]do
    resources :book_comments, only: [:create, :destroy] 
    end
    resources :users, only: [:show, :edit, :update, :destroy] do
      resource :favorites, only: [:create, :destroy]
    end
  end
  
    
  devise_scope :user do
    post "user/guest_sign_in", to: "user/sessions#guest_sign_in"
  end
  
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
