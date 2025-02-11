package FFConstants;

#FFConstants -- arm's length, STATIC version of FF for COLLIDER
#2010_04_01 -- pfs -- adapted from FF.pm to supply STATIC methods
# see old/FF for stuff that may need to be put in a dynamic helper
#
#2011_04_11 consolidate historical depts
#2013_08_23 -- put in DEP MYSTUFF routine
#2013_09_02 -- fix Senior/Junior
#2015_10_29 -- ADD ZZ83
#2016_07_23 -- ADD CAPSULE TAKES, in both uc and lc
#2016_07_23a -- ADD JAZZ in uc
#2017_07_12 -- move FILM to zz81; this is partially done in unifyMapLongfiles.pl
#2017_07_13 -- move Shows to zz81 (pile up on Bollywood)
#2017_07_13a -- move Pop to zz81 (pile up on Bollywood)
#2017_07_14 -- move Film to zz81 (pile up on Bollywood)

use 5.018002;	# I'm using 5.18.2 to develop this

use strict;
no strict 'refs';
use utf8;
use charnames qw/:full/;
binmode STDOUT, ":utf8";

#################### MODULE DIRECTORY ####################
#peter@sam:~/fanfare/factory/ACTIVE/perllib$ grep "^sub " FFConstants.pm | sed -e "s/^/# /; s/ *[{}]//; "
# sub MYSTUFF
# sub issueData
# sub docSourceAttributes
# sub departmentTextByCode
# sub departmentCodeByText
# sub includeDepartmentInvocation
# sub SIGLINEorBYLINEbyInvocation
# sub STARZorASTERZbyInvocation

##########################################################

#####################################################################
#GLOBALS -- THESE ARE DEFINITIVE
#####################################################################
my %departmentTextByCode = (
  # A-Z => COMPOSERS, but look for mistakenly uppercased zz codes first
  "a" => "Letters",
  "1" => "Feature Articles",
  "aa" => "Feature Articles",
  "aaa" => "Want List",
  "az" => "Classical Recordings",	# pete's pseudo-class for [A-Z]
  "zz" => "Collections",	# 2006_11_24 -- it happens, make it legal
  "zz1" => "Collections: Vocal",
  "zz2" => "Collections: Choral",
  "zz3" => "Collections: Early",
  "zz4" => "Collections: Instrumental",
  "zz5" => "Collections: Ensemble",
  "zz6" => "Collections: Orchestral",
  "zz7" => "Collections: Miscellaneous",
  "zz71" => "New Music",
  "zz72" => "Shows",
  "zz8" => "DVDs",
  "zz80" => "DVDs",
  "zz81" => "Bollywood and Beyond",
  "zz82" => "Jazz",
#2015_10_29 -- ADD ZZ83
  "zz83" => "Slightly Off the Beat",
  "zz91" => "Film",
  "zzhf" => "Hall of Fame",
  "zzcc" => "Critics Corner",
  "zzbk" => "Book Reviews",
);# %departmentTextByCode

