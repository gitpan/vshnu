#!/usr/bin/perl

$default_vshnucap = '';
$default_vshnurc  = '';

# .vshnucfg - required general vshnu configuration file
# Steve Kinzler, kinzler@cs.indiana.edu, Aug 99/Mar 00/Sep 00
# see website http://www.cs.indiana.edu/~kinzler/vshnu/
# http://www.cs.indiana.edu/~kinzler/home.html#unixcfg

# Names used only within and below this vshnucfg are placed in the cfg::
# package.  This file should be reloadable.

###############################################################################
## Change Log #################################################################

($cfg::vname, $cfg::version, $cfg::require) = qw(vshnucfg 1.0302 1.0302);
&addversions($cfg::vname, $cfg::version);

&quit("$0: $cfg::vname $cfg::version requires at least $vname $cfg::require ",
      "($version)\n") if $cfg::require > $version;

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
# 1.0141  20 Apr 2005	Document file variables ($_, $_q, $_r, etc)
# 1.0142  22 Apr 2005	Move 6 cmd to 8; Add 6 cmd for mimetype long listing
# 1.0143  24 Apr 2005	Add V and v options for audio and visual beeps
# 1.0144  26 Apr 2005	Add -safer option to ghostview
# 1.0200  29 Apr 2005	Use &mailcap2typemap for vshnucap and $MAILCAPS, &xsh
# 1.0201   3 May 2005	Add ^\ command, $initmouse, $forcemouse and &onrestart
# 1.0202   4 May 2005	Add mous command to call &domouse; Set $initmouse on
# 1.0203   6 May 2005	Use $hostr vs $host in X command
# 1.0204   9 May 2005	Add P option to sort by file basename
# 1.0205   9 May 2005	Update . command description; Fix bug in $onsub{cd}
# 1.0206  10 May 2005	Add username and groupname rl completion to chown/chgrp
# 1.0207  11 May 2005	Use &completetypepath for . command completions
# 1.0208  11 May 2005	Add /`P for choosing all CD_PATH elements
# 1.0209  18 May 2005	Add ordering arrays of typemap and keymap keys
# 1.0210   1 Jul 2005	Fix redundant &win in 8 command
# 1.0211   5 Jul 2005	Use &quit vs die
# 1.0212   4 Dec 2005	Add &opton
# 1.0213  28 Dec 2005	Remove typemap ordering kludges
# 1.0214  28 Jan 2006	Use &ext and &Ext
# 1.0215   6 Apr 2006	Rename $cfg::pager* to $pager*; Delete &help pager arg
# 1.0216   8 Apr 2006	Document and use &run and special ext syntax
# 1.0217  23 Apr 2006	Add base %mousemap_ and ^ command
# 1.0218  14 May 2006	Add ^J and ^^ commands
# 1.0219   8 Feb 2007	Revise _ command for incremental, wrapping shifting
# 1.0220  14 Feb 2007	Add MAILER support
# 1.0221  19 Mar 2007	Add and use &cfg::maketargets with make commands
# 1.0222  11 Apr 2007	Use keymap = flag; Fix ^X pop bug
# 1.0223  15 Apr 2007	Use new screen zones in mousemaps; Fix mouse support
# 1.0224  17 May 2007	Use &atabsfile; Add user@host:chosen to X command menu
# 1.0225  13 Jun 2007	Add $cfg::xcb, &cfg::xcut and &cfg::xpaste
# 1.0300   8 Jul 2007	Version normalization
# 1.0301  15 Jul 2007	Use enhanced &mapadd $before argument syntax
# 1.0302  16 Mar 2008	Add $co_title and map titles; Add *, H and k options

###############################################################################
## External configuration #####################################################

$cfg::editor = $ENV{VISUAL} || $ENV{EDITOR} || 'vi';
$cfg::mailer = $ENV{MAILER} || 'mail';

# $pager	normal pager
#		default $PAGER  or less or more
# $pagera	pager that can display text as available
#		default $PAGERA or less or more
# $pagerr	raw pager for colored text
#		default $PAGERR or `less -R` or `less -r` or more

$pager   = do { `less -V > /dev/null 2>&1`; ($?) ? 'more' : 'less' };
$pager  .= "; echo Press Return | tr -d '\\012'; sh -c 'read x' < /dev/tty"
	if $pager  eq 'more';
$pagera  = $ENV{PAGERA} || $pager;
$pagerr  = $ENV{PAGERR} || $pager;
$pagerr .= do { `less -R /dev/null > /dev/null 2>&1`; ($?) ? ' -r' : ' -R' }
	if $pagerr =~ /\bless\b/ && $pagerr !~ /\s-\S*r/i;
$pager   = $ENV{PAGER}  || $pager;
$pager  .= "; echo Press Return | tr -d '\\012'; sh -c 'read x' < /dev/tty"
	if $pager  =~ /\bmore\b/ && $pager  !~ /(\s-\S*w|Press)/;

# Tip: When viewing a vshnu help listing with `less`, you can save the
# listing into a FILE with this `less` command:		g|$cat > FILE<Ret>
# Set the vshnu H option beforehand for an uncolored version.

$mailbox     = $ENV{MAIL};
@bak	     = qw/~$/;		# regexps identifying backup files

