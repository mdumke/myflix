class RelationshipsController < ApplicationController
  before_action :require_user, only: [:index, :destroy]

  def index
    @follower_relationships = current_user.follower_relationships
  end

  def destroy
    relationship = Relationship.find_by_id(params[:id])

    if relationship.follower == current_user
      relationship.destroy
      flash[:notice] = "You have unfollowed #{relationship.leader.full_name}."
    end
    redirect_to people_path
  end
end

