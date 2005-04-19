#!/usr/bin/perl

$default_vshnurc = '';

# .vshnucfg - required general vshnu configuration file
# Steve Kinzler, kinzler@cs.indiana.edu, Aug 99/Mar 00/Sep 00
# see website http://www.cs.indiana.edu/~kinzler/vshnu/
# http://www.cs.indiana.edu/~kinzler/home.html#unixcfg

# Names used only within and below this .vshnucfg are placed in the cfg::
# package.  This file should be reloadable.

###############################################################################
## Change Log #################################################################

($cfg::vname, $cfg::version, $cfg::require) = qw(.vshnucfg 1.0140 1.0136);
&addversions($cfg::vname, $cfg::version);

die "$0: $cfg::vname $cfg::version requires at least $vname $cfg::require ",
    "($version)\r\n" if $cfg::require > $version;

# 1.0000   7 Nov 2000	Initial public release
# 1.0001  15 Nov 2000	$cfg::pagerr defaults to `less -r` if PAGER=less
# 1.0002   5 Dec 2000	Add 'sleep 1' to /D command; *bz2 support
# 1.0003  13 Dec 2000	Version format x.y.z -> x.0y0z
# 1.0004  25 Jan 2001	Add ReadLine package to ^V command output
# 1.0007  25 May 2001	Recognize .\d\w extensions as man pages
# 1.0008   6 Jun 2001	Add `rpm -Fhv` freshen option for rpm files
# 1.0009  15 Jun 2001	Add loading of .vshnu* files via typemap
# 1.0010   2 Jul 2001	Define some function keys for navigation
# 1.0011  19 Oct 2001	Add `md5sum` long listing
# 1.0012   1 Feb 2002	Add viewing actions for SSL files
# 1.0100  29 Mar 2002	Move Y command to U, add Y as tree list cwd
# 1.0101   1 Apr 2002	Enhance directory actions, use ifopt
# 1.0103  16 Apr 2002	Add ^_ command for variable listing
# 1.0104  13 Mar 2003	Add list and extract actions for tnef files
# 1.0105  31 May 2003	Add ReadLine package version to ^V command output
# 1.0106  11 Jun 2003	Full versions support including ^V command
# 1.0107   2 Jul 2003	Add binding for Gnu ReadLine insert-vshnu-chosen
# 1.0108   9 Jul 2003	Add /`p for choosing all PATH elements
# 1.0109  11 Jul 2003	Add /`d for disks; Add `xpdf` fallback for .pdf
# 1.0110   2 Dec 2003	Add decryption actions for PGP and GPG files
# 1.0111   1 Jun 2004	Switch to better multimedia and office apps
# 1.0112   2 Jun 2004	Add suspend choice to ^Q table and alias ^Z
# 1.0113   3 Jun 2004	Add /`v for choosing all disk devices
# 1.0114   4 Jun 2004	Add `stat` for special file action and /A command
# 1.0115   4 Jun 2004	Add + command for longtrunc toggle
# 1.0116   7 Jun 2004	Add ^G cmd for cwd df reporting; Use &pwd in ^A cmd
# 1.0117   8 Jun 2004	Recognize .csv and .tsv extensions for office files
# 1.0118  22 Jun 2004	Switch image viewer from `xv` to `display`, add .ico
# 1.0119  29 Jun 2004	Add $insertkey and $insertcmd
# 1.0120   6 Aug 2004	Add Q command for long listing by arbitrary shell cmd
# 1.0121   2 Nov 2004	Add `konqueror` as a browser for tar and zip files
# 1.0122  15 Nov 2004	Add info, list and dump actions for iso files
# 1.0123  19 Nov 2004	Recognize .wmv extension for gmplayer files
# 1.0124  19 Nov 2004	Recognize .st? and .sx? extensions for office files
# 1.0125  23 Nov 2004	Add X cut buffer option to $insertcmd
# 1.0126  26 Nov 2004	Move X cmd to I; Add X command to copy to X cut buffer
# 1.0127  27 Nov 2004	Move Y tree command into dir action menu; Move U to B
# 1.0128  27 Nov 2004	Add Y/U commands to expand/collapse display files
# 1.0129  27 Nov 2004	Add ^Y command for file count reporting
# 1.0130  28 Nov 2004	Add sort by path depth option
# 1.0131  12 Dec 2004	Drop .tsv extension for office files
# 1.0132  31 Jan 2005	Use &expand, &collapse and &expandtoggle aliases
# 1.0133  13 Feb 2005	Add &cfg::abssets to maintain filesets across cd's
# 1.0134  20 Feb 2005	Revise X command for chosen files options vs lsall
# 1.0135  18 Mar 2005	Add user@host:file choice to X command menu
# 1.0136  14 Apr 2005	Use new rules for default pagers, see comments below
# 1.0137  14 Apr 2005	Add 6 command for disks file set df display
# 1.0138  15 Apr 2005	Add $full threshold for df coloring, skel &cfgcolorlong
# 1.0139  17 Apr 2005	Add long coloring for md5sum and rpm
# 1.0140  18 Apr 2005	Add text view and info action options for .pdf files

###############################################################################
## External configuration #####################################################

$cfg::editor = $ENV{VISUAL} || $ENV{EDITOR} || 'vi';

