#!/usr/bin/env perl -w

# From cpantester@www.arens.nl Fri Jul  4 13:32:23 2003
# Date: Fri, 4 Jul 2003 19:32:03 +0200
# Message-Id: <200307041732.h64HW3v21988@www.arens.nl>
# Cc: KINZLER@cpan.org
# Subject: UNKNOWN vshnu-1.0115 i586-linux 2.2.16c32_iii
# To: cpan-testers@perl.org
# From: cpantester@calaquendi.net (Jeroen Latour)
# 
# This distribution has been tested as part of the cpan-testers
# effort to test as many new uploads to CPAN as possible.  See
# http://testers.cpan.org/
# 
# Please cc any replies to cpan-testers@perl.org to keep other test
# volunteers informed and to prevent any duplicate effort.
# 
# ----
# This is an error report generated automatically by CPANPLUS,
# version 0.042.
# 
# Below is the error stack during 'make test':
# 
# No tests defined for vshnu extension.
# 
# Additional comments:
# 
# Hello, Steve Kinzler! Thanks for uploading your works to CPAN.
# 
# Would it be too much to ask for a simple test script in the next release,
# so people can verify which platforms can successfully install them,
# as well as avoid regression bugs?
# 
# A simple 't/use.t' that says:
# 
# #!/usr/bin/env perl -w
use strict;
use Test;
BEGIN { plan tests => 1 }
# 
# use Your::Module::Here; ok(1);
ok(1);		# not much to test since vshnu isn't a module ...
exit;
# __END__
# 
# would be appreciated.  If you are interested in making a more robust
# test suite, please see the Test::Simple, Test::More and Test::Tutorial
# manpages at <http://search.cpan.org/search?dist=Test-Simple>.
# 
# Thanks! :-)
# 
# ******************************** NOTE ********************************
# The comments above are created mechanically, possibly without manual
# checking by the sender.  Also, because many people performs automatic
# tests on CPAN, chances are that you will receive identical messages
# about the same problem.
# 
# If you believe that the message is mistaken, please reply to the first
# one with correction and/or additional informations, and do not take
# it personally.  We appreciate your patience. :)
# **********************************************************************
