#!/usr/bin/perl

# .vshnurc - personal extra vshnu reconfiguration file
# Steve Kinzler, kinzler@cs.indiana.edu, Oct 00
# see website http://www.cs.indiana.edu/~kinzler/vshnu/
# http://www.cs.indiana.edu/~kinzler/home.html#unixcfg

# Many of the scripts and supporting external configurations used via this
# file are available at http://www.cs.indiana.edu/~kinzler/home.html.

# Names used only within this .vshnurc are placed in the rc:: package.
# This file should be reloadable.

###############################################################################
## Change Log #################################################################

($rc::vname, $rc::version, $rc::require) = qw(.vshnurc 1.0200 1.0200);
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

###############################################################################
## External reconfiguration ###################################################

`tcsh -f /dev/null`;
$shell = 'tcsh' unless $?;		# for use by &shell

$stty_cooked = '-istrip';		# corrections to `stty -raw echo`

###############################################################################
## Color reconfiguration ######################################################

if ($color && getpwnam('kinzler')) {
	$co_decor = 'on_magenta' if $> && $user ne 'kinzler';
	delete $co_user{$user}, @co_user{'kinzler', 'oracle',  'uoracle'} =
					('blue',    'magenta', 'magenta');
}

###############################################################################
## Typemap reconfiguration ####################################################

$typemap_{''}[0] = 'sh $cfg::editor, "--", $_; winch';

$typemap_{  '/(^|\/)_[^_].*\.mbox$/'} = $typemap_do{'/(^|\/|\.)mbox$/'};
$typemap_do{'/(^|\/)_[^_].*\.mbox$/'} = $typemap_{''};

$typemap_{'/(^|\/)_comics_[^\/]*\.html?$/'} =
	 ['sh "$ENV{HTMLVIEW} < $_q"; remove $_; win',
	  'browse and remove this HTML file'];
$typemap_{'/\.doc$/i'} = ['shell "doctxt -- $_q'  . $cfg::page,
			  'view a text conversion of this Word file'];
$typemap_{'/\.xls$/i'} = ['shell "xls2tsv -- $_q' . $cfg::page,
			  'view a text conversion of this Excel file'];

$rc::retrm = '; ret("Remove?") && remove $_; winch';
${$typemap_do{'-d _'}[0]}[0] =~ s/"--/ifopt("C", "--color"), "--/;
$typemap_do{'/\.e?ps$/i'} =
	[['xsh "ghostview -safer $_q"; win',
	  'display this PostScript file',	   'vVgG',  'view'],
	 ['sh "lpr", "-h", $_; ret; winch',
	  'print this PostScript file',		   'pPlL',  'print'],
	 ['sh "psduplex $_q | lpr -h"; ret; winch',
	  'print this PostScript file duplex',	   'dD',    'print duplex'],
	 ['sh "psduplex -tumble $_q | lpr -h"; ret; winch',
	  'print this PostScript file tumble',	   'tT',    'print tumble'],
	 ['sh "psnup -n 2 $_q | lpr -h"; ret; winch',
	  'print this PostScript file 2-up',	   '2rRnN', 'print 2-up'],
	 ['sh "psnup -n 2 $_q | psduplex | lpr -h"; ret; winch',
	  'print this PostScript file duplex 2-up', '4', 'print duplex 2-up']];
$typemap_do{'/\.err$/'}	   = ['sh $cfg::editor, "-q", $_; winch',
			      'quickfix edit based on this error file'];
$typemap_do{'/\.html?$/i'} = ['sh "$ENV{HTMLVIEW} < $_q"; win',
			      'browse this HTML file'];
$typemap_do{'/\.p(rc|qa)$/i'} =
	[['shell "+palm; pilot-file -d -- $_q' . $cfg::page,
	  'view a dump of this Palm file', 'vVfF', 'view'],
	 ['shell "+palm; exec pilot-xfer -i $_q"' . $rc::retrm,
	  'download this file to a Palm',  'dDxX', 'download']];
$typemap_do{'/\.pdb$/i'}      =
	[@{$typemap_do{'/\.p(rc|qa)$/i'}},
	 ['shell "+palm; txt2pdbdoc -d -- $_q' . $cfg::page,
	  'read this Palm Doc file',	   'rRtT', 'read']];
$typemap_do{'/\.url?$/'} = ['sh "xrshio - webrowse -mw < $_q"; win',
			    'browse this URL file marked up'];
