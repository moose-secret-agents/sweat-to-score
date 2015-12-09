class NewsController < ApplicationController
  def index
    @matches=Match.all.order(starts_at: :desc).limit(5)
    @users=User.all.order(created_at: :desc).limit(5)
    #@matches=Match.ended.order(starts_at: :desc).limit(5)
  end
end
