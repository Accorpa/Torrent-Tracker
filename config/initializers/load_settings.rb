filename = Rails.root + "config/settings.yml"
raise "Missing config/settings.yml" unless File.exists?(filename)
yaml = YAML.load_file(filename)
TorrentTracker::Application.settings = ActiveSupport::HashWithIndifferentAccess.new(yaml)
