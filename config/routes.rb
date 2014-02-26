InstrumentalSescBrasil::Application.routes.draw do

  root to: "home#index"

  controller :home do
    get :about_us, path: "projeto"
    get :privacy, path: "privacidade"
    get :live, path: "aovivo"
    get :live_status, :format => :json
    resources :live_transmissions, :only => [:show], :path => "aovivo"
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
        get :typeahead, :format => :json
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

    resources :schedule_items do
      get :datatable, :on => :collection, :format => :json
    end

    resources :events, only: [:edit, :update]

    resources :shows, except: [:show] do
      get :datatable, :on => :collection, :format => :json
      get :typeahead, :on => :collection, :format => :json
      resources :songs, :except => :show do
        post :reorder, :on => :collection
      end
    end

    resources :interviews, except: [:show] do
      get :datatable, :on => :collection, :format => :json
    end

    resources :video_chats, except: [:show] do
      get :datatable, :on => :collection, :format => :json
    end

    resources :tv_shows, except: [:show] do
      get :datatable, :on => :collection, :format => :json
    end

    resources :legacy_tv_shows, except: [:show] do
      get :datatable, :on => :collection, :format => :json
    end

    resources :sound_checks, except: [:show] do
      get :datatable, :on => :collection, :format => :json
    end

    resources :live_transmissions, except: [:show] do
      get :datatable, :on => :collection, :format => :json
    end
    resource :live_transmission_settings, :only => [:edit, :update]

  end

end
