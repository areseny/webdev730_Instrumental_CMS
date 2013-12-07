InstrumentalSescBrasil::Application.routes.draw do

  root to: "home#index"

  controller :home do
    get :about_us, path: "projeto"
    get :privacy, path: "privacidade"
  end

end