my %departmentCodeByText = (
  "Letters" => "a",
  "Feature Articles" => "aa",
  "Want List" => "aaa",
  "Classical Recordings" => "az",	# pete's pseudoclass for [A-Z]
  "Composers" => "az",	# pete's pseudoclass for [A-Z]
  'Collections' => 'zz1',
  "Collections: Vocal" => "zz1",
  "Vocal" => "zz1",
  "Collections: Choral" => "zz2",
  "Choral" => "zz2",
  "Collections: Early" => "zz3",
  "Early Music" => "zz3",
  "Collections: Instrumental" => "zz4",
  "Instrumental" => "zz4",
  "Collections: Ensemble" => "zz5",
  "Ensemble" => "zz5",
  "Collections: Orchestral" => "zz6",
  "Orchestral" => "zz6",
  "Collections: Miscellaneous" => "zz7",
  "Miscellaneous" => "zz7",
  #"New Music" => "zz71",	#2011_04_11 consolidate historical depts
  #"Shows" => "zz72",
  "New Music" => "az",
#2017_07_13 -- move Shows to zz81 (pile up on Bollywood)
  "Shows" => "zz81",
  "DVDs" => "zz80",
  "Videos" => 'zz80',
  "Video Review" => 'zz80',
  "Bollywood and Beyond" => "zz81",
  "Jazz" => "zz82",
#2016_07_23a -- ADD JAZZ in uc
  "JAZZ" => "zz82",
  "More Jazz" => "zz82",
  "The Jazz Column" => "zz82",
  "Jazz Column" => "zz82",
#2016_07_23 -- ADD CAPSULE TAKES, in both uc and lc
  "CAPSULE TAKES" => "zz82",
  "Capsule Takes" => "zz82",
#2015_10_29 -- ADD ZZ83
  "Slightly Off the Beat" => "aa",
#2017_07_12 -- move FILM to zz81; this is partially done in unifyMapLongfiles.pl
#2017_07_14 -- move Film to zz81 (pile up on Bollywood)
  #Film" => "zz91",
  "Film" => "zz81",
  "Technofile" => "aa",
  "The Common-Sense Audiophile" => "aa",
  "Past Music Present" => "aa",
  'The Historical Record' => 'aa',
#2017_07_13a -- move Pop to zz81 (pile up on Bollywood)
  'POPCORNer' => 'zz81',
  'More Pop' => 'zz81',
  'Lend an Ear... From One Serious Collector to Another' => 'aa',
  'Random Noise' => 'aa',
  'New for Audiophiles' => 'aa',
  'On the Air' => 'aa',
  'Letter from Germany' => 'aa',
  'European Opera for the Record' => 'aa',
  'More Features and Interviews' => 'aa',
#2017_07_13 -- move Shows to zz81 (pile up on Bollywood)
  'More Shows' => 'zz81',
  'FOO' => 'foo',
  'FOO' => 'foo',
  'FOO' => 'foo',

  "Film Musings" => "zz91",
  "Film Music" => "zz91",
  "More Film Music" => "zz91",
  "Soundtracks" => "zz91",
  "Book Reviews" => "zzbk",
  "Book Review" => "zzbk",
  "Hall of Fame" => "zzhf",
  'Classical Hall of Fame' => 'zzhf',
  "Critics Corner" => "zzcc",
  "Critics' Corner" => "zzcc",
  'Critics&rsquo; Corner' => 'zzcc',
); # %departmentCodeByText

# 2008_11_24 -- department invocations

#2008_11_18 -- add %includeDepartmentInvocation HARVEST FOR PROMETHEUS
my %includeDepartmentInvocation = (
  "Letters" => '0',
  "Feature Articles" => '0',
  "Want List" => '0',
  "Classical Recordings" => '0',
  "Composers" => '0',
  'Collections' => '0',
  "Collections: Vocal" => '0',
  "Vocal" => '0',
  "Collections: Choral" => '0',
  "Choral" => '0',
  "Collections: Early" => '0',
  "Early Music" => '0',
  "Collections: Instrumental" => '0',
  "Instrumental" => '0',
  "Collections: Ensemble" => '0',
  "Ensemble" => '0',
  "Collections: Orchestral" => '0',
  "Orchestral" => '0',
  "Collections: Miscellaneous" => '0',
  "Miscellaneous" => '0',
  "New Music" => '1',
  "Shows" => '1',
  "DVDs" => '0',
  "Videos" => '0',
  "Video Review" => '0',
  "Bollywood and Beyond" => '0',
  "Jazz" => '0',
  "JAZZ" => '0',
  "More Jazz" => '0',
  "The Jazz Column" => '1',
  "Jazz Column" => '1',
  "CAPSULE TAKES" => '1',
  "Capsule Takes" => '1',
#2015_10_29 -- ADD ZZ83
  "Slightly Off the Beat" => '1',
  "Film" => '0',
  "Technofile" => '1',
  "The Common-Sense Audiophile" => '1',
  "Past Music Present" => '1',
  'The Historical Record' => '1',
  'POPCORNer' => '1',
  'More Pop' => '1',
  'Lend an Ear... From One Serious Collector to Another' => '1',
  'Random Noise' => '1',
  'New for Audiophiles' => '1',
  'On the Air' => '1',
  'Letter from Germany' => '1',
  'European Opera for the Record' => '1',
  'More Features and Interviews' => '0',
  'More Shows' => '0',
  'FOO' => 'foo',
  'FOO' => 'foo',
  'FOO' => 'foo',

  "Film Musings" => '1',
  "Film Music" => "0",
  "More Film Music" => "0",
  "Soundtracks" => "0",
  "Book Reviews" => '0',
  "Book Review" => '0',
  "Hall of Fame" => '0',
  'Classical Hall of Fame' => '0',
  "Critics Corner" => '0',
  "Critics' Corner" => '0',
  'Critics&rsquo; Corner' => '0',
);# %includeDepartmentInvocation