# $cfg::pager	normal pager
#		default $PAGER  or less or more
# $cfg::pagera	pager that can display text as available
#		default $PAGERA or less or more
# $cfg::pagerr	raw pager for colored text
#		default $PAGERR or `less -R` or `less -r` or more

$cfg::pager  = do { `less -V > /dev/null 2>&1`; ($?) ? 'more' : 'less' };
$cfg::pager .= "; echo Press Return | tr -d '\\012'; sh -c 'read x' < /dev/tty"
	if $cfg::pager  eq 'more';
$cfg::pagera = $ENV{PAGERA} || $cfg::pager;
$cfg::pagerr = $ENV{PAGERR} || $cfg::pager;
$cfg::pagerr.= do { `less -R /dev/null > /dev/null 2>&1`;
		    ($?) ? ' -r' : ' -R' }
	if $cfg::pagerr =~ /\bless\b/ && $cfg::pagerr !~ /\s-\S*r/i;
$cfg::pager  = $ENV{PAGER}  || $cfg::pager;
$cfg::pager .= "; echo Press Return | tr -d '\\012'; sh -c 'read x' < /dev/tty"
	if $cfg::pager  =~ /\bmore\b/ && $cfg::pager  !~ /(\s-\S*w|Press)/;

# Tip: When viewing a vshnu help listing with `less`, you can save the
# listing into a FILE with one of these `less` commands:
#	keep color:	g|$cat > FILE<Ret>
# or	 uncolored:	g|$sed 's/<Ctrl-V><Esc>[^m]*m//g' > FILE<Ret>

$mailbox     = $ENV{MAIL};
@bak	     = qw/~$/;		# regexps identifying backup files

###############################################################################
## Color configuration ########################################################

# This color configuration should work reasonably well on either a dark
# or light background.

# Filename coloring is specified via the LS_COLORS environment variable.
# See GNU's ls(1).

$co_decor = ($>)     ? 'reverse'     : ($color) ? 'on_red' : '';
$co_error = ($color) ? 'bold red'    : 'bold';
$co_msg   = ($color) ? 'green'	     : '';

# File permissions
$co_ftype = ($color) ? 'yellow'	     : '';		# file type character
$co_perms = ($color) ? 'white'	     : '';		# triplets
$co_myper = ($color) ? ''	     : 'bold';		# triplet for me
$co_write = ($color) ? 'red'	     : 'reverse';	# write bits above mine
$co_sbits = ($color) ? 'cyan'	     : '';		# set-id & sticky bits

# Long listings
$co_nlink = '';						# number of links
$co_size1 = '';						# 1000^even size digits
$co_size2 = ($color) ? 'white'	     : 'bold';		# 1000^odd  size digits
$co_xaged = ($color) ? ''	     : 'bold';		# non-aged files
$co_aged  = ($color) ? 'white'	     : '';		# aged files
$co_symln = ($color) ? 'yellow'	     : '';		# symlink paths
%co_user  = ($color) ? ($user => 'blue', 0 => 'red', 'other' => 'green')
		     : ();		# '' is a default key (name or uid)

# Help/Prompt listings
$co_key   = ($color) ? ''	     : '';		# key
$co_ckey  = ($color) ? 'green'	     : 'bold';		# ^key
$co_nkey  = ($color) ? 'red'	     : 'reverse';	# \key
$co_wkey  = ($color) ? 'red'	     : 'reverse';	# <key>
$co_0key  = ($color) ? 'cyan'	     : 'bold';		# key [0-9]
$co_Akey  = ($color) ? 'green'	     : 'bold';		# key [A-Z]
$co_akey  = ($color) ? 'white'	     : 'bold';		# key [a-z]
$co_code  = ($color) ? 'yellow'	     : '';		# key code
$co_cmd   = ($color) ? ''	     : 'bold';		# main commands
$co_tail  = ($color) ? 'white'	     : '';		# tail commands
$co_com   = ($color) ? 'yellow'	     : 'reverse';	# command comment
$co_desc  = ($color) ? 'bold cyan'   : '';		# description
$co_prmt  = ($color) ? 'bold green'  : '';		# prompt
$co_xuse  = ($color) ? 'on_green'    : 'reverse';	# unused
@tail	  = qw/ret keymap home win winch/;
					# regexps identifying tail commands

###############################################################################
## General configuration ######################################################

$aged	     = '12h';			# time old to be considered aged
$full	     = '90';			# % disk full warning threshold
$minfilelen  = 15;			# including any tag, recommend <=18
$maxfilecols = 0;			# 0 => as many as possible
$maxcdhist   = '$scr->{ROWS} - 4';	# eval'ed, <0 => no limit
$maxdohist   = '$scr->{ROWS} - 4';	# eval'ed, <0 => no limit

# All mapped commands may be a command string, 'cmd', a command string
# with text description, ['cmd', 'desc'], or a multiple-choice table
# of command specifications, [['cmd', 'desc', 'keys', 'prompt'], ...].
# If 'desc' is null, then 'cmd' is used.  If 'prompt' is null, then 'desc'
# or 'cmd' is used.  If 'keys' are null, then "a" through "z" are used.
# 'cmd's are perl code to be eval()ed.  'desc's and 'prompt's are strings
# to be eval()ed as double-quoted.

