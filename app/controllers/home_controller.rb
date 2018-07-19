require 'rails/application_controller'

class HomeController < Rails::ApplicationController
  def index
    render file: Rails.root.join('public', 'index.html')
  end
end