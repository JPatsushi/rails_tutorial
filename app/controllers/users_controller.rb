class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    if params[:q]
      @q = User.ransack(search_params, activated: true)
      @users = @q.result(distinct: true).page(params[:page])
      @title = "検索結果"
    else  
      @q = User.ransack(activated_true: true)
      # @users = User.paginate(page: params[:page])
      # @users = User.where(activated: true).paginate(page: params[:page])
      @title = "ユーザー"
    end
      @users = @q.result.page(params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.page(params[:page])
    redirect_to root_url and return unless @user.activated? #まだよくわからない
    
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)    
    if @user.save
      @user.send_activation_email
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user #redirect_to user_url(@user)と同じ
      flash[:info] = "メールを確認して、アカウントをアクティベートしてください"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation) #adminを追加してもREDにならなかった。
                                   
    end
    
    # beforeフィルター
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    def search_params
      params.require(:q).permit(:name_cont)
    end
end