$cfg::xcb = 0;
sub cfg::xcut	{ &pipeto("xcb -s $cfg::xcb", @_) }
sub cfg::xpaste { `xcb -p $cfg::xcb` }

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
$co_title = 'reverse';					# title
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
$typemaptab  = 32;			# width of left column of typemap help
$mousemaptab = 16;			# width of left column of mousemap help
$initmouse   = 'on';			# initial xterm mouse mode
$forcemouse  = 0;			# allow mouse mode even if no Km||xterm

# All mapped commands may be a command string, 'cmd', a command string
# with text description, ['cmd', 'desc'], or a multiple-choice table
# of command specifications, [['cmd', 'desc', 'keys', 'prompt'], ...].
# If 'desc' is null, then 'cmd' is used.  If 'prompt' is null, then 'desc'
# or 'cmd' is used.  If 'keys' are undefined, then "a" through "z" are used.
# If 'keys' is empty, this indicates the default.  'cmd's are perl code
# to be eval()ed.  'desc's and 'prompt's are strings to be eval()ed as
# double-quoted.

%onsub = (
	'cd'		=> 'altls; $#cdhist && cfg::abssets $cdhist[1]{ls}',
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
	['split(/\n/, cfg::xpaste)',
		'insert X cut buffer $cfg::xcb', 'xX',	'X cut buffer'],
];

###############################################################################
## Typemap configuration ######################################################

# Using &sh, a multiple argument command and a single argument command
# without shell metacharacters are run directly, while a single argument
# command with shell metacharacters is run with `/bin/sh -c`.  Using &shell,
# all arguments are concatenated to form a command that is run with
# `$shell -c`, where $shell defaults to the SHELL environment variable
# or /bin/sh.  Also using &shell, the command may include embedded perl
# code surrounded by double braces (eg "echo {{reverse @ls}}"), the value
# of which is substituted into the shell command.  &xsh and &xshell are
# versions of these for X Windows commands.

# The following variables are available based on the file being acted upon:
#	$_	orig name, eg foo/bar.baz
#	$_r	root name, eg foo/bar
#	$_e	extension, eg baz
#	$_h	head name, eg foo
#	$_t	tail name, eg bar.baz
#	$_f	full name, eg /foo/bar.baz
#	$_m	MIME type, eg text/plain (requires `file -i` or MIME::Types)
#	$_d	description from `file -L` output
#	$_*q	as above but quoted
#	_	preset file test argument

# &winch = a screen redraw (&win) after a check if the window changed size

# &run('-opts', ...) is a shorthand function for common forms of external
# commands.  A special syntax adjustment is made to make "run -opts " at
# the beginning of a command parse as "run '-opts', ".  These characters in
# "opts" have the following meaning:
#	_	append "$_" to the command
#	=	append "-- $_" to the command
#	+	append @choose to the command
#	#	append "--" and @choose to the command
#	p	append "| $pager" to the command
#	P	append "| $pagera" to the command
#	g	append "| $pagerr" to the command
#	s	run the command with &sh
#	S	run the command with &shell (default)
#	x	run the command with &xsh
#	X	run the command with &xshell
#	b	background the command job with a beep at its finish
#	/	follow the command with &setcomplete
#	r	follow the command with &ret prompt
#	R	follow the command with &ret('Remove?') && &remove($_)
#	C	follow the command with &ret('Remove?') && &remove(@choose)
#	u	unchoose @choose after the command
#	k	pop the keymap mode after the command
#	w	follow the command with &win (default with x and X)
#	W	follow the command with &winch (default with s and S)
#	n	follow the command with neither &win nor &winch

# Typemaps are tested in the order present in @typemap_*; if this is
# empty, then all in sort order.  The default ('') is always tested last.
# Tests beginning with "ext " and "Ext " are specially interpreted so that
# the remainder of the test is parsed as whitespace-separated arguments.

%typemap_ = @typemap_ = (		## ##
	'TTL_'		=> 'EDIT MODE FILE ACTIONS',
	'/^$/'		=> 'win',
	'-e _ && -d _'	=> ['cd $_; win', 'enter this directory'],
	''		=> ['run -s_ $cfg::editor', 'edit this file'],
);
@typemap_ = &akeys(@typemap_);

%typemap_expand = @typemap_expand = (	## " ##
	'TTL"'		=> 'EXPAND MODE FILE ACTIONS',
	'/^$/'		=> 'win',
	'! -e _'	=> 'beep; win',
	'-d _'		=> ['expandtoggle $_; win',
			    'expand or collapse this directory'],
	''		=> 'beep',
);
@typemap_expand = &akeys(@typemap_expand);

sub cfg::zarbrowse {
	['run -X "konqueror -- ' . $_[0] . ':$_fq"',
	 "browse the contents of this $_[1]", 'bBkK', 'browse'] }
sub cfg::tarbrowse { &cfg::zarbrowse('tar', @_) }
sub cfg::zipbrowse { &cfg::zarbrowse('zip', @_) }

