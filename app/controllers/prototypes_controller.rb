class PrototypesController < ApplicationController
  before_action :find_prototype, only: [:show, :edit, :destroy]
  before_action :authenticate_user!, only: :show 
  before_action :reject_edit, only: [:edit, :update, :destroy]

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
    @comments = Comment.all
  end
  
  def edit
  end

  def update
    if Prototype.update(prototype_params)
      redirect_to prototype_path
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

  def find_prototype
    @prototype = Prototype.find(params[:id])
  end

  def reject_edit
    unless current_user == @prototype.user
      redirect_to root_path
    end
  end
end
