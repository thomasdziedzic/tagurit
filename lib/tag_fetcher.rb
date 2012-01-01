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

    def hg urls, hg_path
      new_cache = {}

      # create a ~/.tagurit/hg/ directory to hold mercurial repositories.
      # You can only fetch tags from a repository if they are local
      Dir.mkdir hg_path unless File.directory? hg_path

      urls.each do |url|
	# remove whitespace before and after the string to clean it up
	url.strip!

	# extract the directory it will fetch into
	local_directory = url.split("/")[-1]
	local_path = File.join hg_path, local_directory
	
	# if the directory doesn't exist, clone it first, otherwise pull upstream changes
	if File.directory? local_path
	  `hg pull -u -R #{local_path} 2> /dev/null`
	else
	  `hg clone #{url} #{local_path} 2> /dev/null`
	end

	raw_tags = `hg tags -R #{local_path}`

	# only remove the following "/" from the tag directory
	processed_tags = raw_tags.split("\n").map {|raw_tag| raw_tag.split[0]}

	new_cache[url] = processed_tags
      end

      new_cache
    end
  end
end
