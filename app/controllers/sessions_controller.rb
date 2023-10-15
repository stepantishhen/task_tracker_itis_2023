class SessionsController < ApplicationController
  before_action :authenticate_current_user!, only: %i[show destroy]

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: user_params[:email])
                &.authenticate(user_params[:password])

    if @user
      session[:current_user_id] = @user.id
      redirect_to root_path, notice: "You've successfully logged in!"
    else
      @user = User.new
      @user.errors.add :base, "Wrong email or password"
      render :new
    end
  end

  def destroy
    if session[:current_user_id]
      session.delete(:current_user_id)
      redirect_to root_path, notice: "You've successfully logged out!"
    else
      # rubocop:disable I18n/RailsI18n/DecorateString
      redirect_to root_path, alert: _("You are not logged in.")
      # rubocop:enable I18n/RailsI18n/DecorateString
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