%onsub = (
	'cd'		=> 'altls; cfg::abssets $cdhist[1]{ls}',
	'altls'		=> 'longls',
	'winch'		=> 'longls',
);

# A value of ('a') here would implement a simple single file cursor
# instead of a whole bag, and free up 'b' .. 'z' for other uses.
@bagkeys = @cfg::savebagkeys = ('a' .. 'z');
				# <KEY>  is the selected bagkey character
%bagmap  = (			# <FILE> is each bagkey's quoted file
	''		=> ['point <KEY>; dotype <FILE>',
			    'act on <FILE> by its type'],
	'choose'	=> ['point <KEY>; choose <FILE>', 'choose <FILE>'],
);

$insertkey = 'M-v';
$insertcmd = [
	['@choose',	  'insert chosen files', 'cC/',	'chosen files'],
	['$point',	    'insert point file', 'p>',	'point file'],
	['$_ = $point; s/\.[^\.\/]*$//; $_',
		   'insert point file sans ext', 'P<',	'point file sans ext'],
	['$cwd',     'insert current directory', '.',	'current directory'],
	['pwd',		'insert hard directory', 'hH',	'hard directory'],
	['$cdhist[1]{ls}',
		       'insert prior directory', "\\",	'prior directory'],
	['df && $df->mount(pwd)',
			   'insert mount point', 'mM',	'mount point'],
	['@cfg::set1',	    'insert file set 1', '1',	'file set 1'],
	['@cfg::set2',	    'insert file set 2', '2',	'file set 2'],
	['@cfg::set3',	    'insert file set 3', '3',	'file set 3'],
	['@cfg::set4',	    'insert file set 4', '4',	'file set 4'],
	['map { $_->{ls} } @cdhist',
		     'insert directory history', 'dD',	'directory history'],
	['@dohist',	  'insert file history', 'fF',	'file history'],
	['getmark getkey("Mark:"), "dir"',
		      'insert marked directory', '(',	'marked directory'],
	['getmark getkey("Mark:"), "file"',
			   'insert marked file', ')',	'marked file'],
	['getmark getkey("Mark:"), "path"',
			   'insert marked path', '9',	'marked path'],
	['split(/\n/, `xcb -p 0`)',
			'insert X cut buffer 0', 'xX',	'X cut buffer'],
];

###############################################################################
## Typemap configuration ######################################################

# Using &sh, a multiple argument command and a single argument command
# without shell metacharacters is run directly, while a single argument
# command with shell metacharacters is run with `/bin/sh -c`.  Using &shell,
# a command is run with `$shell -c`, where $shell defaults to the SHELL
# environment variable or /bin/sh.  Also using &shell, the command may
# include embedded perl code surrounded by double braces (eg "echo {{reverse
# @ls}}"), the value of which is substituted into the shell command.

# Typemaps are tested in sort order except for the default ('') being last.
# &winch = a screen redraw (&win) after a check if the window changed size

%typemap_ = (
	' /^$/'		=> 'win',
	'-e _ && -d _'	=> ['cd $_; win', 'enter this directory'],
	''		=> ['sh $cfg::editor, $_; winch', 'edit this file'],
);

%typemap_expand = (	## " ##
	' /^$/'		=> 'win',
	'! -e _'	=> 'beep; win',
	'-d _'		=> ['expandtoggle $_; win',
			    'expand or collapse this directory'],
	''		=> 'beep',
);

sub cfg::zarbrowse {
	['xshell "konqueror -- ' . $_[0] . ':$_fq"; win',
	 "browse the contents of this $_[1]", 'bBkK', 'browse'] }
