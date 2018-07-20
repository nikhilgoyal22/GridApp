class HomeController < ApplicationController
  def get_user
    render json: guest_user
  end
end