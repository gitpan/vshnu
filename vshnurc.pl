#!/usr/bin/perl

#$tmpcwd = '';	# uncomment these two lines if not using shell integration
#$tmpenv = '';

# .vshnurc - personal extra vshnu configuration file
# Steve Kinzler, kinzler@cs.indiana.edu, Oct 00
# see website http://www.cs.indiana.edu/hyplan/kinzler/vshnu/
# http://www.cs.indiana.edu/hyplan/kinzler/home.html#unixcfg

# Many of the scripts and supporting external configurations used via this
# file are available at http://www.cs.indiana.edu/hyplan/kinzler/home.html.

# Items used only within this .vshnurc are placed in the rc:: package.

###############################################################################
## Change Log #################################################################

($rc::vname, $rc::version, $rc::require) = qw(.vshnurc 1.0007 1.0010);

&err("loaded $rc::vname $rc::version requires $cfg::vname $rc::require",
     "($cfg::version)") if $rc::require != $cfg::version;

# 1.0000  07 Nov 2000	Initial public release
# 1.0002  04 Dec 2000	Added 'sleep 1' to /Z command
# 1.0003  13 Dec 2000	Version format x.y.z -> x.0y0z
# 1.0004  25 Jan 2001	Added ReadLine package to ^V command output
# 1.0005  26 Jan 2001	Appended "=yes" to "--color"s
# 1.0006  27 Apr 2001	Improved Slashdot interface
# 1.0007  29 May 2001	Added "go perl:" option to G command

###############################################################################
## External reconfiguration ###################################################

$shell = 'tcsh';		# for use by &shell

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

(@{$typemap_do{'-d _'}[0]}[0,3], @{$typemap_do{'-d _'}[1]}[0,3]) =
	('shell "lls", opt("L") ? "-L" : (), "-R --color=yes -- $_q |'
	 . ' $cfg::pagerr"; winch', 'lls -R',
	 'shell "tls", opt("L") ? "-l" : (), "$_q |'
	 . ' $cfg::pagerr"; winch', 'tls');
$typemap_do{'/\.e?ps$/i'} =
	[['xshell "ghostview $_q"; win',
	  'display this PostScript file',	   'vVgG', 'view'],
	 ['sh "lpr", "-h", $_; ret; winch',
	  'print this PostScript file',		   'pPlL', 'print'],
	 ['sh "psduplex $_q | lpr -h"; ret; winch',
	  'print this PostScript file duplex',	   'dD',   'print duplex'],
	 ['sh "psnup -n2 $_q | lpr -h"; ret; winch',
	  'print this PostScript file 2-up',	   '2nN',  'print 2-up'],
	 ['sh "psnup -n2 $_q | psduplex | lpr -h"; ret; winch',
	  'print this PostScript file duplex 2-up', '4', 'print duplex 2-up']];
$typemap_do{'/\.err$/'}	   = ['sh $cfg::editor, "-q", $_; winch',
			      'quickfix edit based on this error file'];
$typemap_do{'/\.html?$/i'} = ['sh "$ENV{HTMLVIEW} < $_q"; win',
			      "browse this HTML file's contents"];
$typemap_do{'/\.p(rc|db)$/i'} =
	[['shell "+palm; pilot-file -v -- $_q' . $cfg::page,
	  'view a dump of this Palm file', 'vVfF', 'view'],
	 ['shell "+palm; exec pilot-xfer -i $_q"; ret; winch',
	  'download this file to a Palm',  'dDxX', 'download']];
$typemap_do{'/\.url?$/'}    = ['sh "xrshio - webrowse -mw < $_q"; win',
			       'browse this URL file marked up'];
$typemap_do{'/^slashdot$/'} = ['sh "slashdot | xrshio - inbrowse -aw"; win',
			       'browse the Slashdot articles list'];
$typemap_do{'4; /[Mm]akefile/'}[0] = 'shell getcmd "mak -f $_q"; ret; winch';
$typemap_do{'9; ! -f _'}	   = ['sh "stat", "--", $_; ret; winch',
				      'run `stat` on this special file'];
$typemap_do{''}[0]		   = 'sh $cfg::pager, "--", $_; winch';

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
$keymap_{"\cV"}[0] = 'msg "$vname $version; $cfg::vname $cfg::version;'
		   . ' $rc::vname $rc::version; " . $rl->ReadLine';
$keymap_{","}	   = ['evalnext \@rc::ring', 'cycle to monitored directories'];
$keymap_{"A"}	   = ['longls "-win", "getfacls --"',
		      'long list files with their Solaris ACL info'];
