Dependencies
============
* ruby
* git (optional)
* svn (optional)
* hg (optional)

The above are only required if you watch for new tags in those types of repositories.

Warning, due to hg's limitations, tagurit will have to keep a copy of all hg repositories in a local folder.

Installing
==========
```tagurit``` is available as a gem at https://rubygems.org/gems/tagurit

To install it using gem, issue the following command: ```gem install tagurit```

Setup
=====
You need to create a file **~/.tagurit/urls** which contains a list of urls to watch for new tags.

Whenever tagurit sees a new url, it will only print the name of the repo instead of printing out all the tags.
Subsequent runs of ```tagurit``` will either print nothing in case the repo hasn't created any tags, or it will print the repo along with any new tags it hasn't seen from the last time it ran.

Files
=====
**~/.tagurit/urls** - repos to watch for new tags

**~/.tagurit/cache** - a serialized ruby object containing previously seen tags for known repos.

**~/.tagurit/hg** - folder where local copies of hg clones are stored, since you can only query with hg tags locally.

Format for **~/.tagurit/urls**
==============================

Lines beginning with ```#``` are ignored.

Lines beginning with ```#~``` followed by either ```git```, ```svn```, or ```hg``` tell the parser that all urls that follow should be treated as the type specified. Default is ``#~git``.

Empty lines are ignored.

Every other line is treated as a url to a repository to watch for new tags.

Example **~/.tagurit/urls**
===========================
```
# this is a comment
git://github.com/gostrc/tagurit.git

# the next line starts the svn repos section
#~svn
http://svn.apache.org/repos/asf/subversion/tags/

#~hg
https://bitbucket.org/bobf/bpython/
```