sub cfg::tarbrowse { &cfg::zarbrowse('tar', @_) }
sub cfg::zipbrowse { &cfg::zarbrowse('zip', @_) }
$cfg::page  = ' | $cfg::pager"; winch';
$cfg::pagea = ' | $cfg::pagera"; winch';
%typemap_do = (		## ? ##
' /^$/'		=> 'win',
'! -e _'	=> 'beep; win',
'-d _'		=> [['shell "ls -lR", unlessopt("a"), ifopt("L"),'
		     . ' ifopt("T", "-F"), "-- $_q | $cfg::pagerr"; winch',
		     'long list this directory recursively', 'lL', 'ls -lR'],
		    ['shell "tree -A", unlessopt("a"), ifopt("C"),'
		     . ' ifopt("L", "-l"), ifopt("T", "-F"),'
		     . ' "$_q | $cfg::pagerr"; winch',
		     'tree list this directory',	   'tT', 'tree'],
		    ['shell "tree -Apug", unlessopt("a"), ifopt("C"),'
		     . ' ifopt("L", "-l"), ifopt("T", "-F"),'
		     . ' "$_q | $cfg::pagerr"; winch',
		     'long tree list this directory',  'pPuUgG', 'tree -pug']],
'/(^|\/|\.)mbox$/'
		=> ['sh "mail", "-f", $_; winch',
		    'run `mail` on this mailbox file'],
'/\.(\d\w?|man)$/'
		=> ['sh "nroff -man < $_q | $cfg::pagerr"; winch',
		    'view this man page formatted'],
'/\.(aif[cf]?|au|snd)$/'
		=> ['xshell "xplay -stay $_q"; win',
		    'play this AU/AIFF audio file'],
'/\.(avi|mo?v(ie)?|mpe?g|qt|wmv)$/i'
		=> ['xshell "xterm -e gmplayer -- $_q"; win',
		    'play this video file'],
'/\.(bmp|gif|ico|jpe?g|p[bgp]m|pcx|png|tiff?|x[bp]m)$/i'
		=> ['xshell "display $_q"; win', 'display this image file'],
'/\.(csv|doc|ppt|rtf|st[cdiw]|sx[cdgimw]|xls)$/i'
		=> ['xshell "ooffice -- $_q"; win',
		    'load this file into OpenOffice'],
'/\.(dir|pag)$/'=> ['sh "makedbm -u $_rq' . $cfg::page,
		    'view a dump of this dbm file'],
'/\.(mp3|ogg|wav)$/'
		=> ['xshell "xmms -p -e -- $_q"; win',
		    'play this MP3/Ogg/WAV audio file'],
'/\.(wr|vrm)l(\.g?[Zz])?$/'
		=> ['xshell "freewrl -- $_q"; win', 'display this VRML file'],
'/\.a$/'	=> ['sh "ar tv $_q' . $cfg::page,
		    'list the contents of this archive'],
'/\.crl$/'	=> ['sh "openssl crl -noout -text -in $_q' . $cfg::page,
		    'view this SSL certificate revocation list'],
'/\.crt$/'	=> ['sh "openssl x509 -noout -text -in $_q' . $cfg::page,
		    'view this SSL certificate'],
'/\.csr$/'	=> ['sh "openssl req -noout -text -in $_q' . $cfg::page,
		    'view this SSL certificate signing request'],
'/\.dvi$/'	=> ['xshell "xdvi $_q"; win', 'display this DVI file'],
'/\.e?ps$/i'	=> ['xshell "ghostview $_q"; win',
		    'display this PostScript file'],
'/\.fig$/'	=> ['xshell "xfig $_q"; win',
		    'load this figure file into `xfig`'],
'/\.gpg$/'	=> ['sh "gpg -- $_q"; ret; winch', 'decrypt this GPG file'],
'/\.iso$/i'	=> [['sh "isoinfo -d -i $_q' . $cfg::pagea,
		     'list the info about this ISO image', 'iI', 'info'],
		    ['sh "isoinfo -l -i $_q' . $cfg::pagea,
		     'list the files in this ISO image', 'lL', 'list'],
		    ['sh "isodump", "--", $_; winch',
		     'view the dump of this ISO image', 'dDvV', 'dump']],
'/\.jar$/'	=> [['sh "unzip -l -- $_q' . $cfg::pagea,
		     'list the contents of this Java archive', 'tTlL', 'list'],
		    &cfg::zipbrowse('Java archive')],
'/\.key$/'	=> ['sh "openssl rsa -noout -text -in $_q' . $cfg::page,
		    'view this SSL private key'],
'/\.lyx$/'	=> ['xshell "lyx $_q"; win', 'load this file into LyX'],
'/\.o$/'	=> ['sh "nm -- $_q' . $cfg::page,
		    'view the name list of this object file'],
'/\.pdf$/i'	=> [['xshell "xpdf -q -- $_q"; win',
		     'display this PDF file',	     'dDrR', 'display'],
		    ['shell "pdftotext -layout -nopgbrk -- $_q -' . $cfg::page,
		     'view a text conversion of this PDF file',
						     'tTvV', 'view as text'],
		    ['shell "pdfinfo -- $_q"; ret; winch',
		     'view the info of this PDF file', 'iI', 'info']],
'/\.pgp$/'	=> ['sh "pgp -- $_q"; ret; winch', 'decrypt this PGP file'],
'/\.prm$/'	=> ['sh "openssl dsaparam -noout -text -in $_q' . $cfg::page,
		    'view this SSL parameter file'],
'/\.r(am?|m)$/'	=> ['xshell "realplay $_q"; win', 'play this Real file'],
'/\.rpm$/'	=> [['sh "rpm -qisp -- $_q' . $cfg::page,
		     'view the info of this RPM package', 'qQ', 'query'],
		    ['sh "rpm", "-ihv", "--", $_; ret; winch',
		     'install this RPM package',	  'iI', 'install'],
		    ['sh "rpm", "-Fhv", "--", $_; ret; winch',
		     'freshen this RPM package',	  'fF', 'freshen']],
'/\.t(a(r\.?)?)?bz2$/i'
		=> [['sh "bzip2 -d < $_q | tar -tvf -' . $cfg::pagea,
		     'list the contents of this bzip2 tarball',
		     'tTlL', 'list'],
		    &cfg::tarbrowse('bzip2 tarball')],
'/\.t(a(r\.?)?)?gz$/i'
		=> [['sh "gzip -d < $_q | tar -tvf -' . $cfg::pagea,
		     'list the contents of this gzip tarball', 'tTlL', 'list'],
		    &cfg::tarbrowse('gzip tarball')],
'/\.t(a(r\.?)?)?z$/i'
		=> ['sh "uncompress < $_q | tar -tvf -' . $cfg::pagea,
		    'list the contents of this compress tarball'],
'/\.tar$/i'	=> [['sh "tar -tvf $_q' . $cfg::page,
		     'list the contents of this tar archive', 'tTlL', 'list'],
		    &cfg::tarbrowse('tar archive'),
		    ['sh "tar -xpvf $_q' . $cfg::page,
		     'extract this entire tar archive',
		     'xX',   'extract all']],
'/(\.tnef|^winmail\.dat)$/i'
		=> [['sh "tnef -tv -- $_q' . $cfg::page,
		     'list the contents of this tnef archive',
		     'tTlL', 'list contents'],
		    ['sh "tnef", "-wv", "--", $_; ret; winch',
		     'extract this tnef archive',
		     'xX',   'extract']],
'/\.uu$/'	=> [['sh "uudecode -p -- $_q' . $cfg::page,
		     'view this uuencoded file',    'vVpP', 'view'],
		    ['sh "uudecode -- $_q"; ret; winch',
		     'extract this uuencoded file', 'xX',   'extract']],
'/\.vshnu(cfg|rc)$/'
		=> ['do $_q; err $@; win', 'load this vshnu config file'],
'/\.xcf$/'	=> ['xshell "gimp $_q"; win',
		    'load this image file into `gimp`'],
'/\.xwd$/'	=> ['xshell "xwud -in $_q"; win', 'display this window dump'],
'/\.zip$/i'	=> [['sh "unzip -l -- $_q' . $cfg::pagea,
		     'list the contents of this zip archive', 'tTlL', 'list'],
		    &cfg::zipbrowse('zip archive')],
'/(^|\/)Imakefile$/'
		=> ['shell getcmd "xmkmf"; ret; winch',
		    'run `xmkmf` which will use this Imakefile'],
'4; /[Ii]makefile/'
		=> ['shell getcmd "imake -f $_q"; ret; winch',
		    'run `imake` using this Imakefile'],
'4; /[Mm]akefile/'
		=> ['shell getcmd "make -f $_q"; ret; winch',
		    'run `make` using this Makefile'],
'4; /\.Z$/'	=> ['sh "uncompress < $_q' . $cfg::pagea,
		    'view this file uncompressed'],
'4; /\.bz2$/'	=> ['sh "bzip2 -d < $_q' . $cfg::pagea,
		    'view this file bunzipped'],
'4; /\.g?z$/'	=> ['sh "gzip -d < $_q' . $cfg::pagea,
		    'view this file gunzipped'],
'9; ! -f _'	=> ['sh "stat", "--", $_; ret; winch',
		    'run `stat` on this special file'],
'9; -s _ && -B _'
		=> ['sh "strings < $_q' . $cfg::page,
		    'view the strings in this binary file'],
''		=> ['sh $cfg::pager, $_; winch', 'view this file'],
);

