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

($rc::vname, $rc::version, $rc::require) = qw(.vshnurc 1.0116 1.0107);
&addversions($rc::vname, $rc::version);

&err("loaded $rc::vname $rc::version requires $cfg::vname $rc::require",
     "($cfg::version)") if $rc::require != $cfg::version;

# 1.0000  07 Nov 2000	Initial public release
# 1.0002  04 Dec 2000	Added 'sleep 1' to /Z command
# 1.0003  13 Dec 2000	Version format x.y.z -> x.0y0z
# 1.0004  25 Jan 2001	Added ReadLine package to ^V command output
# 1.0005  26 Jan 2001	Appended "=yes" to "--color"s
# 1.0006  27 Apr 2001	Improved Slashdot interface
# 1.0007  29 May 2001	Added "go perl:" option to G command
# 1.0008  05 Jul 2001	Added "go user:", "webdaily", etc options to G command
# 1.0009  01 Aug 2001	Added "go news:" option to G command
# 1.0010  20 Aug 2001	Updated Slashdot interface; added "hmrccal"; B -> GB
# 1.0011  29 Oct 2001	Added "go movie:" option to G command
# 1.0012  14 Feb 2002	Added "go book:" option to G command
# 1.0100  29 Mar 2002	Added mail, download and print menu to default do entry
# 1.0101  01 Apr 2002	Inherit directory action commands, use ifopt
# 1.0102  26 May 2002	Use "pushmime" instead of "mimeexplode"
# 1.0103  14 Jun 2002	Defined $stty_cooked to fix 8-bit characters
# 1.0104  08 Aug 2002	Added P choose command for Palm downloads
# 1.0105  20 Aug 2002	Added "go soft:" option to G command
# 1.0106  18 Nov 2002	Added K command for simple "make"
# 1.0107  17 Dec 2002	Added "go image:" option to G command
# 1.0108  01 Jan 2003	Added "go prod:" option to G command
# 1.0109  03 Mar 2003	Added "go arc:" option to G command
# 1.0110  05 Mar 2003	Added _ choose command for filename whitespace -> _
# 1.0111  01 May 2003	Added browse+remove as edit for _comics_*.html files
# 1.0112  20 May 2003	Added H command for simple "dailyh"
# 1.0113  31 May 2003	added ReadLine package version to ^V command output
# 1.0114  11 Jun 2003	Full versions support
# 1.0115  19 Jun 2003	Correct $optons reloadability
# 1.0116  27 Jun 2003	Updated pilot-file and install-memo usage

###############################################################################
## External reconfiguration ###################################################

$shell = 'tcsh';		# for use by &shell

$stty_cooked = '-istrip';	# corrections to `stty -raw echo`

$cfg::pagera = 'less';		# pager that can display text as available
$cfg::pagerr = 'less -R';	# raw pager for colored text
#cfg::pagerr = 'less -r';	#   for older versions of less

# Tip: When viewing a vshnu help listing with `less`, you can save the
# listing into a FILE with one of these `less` commands:
#	keep color:	g|$cat > FILE<Ret>
# or	 uncolored:	g|$sed 's/<Ctrl-V><Esc>[^m]*m//g' > FILE<Ret>

###############################################################################
## Color reconfiguration ######################################################

$co_decor = 'on_magenta' if $color && $> && $user ne 'kinzler';

delete $co_user{$user}, @co_user{'kinzler', 'oracle',  'uoracle'} =
				('blue',    'magenta', 'magenta') if $color;

###############################################################################
## Typemap reconfiguration ####################################################

$typemap_{''}[0] = 'sh $cfg::editor, "--", $_; winch';

$typemap_{  '/(^|\/)_[^_].*\.mbox$/'} = $typemap_do{'/(^|\/|\.)mbox$/'};
$typemap_do{'/(^|\/)_[^_].*\.mbox$/'} = $typemap_{''};

$typemap_{'/(^|\/)_comics_[^\/]*\.html?$/'} =
	 ['sh "$ENV{HTMLVIEW} < $_q"; remove $_; win',
	  'browse and remove this HTML file'];

$rc::retrm = '; ret("Remove?") && remove $_; winch';
${ $typemap_do{'-d _'}[0]}[0] =~ s/ls -al(.*)--/lls$1--color=yes --/ if $color;
(${$typemap_do{'-d _'}[0]}[3], ${$typemap_do{'-d _'}[1]}[3]) =
	('lls -R', 'tls -pug');
$typemap_do{'/\.e?ps$/i'} =
	[['xshell "ghostview $_q"; win',
	  'display this PostScript file',	   'vVgG',  'view'],
	 ['sh "lpr", "-h", $_; ret; winch',
	  'print this PostScript file',		   'pPlL',  'print'],
	 ['sh "psduplex $_q | lpr -h"; ret; winch',
	  'print this PostScript file duplex',	   'dD',    'print duplex'],
	 ['sh "psnup -n2 $_q | lpr -h"; ret; winch',
	  'print this PostScript file 2-up',	   '2rRnN', 'print 2-up'],
	 ['sh "psnup -n2 $_q | psduplex | lpr -h"; ret; winch',
	  'print this PostScript file duplex 2-up', '4', 'print duplex 2-up']];
