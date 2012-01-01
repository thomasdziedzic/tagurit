class TagFetcher
  class << self
    # tag fetchers get a list of urls
    # return a dictionary with {"<url>": ["<tags>"]}
    def git urls
      new_cache = {}

      urls.each do |url|
	raw_tags = `git ls-remote --tags #{url}`

	# cleanup tags by removing extra data before the tag name
	processed_tags = raw_tags.split("\n").map {|raw_tag| raw_tag.split("/")[-1]}

	# cleanup tags which end with ^{}
	processed_tags.reject! {|tag| tag[-3, 3] == "^{}"}

	new_cache[url] = processed_tags
      end

      new_cache
    end

    def svn urls
      new_cache = {}

      urls.each do |url|
	raw_tags = `svn ls #{url}`

	# only remove the following "/" from the tag directory
	processed_tags = raw_tags.split("\n").map {|raw_tag| raw_tag.split("/")[0]}

	new_cache[url] = processed_tags
      end

      new_cache
    end
  end
end