%typemap_do = @typemap_do = (		## ? ##
'TTL?'		=> 'DO MODE FILE ACTIONS',
'/^$/'		=> 'win',
'! -e _'	=> 'beep; win',
'-d _'		=> [['run -=g "ls -lR", unlessopt("a"), ifopt("L"),'
		     . ' ifopt("T", "-F")', 'long list'
		     . ' this directory recursively', 'lL',	'ls -lR'],
		    ['run -_g "tree -A", unlessopt("a"), ifopt("C"),'
		     . ' ifopt("L", "-l"), ifopt("T", "-F")',
		     'tree list this directory',      'tT',	'tree'],
		    ['run -_g "tree -Apug", unlessopt("a"), ifopt("C"),'
		     . ' ifopt("L", "-l"), ifopt("T", "-F")',
		     'long tree list this directory', 'pPuUgG',	'tree -pug']],
    &mailcap2typemap($ENV{VSHNUCAP} || $default_vshnucap ||
	((-f "$ENV{HOME}/.vshnucap") ? "$ENV{HOME}/.vshnucap" : 'vshnucap')),
'/(\.tnef|(^|\/)winmail\.dat)$/i'
		=> [['run -s=p "tnef -tv"',
		     'list the contents of this tnef archive',
		     'tTlL', 'list contents'],
		    ['run -s=r "tnef", "-wv"', 'extract this tnef archive',
		     'xX',   'extract']],
'/(^|\/|\.)mbox$/'
		=> ['run -s_ "mail", "-f"', 'run `mail` on this mbox file'],
'Ext \d\w? man'	=> ['run -s_g "nroff -man <"', 'view this man page formatted'],
'Ext aif[cf]? au snd'
		=> ['run -x_ "xplay -stay"', 'play this AU/AIFF audio file'],
'ext avi mo?v(ie)? mp4 mpe?g qt wm[av]'
		=> ['run -x= "xterm -e gmplayer"', 'play this video file'],
'ext bmp gif ico jpe?g p[bgnp]m pcx png tiff? xbm xpm'
		=> ['run -x_ "display"', 'display this image file'],
'ext csv doc dot ppt rtf st[cdiw] sx[cdgimw] xls'
		=> ['run -x= "ooffice"', 'load this file into OpenOffice'],
'Ext dir pag'	=> ['run -sp "makedbm -u $_rq"',
		    'view a dump of this dbm file'],
'Ext mp3 ogg wav'
		=> ['run -x= "xmms -p"', 'play this MP3/Ogg/WAV audio file'],
'Ext (wr|vrm)l(\.g?[Zz])?'
		=> ['run -x= "freewrl"', 'display this VRML file'],
'Ext a'		=> ['run -s_p "ar tv"', 'list the contents of this archive'],
'Ext crl'	=> ['run -s_p "openssl crl -noout -text -in"',
		    'view this SSL certificate revocation list'],
'Ext crt'	=> ['run -s_p "openssl x509 -noout -text -in"',
		    'view this SSL certificate'],
'Ext csr'	=> ['run -s_p "openssl req -noout -text -in"',
		    'view this SSL certificate signing request'],
'Ext dvi'	=> ['run -x_ "xdvi"', 'display this DVI file'],
'ext e?ps'	=> ['run -x_ "ghostview -safer"',
		    'display this PostScript file'],
'Ext fig'	=> ['run -x_ "xfig"', 'load this figure file into `xfig`'],
'Ext gpg'	=> ['run -s=r "gpg"', 'decrypt this GPG file'],
'ext iso'	=> [['run -s_P "isoinfo -d -i"',
		     'list the info about this ISO image', 'iI', 'info'],
		    ['run -s_P "isoinfo -l -i"',
		     'list the files in this ISO image',   'lL', 'list'],
		    ['run -s= "isodump"',
		     'view the dump of this ISO image',  'dDvV', 'dump']],
'Ext jar'	=> [['run -s=P "unzip -l"',
		     'list the contents of this Java archive', 'tTlL', 'list'],
		    &cfg::zipbrowse('Java archive')],
'Ext key'	=> ['run -s_p "openssl rsa -noout -text -in"',
		    'view this SSL private key'],
'Ext lyx'	=> ['run -x_ "lyx"', 'load this file into LyX'],
'Ext o'		=> ['run -s=p "nm"', 'view the name list of this object file'],
'ext pdf'	=> [['run -x= "xpdf -q"',
		     'display this PDF file',	     'dDrR', 'display'],
		    ['run -p "pdftotext -layout -- $_q -"',
		     'view a text conversion of this PDF file',
						     'tTvV', 'view as text'],
		    ['run -=r "pdfinfo"',
		     'view the info of this PDF file', 'iI', 'info']],
'Ext pgp'	=> ['run -s=r "pgp"', 'decrypt this PGP file'],
'Ext prm'	=> ['run -s_p "openssl dsaparam -noout -text -in"',
		    'view this SSL parameter file'],
'Ext r(am?|m)'	=> ['run -x_ "realplay"', 'play this Real file'],
'Ext rpm'	=> [['run -s=p "rpm -qisp"',
		     'view the info of this RPM package', 'qQ', 'query'],
		    ['run -s=r "rpm", "-ihv"',
		     'install this RPM package',	  'iI', 'install'],
		    ['run -s=r "rpm", "-Fhv"',
		     'freshen this RPM package',	  'fF', 'freshen']],
'ext t(a(r\.?)?)?bz2'
		=> [['run -sP "bzip2 -d < $_q | tar -tvf -"',
		     'list the contents of this bzip2 tarball',
		     'tTlL', 'list'],
		    &cfg::tarbrowse('bzip2 tarball')],
'ext t(a(r\.?)?)?gz'
		=> [['run -sP "gzip -d < $_q | tar -tvf -"',
		     'list the contents of this gzip tarball', 'tTlL', 'list'],
		    &cfg::tarbrowse('gzip tarball')],
'ext t(a(r\.?)?)?z'
		=> ['run -sP "uncompress < $_q | tar -tvf -"',
		    'list the contents of this compress tarball'],
'ext tar'	=> [['run -s_p "tar -tvf"',
		     'list the contents of this tar archive', 'tTlL', 'list'],
		    &cfg::tarbrowse('tar archive'),
		    ['run -s_p "tar -xpvf"',
		     'extract this entire tar archive', 'xX', 'extract all']],
'Ext uu'	=> [['run -s=p "uudecode -p"',
		     'view this uuencoded file',    'vVpP', 'view'],
		    ['run -s=r "uudecode"',
		     'extract this uuencoded file', 'xX',   'extract']],
'Ext vshnu(cfg|rc)'
		=> ['do $_q; err $@; win', 'load this vshnu config file'],
'Ext xcf'	=> ['run -x_ "gimp"', 'load this image file into `gimp`'],
'Ext xwd'	=> ['run -x_ "xwud -in"', 'display this window dump'],
'ext zip'	=> [['run -s=P "unzip -l"',
		     'list the contents of this zip archive', 'tTlL', 'list'],
		    &cfg::zipbrowse('zip archive')],
'/(^|\/)Imakefile$/'
		=> ['run -r getcmd "xmkmf"',
		    'run `xmkmf` which will use this Imakefile'],
'/[Ii]makefile/'=> ['run -r getcmd "imake -f $_q"',
		    'run `imake` using this Imakefile'],
'/[Mm]akefile/' => ['@cfg::makefiles = ($_); setcomplete \&cfg::maketargets; '
		    . 'run "-/r", getcmd "make -f $_q"; undef @cfg::makefiles',
		    'run `make` using this Makefile'],
'Ext Z'		=> ['run -s_P "uncompress <"', 'view this file uncompressed'],
'Ext bz2'	=> ['run -s_P "bzip2 -d <"',   'view this file bunzipped'],
'Ext g?z'	=> ['run -s_P "gzip -d <"',    'view this file gunzipped'],
'! -f _'	=> ['run -s=r "stat"', 'run `stat` on this special file'],
# insert all mailcaps in $MAILCAPS || std path here
    &mailcap2typemap('', '', ['take' => 'ALL'],
	'text/plain', 'text/x-mail', 'message/rfc822', 'message/news'),
'-s _ && -B _'	=> ['run -s_p "strings <"',
		    'view the strings in this binary file'],
''		=> ['run -s_ $pager', 'view this file'],
);
@typemap_do = &akeys(@typemap_do);