###############################################################################
## Main keymap configuration ##################################################

$cfg::quemarkmsg = 'For help, press % or &; To quit, press ^Q';

%keymap_ = (
"\cA"	=> ['cd pwd; win', "cd to the current directory's hard path"],
"\cB"	=> ['@bagkeys ? rebag : rebag(@cfg::savebagkeys)',
	    "toggle the bag's presence"],
"\cC"	=> ['altls \@choose, "Chosen Files"; win',
	    'switch to/from the chosen files display'],
"\cD"	=> ['altls \@cdhist, "Directory History"; win',
	    'switch to/from the directory history display'],
"\cF"	=> ['altls \@dohist, "File History"; win',
	    'switch to/from the file history display'],
"\cG"	=> ['msg diskspace', 'report the disk space for the current disk'],
"\cH"	=> ['bag "["', 'slide the bag backward on the screen'],
"\cI"	=> ['bag "]"', 'slide the bag forward on the screen'],
"\cL"	=> ['winch', 'redraw the screen, clearing any long listing'],
"\cM"	=> ['cd ".."; win', 'cd to the parent directory'],
"\cN"	=> ['setnorun "once"; win',
	    "don't run but describe the next key command"],
"\cP"	=> ['cdhist "prev"; win',
	    'cd to the previous directory in the history'],
"\cQ"	=> [['do $vshnucfg; err $@; win', 'reload the config file ($vshnucfg)',
				       "cC\cClL\cL",	  'load $vshnucfg'],
	    ['exec $0', 'restart and reinitialize $vname ($0)',
				       "sS\cS",		  'restart'],
	    ['stop; winch', 'suspend to the master shell',
				       "zZ\cZvV\cVyY\cY", 'suspend'],
	    ['last',	'quit $vname', "qQ",		  'quit']],
"\cR"	=> ['rechoose; keymap "choose"', 'rechoose the previously chosen set'],
"\cT"	=> ['cfg::setset(@choose) && win',
	    'append the chosen set to the current file set display'],
"\cU"	=> ['clear; win', 'clear the chosen set or current set display'],
"\cV"	=> ['perl "print versions"; ret; winch',
	    'list the $vname software versions and packages'],
"\cW"	=> ['cdhist "start"; win',
	    'rewind and cd to the start of the directory history'],
"\cY"	=> ['msg filecount', 'report the numbers of directories and files'],
"\c["	=> ['win "<1"', 'shift the file display left one column'],
"\c]"	=> ['win ">1"', 'shift the file display right one column'],
"\c_"	=> ['pipeto $cfg::pager, "#!/bin/perl\n", vardump get "Refs (all):";'
	    . ' winch', 'list the given perl variables with their values'],
" "	=> ['win "]#", 1, 1', 'page to the next screen of this display'],
"\""	=> ['typemap "*expand"', 'toggle the expand/collapse file type mode'],
"#"	=> [['$aged = gets "Age ($aged):"; winch',
	     'set the age threshold ($aged) for time coloring',
	     'aA', 'age threshold ($aged)'],
	    ['$depth = gets "Depth ($depth):"; winch',
	     'set the depth limit ($depth) for expanding, <0 means no limit',
	     'dD', 'depth limit ($depth)'],
	    ['$where = gets "Where {$where}:"; winch',
	     'set the where clause {$where} for display subsets',
	     'wW', 'where clause {$where}'],
	    ['$full = gets "Full ($full):"; winch',
	     'set the % disk full warning threshold ($full) for df coloring',
	     'fF', '% disk full threshold ($full)']],
"\$"	=> ['shellv "Shell"; winch',
	    'run a series of shell (or ;perl) commands, `v` to exit'],
"%"	=> ['help "-unused", $cfg::pagerr; winch',
	    'list the commands for the main key mode'],
"&"	=> ['help $cfg::pagerr, "%typemap"; winch',
	    'list the commands for the current file type mode'],
"'"	=> ['keymap "choose"; point',
	    'choose the point file and enter choose mode'],
"("	=> ['setmark(getkey("Set Mark:"), @bagkeys) || beep; home',
	    'mark the current directory position with the given non-bag key'],
")"	=> ['cfg::pointorcd getkey "To:"; winch 1',
	    'cd to the given mark or point to the given bag key'],
"*"	=> ['winat getfile "Find:"',
	    'page to the file alphabetically >= the given string'],
"+"	=> ['longtrunc "toggle"; win',
	    'truncate the long listing area on the left/right'],
"-"	=> ['point "<1"; point',
	    'act on the file above the point by its type'],
"."	=> ['dotypepath getfile "File:"',
	    'act on the given file by its type, searching in \$CD_PATH'],
"/"	=> ['keymap "choose"', 'enter/exit choose key mode'],
"0"	=> ['point "-\$"; win 1, 1, 1', 'page to the top of the directory'],
"1"	=> ['altls \@cfg::set1, "File Set 1"; win',
	    'switch to/from the first file set display'],
"2"	=> ['altls \@cfg::set2, "File Set 2"; win',
	    'switch to/from the second file set display'],
"3"	=> ['altls \@cfg::set3, "File Set 3"; win',
	    'switch to/from the third file set display'],
"4"	=> ['altls \@cfg::set4, "File Set 4"; win',
	    'switch to/from the fourth file set display'],
"5"	=> ['longls "-win", "md5sum -- \@_ 2>&1"',
	    'long list files with their `md5sum` output'],
"6"	=> ['@cfg::disks = disks, longls "-win", ";diskspace"'
	    . ' if altls \@cfg::disks, "Disks"; win',
	    'switch to/from the disks file set df display'],
"9"	=> ['helpmarks $cfg::pagerr; winch', 'list the defined marks'],
":"	=> ['shellp getshell "Shell:"; ret; winch',
	    'run a shell (or ;perl) command, leaving output'],
";"	=> ['shellp getshell "Shell;"; winch',
	    'run a shell (or ;perl) command, clearing output'],
"<"	=> ['sh "mail"; winch', 'run `mail`'],
"="	=> ['point ">1"; point',
	    'act on the file below the point by its type'],
">"	=> ['point', 'act on the point file by its type'],
"?"	=> ['typemap "*do"; msg $cfg::quemarkmsg',
	    'toggle the special action file type mode'],
"B"	=> ['shell getcmd "man"; winch', 'run `man` with the given arguments'],
"F"	=> ['longls "-win", "file", ifopt("L"), "--"',
	    'long list files with their `file` output'],
"L"	=> ['longls "-win", "+1"',
	    'long list files with their stat info, repeat for more'],
"M"	=> ['shell getcmd "make"; ret; winch',
	    'run `make` with the given arguments'],
"O"	=> ['keymap "opts"', 'push to option key mode'],
"P"	=> ['longls "-win", "rpm -qf -- \$_ 2>&1"',
	    'long list files with their owning RPM package'],
"Q"	=> ['longls "-win", gets "Command:"',
	    'long list files with the queried shell command output'],
"T"	=> ['sh "top -S"; winch', 'run `top -S`'],
"U"	=> ['collapse lsall; win', 'collapse all the display files'],
"V"	=> ['stop; winch', 'suspend to the master shell'],
"X"	=> [['pipeto "xcb -s 0", $cwd',
	     'copy the current directory to X cut buffer 0',
	     '.',   'current directory'],
	    ['pipeto "xcb -s 0", "$user\@$host:$cwd"',
	     'copy user\@host:dir to X cut buffer 0',
	     'dD',  'user\@host:dir'],
	    ['pipeto "xcb -s 0", absfile $point',
	     'copy the point file to X cut buffer 0',
	     '>pP', 'point file'],
	    ['pipeto "xcb -s 0", "$user\@$host:" . absfile $point',
	     'copy the point file to X cut buffer 0',
	     'fF',  'user\@host:file'],
	    ['pipeto "xcb -s 0", join(" ", map { absfile $_ } @choose)',
	     'copy the chosen files to X cut buffer 0, one-line',
	     'c\\', 'chosen files, one-line'],
	    ['pipeto "xcb -s 0", join("\n", map { absfile $_ } @choose)',
	     'copy the chosen files to X cut buffer 0, multi-line',
	     'C/',  'chosen files, multi-line']],
"Y"	=> ['expand lsall; win',    'expand all the display files'],
"["	=> ['expand $point; win',   'expand the point file'],
"\\"	=> ['cdhist "back"; win', 'cd back to the prior directory'],
"]"	=> ['collapse $point; win', 'collapse the point file'],
"_"	=> ['longlen "toggle"; win',
	    'shift the long listing area to the left/right'],
"{"	=> ['point "<1"', 'slide the point up one file, wrapping around'],
"|"	=> ['columns "<1"', 'decrement the number of file columns,'
			    . ' wrapping around to the maximum'],
"}"	=> ['point ">1"', 'slide the point down one file, wrapping around'],
"~"	=> ['cd "~"; win', "cd to the user's home directory"],
"pgup"	=> ['point "-1"', 'slide the point up one file'],
"pgdn"	=> ['point "+1"', 'slide the point down one file'],
"kl"	=> ['bag "-1"',	    'slide the bag left on the screen'],
"kr"	=> ['bag "+1"',	    'slide the bag right on the screen'],
"ku"	=> ['bag "", "-1"', 'slide the bag up on the screen'],
"kd"	=> ['bag "", "+1"', 'slide the bag down on the screen'],
""	=> ['beep; home', 'invalid command key'],
);

