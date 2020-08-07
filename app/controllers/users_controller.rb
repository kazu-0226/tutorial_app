class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]     # editとupdateアクションにlogged_in_userメソッドを適用
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page]) 
  end


   # GET /users/:id
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    # => app/views/users/show.html.erb
    # debugger
    redirect_to root_url and return unless @user.activated?    
  end

  def new
    @user = User.new
    # => form_for @user
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save # => Validation
      # Sucess
      #1-4.新規登録後、ユーザーへアカウント有効化のメールを送信する。(ログインは削除)
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # GET "/users/#{@user.id}" => show
    else
      # Failure
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id]) # URLのユーザーidと同じユーザーをDBから取り出して@userに代入
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)   # 更新に成功した場合を扱う。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :password,
      :password_confirmation)
  end

 # beforeアクション

    def correct_user
      @user = User.find(params[:id])                      # URLのidの値と同じユーザーを@userに代入
      redirect_to(root_url) unless current_user?(@user)   # @userと記憶トークンcookieに対応するユーザー(current_user)を比較して、失敗したらroot_urlへリダイレクト
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
