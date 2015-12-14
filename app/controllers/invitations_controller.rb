class InvitationsController < ApplicationController
  before_action :require_user, only: [:new, :create]

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge(inviter: current_user))

    if @invitation.save
      UserMailer.send_invitation(@invitation.id).deliver
      flash[:notice] = "Your invitation has been sent to #{@invitation.recipient_email}"
      redirect_to home_path
    else
      flash.now[:error] = 'There was a problem creating your invitation'
      render 'new'
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(
      :recipient_name, :recipient_email, :message)
  end
end