$typemap_do{'4; /[Mm]akefile/'}[0] = 'shell getcmd "mak -f $_q"; ret; winch';
$typemap_do{''} =
	 [['sh $cfg::pager, "--", $_; winch',
	   'view this file',		       'vV',   'view'],
	  ['sh "sendfile", $_' . $rc::retrm,
	   'mail this message file',	       'mMsS', 'mail'],
	  [q/shell "+palm; install-memo -c '1) To Do' -- $_q"/ . $rc::retrm,
	   'download this memo to a Palm',     'iI',   'download memo'],
	  ['sh "enscript", "-Gh", "--", $_' . $rc::retrm,
	   'print this text file',	       'pl',   'print'],
	  ['sh "enscript -Gh -p- -- $_q | psduplex | lpr -h"' . $rc::retrm,
	   'print this text file duplex',      'd',    'print duplex'],
	  ['sh "enscript", "-2rGh", "--", $_' . $rc::retrm,
	   'print this text file 2-up',	       '2rn',  'print 2-up'],
	  ['sh "enscript -2rGh -p- -- $_q | psduplex | lpr -h"' . $rc::retrm,
	   'print this text file duplex 2-up', '4',    'print duplex 2-up'],
	  ['sh "mailp", "-from", "-noburstpage", "--", $_' . $rc::retrm,
	   'print this mail file',	       'PL',   'print mail'],
	  ['sh "mailp", "-from", "-landscape", "-noburstpage", "--", $_'
	   . $rc::retrm,
	   'print this mail file 2-up',	       'RN',   'print mail 2-up']];

###############################################################################
## Main keymap reconfiguration ################################################

$cfg::quemarkmsg = '';

@rc::ring = ('cd "/l/picons/ftp/incoming"; win',
#	     '$ENV{RH} !~ /wanarb01/i && ' .	# => bizarre wap hang
		'cd("~oracle/post") ? longls("-win", 1) : win',
	     'cd "~/work"; win');

$keymap_{"\cK"}	   = ['setcomplete \&rc::edtags;'
		      . ' sh $cfg::editor, "-t", get "Tag:"; setcomplete;'
		      . ' winch', 'edit in the file for the given tag'];
$keymap_{"\cL"}[0] = 'point "-\$"; winch';
unshift(@{$keymap_{"\cQ"}},
	['do $vshnurc; err $@; win', 'reload just the personal rc file '
	 . '($vshnurc)', "rR\cR", 'load $vshnurc'])
		unless $keymap_{"\cQ"}[0][2] =~ /r/i;
$keymap_{","}	   = ['evalnext \@rc::ring', 'cycle to monitored directories'];
$keymap_{"A"}	   = ['longls "-win", "getfacls --"',
		      'long list files with their POSIX ACL info'];
$keymap_{"C"}	   = ['longls "-win", "listacls"',
		      'long list files with their AFS ACL info'];
$keymap_{"G"}	   =
	[['shell getcmd "go"; winch',
	  'browse the URL guessed from the given piece(s)',
	  'gG',   'url pieces'],
	 ['sh "go", "url:" . gets "Go URL:"; winch',
	  'browse the given URL',
	  'uUkK', 'url (including Netscape Internet Keywords)'],
	 ['sh "go", "arc:" . gets "Go Archive URL:"; winch',
	  'browse historical versions of the given URL',
	  'vV',   'url versions'],
	 ['sh "grepbm", "-b", "-i", "--", gets "Go Regexp:"; winch',
	  'browse the matched browser bookmarks',
	  'bB',   'bookmarks'],
	 ['sh "go", "search:" . gets "Go Search:"; winch',
	  'browse the results for the given web search query',
	  'sS',   'search (Google)'],
	 ['sh "go", "image:" . gets "Go Image:"; winch',
	  'browse the results for the given web image search query',
	  'iI',   'image (Google Images)'],
	 ['sh "go", "news:" . gets "Go News:"; winch',
	  'browse the results for the given usenet search query',
	  'nN',   'news (Google Groups)'],
	 ['sh "go", "ask:" . gets "Go Ask:"; winch',
	  'browse the matches for the given question',
	  'aA9',  'ask (A9)'],
	 ['sh "go", "topic:" . gets "Go Topic:"; winch',
	  'browse the matches for the given topic',
	  'tT',   'topic (Yahoo)'],
	 ['sh "go", "encyc:" . gets "Go Encyclopedia:"; winch',
	  'browse the results for the given encyclopedia query',
	  'eE',   'encyclopedia (Wikipedia)'],
	 ['sh "go", "word:" . gets "Go Word:"; winch',
	  'browse the results for the given dictionary query',
	  'wW',   'word (Dictionary)'],
	 ['sh "go", "perl:" . gets "Go Perl:"; winch',
	  'browse the results for the given perl documentation query',
	  'pP',   'perl (Perldoc)'],
	 ['sh "go", "user:" . gets "Go User:"; winch',
	  'browse the results for the given user directory query',
	  'hH',   'user (U-M Directory)'],
	 ['sh "go", "city:" . gets "Go City:"; winch',
	  'browse the results for the given city map query',
	  'yY',   'city (City-Data)'],
	 ['sh "go", "book:" . gets "Go Book:"; winch',
	  'browse the results for the given bookstore query',
	  'zZ',   'book (Amazon)'],
	 ['sh "go", "movie:" . gets "Go Movie:"; winch',
	  'browse the results for the given movie database query',
	  'mM',   'movie (IMDb)'],
	 ['sh "go", "soft:" . gets "Go Software:"; winch',
	  'browse the results for the given software archive query',
	  'xX',   'software (Freshmeat)'],
	 ['sh "go", "prod:" . gets "Go Product:"; winch',
	  'browse the results for the given product search query',
	  '$',   'product (Froogle)'],
	 ['sh "webrowse", "-w", getfile("Go File (.):") || $cwd; winch',
	  'browse the given file or directory (default current directory)',
	  'fF',   'file (default current directory)'],
	 ['sh "slashdot"; winch', 'browse the Slashdot website',
	  '/?.'],
	 ['sh "hmrccal"; winch', 'browse the HMRC calendar',
	  'cC'],
	 ['sh "webdaily", "-v"; winch', 'browse my daily web pages',
	  'dD']];