###############################################################################
## Main keymap configuration ##################################################

$cfg::quemarkmsg = 'For help, press % or ^ or &; To quit, press ^Q';

%keymap_ = @keymap_ = (		## ##
'TTL_'	=> 'MAIN MODE KEY COMMANDS',
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
"\cJ"	=> ['msg $point', 'report the point file'],
"\cL"	=> ['winch', 'redraw the screen, clearing any long listing'],
"\cM"	=> ['cd ".."; win', 'cd to the parent directory'],
"\cN"	=> ['setnorun "once"; win',
	    "don't run but describe the next key command"],
"\cP"	=> ['cdhist "prev"; win',
	    'cd to the previous directory in the history'],
"\cQ"	=> [['do $vshnucfg; err $@; win', 'reload the config file ($vshnucfg)',
				       "cC\cClL\cL",	  'load $vshnucfg'],
	    ['restart', 'restart and reinitialize $vname ($0)',
				       "sS\cS",		  'restart'],
	    ['stop; winch', 'suspend to the master shell',
				       "zZ\cZvV\cVyY\cY", 'suspend'],
	    ['last',	'quit $vname', "qQ",		  'quit']],
"\cR"	=> ['rechoose; keymap "=choose"',
	    'rechoose the previously chosen set'],
"\cT"	=> ['cfg::setset(@choose) && win',
	    'append the chosen set to the current file set display'],
"\cU"	=> ['clear; win', 'clear the chosen set or current set display'],
"\cV"	=> ['perl "print versions"; ret; winch',
	    'list the $vname software versions and packages'],
"\cW"	=> ['cdhist "start"; win',
	    'rewind and cd to the start of the directory history'],
"\cY"	=> ['msg filecount', 'report the numbers of directories and files'],
"\c["	=> ['win "<1"', 'shift the file display left one column'],
"\034"	=> ['mousemode("toggle") || beep; win', 'toggle the mouse mode'], # ^\
"\c]"	=> ['win ">1"', 'shift the file display right one column'],
"\c^"	=> ['msg $cwd', 'report the current directory'],
"\c_"	=> ['pipeto $pager, "#!/bin/perl\n", vardump get "Refs (all):"; winch',
	    'list the given perl variables with their values'],
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
	     'fF', '% disk full threshold ($full)'],
	    ['$cfg::xcb = gets "X Cut Buffer ($cfg::xcb):"; winch',
	     'set the X cut buffer number ($cfg::xcb) for cuts and pastes',
	     'xX', 'X cut buffer ($cfg::xcb)']],
"\$"	=> ['shellv "Shell"; winch',
	    'run a series of shell (or ;perl) commands, `v` to exit'],
"%"	=> ['help "-unused"; winch',
	    'list the commands for the main key mode'],
"&"	=> ['help "=typemap"; winch',
	    'list the commands for the current file type mode'],
