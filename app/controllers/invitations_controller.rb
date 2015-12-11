class InvitationsController < ApplicationController
  before_action :require_user, only: [:new]

  def new
    @inviter = current_user
    @invitation = Invitation.new
  end
end

