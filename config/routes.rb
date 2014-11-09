InstrumentalSescBrasil::Application.routes.draw do

  constraints host: "passagemdesom.sesctv.org.br" do
    controller :home do
      get :sound_check_home, path: ""
      get :sound_check_list, path: "lista"
    end
  end

  root to: "home#index"

  controller :home do
    get :about_us, path: "projeto"
    get :privacy, path: "privacidade"
    get :live, path: "aovivo"
    get :search, path: "busca"
    get :live_status, :format => :json
    resources :live_transmissions, :only => [:show], :path => "aovivo"
  end

  resources :artists, path: 'artistas', only: [:index, :show] do
    collection do
      get 'letra/:letter', letter: /[A-aZ-z_]/, action: :index, as: :letter
      get :legacy, path: 'memoria'
      get :export
    end
    resources :events, only: [:show], path: "" do
      get ':song_id', :action => :song, :as => :song
    end
  end

  resources :playlists, :only => [:index] do
    get :search, path: 'busca', on: :collection
  end

  get 'radio_instrumental' => 'radio#show', as: 'radio'

  legacy_route = lambda { |request|
    request.params[:id] =~ /^\d{1,7}$/ && request.params[:format] =~ /^aspx$/i
  }

  get 'ui/show' => 'events#legacy_show', :constraints => legacy_route
  get 'ui/interview' => 'events#legacy_interview', :constraints => legacy_route
  get 'ui/videochat' => 'events#legacy_video_chat', :constraints => legacy_route
  get 'ui/artist' => 'artists#legacy_artist', :constraints => legacy_route

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
    get 'genres' => 'genres#index', :format => :json

    post 'sync_videos' => 'home#sync_videos'
    post 'clear_cache' => 'home#clear_cache'

    resources :features, except: :show
    resources :artists, :except => :show do
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

    resources :pdf_schedules, only: %w(index new create destroy) do
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

    resources :legacy_shows, except: [:show] do
      get :datatable, :on => :collection, :format => :json
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