"'"	=> ['keymap "=choose"; point',
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
"."	=> ['setcomplete \&completetypepath, "Gnu";'
	    . ' dotypepath getfile "File:"; setcomplete',
	    'act on the given file by its type,' .
	    ' searching in \$CD_PATH and histories'],
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
"6"	=> ['longls "-win", ";mimetype"',
	    'long list files with their MIME type'],
"8"	=> ['(@cfg::disks = disks) && longls ";diskspace"'
	    . ' if altls \@cfg::disks, "Disks"; win',
	    'switch to/from the disks file set df display'],
"9"	=> ['helpmarks; winch', 'list the defined marks'],
":"	=> ['shellp getshell "Shell:"; ret; winch',
	    'run a shell (or ;perl) command, leaving output'],
";"	=> ['shellp getshell "Shell;"; winch',
	    'run a shell (or ;perl) command, clearing output'],
"<"	=> ['run -s $cfg::mailer', 'run mailer'],
"="	=> ['point ">1"; point',
	    'act on the file below the point by its type'],
">"	=> ['point', 'act on the point file by its type'],
"?"	=> ['typemap "*do"; msg $cfg::quemarkmsg',
	    'toggle the special action file type mode'],
"B"	=> ['run getcmd "man"', 'run `man` with the given arguments'],
"F"	=> ['longls "-win", "file", ifopt("L"), "--"',
	    'long list files with their `file` output'],
"L"	=> ['longls "-win", "+1"',
	    'long list files with their stat info, repeat for more'],
"M"	=> ['setcomplete \&cfg::maketargets; run "-/r", getcmd "make"',
	    'run `make` with the given arguments'],
"O"	=> ['keymap "opts"', 'push to option key mode'],
"P"	=> ['longls "-win", "rpm -qf -- \$_ 2>&1"',
	    'long list files with their owning RPM package'],
"Q"	=> ['longls "-win", gets "Command:"',
	    'long list files with the queried shell command output'],
"T"	=> ['run -s "top"', 'run `top`'],
"U"	=> ['collapse lsall; win', 'collapse all the display files'],
"V"	=> ['stop; winch', 'suspend to the master shell'],
"X"	=> [['cfg::xcut $cwd',		# see also mousemap_ below
	     'copy the current directory to X cut buffer $cfg::xcb',
	     '.',   'current directory'],
	    ['cfg::xcut atabsfile $cwd',
	     'copy the current user\@host:directory to X cut buffer $cfg::xcb',
	     'dD',  'user\@host:directory'],
	    ['cfg::xcut absfile $point',
	     'copy the point file to X cut buffer $cfg::xcb',
	     '>pP', 'point file'],
	    ['cfg::xcut atabsfile $point',
	     'copy the point user\@host:file to X cut buffer $cfg::xcb',
	     'fF',  'user\@host:file'],
	    ['cfg::xcut join(" ", map { absfile $_ } @choose)',
	     'copy the chosen files to X cut buffer $cfg::xcb, one-line',
	     '\\',  'chosen files, one-line'],
	    ['cfg::xcut join("\n", map { absfile $_ } @choose)',
	     'copy the chosen files to X cut buffer $cfg::xcb, multi-line',
	     '/',   'chosen files, multi-line'],
	    ['cfg::xcut join(" ", map { atabsfile $_ } @choose)',
	     'copy the user\@host:chosen files to X cut buffer, one-line',
	     'c',   'user\@host:chosen, one-line'],
	    ['cfg::xcut join("\n", map { atabsfile $_ } @choose)',
	     'copy the user\@host:chosen files to X cut buffer, multi-line',
	     'C',   'user\@host:chosen, multi-line']],
"Y"	=> ['expand lsall; win',    'expand all the display files'],
"["	=> ['expand $point; win',   'expand the point file'],
"\\"	=> ['cdhist "back"; win', 'cd back to the prior directory'],
"]"	=> ['collapse $point; win', 'collapse the point file'],
"^"	=> ['help "=mousemap"; winch',
	    'list the commands for the current mouse mode'],
"_"	=> ['longlen "+33%r"; win',
	    'shift the long listing area to the left, wrapping around'],
"{"	=> ['point "<1"', 'slide the point up one file, wrapping around'],
"|"	=> ['columns "<1"', 'decrement the number of file cols,'
			    . ' wrapping around to the max'],
"}"	=> ['point ">1"', 'slide the point down one file, wrapping around'],
"~"	=> ['cd "~"; win', "cd to the user's home directory"],
"kd"	=> ['bag "", "+1"', 'slide the bag down on the screen'],
"kl"	=> ['bag "-1"',	    'slide the bag left on the screen'],
"kr"	=> ['bag "+1"',	    'slide the bag right on the screen'],
"ku"	=> ['bag "", "-1"', 'slide the bag up on the screen'],
"mous"	=> ['domouse', 'handle a mouse event'],
"pgdn"	=> ['point "+1"', 'slide the point down one file'],
"pgup"	=> ['point "-1"', 'slide the point up one file'],
""	=> ['beep; home', 'invalid command key'],
);
@keymap_ = &akeys(@keymap_);

&mapadd('keymap_', "\cZ",  $keymap_{"\cQ"}, ">\cY");	# screen(1) special
&mapadd('keymap_', "\177", $keymap_{"\cH"}, "<kd");
&mapadd('keymap_', "del",  $keymap_{"\cH"}, "<kd");
&mapadd('keymap_', "end",  $keymap_{"\c["}, "<kd");	# protocol esc char?
&mapadd('keymap_', "home", $keymap_{"~"},   "<kd");	# protocol esc char?
&mapadd('keymap_', "ins",  $keymap_{"\cI"}, "<kd");
# numbered function keys might be usable as "k1"-"k12" or "k0"-"k9"

