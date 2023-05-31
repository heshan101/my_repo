`dotsync2` is a service that backs up and synchronizes your configuration files
between Devservers, On Demand, and Devspaces.  The files that `dotsync2`
manages are a subset of the files in your home directory (/home/<username>),
and you can edit your "filelist" to control which files DotSync manages.

#######################################################################
             IMPORTANT info you should know about dotsync2
#######################################################################

* `dotsync2` only manages files that are on your personal paths list.  Many
  common configuration files are covered by default.  You can modify
  your paths list using 'dotsync2 paths edit'.

* Files which are not listed will be ignored by `dotsync2` and thus changes
  to them will not be synchronized to other devservers.

See also:

* Basic commands / usage:   https://fburl.com/dotsync2usage
* FAQ / troubleshooting:    https://fburl.com/dotsync2faq
* feedback group:           https://fb.workplace.com/groups/dotsync2/
