class ApplicationController < ActionController::API
  include ActionController::Cookies

  def guest_user
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find_by!(username: cookies[:guest_username] ||= create_guest_user.username)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    cookies.delete :guest_username
    guest_user
  end

  private

  def create_guest_user
    User.create(:username => "guest#{Time.now.to_i}#{rand(1000)}")
  end
end