###############################################################################
## "Choose" keymap configuration ##############################################

# When in the chosen files display, "chosen" files are removed from the
# chosen list, not appended to it.

$cfg::unchoose = '; unchoose @choose; keymap; winch';
%keymap_choose = @keymap_choose = (	## / ##
'TTL/'	=> 'CHOOSE MODE KEY COMMANDS',
"\cB"	=> ['choose @bagfiles', 'choose all the bag files'],
"\cE"	=> ['map { dotype } @choose',
	    'act on each chosen file in turn by its type'],
"\cX"	=> ['unchoose $choose[$#choose]; win',
	    'unchoose the last chosen file'],
"!"	=> ['choose grepls gets "Expr:"; winch',
	    'choose the display files for which the given expression is true'],
"#"	=> ['choosebyn getkey "Digit:"',
	    'choose the Nth chosen file for the given N'],
"%"	=> ['help "-unused"; winch',
	    'list the commands for the choose key mode'],
"."	=> ['choose matchfiles gets "Regexp:"; winch',
	    'choose the display files that match the given pattern'],
":"	=> ['run -ruk gets("(Shell:"), quote(@choose), get("Shell):")',
	    'run a shell (or ;perl) command with the chosen files,'
	    . ' leaving output'],
";"	=> ['run -uk gets("(Shell;"), quote(@choose), get("Shell);")',
	    'run a shell (or ;perl) command with the chosen files,'
	    . ' clearing output'],
"@"	=> ['choose lsall', 'choose all the display files'],
"A"	=> ['run -#puk "stat", ifopt("L")', 'run `stat` on the chosen files'],
"C"	=> [['setcomplete sub {}; run "-s+/ruk", "chmod", gets "Mode:"',
	     'run `chmod` on the chosen files', 'mM', 'chmod'],
	    ['setcomplete \&users; run "-s+/ruk", "chown", gets "Owner:"',
	     'run `chown` on the chosen files', 'oO', 'chown'],
	    ['setcomplete \&groups;'
	     . ' run "-s+/ruk", "chgrp", ifopt("h"), gets "Group:"',
	     'run `chgrp` on the chosen files', 'gG', 'chgrp']],
"D"	=> ['ask "Remove recursively?"; run "-#buk", "rm -r"', 'recursively'
	    . ' remove the chosen files/directories (background)'],
"E"	=> ['run -s+uk $cfg::editor', 'edit the chosen files'],
"I"	=> ['run -x+uk "display"', 'display the chosen image files'],
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
	     'p',	 'PATH'],
	    ['choose split /:/, $ENV{CD_PATH}; win', 
	     'choose the elements of the CD_PATH environment variable',
	     'P',	 'CD_PATH'],
	    ['choose sort &disks; win',	   'choose all system disks',
	     'dDmM',	 'disks'],
	    ['choose sort &diskdevs; win', 'choose all system disk devices',
	     'vV',	 'disk devices']],
""	=> ['cmdeval keymapcmd ""',
	    'execute the main mode command for this key'],
);
@keymap_choose = &akeys(@keymap_choose);

###############################################################################
## "Options" keymap configuration #############################################