$keymap_{"H"}	 = ['sh "dailyh"; ret; winch', 'run `dailyh`'];
$keymap_{"J"}	 =
	[['sh "snaps -u' . $cfg::page,
	  "list the user's current processes",	    'ujJ', 'user'],
	 ['sh "snaps -s -l' . $cfg::page,
	  'list all system processes',		    's',   'system'],
	 ['sh "pstree -alp $user' . $cfg::page,
	  "tree list the user's current processes", 'UtT', 'user tree'],
	 ['sh "pstree -alp' . $cfg::page,
	  'tree list all system processes',	    'S',   'system tree']];
$keymap_{"K"}	 = ['sh "make"; ret; winch', 'run `make`'];
$keymap_{"M"}[0] =  'shell getcmd "mak"; ret; winch';
$keymap_{"N"}	 = ['sh "nn"; winch', 'run `nn`'];
$keymap_{"Y"}[0] .= '; $cwd eq untilde("~/work") && msg filecount';
$keymap_{"^"}	 = ['cd($> && $user ne "kinzler" ? "~$user" : "~/work");'
		 .  ' point "-\$"; win',
		    "cd to the user's working directory"];

###############################################################################
## "Choose" keymap reconfiguration ############################################

$rc::rmunchoose = '("Remove?") && remove @choose' . $cfg::unchoose;
$keymap_choose{"<"}    = ['sh "pushmime", @choose; ret' . $cfg::unchoose,
			  'explode the chosen mail messages into directories'];
$keymap_choose{"D"}    =
	[['shell "rm -r --", quote(@choose), "; ' . $cfg::shbeep
	  . ' &"; sleep 1' . $cfg::unchoose,
	  'recursively remove the chosen files/directories (background)',
	  'dDrR', 'regular recursive remove'],
	 ['shell "srm -r --", quote(@choose), "; ' . $cfg::shbeep
	  . ' &"; sleep 1' . $cfg::unchoose, 'securely,'
	  . ' recursively remove the chosen files/directories (background)',
	  'sS',   'secure recursive remove']];
$keymap_choose{"E"}[0] = 'sh $cfg::editor, "--", @choose' . $cfg::unchoose;
$keymap_choose{"J"}    = ['sh "push", "--", @choose, getfile "Directory:"; ret'
			  . $cfg::unchoose,
			  'push the chosen files into the given directory'];
$keymap_choose{"K"}    = ['sh "pop", "--", @choose; ret' . $cfg::unchoose,
			  'pop files out of the chosen directories'];
$keymap_choose{"P"}    = ['shell "+palm; exec pilot-xfer -i", quote(@choose);'
			  . ' ret' . $rc::rmunchoose,
			  'download the chosen files to a Palm'];
$keymap_choose{"S"}    = ['sh "sendfile", @choose; ret' . $rc::rmunchoose,
			  'mail the chosen message files'];
$keymap_choose{"Z"}    = ['shell "z --", quote(@choose), "; ' . $cfg::shbeep
			  . ' &"; sleep 1' . $cfg::unchoose,
			  '(un)tar and (de)feather the chosen files'
			  . ' and directories (background)'];
$keymap_choose{"_"}    = ['shell "_", quote(@choose)' . $cfg::unchoose,
			  'rename the chosen files without whitespace'];

###############################################################################
## "Options" keymap reconfiguration ###########################################

$optons .= 's' unless $optons =~ /s/;

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
