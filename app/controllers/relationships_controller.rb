class RelationshipsController < ApplicationController
  before_action :require_user, only: [:index, :destroy]
  before_action :set_relationship, only: [:destroy]

  def index
    @follower_relationships = current_user.follower_relationships
  end

  def destroy
    @relationship.destroy
    flash[:notice] = "You have unfollowed #{@relationship.leader.full_name}."
    redirect_to people_path
  end

  private

  def set_relationship
    @relationship = current_user.follower_relationships.find_by_id(params[:id])

    unless @relationship
      flash[:error] = 'This relationship could not be found'
      redirect_to home_path
    end
  end
end

