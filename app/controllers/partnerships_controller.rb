class PartnershipsController < ApplicationController
  before_action :set_user, only: [:index, :new, :create]
  before_action :set_partnership, only: [:destroy, :accept, :refuse, :cancel]


  def new
    partnerships = Partnership.all.where("user_id = ? OR partner_id = ?", current_user.id, current_user.id)
    existing_partners = (partnerships.map(&:user) + partnerships.map(&:partner))

    @partners = User.all - existing_partners
    @partnership = @user.partnerships.build
  end

  def create
    partner = User.find(partnership_params[:partner_id])
    @partnership = @user.propose_partnership(partner)

    if @partnership.save
      redirect_to user_partnerships_path(current_user), notice: 'Partnership request has been sent'
    else
      render :new
    end
  end

  def destroy
    @partnership.destroy
    redirect_to user_partnerships_path(current_user), notice: 'Partnership was successfully deleted.'
  end

  def accept
    @partnership.accept
    redirect_to user_partnerships_path(current_user), notice: 'Partnership was successfully accepted.'
  end

  def refuse
    @partnership.refuse
    redirect_to user_partnerships_path(current_user), notice: 'Partnership was successfully refused.'
  end

  def cancel
    @partnership.cancel
    redirect_to user_partnerships_path(current_user), notice: 'Partnership was successfully cancelled.'
  end

  def user_index
    @partnerships = Partnership.all.where("user_id = ? OR partner_id = ?", current_user.id, current_user.id)
    render :index
  end

  private
    def partnership_params
      params.require(:partnership).permit(:user_id, :partner_id, :status)
    end

    def set_user
      @user = current_user
    end

    def set_partnership
      @partnership = Partnership.find(params[:id])
    end
end
