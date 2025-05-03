class GithubController < ApplicationController
  include PathSaver
  include AlphaIndexable
  include Searchable
  include Pageable

  layout "modal", only: [ :add_project ]

  prepend_before_action do
    @title = "GitHub Projects"
    @collection = Library.github.all
  end

  prepend_before_action :last_path_redirect, if: -> { request.path == "/" && request.referrer.blank? && cookies[PathSaver::COOKIE_NAME].present? }

  def index
    render "shared/library_list"
  end

  def add_project
    @project = GithubProject.new
  end

  def create
    @project = GithubProject.new(params.require(:github_project).permit(%i[url commit]))
    if @project.validate
      GithubCheckoutJob.perform_now(owner: @project.owner, project: @project.name, commit: @project.commit)
      redirect_to yard_github_path(@project.owner, @project.name, @project.commit)
    else
      render :add_project, layout: "modal"
    end
  end

  private

  def default_alpha_index
    nil
  end

  def set_alpha_index_collection
    @collection = @collection.reorder(updated_at: :desc).limit(10) if @letter.blank?
    super
  end

  def last_path_redirect
    last_path = cookies.permanent[PathSaver::COOKIE_NAME]
    redirect_to controller: last_path, action: :index if last_path != controller_name
  end
end
