class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  def new
    unless current_user
      @user = User.new
    else
      redirect_to tasks_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id), notice: "アカウントが作成できました"
    else
      render :new
    end
  end

  def show
    if params[:id] == (current_user.id.to_s)
      @user = User.find(params[:id])
      @tasks = @user.tasks.page(params[:page]).per(10).sort_created_at
    else
      redirect_to tasks_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
