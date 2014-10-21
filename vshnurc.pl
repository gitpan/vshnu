#!/usr/bin/perl

# .vshnurc - personal extra vshnu reconfiguration file
# Steve Kinzler, kinzler@cs.indiana.edu, Oct 00
# see website http://www.cs.indiana.edu/~kinzler/vshnu/
# http://www.cs.indiana.edu/~kinzler/home.html#unixcfg

# Many of the scripts and supporting external configurations used via this
# file are available at http://www.cs.indiana.edu/~kinzler/home.html.

# Names used only within this vshnurc are placed in the rc:: package.
# This file should be reloadable.

###############################################################################
## Change Log #################################################################

($rc::vname, $rc::version, $rc::require) = qw(vshnurc 1.0302 1.0302);
&addversions($rc::vname, $rc::version);

&err("loaded $rc::vname $rc::version requires $cfg::vname $rc::require",
     "($cfg::version)") if $rc::require != $cfg::version;

# 1.0000   7 Nov 2000	Initial public release
# 1.0002   4 Dec 2000	Add 'sleep 1' to /Z command
# 1.0003  13 Dec 2000	Version format x.y.z -> x.0y0z
# 1.0004  25 Jan 2001	Add ReadLine package to ^V command output
# 1.0005  26 Jan 2001	Append "=yes" to "--color"s
# 1.0006  27 Apr 2001	Improve Slashdot interface
# 1.0007  29 May 2001	Add "go perl:" option to G command
# 1.0008  05 Jul 2001	Add "go user:", "webdaily", etc options to G command
# 1.0009   1 Aug 2001	Add "go news:" option to G command
# 1.0010  20 Aug 2001	Update Slashdot interface; Add "hmrccal"; B -> GB
# 1.0011  29 Oct 2001	Add "go movie:" option to G command
# 1.0012  14 Feb 2002	Add "go book:" option to G command
# 1.0100  29 Mar 2002	Add mail, download and print menu to default do entry
# 1.0101   1 Apr 2002	Inherit directory action commands, use ifopt
# 1.0102  26 May 2002	Use "pushmime" instead of "mimeexplode"
# 1.0103  14 Jun 2002	Define $stty_cooked to fix 8-bit characters
# 1.0104   8 Aug 2002	Add P choose command for Palm downloads
# 1.0105  20 Aug 2002	Add "go soft:" option to G command
# 1.0106  18 Nov 2002	Add K command for simple "make"
# 1.0107  17 Dec 2002	Add "go image:" option to G command
# 1.0108   1 Jan 2003	Add "go prod:" option to G command
# 1.0109   3 Mar 2003	Add "go arc:" option to G command
# 1.0110   5 Mar 2003	Add _ choose command for filename whitespace -> _
# 1.0111   1 May 2003	Add browse+remove as edit for _comics_*.html files
# 1.0112  20 May 2003	Add H command for simple "dailyh"
# 1.0113  31 May 2003	Add ReadLine package version to ^V command output
# 1.0114  11 Jun 2003	Full versions support
# 1.0115  19 Jun 2003	Correct $optons reloadability
# 1.0116  27 Jun 2003	Update pilot-file and install-memo usage
# 1.0117   3 Sep 2003	Add "print tumble" option to .ps action menu
# 1.0118  18 May 2004	Revise mailp flags for newer versions
# 1.0119   3 Jun 2004	Add secure remove option to /D command
# 1.0120   4 Jun 2004	Remove special file action and /A (to vshnucfg)
# 1.0121   6 Jun 2004	Add "go city:" option to G command
# 1.0122  15 Sep 2004	Replace AskJeeves with A9 for "go ask:"
# 1.0123  22 Nov 2004	Add `txt2pdbdoc -d` action option for pdb files
# 1.0124  28 Nov 2004	Run ^Y on Y command run in ~/work
# 1.0125  18 Mar 2005	Add &rc::edtags and use for ^K command completions
# 1.0126  18 Mar 2005	Add text view as edit for .doc and .xls files
# 1.0127  11 Apr 2005	Make external reconfig dependent on tcsh/less presence
# 1.0128  14 Apr 2005	Delete pager[ar] config; No color reconfig if ! kinzler
# 1.0129  17 Apr 2005	Add &rccolorlong for getfacls and listacls
# 1.0200  29 Apr 2005	Version normalization
# 1.0201   6 May 2005	Add &hostr
# 1.0202  18 May 2005	Use &mapadd for typemap and keymap additions
# 1.0203   2 Jun 2005	Add "go info:" option to G command
# 1.0204   8 Jul 2005	Add "go yub:" option to G command
# 1.0205  24 Oct 2005	Undef $mailbox
# 1.0206   4 Dec 2005	Use &opton vs $optons to fix description bug
# 1.0207  28 Dec 2005	Add ^S command for copying chosen set
# 1.0208  28 Dec 2005	Use &mapget and &mapset for typemap changes
# 1.0209  28 Jan 2006	Use &ext and &Ext
# 1.0210   9 Feb 2006	Add "go video:" option to G command
# 1.0211  24 Mar 2006	Add @ command for atls; Use pager with z file actions
# 1.0212  30 Mar 2006	Add "go map:" and "go phone:" options to G command
# 1.0213   6 Apr 2006	Rename $cfg::pager* to $pager*
# 1.0214   8 Apr 2006	Use &run and special ext syntax
# 1.0215  23 Apr 2006	Move ^ command to W
# 1.0216  14 Feb 2007	Use/Add "$cfg::mailer -f" for mailbox actions
# 1.0217   6 Mar 2007	Add "go cpan:" option to G command
# 1.0218  15 Apr 2007	Use new screen zones in mousemaps
# 1.0219  12 Jun 2007	Enhance ^S command for rcp and X cut buffer usage
# 1.0220  13 Jun 2007	Use $cfg::xcb and &cfg::xpaste
# 1.0300   8 Jul 2007	Version normalization
# 1.0301  15 Jul 2007	Use enhanced &mapadd $before argument syntax
# 1.0302  21 Feb 2008	Add @rc::faves and 7 command

