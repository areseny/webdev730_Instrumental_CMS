InstrumentalSescBrasil::Application.routes.draw do

  root to: "home#index"

  controller :home do
    get :about_us, path: "projeto"
    get :privacy, path: "privacidade"
  end

  resources :artists, path: 'artistas', only: [:index, :show] do
    collection do
      get 'letra/:letter', letter: /[A-aZ-z_]/, action: :index, as: :letter
    end
  end

  controller :contact_form do
    get :contact_form, path: "contato"
    post :contact, path: "contato"
  end

  resources :subscribers, only: [:create]

  get 'auth/:provider/callback' => 'oauth#callback'
  get 'auth/failure' => 'oauth#failure'

end