#2010_10_19 -- SIGLINEorBYLINEbyInvocation
my %SIGLINEorBYLINEbyInvocation = (
  "Letters" => '',
  "Feature Articles" => 'BYLINE',
  "Want List" => 'WANT_BYLINE',
  "Classical Recordings" => 'SIGLINE',
  "Composers" => 'SIGLINE',
  'Collections' => 'SIGLINE',
  "Collections: Vocal" => 'SIGLINE',
  "Vocal" => 'SIGLINE',
  "Collections: Choral" => 'SIGLINE',
  "Choral" => 'SIGLINE',
  "Collections: Early" => 'SIGLINE',
  "Early Music" => 'SIGLINE',
  "Collections: Instrumental" => 'SIGLINE',
  "Instrumental" => 'SIGLINE',
  "Collections: Ensemble" => 'SIGLINE',
  "Ensemble" => 'SIGLINE',
  "Collections: Orchestral" => 'SIGLINE',
  "Orchestral" => 'SIGLINE',
  "Collections: Miscellaneous" => 'SIGLINE',
  "Miscellaneous" => 'SIGLINE',
  "New Music" => 'SIGLINE',
  "Shows" => 'SIGLINE',
  "DVDs" => 'SIGLINE',
  "Videos" => 'SIGLINE',
  "Video Review" => 'SIGLINE',
  "Bollywood and Beyond" => 'SIGLINE',
  "Jazz" => 'SIGLINE',
  "JAZZ" => 'SIGLINE',
  "More Jazz" => 'SIGLINE',
  "The Jazz Column" => 'BYLINE',
  "Jazz Column" => 'BYLINE',
  "CAPSULE TAKES" => 'BYLINE',
  "Capsule Takes" => 'BYLINE',
#2015_10_29 -- ADD ZZ83
  "Slightly Off the Beat" => 'BYLINE',
  "Film" => 'SIGLINE',
  "Technofile" => 'BYLINE',
  "The Common-Sense Audiophile" => 'BYLINE',
  "Past Music Present" => 'BYLINE',
  'The Historical Record' => 'BYLINE',
  'POPCORNer' => 'BYLINE',
  'More Pop' => 'SIGLINE',
  'Lend an Ear... From One Serious Collector to Another' => 'BYLINE',
  'Random Noise' => 'BYLINE',
  'New for Audiophiles' => 'BYLINE',
  'On the Air' => 'BYLINE',
  'Letter from Germany' => 'BYLINE',
  'European Opera for the Record' => 'BYLINE',
  'More Features and Interviews' => 'BYLINE',
  'More Shows' => 'SIGLINE',
  'FOO' => 'foo',
  'FOO' => 'foo',
  'FOO' => 'foo',

  "Film Musings" => 'BYLINE',
  "Film Music" => "SIGLINE",
  "More Film Music" => "SIGLINE",
  "Soundtracks" => "SIGLINE",
  "Book Reviews" => 'SIGLINE',
  "Book Review" => 'SIGLINE',
  "Hall of Fame" => 'SIGLINE',
  'Classical Hall of Fame' => 'SIGLINE',
  "Critics Corner" => 'SIGLINE',
  "Critics' Corner" => 'SIGLINE',
  'Critics&rsquo; Corner' => 'SIGLINE',
);# %SIGLINEorBYLINEbyInvocation

