class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: :index

  def index
  end

  def logged_in
  end
end
