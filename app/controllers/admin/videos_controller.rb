class Admin::VideosController < AdminsController
  before_filter :require_user

  def new
    @video = Video.new
  end

  def create
    @video = Video.create(video_params)
    category = params.require(:video).permit(:categories)
    @video.categories << Category.where(id: category[:categories])
    if @video.save
      flash[:success] = "You have successfully added the video '#{@video.title}'."
      redirect_to new_admin_video_path
    else
      flash[:error] = "You cannot add this video, check the errors."
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :small_cover, :large_cover, :video_url)
  end
end