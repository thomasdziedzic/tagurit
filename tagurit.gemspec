Gem::Specification.new do |s|
  s.name        = "tagurit"
  s.version     = "0.3"
  s.summary     = "Version control system, tag watcher."
  s.description = "Watches multiple types of VCS repositories for new tags."
  s.authors     = ["Thomas Dziedzic"]
  s.email       = "gostrc@gmail.com"
  s.files       = [
		   "lib/url_parser.rb",
		   "lib/tag_fetcher.rb",
		  ]
  s.executables << "tagurit"
  s.homepage    = "https://github.com/gostrc/tagurit"
end
