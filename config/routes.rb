Rails.application.routes.draw do
  scope '/api' do
    get '/get_user', to: 'home#get_user'
  end

  get '*unmatchedroute', to: redirect('/')

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
