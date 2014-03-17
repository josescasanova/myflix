class ReviewsController < ApplicationController
before_filter :require_user

  def create
    @video = Video.find(video_id_params)
    review = @video.reviews.build(review_params.merge!(user: current_user))

    if review.save
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end

  private

  def video_id_params
    params.require(:video_id)
  end

  def review_params
    params.require(:review).permit(:rating, :description)
  end

end