###############################################################################
## External reconfiguration ###################################################

$mailbox = undef;

`tcsh -f /dev/null`;
$shell = 'tcsh' unless $?;	# for use by &shell

$stty_cooked = '-istrip';	# corrections to `stty -raw echo`

sub hostr { local $_ = shift; s/^dkinzler\b.*/$ENV{KH}/is; $_ }

###############################################################################
## Color reconfiguration ######################################################

if ($color && getpwnam('kinzler')) {
	$co_decor = 'on_magenta' if $> && $user ne 'kinzler';
	delete $co_user{$user}, @co_user{'kinzler', 'oracle',  'uoracle'} =
					('blue',    'magenta', 'magenta');
}

###############################################################################
## Typemap reconfiguration ####################################################

&mapset('typemap_', '', 'run -s= $cfg::editor', 0);

$rc::Ext_mbox  = (grep(/mbox/, @typemap_do))[0];
$rc::Ext__mbox = '/(^|\/)_(|[^_].*\.)mbox$/';

&mapset('typemap_do', $rc::Ext_mbox,
	['run -s_ "$cfg::mailer -f"', 'run the mailer on this mbox file']);
&mapadd('typemap_',   $rc::Ext__mbox, &mapget('typemap_do', $rc::Ext_mbox));
&mapadd('typemap_do', $rc::Ext__mbox, &mapget('typemap_', ''), $rc::Ext_mbox);

&mapadd('typemap_', '/(^|\/)_comics_[^\/]*\.html?$/',
	 ['sh "$ENV{HTMLVIEW} < $_q"; remove $_; win',
	  'browse and remove this HTML file']);
&mapadd('typemap_', 'ext doc dot',
	 ['run -=p "doctxt"',  'view a text conversion of this Word file']);
&mapadd('typemap_', 'ext xls',
	 ['run -=p "xls2tsv"', 'view a text conversion of this Excel file']);

${&mapget('typemap_do', '-d _', 0)}[0] .= ', ifopt("C", "--color")';
&mapset('typemap_do', 'ext e?ps',
	[['run -x_W "ghostview -safer"',
	  'display this PostScript file',	   'vVgG',  'view'],
	 ['run -s_r "lpr", "-h"',
	  'print this PostScript file',		   'pPlL',  'print'],
	 ['run -sr "psduplex $_q | lpr -h"',
	  'print this PostScript file duplex',	   'dD',    'print duplex'],
	 ['run -sr "psduplex -tumble $_q | lpr -h"',
	  'print this PostScript file tumble',	   'tT',    'print tumble'],
	 ['run -sr "psnup -n 2 $_q | lpr -h"',
	  'print this PostScript file 2-up',	   '2rRnN', 'print 2-up'],
	 ['run -sr "psnup -n 2 $_q | psduplex | lpr -h"',
	  'print this PostScript file duplex 2-up', '4','print duplex 2-up']]);
&mapadd('typemap_do', 'Ext err',
	 ['run -s_ $cfg::editor, "-q"',
	  'quickfix edit based on this error file'], 'Ext fig');
