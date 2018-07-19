Rails.application.routes.draw do
  root "home#index"

  scope '/api' do
    # my other api stuff
  end

  get '*unmatchedroute', to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
