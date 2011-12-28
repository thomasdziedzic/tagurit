Dependencies
============
* ruby
* git

Setup
=====
You need to create a file **~/.tagurit/urls** which contains a list of urls to watch for new tags.
The format for this file is each line is treated as a url unless it begins with ```#``` marking that line as a comment.
Whenever tagurit sees a new url, it will only print the name of the repo instead of printing out all the tags. Subsequent runs of ```tagurit``` will either print nothing in case the repo hasn't created any tags, or it will print the repo along with any new tags it hasn't seen from the last time it ran.

Files
=====
**~/.tagurit/urls** - repos to watch for new tags
**~/.tagurit/cache** - a serialized ruby object containing previously seen tags for known repos.
