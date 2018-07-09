class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :index
  load_and_authorize_resource

  def index
    @posts = Post.all.page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.json { render :json, @post }
    end
  end

  def new
    @post = Post.new
    # rendering을 하기위해서 넣어줌.
    # new.html.erb의 form_for에서 @post 를 사용하기 위해비어있는 @post를 만들어준것.
    # @post 가 비어있으므로 form_for는 create하기 위함인것으로 이해하고 알아서 create로 보내줌
    # @post 가 차있으면? edit하기 위함으로 이해하고 알아서 update로 보냄
  end

  def create
    @post = current_user.posts.new(post_params)
    respond_to do |format|
      if @post.save
        # 저장이 되었을 경우 실행
        # flash[:notice] = "글 작성이 완료되었습니다."
        # redirect_to "/"
        format.html { redirect_to "/", notice: "글 작성 완료!" }
      else
        # 저장에 실패했을 경우에 (validation 걸렸을 때) 실행
        # flash[:alert] = "글 작성에 실패했습니다."
        # redirect_to new_post_path
        format.html { render :new}
        format.json { render json: @post.errors }
      end
    end
  end

  def show
    @comments = @post.comments
  end

  def edit
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { rediret_to @post, notice: '글 수정 완료'}
      else
        format.html { render :edit}
        format.json { render json: @post.errors}
      end
    end
  end

  def destroy
    @post.destroy
    redirect_to "/"
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :img)
    # form for에서 받을때
    # params = {post: {title: "제목", content: "내용"}} 이렇게 2중으로 받아옴.
    # params[:post][:title] ~> 제목
    # 예) a=[[1,2],[2,3]]
    #     a[0][0] ~> 1 이런식임
    # 2중해쉬로 받는것 때문에 .require(:post)가 추가됨
  end
end
