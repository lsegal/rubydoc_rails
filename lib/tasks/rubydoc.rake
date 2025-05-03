namespace :rubydoc do
  namespace :docs do
    desc "Builds documentation for LibraryVersion(NAME, VERSION, SOURCE) in an isolated Docker container"
    task generate: :environment do
      raise "Missing library version (NAME=gemname VERSION=targetversion SOURCE=source)" unless ENV["NAME"] && ENV["VERSION"] && ENV["SOURCE"]
      ENV["SOURCE"] = "remote_gem" if ENV["SOURCE"] == "gem"
      library_version = YARD::Server::LibraryVersion.new(ENV["NAME"], ENV["VERSION"], nil, ENV["SOURCE"].to_sym)
      GenerateDocsJob.perform_now(library_version)
    end
  end

  namespace :gems do
    desc "Update remote gems list"
    task update: :environment do
      QueueUpdateRemoteGemsListJob.perform_now
    end
  end

  namespace :stdlib do
    desc "Installs a standard library VERSION=targetversion"
    task install: :environment do
      raise "Missing Ruby version (VERSION=targetversion)" unless ENV["VERSION"]
      StdlibInstaller.new(ENV["VERSION"]).install
    end
  end
end
