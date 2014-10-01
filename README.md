Mingle Attachment Link Fixer
============================

If you're like many Mingle users and you wanted to add link to an attachment, then you probably just right-clicked the attachment at the bottom of the card and pasted that into the link box.

Which is all fine and dandy, until you move Mingle servers, move from on-premise to Mingle SaaS, or recover your project from a data backup.  In this case, the attachment IDs will be different.  All the links will be broken!!

This script is designed to fix this problem.  If you have your export file with valid attachments inside, then this tool can go through your cards and magically restore your links. It will use the archaic (but correct and guaranteed not to break) syntax:

[[Your link text|#123/my-file.ext]]

What's that, you say?  That's wiki markup?  Well, yes, it is.  We chose to stick with the format our users were used to rather than invent a way to put that into HTML links.

Usage
-----

You'll need Ruby 2.0+

  > gem install mingle-link-fixer

  > mingle-link-fixer http://mingle.your.org/projects/iphone_app /path/containing/extracted/good/export

You can set the environment variables VERBOSE and DRY_RUN to true if you want more information or want to see what will happen when it runs, respectively.


Contributors / Bugs / &c.
-------------------------

Email mingle dot feedback at thoughtworks.com to get in touch with the development team.

Or open a pull request at github.

Snap CI build status:

[![Build Status](https://snap-ci.com/ThoughtWorksStudios/mingle-link-fixer/branch/master/build_image)](https://snap-ci.com/ThoughtWorksStudios/mingle-link-fixer/branch/master)