%keymap_opts = @keymap_opts = (		## O ##
	'TTLO'	=> 'OPTS MODE KEY COMMANDS',
	"\cN"	=> $keymap_{"\cN"},
	"%"	=> ['help "-unused", "=keymap_opts"; winch',
		    'list the commands for the option key mode'],
	"="	=> ['initopts; keymap; win', 'reset all options'],
	"O"	=> ['keymap', 'pop from option key mode'],
	"mous"	=> $keymap_{"mous"},
	""	=> ['beep; keymap; home', 'invalid option'],
);
@keymap_opts = &akeys(@keymap_opts);
$optkeys = '#*/ABCDFHILNPSTVXabcdfghiklmnoprstuv';	# enabled options
$optons  = ($color) ? '*CHVn' : 'V';		# options with toggled meaning
%cfg::desc_opts = (
	"#"	=> "list inode number instead of size in long listings",
	"*"	=> "use color",
	"/"	=> "sort by increasing path depth",
	"A"	=> "don't list . and ..",
	"B"	=> "don't list backup files",
	"C"	=> "color files",
	"D"	=> "segregate directories to the list top",
	"F"	=> "sort by file color",
	"H"	=> "color command listings and prompts",
	"I"	=> "sort by increasing inode",
	"L"	=> "follow symlinks for long listings, stat sorting, etc",
	"N"	=> "show/sort owners and groups by ids not names",
	"P"	=> "sort by file basename",
	"S"	=> "sort by decreasing size",
	"T"	=> "tag files",
	"V"	=> "use an audio beep",
	"X"	=> "sort by file extension",
	"a"	=> "don't list dot files",
	"b"	=> "segregate dot files to the list bottom",
	"c"	=> "sort by change time (newest first)",
	"d"	=> "segregate directories to the list bottom",
	"f"	=> "don't sort list",
	"g"	=> "sort by group or increasing gid",
	"h"	=> "long list a symlink's stats not its destination, etc",
	"i"	=> "sort case-insensitively",
	"k"	=> "sort command listings by key",
	"l"	=> "sort by decreasing number of links",
	"m"	=> "sort by decreasing permissions mode",
	"n"	=> "color long listings",
	"o"	=> "sort by owner or increasing uid",
	"p"	=> "prefer command strings instead of command descriptions",
	"r"	=> "reverse list",
	"s"	=> "show Internet time in screen date",
	"t"	=> "sort by modification time (newest first)",
	"u"	=> "sort by access time (newest first)",
	"v"	=> "use a visual beep",
);
foreach (split(//, $optons))  {
	$cfg::desc_opts{$_} = "don't $cfg::desc_opts{$_}"
		unless $cfg::desc_opts{$_} =~ s/^don't //;
}
foreach (split(//, $optkeys)) {
	&mapadd('keymap_opts', $_,
		["setopt '$_'; keymap; win", $cfg::desc_opts{$_}]);
}
undef %cfg::desc_opts;

sub opton {
	my $opt = shift;
	return unless length($opt) == 1 && index($optkeys, $opt) >= 0;
	$optons .= $opt unless $optons =~ s/$opt//;
	$keymap_opts{$opt}[1] = "don't $keymap_opts{$opt}[1]"
		unless $keymap_opts{$opt}[1] =~ s/^don't //;
}

###############################################################################
## Main mousemap configuration ################################################

# A common default xterm resources configuration provides only unmodified
# Button/Wheel events and Ctrl-Wheel events to applications, so we
# restrict ourselves to these.  (Shift events retain the xterm cut/paste
# functionality; other Ctrl events bring up xterm menus; combo and some
# Mod1 events are unused but would require reconfiguration to enable for
# applications (untested)).

# Mouse events without actions defined for the zone (explicitly or via a
# default '' event) also default to the '' zone.

# Note that if setnorun is "once" (to describe the next key command),
# this'll still report 1d, 2d and 3d mouse event commands, which are
# generally not defined here.  To see the key command for the 1u, 2u or
# 3u mouse events, setnorun in between, eg, the 1d and the 1u events.

%cfg::typering = ('' => 'do', 'do' => 'expand', 'expand' => '');

%mousemap_ = @mousemap_ = (		## ##
'TTL_'		=> 'MOUSE COMMANDS',
'user'		=> [[@{$keymap_{"~"}},		   &mev2c('1u')]],
'dir'		=> [['setopt "t"; win', ${$keymap_opts{"t"}}[1],
						   &mev2c('1u')],
		    [@{${$keymap_{"X"}}[1]}[0, 1], &mev2c('3u')],
		    [@{$keymap_{"Y"}},		   &mev2c('Wd')],
		    [@{$keymap_{"U"}},		   &mev2c('Wu')]],
'dir...'	=> ['msg $_', 'report the full directory name'],
'title'		=> [[@{$keymap_{"\cF"}},	   &mev2c('1u')],
		    [@{$keymap_{"\cD"}},	   &mev2c('2u')],
		    [@{$keymap_{"\cC"}},	   &mev2c('3u')],
		    ['cmdeval $keymap_{cfg::nextset(+1) || 4}',
		     'cycle forward through the file set displays',
						   &mev2c('Wd')],
		    ['cmdeval $keymap_{cfg::nextset(-1) || 1}',
		     'cycle backward through the file set displays',
						   &mev2c('Wu')],
		    [@{$keymap_{"8"}},		   &mev2c('cWd', 'cWu')]],
'title...'	=> ['msg $_', 'report the full title'],
'state'		=> [['initopts; win', ${$keymap_opts{"="}}[1], &mev2c('2u')],
		    [@{$keymap_{"|"}},			       &mev2c('3u')]],
'file'		=> [['dotypein',      'act on the file by its type'
		     . ' per normal mode',		       &mev2c('1u')],
		    ['dotypein "do"', 'act on the file by its type'
		     . ' per special action mode',	       &mev2c('2u')],
		    ['choose $_; keymap "=choose"',
		     'choose the file and enter choose mode',  &mev2c('3u')],
		    ['expand $_; win',	 'expand the file',    &mev2c('Wd')],
		    ['collapse $_; win', 'collapse the file',  &mev2c('Wu')],
		    ['do { local $depth = -1; expand $_ }; win',
		     'completely expand the file',	       &mev2c('cWd')],
		    ['do { local $depth = -1; collapse $_ }; win',
		     'completely collapse the file',	       &mev2c('cWu')]],
'file...'	=> ['msg $_', 'report the full filename'],
'longls'	=> [[@{$keymap_{"_"}},			 &mev2c('1u')],
		    ['setopt "L"; win', ${$keymap_opts{"L"}}[1],
							 &mev2c('2u')],
		    [@{$keymap_{"+"}},			 &mev2c('3u')]],
'long'		=> [[@{$keymap_{"_"}},			 &mev2c('1u')],
		    [@{$keymap_{"+"}},			 &mev2c('3u')]],
'bag'		=> [['point $_[1]', 'point to the file', &mev2c('1u')],
		    [@{$keymap_{"\cB"}},		 &mev2c('2u')],
		    ['cfg::xcut atabsfile $_',
		     'copy the user\@host:file to X cut buffer $cfg::xcb',
							 &mev2c('3u')],
		    [@{$keymap_{"\cI"}},		 &mev2c('Wd', 'cWd')],
		    [@{$keymap_{"\cH"}},		 &mev2c('Wu', 'cWu')]],
'point'		=> [['point $_[1]', 'point to the file', &mev2c('1u')],
		    [@{$keymap_{"\cB"}},		 &mev2c('2u')],
		    [@{${$keymap_{"X"}}[3]}[0, 1],	 &mev2c('3u')],
		    [@{$keymap_{"}"}},			 &mev2c('Wd')],
		    [@{$keymap_{"{"}},			 &mev2c('Wu')],
		    [@{$keymap_{"pgdn"}},		 &mev2c('cWd')],
		    [@{$keymap_{"pgup"}},		 &mev2c('cWu')]],
'chose#'	=> [['$_[1] ? unchoose($_) : choose($_)',
		     "toggle the file's choose status",  &mev2c('1u')],
		    ['unchoose $_', 'unchoose the file', &mev2c('2u')],
		    ['choose $_',   'choose the file',	 &mev2c('3u')]],
'mode'		=> [# reserve 1u for mousemap's
		    ['typemap "*$cfg::typering{$typemap[$#typemap]}"',
		     'change the file type mode',  &mev2c('2u')],
		    [${$keymap_{"/"}}[0],
		     'change the key mode',	   &mev2c('3u')],
		    [@{${$keymap_{"X"}}[6]}[0, 1], &mev2c( 'Wd',  'Wu')],
		    [@{${$keymap_{"X"}}[7]}[0, 1], &mev2c('cWd', 'cWu')]],
'mode...'	=> ['msg $_', 'report the full mode text'],
'time'		=> [['win', 'redraw the screen',	 &mev2c('1u')],
		    ['opton "s"; win',
		     'toggle the Internet time display', &mev2c('2u')],
		    [@{$keymap_{"\cL"}},		 &mev2c('3u')],
		    [@{$keymap_{"L"}},			 &mev2c('Wd', 'Wu')]],
'time_'		=> [['mousemap "test"',
		     'toggle the test mouse mode',	 &mev2c('3u')]],
#'home'		=> unused
''		=> [# avoid 1u for window management use
		    [@{$keymap_{"\cM"}}, &mev2c('2u')],
		    [@{$keymap_{"\\"}},	 &mev2c('3u')],
		    [@{$keymap_{" "}},	 &mev2c('Wd')],
		    [@{$keymap_{"0"}},	 &mev2c('Wu')],
		    [@{$keymap_{"\c]"}}, &mev2c('cWd')],
		    [@{$keymap_{"\c["}}, &mev2c('cWu')]],
);
@mousemap_ = &akeys(@mousemap_);
&mapadd('mousemap_', 'page',	$mousemap_{'state'},   '<title');
&mapadd('mousemap_', 'filetag',	$mousemap_{'file'},    '>file');
&mapadd('mousemap_', 'file/',	$mousemap_{'file...'}, '>file...');

%mousemap_test = @mousemap_test = (	## ##
'TTLt'		=> 'TEST MODE MOUSE COMMANDS',
'time_'		=> $mousemap_{'time_'},
''		=> ['msg mousetxt', 'report the mouse event'],
);
@mousemap_test = &akeys(@mousemap_test);

###############################################################################
## Subroutines ################################################################

sub onrestart { 1 }
sub onquit    { 1 }

sub cfgcolorlong {
	local $_ = join('', @_); my $s;
	($s = &rccolorlong($_)) ne '' && ($_ = $s) if defined &rccolorlong;
	return &colorlongline($_, $co_error)
		if $long =~ /^\s*md5sum\b/	&& ! /^\\?[0-9a-f]*\\?$/i;
	return &colorlongline($_, $co_msg)
		if $long =~ /^\s*rpm\b/		&&   /is ?n[o']t owned/i;
	return &colorlongline($_, $co_error)
		if $long =~ /^\s*;.*mimetype\b/ &&   /Can ?n?['o]t stat/i;
	s/^([^\s,;]*)(\/)([^\s,;]*)(,\s*)?([^;]*)(;\s*)?(.*)/
		&color($1, $co_ftype) . $2 .
		&color($3, $co_myper) . $4 .
		&color($5, $co_sbits) . $6 .
		&color($7, $co_perms)/e if $long =~ /^\s*;.*mimetype/;
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

sub cfg::nextset {
	my $s = ($altls == \@cfg::set1) ? 1 : ($altls == \@cfg::set2) ? 2 :
		($altls == \@cfg::set3) ? 3 : ($altls == \@cfg::set4) ? 4 : 0;
	($s + ((defined $_[0]) ? $_[0] : 1)) % 5;
}

sub cfg::maketargets {
	my %targets = ();
	foreach my $makefile (@cfg::makefiles ? @cfg::makefiles
					      : ('makefile', 'Makefile')) {
		next unless open(MAKEFILE, $makefile);
		while (<MAKEFILE>) {
			next unless /^[^\t#].*:/;
			chomp; s/:.*//; $targets{$_}++;
		}
		close MAKEFILE;
	}
	sort keys %targets;
}

###############################################################################
## Personal configuration #####################################################

$vshnurc = $ENV{VSHNURC} || $default_vshnurc ||
	   ((-f "$ENV{HOME}/.vshnurc") ? "$ENV{HOME}/.vshnurc" : 'vshnurc.pl');
(-r _) ? do { do $vshnurc; &err($@) } : &err("Cannot read $vshnurc")
	if -f $vshnurc;

1;
