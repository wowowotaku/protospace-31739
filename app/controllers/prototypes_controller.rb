class PrototypesController < ApplicationController
  before_action :authenticate_user!, expect: [:create, :edit, :destroy] 
  before_action :reject_edit, only: :edit

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments
  end
  
  def edit
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit
    end
  end
  
  def destroy
    if @prototype.destroy
      redirect_to root_path
    end
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def reject_edit
    unless current_user == @prototype.user
      redirect_to root_path
    end
  end
end
