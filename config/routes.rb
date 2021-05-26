Rails.application.routes.draw do

  get '/auth/:provider/callback',    to: 'users#auth_callback',       as: :auth_callback
  get '/auth/failure',               to: 'users#auth_failure',        as: :auth_failure

  root "users/dashboard#index"

  namespace :api do
    resources :member_skills, only: %i(show)
  end

  get '/users/new/creator/', to: redirect('http://workeasy.jp/')

  namespace :general do
    resources :policy,          only: [:index]
    resources :inquiry,         only: [:create] do
      new do
        match 'general', via: [:get, :post]
        match 'consult', via: [:get, :post]
      end
      collection do
        get :inquirysent
      end
    end

    resources :helppages,        only: [:index] do
      collection do
        get :page1, :page2, :page3
      end
    end
  end

  namespace :users do
    resources :teammembers,   only: [:show] do
      get :team, on: :member
    end
    resources :projects,      only: [:show, :edit, :update]
    resources :settings,      only: [:show, :edit, :update] do
      resources :profile,       only: [:edit, :update], shallow: true
      resources :availability,  only: [:edit, :update], shallow: true
      resources :skill,         only: [:edit, :update], shallow: true
      resources :curriculum,    only: [:edit, :update], shallow: true
      resources :portfolio,     only: [:edit, :update], shallow: true
      resources :license,       only: [:edit, :update], shallow: true
    resources :reports,      only: [:index, :show, :edit, :create, :update]
    end
  end

  resources :users do
    new do
      match 'step1', via: [:get, :post]
      post  'step2'
      match  'creators', via: [:get, :post]
      match  'enterprise', via: [:get, :post]
      post  'confirmation'
    end
    collection do
      get :change, :passwordupdate, :download
    end
    resources :images, controller: "paperclips"
  end

  namespace :createteams do
    resources :categories,      only: [:index, :new, :show] do
      collection do
        get :vision, :urgency, :budget, :frequency, :consult
      end
    end
    resources :teams,           only: [:new, :create, :destroy] do
      collection do
        get :result, :sendmail, :reservation
      end
    end
  end

  resource :session,            only: [:new, :create, :destroy] do
    collection do
      get :reset, :forgetpassword, :resetlogin
    end
  end

  namespace :workstyle do
    resources :questions,       only: [:new] do
      new do
        match 'step1', via: [:get, :post]
        match 'step2', via: [:get, :post]
        match 'step3', via: [:get, :post]
        match 'step4', via: [:get, :post]
        match 'step5', via: [:get, :post]
        match 'step6', via: [:get, :post]
        match 'step7', via: [:get, :post]
        match 'step8', via: [:get, :post]
        match 'step9', via: [:get, :post]
        match 'birth', via: [:get, :post]
        post  'result'
      end
    end
  end

  namespace :admin do
    root "top#index"

    namespace :users do
      resources :adminusers,      only: [:index, :new, :create, :update, :destroy] do
        collection do
          get :selection ,:default
        end
      end
      resources :allusers,        only: [:index, :edit, :update, :destroy] do
        collection do
          get :activechange, :adminchange
        end
      end
      resources :creators,        only: [:index, :show]
      resources :enterprises,     only: [:index, :show, :edit, :update]
    end
    namespace :masters do
      resources :masters,         only: [:index]
      resources :skills,          only: [:index, :new, :edit, :create, :update, :destroy]
      resources :categories,      only: [:index, :new, :edit, :create, :update, :destroy]
      resources :fruits,          only: [:index, :new, :edit, :create, :update, :destroy]
    end
    namespace :organizations do
      resources :teams,           only: [:index, :show, :edit, :update, :destroy] do
        resources :members,       only: [:index, :new, :create, :destroy]
      end
    end
  end

  # どこにも当てはまらなかったものを取得するので最終行に書いて下さい。
  # この方法を利用すると画像が表示されなくなるので利用禁止。
  # get '*path', to: 'application#rescue_not_found'

  if Rails.env.production?
   get '404', :to => 'application#rescue_not_found'
  end
end