$keymap_{"B"}	   = ['sh "grepbm", "-b", "-i", "--", gets "Regexp:"; winch',
		      'browse the matched browser bookmarks'];
$keymap_{"C"}	   = ['longls "-win", "listacls"',
		      'long list files with their AFS ACL info'];
$keymap_{"G"}	   =
	[['shell getcmd "go"; winch',
	  'browse the URL guessed from the given piece(s)',
	  'gG',   'url pieces'],
	 ['sh "go", "url:" . gets "Go URL:"; winch',
	  'browse the given URL',
	  'uUkK', 'url (including Netscape Internet Keywords)'],
	 ['sh "go", "search:" . gets "Go Search:"; winch',
	  'browse the results for the given web search query',
	  'sS',   'search (Google)'],
	 ['sh "go", "ask:" . gets "Go Ask:"; winch',
	  'browse the matches for the given question',
	  'aAjJ', 'ask (AskJeeves)'],
	 ['sh "go", "topic:" . gets "Go Topic:"; winch',
	  'browse the matches for the given topic',
	  'tTyY', 'topic (Yahoo)'],
	 ['sh "go", "encyc:" . gets "Go Encyclopedia:"; winch',
	  'browse the results for the given encyclopedia query',
	  'eEbB', 'encyclopedia (Brittanica)'],
	 ['sh "go", "word:" . gets "Go Word:"; winch',
	  'browse the results for the given dictionary query',
	  'wW',   'word (Dictionary)'],
	 ['sh "go", "perl:" . gets "Go Perl:"; winch',
	  'browse the results for the given perl documentation query',
	  'pP',   'perl (Perldoc)'],
	 ['sh "webrowse", "-w", getfile("Go File (.):") || $cwd; winch',
	  'browse the given file or directory (default current directory)',
	  'fFdD', 'file (default current directory)']];
$keymap_{"J"}	 =
	[['sh "snaps -u' . $cfg::page,
	  "list the user's current processes",	    'ujJ', 'user'],
	 ['sh "snaps -s -l' . $cfg::page,
	  'list all system processes',		    's',   'system'],
	 ['sh "pstree -alp $user' . $cfg::page,
	  "tree list the user's current processes", 'UtT', 'user tree'],
	 ['sh "pstree -alp' . $cfg::page,
	  'tree list all system processes',	    'S',   'system tree']];
$keymap_{"M"}[0] = 'shell getcmd "mak"; ret; winch';
$keymap_{"N"}	 = ['sh "nn"; winch', 'run `nn`'];
$keymap_{"S"}	 = ['sh "slashdot update"; ' . $typemap_do{'/^slashdot$/'}[0],
		    'update and ' . $typemap_do{'/^slashdot$/'}[1]];
$keymap_{"^"}	 = ['cd($> && $user ne "kinzler" ? "~$user" : "~/work");'
		 .  ' point "-\$"; win',
		    "cd to the user's working directory"];

###############################################################################
## "Choose" keymap reconfiguration ############################################

$rc::rmunchoose = '("Remove?") && remove @choose' . $cfg::unchoose;
$keymap_choose{"<"}    = ['sh "mimeexplode", @choose; ret' . $rc::rmunchoose,
			  'explode the chosen mail messages into directories'];
$keymap_choose{"A"}    = ['shell "stat", opt("L") ? () : "-l", "--", '
			  . 'quote(@choose), "| $cfg::pager"' . $cfg::unchoose,
			  'run `stat` on the chosen files'];
$keymap_choose{"E"}[0] = 'sh $cfg::editor, "--", @choose' . $cfg::unchoose;
$keymap_choose{"J"}    = ['sh "push", "--", @choose, gets "Directory:"; ret'
			  . $cfg::unchoose,
			  'push the chosen files into the given directory'];
$keymap_choose{"K"}    = ['sh "pop", "--", @choose; ret' . $cfg::unchoose,
			  'pop files out of the chosen directories'];
$keymap_choose{"S"}    = ['sh "sendfile", @choose; ret' . $rc::rmunchoose,
			  'mail the chosen message files'];
$keymap_choose{"Z"}    = ['shell "z --", quote(@choose), "; ' . $cfg::shbeep
			  . ' &"; sleep 1' . $cfg::unchoose,
			  '(un)tar and (de)feather the chosen files'
			  . ' and directories (background)'];

###############################################################################
## "Options" keymap reconfiguration ###########################################

$optons .= 's';

1;