#2010_10_19 -- STARZorASTERZbyInvocation
my %STARZorASTERZbyInvocation = (
  "Letters" => '',
  "Feature Articles" => 'ASTERZ',
  "Want List" => 'ASTERZ',
  "Classical Recordings" => 'STARZ',
  "Composers" => 'STARZ',
  'Collections' => 'STARZ',
  "Collections: Vocal" => 'STARZ',
  "Vocal" => 'STARZ',
  "Collections: Choral" => 'STARZ',
  "Choral" => 'STARZ',
  "Collections: Early" => 'STARZ',
  "Early Music" => 'STARZ',
  "Collections: Instrumental" => 'STARZ',
  "Instrumental" => 'STARZ',
  "Collections: Ensemble" => 'STARZ',
  "Ensemble" => 'STARZ',
  "Collections: Orchestral" => 'STARZ',
  "Orchestral" => 'STARZ',
  "Collections: Miscellaneous" => 'STARZ',
  "Miscellaneous" => 'STARZ',
  "New Music" => 'STARZ',
  "Shows" => 'STARZ',
  "DVDs" => 'STARZ',
  "Videos" => 'STARZ',
  "Video Review" => 'STARZ',
  "Bollywood and Beyond" => 'STARZ',
  "Jazz" => 'ASTERZ',
  "JAZZ" => 'ASTERZ',
  "More Jazz" => 'ASTERZ',
  "The Jazz Column" => 'ASTERZ',
  "Jazz Column" => 'ASTERZ',
  "CAPSULE TAKES" => 'ASTERZ',
  "Capsule Takes" => 'ASTERZ',
#2015_10_29 -- ADD ZZ83
  "Slightly Off the Beat" => 'ASTERZ',
  "Film" => 'ASTERZ',
  "Technofile" => 'ASTERZ',
  "The Common-Sense Audiophile" => 'ASTERZ',
  "Past Music Present" => 'ASTERZ',
  'The Historical Record' => 'ASTERZ',
  'POPCORNer' => 'ASTERZ',
  'More Pop' => 'STARZ',
  'Lend an Ear... From One Serious Collector to Another' => 'ASTERZ',
  'Random Noise' => 'ASTERZ',
  'New for Audiophiles' => 'ASTERZ',
  'On the Air' => 'ASTERZ',
  'Letter from Germany' => 'ASTERZ',
  'European Opera for the Record' => 'ASTERZ',
  'More Features and Interviews' => 'ASTERZ',
  'More Shows' => 'ASTERZ',
  'FOO' => 'foo',
  'FOO' => 'foo',
  'FOO' => 'foo',

  "Film Musings" => 'ASTERZ',
  "Film Music" => "STARZ",
  "More Film Music" => "STARZ",
  "Soundtracks" => "STARZ",
  "Book Reviews" => 'STARZ',
  "Book Review" => 'STARZ',
  "Hall of Fame" => 'STARZ',
  'Classical Hall of Fame' => 'STARZ',
  "Critics Corner" => 'ASTERZ',
  "Critics' Corner" => 'ASTERZ',
  'Critics&rsquo; Corner' => 'ASTERZ',
);#

#####################################################################
#METHODS
#####################################################################