&mapadd('typemap_do', 'ext html?',
	 ['run -s_w "$ENV{HTMLVIEW} <"',
	  'browse this HTML file'], 'ext iso');
&mapadd('typemap_do', 'ext pdb',
	[['run -=p "+palm; txt2pdbdoc -d"',
	  'read this Palm Doc file',	   'rRtT', 'read'],
	 ['run -=p "+palm; pilot-file -d"',
	  'view a dump of this Palm file', 'vVfF', 'view'],
	 ['run -_R "+palm; exec pilot-xfer -i"',
	  'download this file to a Palm',  'dDxX', 'download']], '>Ext o');
&mapadd('typemap_do', 'ext prc pqa',
	[@{&mapget('typemap_do', 'ext pdb')}[0, 1]], '>Ext o');
&mapadd('typemap_do', 'Ext url?',
	 ['run -s_w "xrshio - webrowse -mw <"',
	  'browse this URL file marked up'], 'Ext uu');
${&mapget('typemap_do', '/[Mm]akefile/')}[0] =~ s/"make /"mak /;
${&mapget('typemap_do', 'Ext Z'	       )}[0] =~ s/P/p/;
${&mapget('typemap_do', 'Ext bz2'      )}[0] =~ s/P/p/;
${&mapget('typemap_do', 'Ext g?z'      )}[0] =~ s/P/p/;
&mapset('typemap_do', '',
	[['run -s= $pager',
	  'view this file',		      'vV',   'view'],
	 ['run -s_ "$cfg::mailer -f"',
	  'run the mailer on this mailbox',   'mM',   'view mailbox'],
	 ['run -s_R "sendfile"',
	  'mail this message file',	      'sS',   'send mail'],
	 [q/run -=R "+palm; install-memo -c '1) To Do'"/,
	  'download this memo to a Palm',     'iI',   'download memo'],
	 ['run -s=R "enscript", "-Gh"',
	  'print this text file',	      'pl',   'print'],
	 ['run -sR "enscript -Gh -p- -- $_q | psduplex | lpr -h"',
	  'print this text file duplex',      'd',    'print duplex'],
	 ['run -s=R "enscript", "-2rGh"',
	  'print this text file 2-up',	      '2rn',  'print 2-up'],
	 ['run -sR "enscript -2rGh -p- -- $_q | psduplex | lpr -h"',
	  'print this text file duplex 2-up', '4',    'print duplex 2-up'],
	 ['run -s=R "mailp", "-from", "-noburstpage"',
	  'print this mail file',	      'PL',   'print mail'],
	 ['run -s=R "mailp", "-from", "-landscape", "-noburstpage"',
	  'print this mail file 2-up',	      'RN',   'print mail 2-up']]);

###############################################################################
## Main keymap reconfiguration ################################################

$cfg::quemarkmsg = '';

@rc::ring = ('cd "/l/picons/ftp/incoming"; win',
	     ($ENV{'HOST'} !~ /^moose/i) ?  'cd "~/tmp"; win' :
	       'cd("~oracle/post") ? longls("-win", 1) : win',
	     'cd "~/work"; win');

@rc::faves = ('/l/web/hra', '/l/web/webhra/arc', '/l/web/arc',
	      '/l/hmrc', "/l/hmrc/$ENV{'USER'}");

&mapadd('keymap_', "\cK",
	 ['setcomplete \&rc::edtags;'
	  . ' run "-s/", $cfg::editor, "-t", get "Tag:"',
	  'edit in the file for the given tag'], "\cL");
$keymap_{"\cL"}[0] = 'point "-\$"; winch';
unshift(@{$keymap_{"\cQ"}},
	 ['do $vshnurc; err $@; win', 'reload just the personal rc file '
	  . '($vshnurc)', "rR\cR", 'load $vshnurc'])
		unless $keymap_{"\cQ"}[0][2] =~ /r/i;
&mapadd('keymap_', "\cS",	# warning, scp not robust wrt quoting & no -i
	[['run -ru "gnu cp -axi --", quote(@choose), "."',
	  'copy the chosen set to the current directory',
	  '.', 'cp chosen .'],
	 ['run -r "$ENV{RCPCMD} -r --", quote(split(/\n/, cfg::xpaste)), "."',
	  'remote copy X cut buffer $cfg::xcb lines to the current directory',
	  'x', 'rcp Xcutbuf$cfg::xcb .'],
	 ['run -ru "$ENV{RCPCMD} -r --", quote(@choose, cfg::xpaste)',
	  'remote copy the chosen set to X cut buffer $cfg::xcb',
	  'X', 'rcp chosen Xcutbuf$cfg::xcb']], "\cT");
