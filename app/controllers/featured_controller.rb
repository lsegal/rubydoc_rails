class FeaturedController < ApplicationController
  include PathSaver

  prepend_before_action do
    @title = "Featured Libraries"
    @collection = Rubydoc.config.libraries[:featured].map do |name, source|
      if source == "gem"
        Library.gem.find_by(name: name)
      elsif source == "featured"
        versions = FeaturedLibrary.versions_for(name)
        Library.new(name: name, source: :featured, versions: versions)
      end
    end.compact
  end

  def index
    render "shared/library_list"
  end
end
