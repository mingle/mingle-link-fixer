Mingle Attachment Link Fixer
============================

If you're like many [Mingle](http://getmingle.io) users and you wanted to add link to an attachment, then you probably just right-clicked the attachment at the bottom of the card and pasted that into the link box.

Which is all fine and dandy, until you move Mingle servers, move from on-premise to Mingle SaaS, or recover your project from a data backup.  In this case, the attachment IDs will be different.  All the links will be broken!!

This script is designed to fix this problem.  If you have your export file with valid attachments inside, then this tool can go through your cards and magically restore your links. It will use the archaic (but correct and guaranteed not to break) syntax:

[[Your link text|#123/my-file.ext]]

What's that, you say?  That's wiki markup?  Well, yes, it is.  We chose to stick with the format our users were used to rather than invent a way to put that into HTML links.

Prerequisites
-------------

You'll need Ruby 2.0+

You'll also need the .mingle export file you used to move (which has the valid mappings from attachment ID to attachment filename.)

You need to extract this export in a known location (to pass in as the second param below). Unfortunately, extracting has two gotchas:

  * A .mingle file is a zip file but it uses the poorly supported [zip64](https://en.wikipedia.org/wiki/Zip_(file_format)#ZIP64) extension to allow it to exceed 4GB.  The easiest way to extract it is to use p7zip.
  * It is an "archive bomb" which means it extracts all its contents into your current directory, polluting it.  Make sure to create an empty new folder before extracting.


Steps
-----

  > gem install mingle-link-fixer

  > mingle-link-fixer http://mingle.your.org/projects/iphone_app /path/containing/extracted/good/export

You can set the environment variables VERBOSE and DRY_RUN to true if you want more information or want to see what will happen when it runs, respectively.


Contributors / Bugs / &c.
-------------------------

Please open a GitHub issue and we'll get in touch.

Snap CI build status:

[![Build Status](https://snap-ci.com/ThoughtWorksStudios/mingle-link-fixer/branch/master/build_image)](https://snap-ci.com/ThoughtWorksStudios/mingle-link-fixer/branch/master)
