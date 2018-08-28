class UsersController < ApplicationController
  
  before_action :authenticate_user, {only: [:index, :show, :edit, :update]}
  # before_actionにforbid_login_userメソッドを指定してください
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :eusure_correct_user, {only: [:edit, :update]}
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by(id: params[:id])
    # @friend = Friend.where(follower_id: @user.id).where(followed_id: @current_user.id).or(Friend.where(follower_id: @current_user.id).where(followed_id: @user.id))
    @friend = Friend.select('status').where(follower_id: @user.id).where(followed_id: @current_user.id)
    
    @friend.each do |friend|
      if friend.status == "w"
        @flag = "w"
      elsif friend.status == "a"
        @flag = "a"
      elsif friend.status == "b"
        @flag = "b"
      else
        @flag = "r"
      end
    end
         

          

  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
      image_name: "default_user.jpg"
      )
      
    if @user.save
      flash[:notice] = "ユーザー登録が完了しました"
      session[:user_id] = @user.id
      redirect_to("/users/#{@user.id}")
    else
      render("/users/new")
    end
  end
  
  def edit
    @user = User.find_by(id: params[:id])
  end 
  
  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    @user.profile = params[:profile]
    
    # 画像を保存する
    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      #logger.debug(image.inspect)
      # File.binwrite("public/user_images/#{@user.image_name}", image.read)
     
      picname = "public/user_images/#{@user.image_name}"
      File.open(picname,"wb") do |file|
        file.puts image.read
      end
    end
    
    # 動画を保存する
    if params[:video]
      @user.video_name = "#{@user.id}.mp4"
      video = params[:video]
      #logger.debug(image.inspect)
      # File.binwrite("public/user_images/#{@user.image_name}", image.read)
     
      videoname = "public/user_videos/#{@user.video_name}"
      File.open(videoname,"wb") do |file|
        file.puts video.read
      end
    end
    
    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end
  
  def follow_request
    @user = User.find_by(id: params[:id])
    @friend = Friend.new(
                         follower_id: params[:id],
                         followed_id: @current_user.id,
                         status: "w"  #承認待ち
                        )
                        
    if @friend.save
        flash[:notice] = "#{@user.name}さんに友達申請しました"
        redirect_to("/users/#{@user.id}")
    else
        render("/users/#{@user.id}")
    end
    
  end
  
  
  
  
  def login_form
  end
  
  def login
    # メールアドレスのみを用いて、ユーザーを取得するように書き換えてください
    @user = User.find_by(email: params[:email])
    # if文の条件を&&とauthenticateメソッドを用いて書き換えてください
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/posts/index")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end
  
  def quit_confirm
    @user = User.find_by(id: params[:id])
  end
  
  def destroy
      @user = User.find_by(id: params[:id])
      if @user      
        if @user.destroy
          flash[:notice] = "#{@user.name}様、退会処理完了しました"
          session[:user_id] = nil
          redirect_to("/signup")
        else
          render("/users/index")
        end
      else
        flash[:notice] = "存在しないユーザーです"
        redirect_to("/signup")        
      end
  end
  
  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
  end
  
  def eusure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/users/index")
    end
  end
  
  
end
