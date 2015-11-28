class FollowingsController < ApplicationController
  before_action :require_user, only: [:index]

  def index
    @people = current_user.people
  end
end

