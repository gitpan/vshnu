use ExtUtils::MakeMaker;

WriteMakefile (
	NAME		=> 'vshnu',
	VERSION		=> '1.0115',	# package version; also ../*.html,
					# mailing list?, freshmeat?, pause?
	ABSTRACT	=> 'a visual shell supplement',
	AUTHOR		=> 'Steve Kinzler <kinzler@cs.indiana.edu>',
#	DATE		=> 'Nov 2000',
#	URL		=> 'http://www.cs.indiana.edu/~kinzler/vshnu/',
	EXE_FILES	=> ['vshnu'],
	PM		=> {'vshnucfg.pl' => '$(INST_LIBDIR)/vshnucfg.pl'},
	PREREQ_PM	=> {'Term::Screen'    => '0',
			    'Term::ANSIColor' => '0'},
	dist		=> {COMPRESS => 'gzip -9f', SUFFIX => '.gz',
			    POSTOP   => 'mv $(DISTVNAME)* ..'},
);

# 1.0000  07 Nov 2000	Initial public release
# 1.0001  15 Nov 2000	Color text pager defaults to `less -r` if PAGER=less
# 1.0002  05 Dec 2000	Added 'sleep 1' to backgrounded commands; *bz2 support
# 1.0003  13 Dec 2000	Version format x.y.z -> x.0y0z; s/.pm// in libperl
# 1.0004  25 Jan 2001	Added ReadLine package to ^V command output
# 1.0005  26 Jan 2001	Use most specific LS_COLORS match and "--color=yes"
# 1.0006  27 Apr 2001	Improved Slashdot interface in vshnurc
# 1.0007  29 May 2001	Recognize .\d\w exts as man pages; "go perl:" support
# 1.0008  06 Jun 2001	Added `rpm -Fhv` freshen option for rpm files
# 1.0009  15 Jun 2001	Added loading of .vshnu* files via typemap
# 1.0010  02 Jul 2001	Improved function key support and definitions
# 1.0011  19 Oct 2001	Added `md5sum` long listing
# 1.0012  01 Feb 2002	Added viewing actions for SSL files
# 1.0013  27 Mar 2002	Use VSHNUTMP to enable tmp files and specify location
# 1.0100  29 Mar 2002	Use VSHNUCWD and VSHNUENV; Added bash integration
# 1.0101  01 Apr 2002	Enhanced directory actions; Added ifopt and unlessopt
# 1.0102  03 Apr 2002	Fixed bug in ifopt and unlessopt for older perls
# 1.0103  18 Apr 2002	Added ^_ command for variable listing
# 1.0105  14 Jun 2002	Report $! from &sh and &shell; Added $stty_{cooked,raw}
# 1.0106  25 Nov 2002	Support non-ANSI non-color terminals
# 1.0107  23 Jan 2003	Fixed readline for prompts w/ non-visible characters
# 1.0108  04 Jun 2003	Include ~/perl in @INC; Use HOSTNAME; Support .tnef
# 1.0111  18 Jun 2003	Fixes for signals and readlines; Full versions support
# 1.0115   3 Jul 2003	Use Sys::Hostname; Added insert-vshnu-chosen for rl

sub MY::postamble { q~
import:
	$(CP) $(HOME)/binp/vshnu   .
	$(CP) $(HOME)/etc/vshnucfg vshnucfg.pl
	$(CP) $(HOME)/etc/vshnurc  vshnurc.pl
	@$(MKPATH)				  libperl/Term
	$(CP) $(HOME)/libp/perl/Term/ANSIColor.pm libperl/Term/ANSIColor
	$(CP) $(HOME)/libp/perl/Term/Screen.pm	  libperl/Term/Screen
	@$(MKPATH)				tcsh
	$(CP) $(HOME)/binp/penv			tcsh
	$(PERL) -pi -e '$$. == 2 && s:local/::'	tcsh/penv
	$(CP) $(HOME)/etc/lo $(HOME)/etc/precmd	tcsh
	$(PERL) -pi -e 's,^#!\s*/\S+/perl\S*(\s|$$),#!/usr/bin/perl$$1,' \
		`cat MANIFEST`
~; }
