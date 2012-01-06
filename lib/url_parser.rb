class URLParser
  def URLParser.parse content
    urls = {git: [], svn: [], hg: []}
    repo_state = :git

    content.split("\n").each do |line|
      # change the repo state
      # all urls following this will be labeled with this state
      if line.match /^#~(git|svn|hg)/
	repo_state = $1.to_sym 
	next
      end

      # skip comments
      next if line.match /^#/

      # skip empty lines
      next if line.match /^\s*$/

      # everything else is considered a url
      # remove whitespace before and after the string to clean it up
      urls[repo_state] << line.strip
    end

    urls
  end
end