$keymap_{"\cZ"}	 = $keymap_{"\cQ"};	# screen(1) special char
$keymap_{"ins"}	 = $keymap_{"\cI"};
$keymap_{"del"}	 = $keymap_{"\177"} = $keymap_{"\cH"};
$keymap_{"home"} = $keymap_{"~"};	# potential protocol escape char
$keymap_{"end"}	 = $keymap_{"\c["};	# potential protocol escape char
# numbered function keys might be usable as "k1"-"k12" or "k0"-"k9"

###############################################################################
## "Choose" keymap configuration ##############################################

# When in the chosen files display, "chosen" files are removed from the
# chosen list, not appended to it.

$cfg::unchoose = '; unchoose @choose; keymap; winch';
$cfg::shbeep   = "echo \a\a | tr -d '\\\\012'";
%keymap_choose = (	## / ##
"\cB"	=> ['choose @bagfiles', 'choose all the bag files'],
"\cE"	=> ['map { dotype $_ } @choose',
	    'act on each chosen file in turn by its type'],
"\cR"	=> ['rechoose', 'rechoose the previously chosen set'],
"\cX"	=> ['unchoose pop @choose; win', 'unchoose the last chosen file'],
"!"	=> ['choose grepls gets "Expr:"; winch',
	    'choose the display files for which the given expression is true'],
"#"	=> ['choosebyn getkey "Digit:"',
	    'choose the Nth chosen file for the given N'],
"%"	=> ['help "-unused", $cfg::pagerr; winch',
	    'list the commands for the choose key mode'],
"'"	=> ['point', 'choose the point file'],
"."	=> ['choose grepls "/" . gets("Regexp:") . "/"; winch',
	    'choose the display files that match the given pattern'],
":"	=> ['shell gets("(Shell:"), quote(@choose), get("Shell):"); ret'
	    . $cfg::unchoose, 'run a shell (or ;perl) command'
	    . ' with the chosen files, leaving output'],
";"	=> ['shell gets("(Shell;"), quote(@choose), get("Shell);")'
	    . $cfg::unchoose, 'run a shell (or ;perl) command'
	    . ' with the chosen files, clearing output'],
"@"	=> ['choose lsall', 'choose all the display files'],
"A"	=> ['shell "stat", ifopt("L"), "--", quote(@choose), "| $cfg::pager"'
	    . $cfg::unchoose, 'run `stat` on the chosen files'],
"C"	=> [['sh "chmod", gets("Mode:"), @choose; ret' . $cfg::unchoose,
	     'run `chmod` on the chosen files', 'mM', 'chmod'],
	    ['sh "chown", gets("Owner:"), @choose; ret' . $cfg::unchoose,
	     'run `chown` on the chosen files', 'oO', 'chown'],
	    ['sh "chgrp", ifopt("h"), gets("Group:"), @choose; ret'
	     . $cfg::unchoose,
	     'run `chgrp` on the chosen files', 'gG', 'chgrp']],
"D"	=> ['ask "Remove recursively?"; shell "rm -r --", quote(@choose), "; '
	    . $cfg::shbeep . ' &"; sleep 1' . $cfg::unchoose, 'recursively'
	    . ' remove the chosen files/directories (background)'],
"E"	=> ['sh $cfg::editor, @choose' . $cfg::unchoose,
	    'edit the chosen files'],
"I"	=> ['xshell "display", quote(@choose)' . $cfg::unchoose,
	    'display the chosen image files'],
"O"	=> ['keymap "opts"', 'push to option key mode'],
"R"	=> ['ask "Remove?"; remove @choose' . $cfg::unchoose,
	    'remove the chosen files and empty directories'],
"["	=> ['expand @choose'   . $cfg::unchoose,
	    'expand the chosen directories'],
"]"	=> ['collapse @choose' . $cfg::unchoose,
	    'collapse the chosen directories'],
"`"	=> [['choose getoutput "`Shell`:"; winch',
	     'choose the file list output of a shell (or ;perl) command',
	     'cCsS`;:$', 'command'],
	    ['choose split /:/, $ENV{PATH}; win', 
	     'choose the elements of the PATH environment variable',
	     'pP',	 'PATH'],
	    ['choose sort &disks; win',	   'choose all system disks',
	     'dDmM',	 'disks'],
	    ['choose sort &diskdevs; win', 'choose all system disk devices',
	     'vV',	 'disk devices']],
""	=> ['cmdeval keymapcmd ""',
	    'execute the main mode command for this key'],
);

