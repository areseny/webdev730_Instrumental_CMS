InstrumentalSescBrasil::Application.routes.draw do

  root to: "home#index"

  controller :home do
    get :about_us, path: "projeto"
    get :privacy, path: "privacidade"
  end

  resources :artists, path: 'artistas', only: [:index, :show] do
    collection do
      get 'letra/:letter', letter: /[A-aZ-z_]/, action: :index, as: :letter
      get :legacy, path: 'memoria'
      get :export
    end
    resources :events, only: [:show], path: ""
  end

  controller :contact_form do
    get :contact_form, path: "contato"
    post :contact, path: "contato"
  end

  resources :subscribers, only: [:create]

  get 'auth/:provider/callback' => 'oauth#callback'
  get 'auth/failure' => 'oauth#failure'

  namespace :admin, path: 'ueber', as: :admin do

    root to: 'home#dashboard'

    get    'login' => 'authentication#login_form', as: :login
    post   'login' => 'authentication#login'
    delete 'logoff' => 'authentication#logoff'

    get 'instruments' => 'instruments#index', :format => :json
    resources :features, except: :show
    resources :artists do
      member do
        get :images
      end
      collection do
        get :datatable, :format => :json
      end
    end

    resources :tv_features, :except => [:show] do
      get :datatable, :on => :collection, :format => :json
    end

    resources :tv_schedule_items, :only => [:index] do
      get :datatable, :on => :collection, :format => :json
      get :import, :on => :collection
      post :import, :on => :collection, action: :upload
      post :clear, :on => :collection
    end

    resources :events, only: [:edit, :update]

    resources :shows, only: [] do
      get :typeahead, :on => :collection, :format => :json
    end

  end

end
