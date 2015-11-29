class RelationshipsController < ApplicationController
  before_action :require_user, only: [:index]

  def index
    @people = current_user.leaders
  end
end

