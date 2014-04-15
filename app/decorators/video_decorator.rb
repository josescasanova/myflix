class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    # object.rating.first.present? ? "#{object.rating}/5.0" : "N/A"
    # fix this
  end
end