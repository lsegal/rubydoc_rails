module PathSaver
  extend ActiveSupport::Concern

  included do
    before_action :save_path
  end

  COOKIE_NAME = :defaultIndex

  def save_path
    return if turbo_frame_request?
    cookies.permanent[PathSaver::COOKIE_NAME] = controller_name
  end
end