###############################################################################
## "Options" keymap configuration #############################################

%keymap_opts = (	## O ##
	"\cN"	=> $keymap_{"\cN"},
	"%"	=> ['help "-unused", $cfg::pagerr, %keymap_opts; winch',
		    'list the commands for the option key mode'],
	"="	=> ['initopts; keymap; win', 'reset all options'],
	"O"	=> ['keymap', 'pop from option key mode'],
	""	=> ['beep; keymap; home', 'invalid option'],
);
$optkeys = '#/ABCDFILNSTXabcdfghilmnoprstu'; # enabled options
$optons  = ($color) ? 'Cn' : '';	     # options with a toggled meaning
%cfg::desc_opts = (
	"#"	=> "list inode number instead of size in long listings",
	"/"	=> "sort by increasing path depth",
	"A"	=> "don't list . and ..",
	"B"	=> "don't list backup files",
	"C"	=> "color files",
	"D"	=> "segregate directories to the list top",
	"F"	=> "sort by file color",
	"I"	=> "sort by increasing inode",
	"L"	=> "follow symlinks for long listings, stat sorting, etc",
	"N"	=> "show/sort owners and groups by ids not names",
	"S"	=> "sort by decreasing size",
	"T"	=> "tag files",
	"X"	=> "sort by file extension",
	"a"	=> "don't list dot files",
	"b"	=> "segregate dot files to the list bottom",
	"c"	=> "sort by change time (newest first)",
	"d"	=> "segregate directories to the list bottom",
	"f"	=> "don't sort list",
	"g"	=> "sort by group or increasing gid",
	"h"	=> "long list a symlink's stats not its destination, etc",
	"i"	=> "sort case-insensitively",
	"l"	=> "sort by decreasing number of links",
	"m"	=> "sort by decreasing permissions mode",
	"n"	=> "color long listings",
	"o"	=> "sort by owner or increasing uid",
	"p"	=> "prefer command strings instead of command descriptions",
	"r"	=> "reverse list",
	"s"	=> "show Internet time in screen date",
	"t"	=> "sort by modification time (newest first)",
	"u"	=> "sort by access time (newest first)",
);
foreach (split(//, $optons))  {
	$cfg::desc_opts{$_} = "don't $cfg::desc_opts{$_}"
		unless $cfg::desc_opts{$_} =~ s/^don't //;
}
foreach (split(//, $optkeys)) {
	$keymap_opts{$_} = ["setopt '$_'; keymap; win", $cfg::desc_opts{$_}];
}
undef %cfg::desc_opts;

###############################################################################
## Subroutines ################################################################

sub onquit { 1; }

sub cfgcolorlong {
	local $_ = join('', @_); my $s;
	($s = &rccolorlong($_)) ne '' && ($_ = $s) if defined &rccolorlong;
	$_ = &colorlongline($_, $co_error)
		if $long =~ /^\s*md5sum\b/ && ! /^\\?[0-9a-f]*\\?$/i;
	$_ = &colorlongline($_, $co_msg)
		if $long =~ /^\s*rpm\b/    &&   /is ?n[o']t owned/i;
	$_;
}

sub cfg::pointorcd {
	grep($_[0] eq $_, @bagkeys) ? &point($_[0]) :
	(&cd(&getmark($_[0])) == 1) ? &beep()	    : 1;
}

sub cfg::setset {
	grep($altls == $_, \@cfg::set1, \@cfg::set2, \@cfg::set3, \@cfg::set4)
		? do { push(@$altls, @_); 1 } : do { &beep(); 0 };
}

sub cfg::abssets {
	foreach (\@cfg::set1, \@cfg::set2, \@cfg::set3, \@cfg::set4) {
		map(/^\// || do { $_ = &absfile($_, $_[0]) }, @$_);
	}
}

###############################################################################
## Personal configuration #####################################################

$vshnurc = $ENV{VSHNURC} || $default_vshnurc ||
	   ((-f "$ENV{HOME}/.vshnurc") ? "$ENV{HOME}/.vshnurc" : 'vshnurc.pl');
(-r _) ? do { do $vshnurc; &err($@) } : &err("Cannot read $vshnurc")
	if -f $vshnurc;

1;
