class RelationshipsController < ApplicationController
  before_action :require_user, only: [:index, :create, :destroy]

  def index
    @follower_relationships = current_user.follower_relationships
  end

  def create
    leader = User.find_by_id(params[:leader_id])
    relationship = Relationship.new(leader: leader, follower: current_user)

    if !current_user.can_follow?(leader)
      # nothing to do
    elsif relationship.save
      flash[:notice] = "You are now following #{leader.full_name}"
    else
      flash[:error] = "Something went wrong."
    end

    redirect_to :back
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

