class TagFetchError < StandardError
end

class TagFetcher
  def initialize urls
    @urls = urls
  end

  # process a list of urls
  def fetch
    new_cache = {}

    @urls.each do |url|
      # remove whitespace before and after the string to clean it up
      url.strip!

      begin
	raw_tags = fetch_tags url
      rescue TagFetchError
	puts "Failed to retrieve repo tags from : #{url}"
	new_cache[url] = [:failed]
      else
	new_cache[url] = clean_tags raw_tags
      end
    end

    # return a dictionary with {"<url>": ["<tags>"]}
    # set "<tags>" to :failed in case of failure to retrieve tags
    new_cache
  end

  private

  def fetch_tags url
    raise NotImplementedError.new "You need to implement fetch_tags yourself."
  end

  def clean_tags raw_tags
    raise NotImplementedError.new "You need to implement clean_tags yourself."
  end
end

class GitTagFetcher < TagFetcher
  private

  def fetch_tags url
    raw_tags = `git ls-remote --tags #{url}`
    raise TagFetchError unless $?.success?
    raw_tags
  end
  
  def clean_tags raw_tags
    # cleanup tags by removing extra data before the tag name
    processed_tags = raw_tags.split("\n").map {|raw_tag| raw_tag.split("/")[-1]}
    # cleanup tags which end with ^{}
    processed_tags.reject! {|tag| tag[-3, 3] == "^{}"}
    processed_tags
  end
end

class SvnTagFetcher < TagFetcher
  private

  def fetch_tags url
    raw_tags = `svn ls #{url}`
    raise TagFetchError unless $?.success?
    raw_tags
  end
  
  def clean_tags raw_tags
    # only remove the following "/" from the tag directory
    processed_tags = raw_tags.split("\n").map {|raw_tag| raw_tag.split("/")[0]}
    processed_tags
  end
end

class HgTagFetcher < TagFetcher
  def initialize urls, hg_path
    # create a ~/.tagurit/hg/ directory to hold mercurial repositories.
    # You can only fetch tags from a repository if they are local
    Dir.mkdir hg_path unless File.directory? hg_path

    @hg_path = hg_path

    super urls
  end

  private

  def fetch_tags url
    # extract the directory it will fetch into
    local_directory = url.split("/")[-1]
    local_path = File.join @hg_path, local_directory

    # if the directory doesn't exist, clone it first, otherwise pull upstream changes
    if File.directory? local_path
      `hg pull -u -R #{local_path} 2> /dev/null`
    else
      `hg clone #{url} #{local_path} 2> /dev/null`
    end
    raise TagFetchError unless $?.success?
    raw_tags = `hg tags -R #{local_path}`
    raw_tags
  end
  
  def clean_tags raw_tags
    processed_tags = raw_tags.split("\n").map {|raw_tag| raw_tag.split[0]}
    processed_tags
  end
end