$typemap_do{'/\.err$/'}	   = ['sh $cfg::editor, "-q", $_; winch',
			      'quickfix edit based on this error file'];
$typemap_do{'/\.html?$/i'} = ['sh "$ENV{HTMLVIEW} < $_q"; win',
			      'browse this HTML file'];
$typemap_do{'/\.p(rc|db|qa)$/i'} =
	[['shell "+palm; pilot-file -d -- $_q' . $cfg::page,
	  'view a dump of this Palm file', 'vVfF', 'view'],
	 ['shell "+palm; exec pilot-xfer -i $_q"' . $rc::retrm,
	  'download this file to a Palm',  'dDxX', 'download']];
$typemap_do{'/\.url?$/'} = ['sh "xrshio - webrowse -mw < $_q"; win',
			    'browse this URL file marked up'];
$typemap_do{'4; /[Mm]akefile/'}[0] = 'shell getcmd "mak -f $_q"; ret; winch';
$typemap_do{'9; ! -f _'}	   = ['sh "stat", "--", $_; ret; winch',
				      'run `stat` on this special file'];
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
	  ['sh "mailp", "-F", "-h", "--", $_' . $rc::retrm,
	   'print this mail file',	       'PL',   'print mail'],
	  ['sh "mailp", "-F", "-l", "-h", "--", $_' . $rc::retrm,
	   'print this mail file 2-up',	       'RN',   'print mail 2-up']];

###############################################################################
## Main keymap reconfiguration ################################################

$cfg::quemarkmsg = '';

@rc::ring = ('cd "/l/picons/ftp/incoming"; win',
	     'cd("~oracle/post") ? longls("-win", 1) : win',
	     'cd "~/work"; win');

$keymap_{"\cK"}	   = ['sh $cfg::editor, "-t", get "Tag:"; winch',
		      'edit in the file for the given tag'];
$keymap_{"\cL"}[0] = 'point "-\$"; winch';
unshift(@{$keymap_{"\cQ"}},
	['do $vshnurc; err $@; win', 'reload just the personal rc file '
	 . '($vshnurc)', "rR\cR", 'load $vshnurc'])
		unless $keymap_{"\cQ"}[0][2] =~ /r/i;
$keymap_{","}	   = ['evalnext \@rc::ring', 'cycle to monitored directories'];
$keymap_{"A"}	   = ['longls "-win", "getfacls --"',
		      'long list files with their Solaris ACL info'];
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
	  'aAjJ', 'ask (Ask Jeeves)'],
	 ['sh "go", "topic:" . gets "Go Topic:"; winch',
	  'browse the matches for the given topic',
	  'tTyY', 'topic (Yahoo)'],
	 ['sh "go", "encyc:" . gets "Go Encyclopedia:"; winch',
	  'browse the results for the given encyclopedia query',
	  'eE',   'encyclopedia (Columbia Concise)'],
	 ['sh "go", "word:" . gets "Go Word:"; winch',
	  'browse the results for the given dictionary query',
	  'wW',   'word (Dictionary)'],
	 ['sh "go", "perl:" . gets "Go Perl:"; winch',
	  'browse the results for the given perl documentation query',
	  'pP',   'perl (Perldoc)'],
	 ['sh "go", "user:" . gets "Go User:"; winch',
	  'browse the results for the given user directory query',
	  'hH',   'user (U-M Directory)'],
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
$keymap_{"M"}[0] = 'shell getcmd "mak"; ret; winch';
$keymap_{"N"}	 = ['sh "nn"; winch', 'run `nn`'];
$keymap_{"^"}	 = ['cd($> && $user ne "kinzler" ? "~$user" : "~/work");'
		 .  ' point "-\$"; win',
		    "cd to the user's working directory"];

###############################################################################
## "Choose" keymap reconfiguration ############################################

$rc::rmunchoose = '("Remove?") && remove @choose' . $cfg::unchoose;
$keymap_choose{"<"}    = ['sh "pushmime", @choose; ret' . $cfg::unchoose,
			  'explode the chosen mail messages into directories'];
$keymap_choose{"A"}    = ['shell "stat", unlessopt("L", "-l"), "--", '
			  . 'quote(@choose), "| $cfg::pager"' . $cfg::unchoose,
			  'run `stat` on the chosen files'];
$keymap_choose{"E"}[0] = 'sh $cfg::editor, "--", @choose' . $cfg::unchoose;
$keymap_choose{"J"}    = ['sh "push", "--", @choose, gets "Directory:"; ret'
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

1;
