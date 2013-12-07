InstrumentalSescBrasil::Application.routes.draw do

  root to: "home#index"

  controller :home do
    get :about_us, path: "projeto"
    get :privacy, path: "privacidade"
  end

  controller :contact_form do
    get :contact_form, path: "contato"
    post :contact, path: "contato"
  end

  resources :subscribers, only: [:create]

end
