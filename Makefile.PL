use ExtUtils::MakeMaker;

WriteMakefile (
	NAME		=> 'vshnu',
	VERSION		=> '1.0005',	# package version
					# also ../*.html, freshmeat?, pause?
	ABSTRACT	=> 'a visual shell supplement',
	AUTHOR		=> 'Steve Kinzler <kinzler@cs.indiana.edu>',
#	DATE		=> 'Nov 2000',
#	URL		=> 'http://www.cs.indiana.edu/hyplan/kinzler/vshnu/',
	EXE_FILES	=> ['vshnu'],
	PM		=> {'vshnucfg.pl' => '$(INST_LIBDIR)/vshnucfg.pl'},
	PREREQ_PM	=> {'Term::Screen'    => '1.00',
			    'Term::ANSIColor' => '1.03'},
	dist		=> {COMPRESS => 'gzip -9f', SUFFIX => '.gz',
			    POSTOP   => 'mv $(DISTVNAME)* ..'},
);

# 1.0000  07 Nov 2000	Initial public release
# 1.0001  15 Nov 2000	Color text pager defaults to `less -r` if PAGER=less
# 1.0002  05 Dec 2000	Added 'sleep 1' to backgrounded commands; *bz2 support
# 1.0003  13 Dec 2000	Version format x.y.z -> x.0y0z; s/.pm// in libperl
# 1.0004  25 Jan 2001	Added ReadLine package to ^V command output
# 1.0005  26 Jan 2001	Use most specific LS_COLORS match and "--color=yes"

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
