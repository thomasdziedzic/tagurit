#!/usr/bin/env ruby

require "set"
require "yaml"

# files used:
#   ~/.tagurit
#   ~/.tagurit/cache - serialized ruby object to represent a cache of previous tags
#   ~/.tagurit/urls - list of git repository urls to watch for new tags
base_dir = File.join Dir.home, ".tagurit"
urls_path = File.join base_dir, "urls"
cache_path = File.join base_dir, "cache"

# if ~/.tagurit does not exist create it, for convenience
Dir.mkdir base_dir unless File.directory? base_dir

# read the urls
git_urls = []
begin
  File.open(urls_path).each {|line| git_urls.push line.chomp unless line.match(/^#/)}
rescue Errno::ENOENT
  puts "you must create %s" % urls_path
  puts "each line must be a url"
  puts "lines beginning with '#' will be counted as comments"
  exit false
end

# cache is in the format {'<url>': '<list of tags>'}
begin
  old_cache = YAML.load_file cache_path
rescue Errno::ENOENT
  old_cache = {}
end

# create a new cache
new_cache = {}
git_urls.each do |git_url|
  # fetch tags
  raw_tags = `git ls-remote --tags #{git_url}`
  # cleanup tags by removing extra data before the tag name
  processed_tags = raw_tags.split("\n").map {|raw_tag| raw_tag.split("/")[-1]}
  # cleanup tags which end with ^{}
  processed_tags.reject! {|tag| tag[-3, 3] == "^{}"}
  # set the url to point to the list of tags available
  new_cache[git_url] = processed_tags
end

# compare the new with the old
new_cache.each do |url, tags|
  # check if the url exists in the old cache
  unless old_cache.has_key? url
    puts "new git repo: #{url}"
    next
  end

  # check if the tag exists in the old cache
  new_tags = Set.new new_cache[url]
  old_tags = Set.new old_cache[url]

  diff_tags = new_tags - old_tags

  unless diff_tags.empty?
    puts "new tags for #{url}"
    puts diff_tags.to_a.join("\n")
  end
end

# save the new cache as the old cache
File.open(cache_path, "w") {|out| YAML.dump new_cache, out}