&mapadd('keymap_', ",",
	 ['evalnext \@rc::ring', 'cycle to monitored directories'], "-");
&mapadd('keymap_', "7",
	 ['altls \@rc::faves, "Favorites"; win',
	  'switch to/from the favorites display'], "8");
&mapadd('keymap_', "@",
	 ['run -sp "atls"', 'view the scheduled at(1) jobs'], "B");
&mapadd('keymap_', "A",
	 ['longls "-win", "getfacls --"',
	  'long list files with their POSIX ACL info'], "B");
&mapadd('keymap_', "C",
	 ['longls "-win", "listacls"',
	  'long list files with their AFS ACL info'], ">B");
&mapadd('keymap_', "G",
	[['run getcmd "go"',
	  'browse the URL guessed from the given piece(s)',
	  'gG',   'url pieces'],
	 ['run -s "go", "url:" . gets "Go URL:"',
	  'browse the given URL',
	  'uUkK', 'url (including Netscape Internet Keywords)'],
	 ['run -s "go", "info:" . gets "Go Info URL:"',
	  'browse the information about the given URL',
	  'iI',   'url info (Google Info)'],
	 ['run -s "go", "arc:" . gets "Go Archive URL:"',
	  'browse historical versions of the given URL',
	  'vV',   'url versions (Wayback)'],
	 ['run -s "grepbm", "-b", "-i", "--", gets "Go Regexp:"',
	  'browse the matched browser bookmarks',
	  'bB',   'bookmarks'],
	 ['run -s "go", "yub:" . gets "Go YubNub:"',
	  'browse the results for the given yubnub command',
	  'yY',   'yubnub'],
	 ['run -s "go", "search:" . gets "Go Search:"',
	  'browse the results for the given web search query',
	  'sS',   'search (Google)'],
	 ['run -s "go", "image:" . gets "Go Image:"',
	  'browse the results for the given web image search query',
	  '@',    'image (Google Images)'],
	 ['run -s "go", "video:" . gets "Go Video:"',
	  'browse the results for the given web video search query',
	  '%',    'video (Google Video)'],
	 ['run -s "go", "map:" . gets "Go Map:"',
	  'browse the results for the given map directions query',
	  '^',    'map (Google Maps)'],
	 ['run -s "go", "news:" . gets "Go News:"',
	  'browse the results for the given usenet search query',
	  'nN',   'news (Google Groups)'],
	 ['run -s "go", "ask:" . gets "Go Ask:"',
	  'browse the matches for the given question',
	  'aA',   'ask (Ask)'],
	 ['run -s "go", "topic:" . gets "Go Topic:"',
	  'browse the matches for the given topic',
	  'tT',   'topic (Yahoo)'],
	 ['run -s "go", "encyc:" . gets "Go Encyclopedia:"',
	  'browse the results for the given encyclopedia query',
	  'eE',   'encyclopedia (Wikipedia)'],
	 ['run -s "go", "word:" . gets "Go Word:"',
	  'browse the results for the given dictionary query',
	  'wW',   'word (Dictionary)'],
	 ['run -s "go", "perl:" . gets "Go Perl:"',
	  'browse the results for the given perl documentation query',
	  'p',    'perl (Perldoc)'],
	 ['run -s "go", "cpan:" . gets "Go CPAN:"',
	  'browse the results for the given CPAN module query',
	  'P',    'cpan'],
	 ['run -s "go", "user:" . gets "Go User:"',
	  'browse the results for the given user directory query',
	  'hH',   'user (U-M Directory)'],
	 ['run -s "go", "phone:" . gets "Go Phonebook:"',
	  'browse the results for the given phonebook query',
	  '#',    'phone (Google PhoneBook)'],
	 ['run -s "go", "city:" . gets "Go City:"',
	  'browse the results for the given city map query',
	  'c',    'city (City-Data)'],
	 ['run -s "go", "book:" . gets "Go Book:"',
	  'browse the results for the given bookstore query',
	  'zZ',   'book (Amazon)'],
	 ['run -s "go", "movie:" . gets "Go Movie:"',
	  'browse the results for the given movie database query',
	  'mM',   'movie (IMDb)'],
	 ['run -s "go", "soft:" . gets "Go Software:"',
	  'browse the results for the given software archive query',
	  'xX',   'software (Freshmeat)'],
	 ['run -s "go", "prod:" . gets "Go Product:"',
	  'browse the results for the given product search query',
	  '$',   'product (Froogle)'],
	 ['run -s "webrowse", "-w", getfile("Go File (.):") || $cwd',
	  'browse the given file or directory (default current directory)',
	  'fF',   'file (default current directory)'],
	 ['run -s "slashdot"', 'browse the Slashdot website',
	  '/?.'],
	 ['run -s "hmrccal"', 'browse the HMRC calendar',
	  'C'],
	 ['run -s "webdaily", "-v"', 'browse my daily web pages',
	  'Dd']], ">F");
