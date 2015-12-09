class NewsController < ApplicationController
  def index
    @matches=Match.ended.order(starts_at: :desc).limit(5)
    @users=User.all.order(created_at: :desc).limit(5)
    @tweets=Twitterer.new.latestTweets()
  end
end
