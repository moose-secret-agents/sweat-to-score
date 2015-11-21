class PartnershipsController < ApplicationController
  before_action :set_user, only: [:index, :new, :create]

  # def index
  #   @partnerships = Partnership.all
  # end

  def new
    @partnership = @user.partnerships.build
  end

  def create
    @partnership = @user.partnerships.create(partnership_params)

    if @partnership.save
      redirect_to @partnership, notice: 'Partnership request has been sent'
    else
      render :new
    end
  end

  def user_index
    @partnerships = current_user.partnerships
    render :index
  end


  private
    def partnership_params
      params.require(:partnership).permit(:user_id, :partner_id, :status)
    end

    def set_user
      @user = current_user
    end
end
