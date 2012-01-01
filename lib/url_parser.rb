class URLParser
  def URLParser.parse content
    urls = {git: [], svn: []}
    repo_state = :git

    content.split("\n").each do |line|
      # change the repo state
      # all urls following this will be labeled with this state
      if line.match /^#~(git|svn)/
	repo_state = $1.to_sym 
	next
      end

      # skip comments
      next if line.match /^#/

      # skip empty lines
      next if line.match /^\s*$/

      # everything else is considered a url
      urls[repo_state] << line.chomp
    end

    urls
  end
end
