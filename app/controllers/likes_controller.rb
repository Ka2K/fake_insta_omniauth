class LikesController < ApplicationController

  def create
    @post_id = params[:post_id]
    @like = Like.create(user_id: current_user.id, post_id: @post_id)
    # current_user는 session에 있는 정보, post_id는 params로 받는 정보
    respond_to do |format|
      format.html { redirect_to :back }
      format.js {}
    end
  end

  def destroy
    @post_id = params[:post_id]
    Like.find_by(user_id: current_user.id, post_id: @post_id.destroy)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js {}
    end
  end

end