&mapadd('keymap_', "H",
	 ['run -sr "dailyh"', 'run `dailyh`'], ">G");
&mapadd('keymap_', "J",
	[['run -sp "snaps -u"',
	  "list the user's current processes",	    'ujJ', 'user'],
	 ['run -sp "snaps -s -l"',
	  'list all system processes',		    's',   'system'],
	 ['run -sp "pstree -alp $user"',
	  "tree list the user's current processes", 'UtT', 'user tree'],
	 ['run -sp "pstree -alp"',
	  'tree list all system processes',	    'S',   'system tree']],
	">H");
&mapadd('keymap_', "K",
	 ['run -sr "make"', 'run `make`'], ">J");
$keymap_{"M"}[0] =~ s/"make"/"mak"/;
#&mapadd('keymap_', "N",
#	 ['run -s "nn"', 'run `nn`'], ">M");
&mapadd('keymap_', "W",
	 ['cd($> && $user ne "kinzler" ? "~$user" : "~/work");'
	  . ' point "-\$"; win',
	  "cd to the user's working directory"], "X");
$keymap_{"Y"}[0] .= '; $cwd eq untilde("~/work") && msg filecount';

###############################################################################
## "Choose" keymap reconfiguration ############################################

&mapadd('keymap_choose', "<",
	 ['run -s+ruk "pushmime"',
	  'explode the chosen mail messages/folders into directories'], ">;");
$keymap_choose{"D"}    =
	[['run -#buk "rm -r"',
	  'recursively remove the chosen files/directories (background)',
	  'dDrR', 'regular recursive remove'],
	 ['run -#buk "srm -r"', 'securely,'
	  . ' recursively remove the chosen files/directories (background)',
	  'sS',   'secure recursive remove']];
$keymap_choose{"E"}[0] = 'run -s#uk $cfg::editor';
&mapadd('keymap_choose', "J",
	 ['run -sruk "push", "--", @choose, getfile "Directory:"',
	  'push the chosen files into the given directory'], ">I");
&mapadd('keymap_choose', "K",
	 ['run -s#ruk "pop"', 'pop files out of the chosen directories'],">J");
&mapadd('keymap_choose', "P",
	 ['run -+Cuk "+palm; exec pilot-xfer -i"',
	  'download the chosen files to a Palm'], "R");
&mapadd('keymap_choose', "Z",
	 ['run -#buk "z"', '(un)tar and (de)feather the chosen files'
			   . ' and directories (background)'], ">R");
&mapadd('keymap_choose', "_",
	 ['run -+uk "_"', 'rename the chosen files without whitespace'], "`");

###############################################################################
## "Options" keymap reconfiguration ###########################################

#&opton('s');

###############################################################################
## Main mousemap reconfiguration ##############################################

&mapset('mousemap_', 'user',
	[[@{$keymap_{"~"}}, &mev2c('1u')],
	 [@{$keymap_{"W"}}, &mev2c('3u')],
	 [@{$keymap_{","}}, &mev2c('Wd')],
	 [@{$keymap_{","}}, &mev2c('Wu')]]);

###############################################################################
## Subroutines ################################################################

sub rccolorlong {
	local $_ = join('', @_);
	my $rwx = '[-r][-w][-x]';
	s/\b(?:(d)(:))?([ugmo]):(?:(\w*)(:))?($rwx)(?:(#)($rwx))?/
		&color($1, $co_sbits)			 . $2  .
		&color($3, $co_ftype)			 . ':' .
		&color($4, $co_user{$4} || $co_user{''}) . $5  .
		&color($6, $co_perms)			 . $7  .
		&color($8, $co_myper)/ge if $long =~ /^\s*getfacls\b/;
	s/([^\\\s]+) (r?l?i?d?w?k?a?)(, |\\|$)/
		&color($1, $co_user{$1} || $co_user{''}) . ' ' .
		&color($2, $co_perms)			 . $3
				     /ge if $long =~ /^\s*listacls\b/;
	$_;
}

sub rc::edtags {
	my %tags = ();
	foreach my $tags ('tags', 'etc/tags', "$ENV{HOME}/etc/tags") {
		next unless open(TAGS, $tags);
		while (<TAGS>) {
			next if /^!_TAG_/;
			chomp; s/\t.*//; $tags{$_}++;
		}
		close TAGS;
	}
	sort keys %tags;
}

1;