# sub MYSTUFF
#@newLines = &MYSTUFF(@newLines);
sub MYSTUFF {
  my (@newLines) = @_;

  #2013_09_02 -- fix Senior/Junior
  foreach my $t (@newLines) {
      if ($t =~ /ARIAL/) {
	      if ($t =~ s/,(\s+[JS]r[\W]?)/$1/ ) {
		      #warn "JUNIOR: $t\n";
		}
	}

  #2007_12_02 -- garbled Extras to &amp;
  $t =~ s%(<span class='ARIAL12b?i?'>\s*)Sö%$1&amp;%g;

  #2007_12_03 -- characteristic garbles
  $t =~ s%(<span class='ARIAL12'>.*)\(et\)%$1(ct)%g;	# countertenors
  $t =~ s%(<span class='ARIAL12'>.*)\(ve\)%$1(vc)%g;	# cellists
  $t =~ s%(<span class='ARIAL12'>.*)\(It\)%$1(lt)%g;	# lutes
  $t =~ s%(<span class='ARIAL12'>.*)\(Pere\)%$1(Perc)%g;	# percussion

  #2007_07_19 -- get the martinu junufa u-circle right in both cases
  $t =~ s/˚U/Ů/g;
  $t =~ s/U˚/Ů/g;
  $t =~ s/u˚/ů/g;
  $t =~ s/˚u/ů/g;

  #2008_01_20 -- IVANČI´C
  $t =~ s/´C/Ć/g;
  $t =~ s/´c/ć/g;

  #2008_05_22 -- Elena Moşuc (Romanian)
  $t =~ s/s¸/ş/g;
  $t =~ s/S¸/Ş/g;

  #2008_08_29 -- correct always-wrong ď to d
  $t =~ s/ď/d/g;



  #2008_08_26 -- guard better against db vs d<FLAT> (DO ONLY in chilled monodoc corrections)
  #2008_09_10 -- more tweaks on mis-scanned <FLAT> and <SHARP>

  $t =~ s%([iI])n ([aAbBdDeE])b([,.; <])%$1n $2<FLAT>$3%g;	# scanned flats Eb
  $t =~ s%([iI])n ?([cCfF])[\#]([,.; <])%$1n $2<SHARP>$3%g;	# scanned sharps
  $t =~ s%([iI])n ?([aAbBdDeE]).&gt;([,.; <])%$1n $2<FLAT>$3%g;	# scanned flats Et&gt;
  $t =~ s%([iI])n ?([cCfF])if([,.; <])%$1n $2<SHARP>$3%g;	# scanned sharps Cif

  #2008_06_27 -- correct run-on words
  $t =~ s/(\b)ifit(\b)/$1if it$2/ig;
  $t =~ s%ofthat%of that%g;	# ofthat
  $t =~ s%fugai%fugal%g;	# fugai
  $t =~ s%\(pere\)%\(perc\)%g;	# percussion

  # correct scanned syllable glitches
  $t =~ s/(\b)tenn(\b)/$1term$2/ig;
  $t =~ s/(\b)fonn(\b)/$1form$2/ig;

  #9837 266D ♭ MUSIC FLAT SIGN;So;0;ON;;;;;N;FLAT;;;;
  #9838 266E ♮ MUSIC NATURAL SIGN;So;0;ON;;;;;N;NATURAL;;;;
  #9839 266F ♯ MUSIC SHARP SIGN;Sm;0;ON;;;;;N;SHARP;;;;
    $t =~ s/<sharp>/♯/gi;
    $t =~ s/<flat>/♭/gi;
    $t =~ s/<natural>/♮/gi;

  }# each line

  
  return (@newLines);

}# end of &MYSTUFF();



#my ($issue, $months, $year, $sortable ) = &issueData($serNum);
# e.g. ("28:5", "May/June", "2005", "2005_05") = &issueData("285123");
# 2006_07_06 -- addded the fourth sortable string to return
sub issueData {
  my ($serNum) = @_;
  my $vol = 0;
  my $iss = 0;

  my $baseYear = 1976;
  my %months = (
    "1" => "Sept/Oct",
    "2" => "Nov/Dec",
    "3" => "Jan/Feb",
    "4" => "Mar/Apr",
    "5" => "May/June",
    "6" => "July/Aug",
  );
  my %monthDigits = (
    "1" => "09",
    "2" => "11",
    "3" => "01",
    "4" => "03",
    "5" => "05",
    "6" => "07",
  );
  if ($serNum =~ /^(\d\d)(\d)/) {	# e.g. 285
    $vol = $1;
    $iss = $2;
  }
  
  my $month = $months{$iss};
  my $monthDigits = $monthDigits{$iss};

  my $year = $baseYear + $vol;
  $year+=1 if ($iss >= 3);

  my $issueString = "$vol:$iss";
  my $sortable = "$year" . "_" . "$monthDigits";

  return ($issueString, $month, $year, $sortable);

} # end of issueData()

#my ($sourceProvider, $docGenerator, $headnoteVersionMajor, $headnoteVersionMinor, $footerVersion, $sigVersion) = FF::docSourceAttributes($vvi);

sub docSourceAttributes {
  my ($vvi) = @_;
  my %attributesByVVI = (
    #'vvi' => "WHO	GEN	HN_MAJ	HN_MIN	FOOTER	SIGLINE",

    # Pete and Celeste Territory

    '146' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",

    '151' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '152' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '153' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '154' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '155' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '156' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",

    '161' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '162' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '163' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '164' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '165' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '166' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",

    '171' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '172' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '173' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '174' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '175' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '176' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",

    '181' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '182' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '183' => "CHOF_ONLY	ABBYY	-1	0	NNN	SIGLINE",
    '184' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '185' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '186' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",

    '191' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '192' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '193' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '194' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '195' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '196' => "CELESTE	ABBYY	-1	0	FULL	SIGLINE",

    '201' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '202' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '203' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '204' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '205' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '206' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",

    '211' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '212' => "CHOF_ONLY	ABBYY	-1	0	FULL	SIGLINE",
    '213' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '214' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '215' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '216' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",

    '221' => "CELESTE	ABBYY	-1	0	FULL	SIGLINE",
    '222' => "CELESTE	ABBYY	-1	0	FULL	SIGLINE",
    '223' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '224' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '225' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '226' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",

    '231' => "CELESTE	ABBYY	-1	0	FULL	SIGLINE",
    '232' => "CELESTE	ABBYY	-1	0	FULL	SIGLINE",
    '233' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '234' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '235' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '236' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",

    '241' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '242' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '243' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '244' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '245' => "TOM	ABBYY	0	0	FULL	SIGLINE",
    '246' => "CHOF_ONLY	ABBYY	0	0	FULL	SIGLINE",

    # Tom Spence Territory

    #'246' => "TOM	ABBYY	0	0	FULL	SIGLINE",

    '251' => "TOM	ABBYY	0	0	FULL	SIGLINE",
    '252' => "TOM	ABBYY	0	0	FULL	SIGLINE",
    '253' => "TOM	ABBYY	0	0	FULL	SIGLINE",
    '254' => "TOM	ABBYY	0	0	FULL	SIGLINE",
    '255' => "TOM	ABBYY	0	0	FULL	SIGLINE",
    '256' => "TOM	ABBYY	0	0	FULL	SIGLINE",

    '261' => "RUTH	MS	0	0	FULL	SIGLINE",
    '262' => "RUTH	MS	0	0	FULL	SIGLINE",
    '263' => "CELESTE	ABBYY	0	0	FULL	SIGLINE",
    '264' => "RUTH	MS	0	0	FULL	SIGLINE",
    '265' => "RUTH	MS	0	0	FULL	SIGLINE",
    '266' => "RUTH	MS	0	0	FULL	SIGLINE",

    '271' => "RUTH	MS	0	0	FULL	SIGLINE",
    '272' => "RUTH	MS	0	0	FULL	SIGLINE",
    '273' => "RUTH	MS	0	0	FULL	SIGLINE",
    '274' => "RUTH	MS	0	0	FULL	SIGLINE",
    '275' => "RUTH	MS	0	0	FULL	SIGLINE",
    '276' => "RUTH	MS	0	0	FULL	SIGLINE",

    '281' => "RUTH	MS	0	0	FULL	SIGLINE",
    '282' => "RUTH	MS	0	0	FULL	SIGLINE",
    '283' => "RUTH	MS	0	0	FULL	SIGLINE",
    '284' => "RUTH	MS	0	0	FULL	SIGLINE",
    '285' => "RUTH	MS	0	0	FULL	SIGLINE",
    '286' => "RUTH	MS	0	0	FULL	SIGLINE",

    '291' => "RUTH	MS	0	0	FULL	SIGLINE",
    '292' => "RUTH	MS	0	0	FULL	SIGLINE",
    '293' => "RUTH	MS	0	0	FULL	SIGLINE",
    '294' => "RUTH	MS	0	0	FULL	SIGLINE",
    '295' => "RUTH	MS	0	0	FULL	SIGLINE",
    '296' => "RUTH	MS	0	0	FULL	SIGLINE",

    # Carolyn Territory

    '301' => "RUTH	MS	0	0	FULL	SIGLINE",
    '302' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '303' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '304' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '305' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '306' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",

    '311' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '312' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '313' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '314' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '315' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '316' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",

    '321' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '322' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '323' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '324' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '325' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '326' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",

    '331' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '332' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '333' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '334' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '335' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '336' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",

    '341' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '342' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '343' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '344' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '345' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",
    '346' => "CAROLYN	QUARK	0	0	FULL	SIGLINE",



  );

  my ($sourceProvider, $docGenerator, $headnoteVersionMajor, $headnoteVersionMinor, $footerVersion, $sigVersion) = split(/\s*\t\s*/, $attributesByVVI{$vvi});

  unless ($sourceProvider) {	# if vvi needs declaration above
    die "ISSUE \[$vvi\] NEEDS SOURCE DOC ATTRBUTES DEFINED IN FFConstants->sourceDocAttributes(vvi)\n";
  }

  return ($sourceProvider, $docGenerator, $headnoteVersionMajor, $headnoteVersionMinor, $footerVersion, $sigVersion);

}# end of docSourceAttributes();

#my %departmentTextByCode = &FFConstants::departmentTextByCode();
sub departmentTextByCode {
  # STATIC NO ARGS();

  return (%departmentTextByCode);

}# end of &departmentTextByCode();

#my %departmentCodeByText = &FFConstants::departmentCodeByText();
sub departmentCodeByText {
  # STATIC NO ARGS();

  return (%departmentCodeByText);

}# end of &departmentCodeByText();

#my %includeDepartmentInvocation = &FFConstants::includeDepartmentInvocation();
sub includeDepartmentInvocation {
  # STATIC NO ARGS();

  return (%includeDepartmentInvocation);

}# end of &includeDepartmentInvocation();

#my %SIGLINEorBYLINEbyInvocation = &FFConstants::SIGLINEorBYLINEbyInvocation();
sub SIGLINEorBYLINEbyInvocation {
  # STATIC NO ARGS();

  return (%SIGLINEorBYLINEbyInvocation);

}# end of &SIGLINEorBYLINEbyInvocation();

#my %STARZorASTERZbyInvocation = &FFConstants::STARZorASTERZbyInvocation();
sub STARZorASTERZbyInvocation {
  # STATIC NO ARGS();

  return (%STARZorASTERZbyInvocation);

}# end of &STARZorASTERZbyInvocation();

###################### END OF MODULE ##########################
1
