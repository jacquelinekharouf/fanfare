package FFATLASSyntax;
#2009_06_14 -- new
# 2009_11_11 -- LFName cannot be '_'
# 2009_11_28 -- specific attrs for CATALOG data
# 2010_01_28 -- thingsyn formats: three forms
  #<expr class='FFS_REC_CATALOG' recid='emi_CD_06626' lfname='EMI_CD_06626 ' syntype='catalog' thingsyn='emi_CD_06626' assert=''>06626 </expr>
  #<expr class='FFS_PR_INSTRUMENTALIST' pnid='firkusny_rudolf' lfname='Firkušný_Rudolf' syntype='instrumentalist' thingsyn='rudolffirkusny' sup='' assert=''>Rudolf Firkušny </expr>
  #<expr class='FFIS_WORK_PNID' cwid='fischer_j_choralherzlichtutmichverlangen' lfname='FISCHER_J._Choral, "Herzlich tut mich verlangen"' syntype='works' thingsyn='jfischer_choralherzlichtutmichverlangen' sup='' assert=''>Choral, "Herzlich tut mich verlangen"</expr>

#2010_04_27 -- allow numerical LFNames
#2010_05_07 -- remove nbsp from name0 and name1
#2010_06_12 -- CWID now uses : to join -- composerPNID : workThingSyn
#2010_06_12 -- CWID now allows [/-] in workThingSyn for op 33/1
#2010_06_12 -- add method decodeCWID();
#2010_06_13 -- work LFName is now split by :, not _
#2011_02_14 -- city now a legal syntype
#2011_07_27 -- eliminate trailing [;,] from nice name
#2011_07_30 -- trims nice name
#2011_10_25 -- wlens now a legal syntype

########################### METHOD INDEX ###########################
# sub synTypeOfExpr
# sub isXIDExpr
# sub encodePRPairExpr
# sub decodeXIDExpr
# sub encodeXIDExpr
# sub genNumsThingSyn
# sub genMediumThingSyn
# sub genCatalogLFName
# sub genTHINGSYNFlatName
# sub genThingSyn		# FFATLASXIDs
# sub genWorksThingSyn
# sub genPNID
# sub genCWID
# sub decodeCWID
# sub genRECID
# sub getName1FromText
# sub genWorkLFName
# sub legalizeValidityCode	# FFATLASXIDs
# sub getExprValidityText	# FFATLASXIDs
# sub XIDFromScratch		# FFATLASXIDs
# sub cleanLFName
# sub trims
# sub trimW
# sub niceNameFromLFName	# FFChunkyIssues
# sub niceNameFromWorkLFName	# FFChunkyIssues
# sub comeToJesus
# sub murmurToJesus

########################### METHOD INDEX ###########################

use 5.008008;	# I'm using 5.8.8 to develop this
use strict;
no strict 'refs';
use utf8;
use vars qw{
	@ISA
	@EXPORT
	@EXPORT_OK
	%EXPORT_TAGS
	$VERSION

	%XMLAttr2selfAttr
	%selfAttr2XMLattr
	%LEGAL_EXPR_FORMATS
	%LEGAL_EXPR_CLASSES
	%synTypesOfBasicExprClasses
	@LEGAL_SYN_TYPES
	%synTypesOfBasicExprClasses
	%mustExistFlags
	%synType_is_person
	%ensembleAbbreviations
	};
use charnames qw/:full/;

use Exporter;
$VERSION = 1.0;		# pfs -- 2009_06_14 -- initial version

@ISA = qw{Exporter};
@EXPORT_OK = qw{ 
		%XMLAttr2selfAttr
		%selfAttr2XMLattr
		%LEGAL_EXPR_FORMATS
		%LEGAL_EXPR_CLASSES
		@LEGAL_SYN_TYPES 
		%synTypesOfBasicExprClasses
		%mustExistFlags 
		%synType_is_person 
		};

# MODULES
use FFUTF;
use Carp;

#####################################################################
#GLOBALS -- GENERAL
#####################################################################

%LEGAL_EXPR_FORMATS = (
  'SHORT' => [ 'class' ],
  'PNID' => [ 'class', 'pnid', 'lfname', 'syntype', 'thingsyn', 'sup', 'assert' ],
  'CWID' => [ 'class', 'cwid', 'lfname', 'syntype', 'thingsyn', 'sup', 'assert' ],
  'RECID' => [ 'class', 'recid', 'lfname', 'syntype', 'thingsyn', 'sup', 'assert' ],
);

%selfAttr2XMLattr = (
  'PNID' => 'pnid',
  'CWID' => 'cwid',
  'RECID' => 'recid',
  #'LABELPNID' => 'labelpnid',
  #'NUMPARTS' => 'numparts',
  #'MEDIUM' => 'medium',
  #'COMPOSERPNID' => 'composerpnid',
  'LFNAME' => 'lfname',
  'THINGSYN' => 'thingsyn',
  'SYNTYPE' => 'syntype',
  'SUP' => 'sup',
  'ASSERT' => 'assert',
); # manually keep in sync with....
%XMLAttr2selfAttr = (
  'pnid' => 'PNID',
  'cwid' => 'CWID',
  'recid' => 'RECID',
  #'labelpnid' => 'LABELPNID',
  #'numparts' => 'NUMPARTS',
  #'medium' => 'MEDIUM',
  #'composerpnid' => 'COMPOSERPNID',
  'lfname' => 'LFNAME',
  'syn' => 'THINGSYN',	# compatibility
  'thingsyn' => 'THINGSYN',
  'syntype' => 'SYNTYPE',
  'sup' => 'SUP',
  'assert' => 'ASSERT',
);

%LEGAL_EXPR_CLASSES = (
  'FFIS_ARTICLE_AUTHOR' => "PNID;AM",
  'FFIS_ARTICLE_AUTHOR_REQUIRED_NEW' => "PNID;AM",
  'FFIS_ARTICLE_CLOSE_EVENT' => "SHORT;AM",
  'FFIS_ARTICLE_CLOSE_INVOCATION' => "SHORT;AM",
  'FFIS_ARTICLE_CLOSE_OK' => "SHORT;AM",
  'FFIS_ARTICLE_CLOSE_REGIME' => "SHORT;AM",
  'FFIS_ARTICLE_DEPTCODE' => "SHORT;AM",
  'FFIS_ARTICLE_INTRODUCER_EVENT' => "SHORT;AM",
  'FFIS_ARTICLE_INTRODUCER_INVOCATION' => "SHORT;AM",
  'FFIS_ARTICLE_INTRODUCER_REGIME' => "SHORT;AM",
  'FFIS_ARTICLE_OPEN_OK' => "SHORT;AM",
  'FFIS_ARTICLE_SERNUM' => "SHORT;AM",
  'FFIS_ARTICLE_TITLE' => "SHORT;AM",
  'FFIS_ARTICLE_TITLE_TOKEN' => "SHORT;AM",
  'FFIS_ORIGINAL_DOCID' => "SHORT;AM",
  #'FFIS_ORIG_DOCID' => "SHORT;AM",
  'FFIS_DEPARTMENT_INVOCATION' => 1,
  'FFIS_DEPARTMENT_NAME' => 1,
  'FFIS_FEATURE_AUTHOR' => 1,
  'FFIS_FEATURE_LABEL' => 1,
  'FFIS_FEATURE_PERFORMER' => 1,
  'FFIS_FEATURE_ROLE' => 1,
  'FFIS_FEATURE_TITLE' => 1,
  'FFIS_ISSUE_DOC_GENERATOR' => 1,
  'FFIS_ISSUE_FOOTER_VERSION' => 1,
  'FFIS_ISSUE_HEADNOTE_VERSION_MAJOR' => 1,
  'FFIS_ISSUE_HEADNOTE_VERSION_MINOR' => 1,
  'FFIS_ISSUE_ISSUE_STRING' => 1,
  'FFIS_ISSUE_MONTHS_STRING' => 1,
  'FFIS_ISSUE_RECAPTURE_VERSION' => 1,
  'FFIS_ISSUE_REEXPR_VERSION' => 1,
  'FFIS_ISSUE_SCHEMA_LEVEL' => 1,
  'FFIS_ISSUE_SIG_VERSION' => 1,
  'FFIS_ISSUE_SORTABLE' => 1,
  'FFIS_ISSUE_SOURCE_PROVIDER' => 1,
  'FFIS_ISSUE_SYNTAX_LEVEL' => 1,
  'FFIS_ISSUE_VVI' => 1,
  'FFIS_ISSUE_YEAR_STRING' => 1,
  'FFIS_WORK_PNID' => "CWID;CW",
  'FFIS_WORK_PNID_MAYBE' => "CWID;CW",
  'FFIS_WORK_PNID_NEW' => "CWID;CW",
  'FFS_ARTICLE_BYLINE' => 1,
  'FFS_ARTICLE_TITLE' => 1,
  'FFS_BOOK_DATA' => 1,
  'FFS_BOOK_TITLE' => 1,
  'FFS_BULLET_PR' => 1,
  'FFS_BULLET_REC' => 1,
  'FFS_CLIST_FILLER' => "SHORT;CW",
  'FFS_CLIST_TYPE' => "SHORT;CW",
  'FFS_COMPOSER' => "PNID;CW",
  'FFS_COMPOSER_EDITION' => "SHORT;CW",
  'FFS_COMPOSER_LIST_PREFIX' => "SHORT;CW",
  'FFS_COMPOSER_MAYBE' => "PNID;CW",
  'FFS_COMPOSER_NEW' => "PNID;CW",
  'FFS_COMPOSER_SUPER' => "SHORT;CW",
  'FFS_DISK_NUM' => "SHORT;CW",
  'FFS_EXTRAS' => "SHORT;CW;PR",
  'FFS_EXTRAS_CONTENT' => "SHORT;PR",
  'FFS_EXTRAS_CONTENT_B' => 1,
  'FFS_EXTRAS_CONTENT_BI' => 1,
  'FFS_EXTRAS_CONTENT_COMPOSER' => 1,
  'FFS_EXTRAS_CONTENT_I' => 1,
  'FFS_EXTRAS_CONTENT_SUPER' => 1,
  'FFS_PR_ENSEMBLE' => 1,
  'FFS_PR_ENSEMBLE_MAYBE' => "PNID;PR",
  'FFS_PR_ENSEMBLE_NEW' => "PNID;PR",
  'FFS_PR_ENSEMBLE' => "PNID;PR",
  'FFS_PR_INSTRUMENT' => "PNID;PR",
  'FFS_PR_INSTRUMENTALIST_MAYBE' => "PNID;PR",
  'FFS_PR_INSTRUMENTALIST_NEW' => "PNID;PR",
  'FFS_PR_INSTRUMENTALIST' => "PNID;PR",
  'FFS_PR_INSTRUMENT_MAYBE' => "PNID;PR",
  'FFS_PR_INSTRUMENT_PUNCT' => "SHORT;PR",
  'FFS_PR_INSTRUMENT_REQUIRED_NEW' => "PNID;PR",
  'FFS_PR_LEADER' => "PNID;PR",
  'FFS_PR_LEADER_MAYBE' => "PNID;PR",
  'FFS_PR_LEADERMODE' => "PNID;PR",
  'FFS_PR_LEADERMODE_REQUIRED_NEW' => "PNID;PR",
  'FFS_PR_LEADER_NEW' => "PNID;PR",
  'FFS_PR_PERFORMER' => "PNID;PR",
  'FFS_PR_PERFORMER_MAYBE' => "PNID;PR",
  'FFS_PR_PERFORMER_NEW' => "PNID;PR",
  'FFS_PR_PERFORMER_PUNCT' => "SHORT;PR",
  'FFS_PR_PERF_SUPER' => "SHORT;PR",
  'FFS_PR_SINGER' => "PNID;PR",
  'FFS_PR_SINGER_MAYBE' => "PNID;PR",
  'FFS_PR_SINGER_NEW' => "PNID;PR",
  'FFS_PR_STRING' => "PNID;PR",
  'FFS_PR_VOICE' => "PNID;PR",
  'FFS_PR_VOICE_REQUIRED_NEW' => "PNID;PR",
  'FFS_PR_VROLE' => "PNID;PR",
  'FFS_PR_VROLE_MAYBE' => "PNID;PR",
  'FFS_PR_VROLE_NEW' => "PNID;PR",
  'FFS_PR_VROLE_PUNCT' => "SHORT;PR",
  'FFS_PR_WLPERF' => "PNID;PR",
  'FFS_REC_CATALOG' => "RECID;REC",
  'FFS_REC_INFO' => "SHORT;PR;REC",
  'FFS_REC_LABEL' => "PNID;REC",
  'FFS_REC_LABEL_REQUIRED_NEW' => "PNID;REC",
  'FFS_REC_NOTES' => "SHORT;REC",
  'FFS_REC_ORIG' => "SHORT;REC",
  'FFS_REC_PACKAGE' => "SHORT;REC",
  'FFS_REC_SOURCE' => "SHORT;REC",
  'FFS_REC_TIMING' => "SHORT;REC",
  'FFS_REC_TT' => "SHORT;REC",
  'FFS_RELEASE_TITLE' => 1,
  'FFS_REVIEWERSIG' => 1,
  'FFS_REVIEWERSIG_BROKEN' => 1,
  'FFS_SELECTIONS_TYPE' => 1,
  'FFS_SELECTIONS_TYPE_B' => 1,
  'FFS_SELECTIONS_TYPE_BI' => 1,
  'FFS_SELECTIONS_TYPE_I' => "SHORT;CW",
  'FFS_UNKN_EXPR' => 1,
  'FFS_WORK_CAGESUPER' => "SHORT;CW",
  'FFS_WORK_CONT' => "SHORT;CW",
  'FFS_WORK_EDITION' => "SHORT;CW",
  'FFS_WORK_FILLER' => "SHORT;CW",
  'FFS_WORK_KEY_MAJOR' => "SHORT;CW",
  'FFS_WORK_KEY_MINOR' => "SHORT;CW",
  'FFS_WORK_LIST_bi' => "SHORT;CW",
  'FFS_WORK_LIST_b' => "SHORT;CW",
  'FFS_WORK_LIST_i' => "SHORT;CW",
  'FFS_WORK_LIST_' => "SHORT;CW",
  'FFS_WORK_NAME' => "SHORT;CW",
  'FFS_WORK_NAME_BI' => "SHORT;CW",
  'FFS_WORK_NAME_I' => "SHORT;CW",
  'FFS_WORK_NAME_PREFIX_I' => "SHORT;CW",
  'FFS_WORK_NOTES' => "SHORT;CW",
  'FFS_WORK_NUMBER_BIG' => "SHORT;CW",
  'FFS_WORK_NUMBER_LITTLE' => "SHORT;CW",
  'FFS_WORK_OPUS' => "SHORT;CW",
  'FFS_WORK_PR_STRING' => "SHORT;CW",
  'FFS_WORK_REC_DATE' => "SHORT;CW",
  'FFS_WORK_SUPER' => "SHORT;CW",
); #end of %LEGAL_EXPR_CLASSES;

#GLOBALS -- LEGAL SYNTYPES

%mustExistFlags = (	# set if a mandatory enumeration 
  'reviewer' => '1',
  'composer' => '0',
  'performer' => '0',
  'singer' => '0',
  'instrumentalist' => '0',
  'instrument' => '1',
  'ensemble' => '0',
  'voice' => '1',
  'vrole' => '0',
  'leader' => '0',
  'leadermode' => '1',
  'label' => '1',
  'works' => '0',
  'wlperf' => '0',
  'wlens' => '0',
  'city' => '0',

);

@LEGAL_SYN_TYPES = (
  'reviewer',
  'composer',
  'performer',
  'singer',
  'instrument',
  'instrumentalist',
  'ensemble',
  'voice',
  'vrole',
  'leader',
  'leadermode',
  'label',
  'works',
  'wlperf',
#2011_10_25 -- wlens now a legal syntype
  'wlens',
#2011_02_14 -- city now a legal syntype
  'city',
);

%synTypesOfBasicExprClasses = (
  'ARTICLE_AUTHOR' => 'reviewer',
  'COMPOSER' => 'composer',
  'PR_ENSEMBLE' => 'ensemble',
  'PR_INSTRUMENTALIST' => 'instrumentalist',
  'PR_INSTRUMENT' => 'instrument',
  'PR_LEADER' => 'leader',
  'PR_LEADERMODE' => 'leadermode',
  'PR_PERFORMER' => 'performer',
  'PR_SINGER' => 'singer',
  'PR_VOICE' => 'voice',
  'PR_VROLE' => 'vrole',
  'PR_WLPERF' => 'wlperf',
  'PR_WLENS' => 'wlens',
  'REC_CATALOG' => 'catalog',
  'REC_LABEL' => 'label',
  'WORK_PNID' => 'works',
);

%synType_is_person = (	# set if a synType may have a person's first name
  'person' => '1',
  'thing' => '0',
  'reviewer' => '1',
  'composer' => '1',
  'performer' => '1',
  'singer' => '1',
  'instrumentalist' => '1',
  'instrument' => '0',
  'ensemble' => '0',
  'voice' => '0',
  'vrole' => '0',
  'leader' => '1',
  'leadermode' => '0',
  'label' => '0',
  'works' => '0',
  'wlperf' => '1',
  'wlens' => '0',
  'city' => '0',
);

#2009_11_22 -- promote common Ensemble Abbreviations to FFATLASSyntax

%ensembleAbbreviations = (
  'Flub' => 'Flubbo',	# 2006_12_11 -- second entry is hash for some damn reason
  'Flob' => 'Flobbo',
  'Acad' => 'Academy',
  'Duo' => 'Duo',
  'C' => 'Chamber',
  'CS' => 'Chamber Symphony',
  'Ch' => 'Chorus',
  'Choir' => 'Choir',
  'CCh' => 'Chamber Chorus',
  'Ch & O' => 'Chorus & Orchestra',
  'Chorale' => 'Chorale',
  'CO' => 'Chamber Orchestra',
  'Consort' => 'Consort',
  'Ens' => 'Ensemble',
  'Les' => 'Les',
  'Natl' => 'National',
  'Of' => 'Of',
  'of' => 'of',
  'O' => 'Orchestra',
  'O & Ch' => 'Orchestra & Chorus',
  'Op' => 'Opera',
  'PO' => 'Philharmonic Orchestra',
  'P' => 'Philharmonic',
  'PCh' => 'Philharmonic Choir',
  'Qnt' => 'Quintet',
  'Qrt' => 'Quartet',
  'R' => 'Radio',
  'RO' => 'Radio Orchestra',
  'RPO' => 'Radio Philharmonic Orchestra',
  'RSO' => 'Radio Symphony Orchestra',
  'RCh' => 'Radio Chorus',
  'S' => 'Symphony',
  'Singers' => 'Singers',
  'SO' => 'Symphony Orchestra',
  'Snf' => 'Sinfonia',
  #'St.' => 'St.',	# Saint or State or String -- leave it be
  'Str' => 'String',
  'The' => 'The',
  'the' => 'the',
  'Tr' => 'Trio',
  'Univ' => 'University',
);

#####################################################################
#CONSTRUCTOR
# NONE -- this provides STATIC routines
#####################################################################

#
# SYNTYPE OF EXPR ROUTINE
#

#$synType = &FFATLASSyntax::synTypeOfExpr($expr);
sub synTypeOfExpr {

  #
  # synTypeOfExpr will return a synType IFF there is one defined at all
  # This includes partial (pre-SYNTAX1) exprs
  # This MAY include ILLEGAL (pre-SYNTAX1 or pre-disambiguation) synTypes
  #
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  my ($expr) = @_;
  my $synType = "";

  if ($expr =~ m%syntype='([^\']*)'% ) {
    $synType = $1;
  }

  return $synType;

}# end of &FFATLASSyntax::synTypeOfExpr($expr);

#if (&FFATLASSyntax::isXIDExpr($primitiveExpr) )
sub isXIDExpr {
  my ($expr) = @_;
  if ($expr =~ m%^\s*<expr class=.* (pnid|cwid|recid)=.*</expr>\s*$% ) {
    return (1);
  } else {
    return undef;
  }
}# end of &isXIDExpr();

#
# DECODE/ENCODE routines
#

#$PR_PAIR_EXPR = &FFATLASSyntax::encodePRPairExpr($performerSynType, $performerXID, $roleSynType, $roleXID, $pairSuper, $assert);
sub encodePRPairExpr {
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  my ($performerSynType, $performerXID, $roleSynType, $roleXID, $pairSuper, $assert) = @_;
  my $PR_PAIR_EXPR = "";

  $performerSynType =~ tr/A-Z/a-z/;
  $roleSynType =~ tr/A-Z/a-z/;
  
  $PR_PAIR_EXPR = qq{<expr class='PRPAIR' psyntype='$performerSynType', ppnid='$performerXID' rsyntype='$roleSynType', rpnid='$roleXID'  sup='$pairSuper' assert='$assert'></expr>};

  return $PR_PAIR_EXPR;

}# end of &encodePRPairExpr();

#my ($XIDType, $exprClass, $XID, $LFName, $synType, $thingSyn, $sup, $assert, $text) = &FFATLASSyntax::decodeXIDExpr($XIDExpr);; 
sub decodeXIDExpr {
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  my ($expr) = @_;
  my ($XIDType, $exprClass, $XID, $LFName, $synType, $thingSyn, $sup, $assert, $text) = ();
  #warn "SYNTAX:decode:050: $expr\n";

  unless ($expr =~ m%^\s*<(expr|attr|span) .*</(expr|attr|span)>\s*$% ) {
    return undef;
  }

  if ($expr =~ m% class='([^\']*)'% ) {
    $exprClass = $1;
  }
  if ($expr =~ m% (pnid|cwid|recid)='([^\']*)'% ) {
    $XIDType = $1;
    $XID = $2;

    $XIDType =~ tr/a-z/A-Z/;
  } else {
    $XIDType = 'SHORT';
  }

  if ($expr =~ m% syntype='([^\']*)'% ) {
    $synType = $1;
  }
  if ($expr =~ m% syn='([^\']*)'% ) {		# old
    $thingSyn = $1;
  }
  if ($expr =~ m% thingsyn='([^\']*)'% ) {	# current
    $thingSyn = $1;
  }
  if ($expr =~ m% lfname='([^\']*)'% ) {
    $LFName = $1;
  }
  if ($expr =~ m% sup='([^\']*)'% ) {
    $sup = $1;
  }
  if ($expr =~ m% assert='([^\']*)'% ) {
    $assert = $1;
  }
  if ($expr =~ m%>([^<>]*)% ) {
    $text = $1;
  }

  $XIDType =~ tr/A-Z/a-z/;	# lowercase XIDtype e.g. pnid
  $synType =~ tr/A-Z/a-z/;	# lowercase syntype e.g. leadermode
  $exprClass =~ tr/a-z/A-Z/;	# uppercase experClass

  return ($XIDType, $exprClass, $XID, $LFName, $synType, $thingSyn, $sup, $assert, $text); 

}# end of decodeXIDExpr();

#my $newExpr = &FFATLASSyntax::encodeXIDExpr($XIDType, $exprClass, $XID, $LFName, $synType, $thingSyn, $sup, $assert, $text);
sub encodeXIDExpr {
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  my ($XIDType, $exprClass, $XID, $LFName, $synType, $thingSyn, $sup, $assert, $text) = @_;
  $LFName =~ s/'/’/g;	# escape all quotes to RIGHT SINGLE QUOTES
  unless ($LFName =~ /\w/ && $LFName =~ /_/ ) {
    my $msg = "EMPTY_LFNAME_IN_CALL";
    &murmerToJesus( $msg, @_ );
  }
  $text =~ s/'/’/g;	# escape all quotes to RIGHT SINGLE QUOTES

  #2010_01_28 -- thingsyn formats: three forms based on XIDType
  #my $newExpr = qq{<expr class='$exprClass' pnid='$PNID' syntype='$synType' syn='$thingSyn' lfname='$LFName' sup='$sup' assert='$assert'>$text</expr>};

  $XIDType =~ tr/A-Z/a-z/;	# lowercase XIDtype e.g. pnid
  $synType =~ tr/A-Z/a-z/;	# lowercase syntype e.g. leadermode
  $exprClass =~ tr/a-z/A-Z/;	# uppercase experClass

  my $newExpr = "";


  if ($XIDType eq 'pnid' ) {
    $newExpr = qq{<expr class='$exprClass' $XIDType='$XID' lfname='$LFName' syntype='$synType' thingsyn='$thingSyn' sup='$sup' assert='$assert'>$text</expr>};
  } elsif ($XIDType eq 'cwid' ) {
    $newExpr = qq{<expr class='$exprClass' $XIDType='$XID' lfname='$LFName' syntype='$synType' thingsyn='$thingSyn' sup='$sup' assert='$assert'>$text</expr>};
  } elsif ($XIDType eq 'recid' ) {
    $newExpr = qq{<expr class='$exprClass' $XIDType='$XID' lfname='$LFName' syntype='$synType' thingsyn='$thingSyn' assert='$assert'>$text</expr>};
  } else {
    &comeToJesus( "encodeXIDExpr() called with illegal XIDType \[$XIDType\]", @_ );
  }

  return $newExpr; 
  
}# end of &encodeXIDExpr()

#my $numsThingSyn = &genNumsThingSyn($numsText);
sub genNumsThingSyn {
  my ($numsText) = @_;
  my $numsThingSyn = $numsText;
  if ($numsThingSyn =~ /[0-9]/ ) {
    $numsThingSyn =~ s/[^0-9]//g;	# leave only numbers
  } else {
    $numsThingSyn = "unnumbered";
  }
  return $numsThingSyn;
}# end of &genNumsThingSyn();
  
#my $mediumThingSyn = &genMediumThingSyn($auxMediumText);
sub genMediumThingSyn {
  my ($rawRecString) = @_;
  my $medium = "CD";	# default
  #
  # find Medium
  #
  if ($rawRecString =~ /DVD/) {
    $medium = "DVD";
  }
  if ($rawRecString =~ /SACD|Super Audio.*CD|Hybrid.*Multi.*Channel/i) {
    $medium = "SACD";
  }
  if ($rawRecString =~ /Blu.RAY/i) {
    $medium = "BLU-RAY";
  }

  return $medium;
  
}# end of &genMediumThingSyn();

#my ($LFName, $name0, $name1) = &genCatalogLFName($labelPNID, $mediumText, $numsText);
sub genCatalogLFName {
  my ($labelPNID, $mediumText, $numsText) = @_;
  my ($LFName, $name0, $name1) = ();


  $name0 = $labelPNID;
  $name1 = $mediumText . "_" . $numsText;
  $LFName = $name0 . "_" . $name1;
  
  return ($LFName, $name0, $name1);

}# end of &genCatalogLFName();

#my $THINGSYNFlatName = &genTHINGSYNFlatName($displayName);
sub genTHINGSYNFlatName {
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  my ($displayName) = @_;
  my $THINGSYNFlatName = "";

  $THINGSYNFlatName = lc(FFUTF::toIdiomaticLatinSafe($displayName));
  #2010_06_12 -- CWID now allows [/-] in workThingSyn for op 33/1
  ##$THINGSYNFlatName =~ s/[^a-z0-9]+//g;
  $THINGSYNFlatName =~ s/[^a-z0-9\/-]+//g;
  $THINGSYNFlatName = substr($THINGSYNFlatName, 0, 100);
  
  #print "      AFTER_FLAT: \[$THINGSYNFlatName\]\n";

  return $THINGSYNFlatName;

}# end of &genTHINGSYNFlatName();

#my ($thingSyn) = &FFATLASSyntax::genThingSyn($text);
sub genThingSyn {
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  my ($text) = @_;

  # if text has a _ in it, it is an asserted LFName
  if ($text =~ /_/ ) {
    $text =~ s/^(.*)_(.*)/$2$1/;
  } else {
    #2010_05_07 -- remove NBSPs before creating thingsyn
    $text = &removeNBSPs($text);
  }

  my $thingSyn = &genTHINGSYNFlatName($text);

  return $thingSyn;
  
}# end of &genThingSyn();

#$thingSynFromScratch = &FFATLASSyntax::genWorksThingSyn( $currentComposerThingSyn, $text );
sub genWorksThingSyn {
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  my ($currentComposerThingSyn, $text ) = @_;
  my $primitiveWorkThingSyn = &genThingSyn($text);
  my $worksThingSyn = $currentComposerThingSyn . "_" . $primitiveWorkThingSyn;

  return ($worksThingSyn);

}# end of genWorksThingSyn();

#my ($new_PNID, $new_name0, $new_name1) = &genPNID($synType, $name0, $name1, $text);
sub genPNID {
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance

  my ($synType, $name0, $name1, $text) = @_;

  $name0 =~ s/^\s+//;
  $name0 =~ s/\s+$//;
  $name1 =~ s/^\s+//;
  $name1 =~ s/\s+$//;
  $text =~ s/^\s+//;
  $text =~ s/\s+$//;

  #
  # detatch initials
  #
  $text =~ s/([A-Z])\.([^ ])/$1. $2/g;

  #2010_04_27 -- allow numerical LFNames
  return undef unless ($name0 =~ /[A-z0-9]/ || $text =~ /[A-z0-9]/);

  my $new_PNID = "";
  my $new_name0 = $name0;
  my $new_name1 = $name1;

  my $flatName0 = "";
  my $flatName1 = "";

  if ($synType_is_person{$synType} ) {
    #warn "GEN_PNID_IS_PERSON \[$synType\]\n";
    #
    # person: if name0 present, make syn of name0 and name1
    #
    if ($name0) {
      #warn "GEN_PNID_HAS_NAME0: \[$name0\]\n";
      $flatName0 = &genTHINGSYNFlatName($name0);
      $flatName1 = &genTHINGSYNFlatName($name1);
      $new_PNID = $flatName0 . "_" . $flatName1;
      #print " PERSON_FROM_NAMES: NAME0: \[$name0\] NAME1: \[$name1\] FLAT_NAME0: \[$flatName0\] FLAT_NAME1: \[$flatName1\] NEW_PNID: \[$new_PNID\]\n";
    } else {
      #warn "GEN_PNID_HAS_NO_NAME0: \[$name0\]\n";
      #
      # if person and we are working from text, hack up a name0 name1 combo
      #
      ($new_name0, $new_name1) = &getName1FromText($text);
      $flatName0 = &genTHINGSYNFlatName($new_name0);
      $flatName1 = &genTHINGSYNFlatName($new_name1);
      $new_PNID = $flatName0 . "_" . $flatName1;
      if ($text =~ / /) {
	#warn " FL_PERSON_FROM_TEXT: \[$text\] NEW_NAME0: \[$new_name0\] NEW_NAME1: \[$new_name1\] FLAT_NAME0: \[$flatName0\] FLAT_NAME1: \[$flatName1\] NEW_PNID: \[$new_PNID\]\n";
      } else {
	#warn " F_PERSON_FROM_TEXT: \[$text\] NEW_NAME0: \[$new_name0\] NEW_NAME1: \[$new_name1\] FLAT_NAME0: \[$flatName0\] FLAT_NAME1: \[$flatName1\] NEW_PNID: \[$new_PNID\]\n";
      }
    } # cases of where name0 and name1 come from to make person names
  } else {
    #warn "GEN_PNID_IS_THING \[$synType\]\n";
    #
    # not a person --  we just use name0
    #
    $new_name1 = "";
    if ($new_name0) {
      $flatName0 = &genTHINGSYNFlatName($new_name0);
      $new_PNID = $flatName0;
      #warn " THING_FROM_NAME0: FLAT_NAME0: \[$flatName0\] NEW_PNID: \[$new_PNID\]\n";
    } else {
      $new_name0 = $text;
      $new_name0 =~ s/^[^0-9a-zA-Z]+//;
      $new_name0 =~ s/[^0-9a-zA-Z]+$//;
      $flatName0 = &genTHINGSYNFlatName($new_name0);
      $new_PNID = $flatName0;
      #warn " THING_FROM_TEXT \[$text\]: FLAT_NAME0: \[$flatName0\] NEW_PNID: \[$new_PNID\]\n" if ($text =~ / /);
    } # cases of where name0 comes from to make non-person names
  }# cases of PERSON or THING

  $new_PNID = substr($new_PNID, 0, 100);
  unless ($new_PNID) {
    &comeToJesus("genPNID MADE NEW PNID \[$new_PNID\] FROM SYNTYPE \[$synType\] NAME0 \[$name0\] NAME1 \[$name1\] TEXT \[$text\]", @_ );
  }

  return ($new_PNID, $new_name0, $new_name1);

}# end of &genPNID();

#($CWID, $name0, $name1) = &genCWID($composerPNID, $workDisplayName);
sub genCWID {
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  #STATIC 
  my ($composerPNID, $workDisplayName) = @_;

  #2010_06_12 -- CWID now uses : to join -- composerPNID : workThingSyn
  #my $CWID = $composerPNID . "_" . &genTHINGSYNFlatName($workDisplayName);
  my $CWID = $composerPNID . ":" . &genTHINGSYNFlatName($workDisplayName);

  #
  # trim to specifications
  #
  my $illegalPat = qr{[^A-Za-z0-9.,:/_-]};
  my $maxLength = 100;
  $CWID =~ s%$illegalPat%%g;
  $CWID =~ substr($CWID, 0, $maxLength);

  #warn "FFATLASSyntax.pm IS_GENERATING_CWID: \[$composerPNID\] \[$workDisplayName\] => \[$CWID\]\n"; 

  #
  # make LFName
  #
  my ($LFName, $name0, $name1) = &genWorkLFName($composerPNID, $workDisplayName);

  return ($CWID, $name0, $name1);

}# end of &genCWID();

#($composerPNID, $workThingSyn) = &decodeCWID($CWID);
sub decodeCWID {
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  #STATIC 
  #2010_06_12 -- CWID now uses : to join -- composerPNID : workThingSyn
  my ($CWID) = @_;

  my ($composerPNID, $workThingSyn) = ();
  if ($CWID =~ /^([^_]*_[^_]*)_(.*)/ ) {
    #abaco__concertiaquattrodachiesaingop25 -- OLD STYLE
    $composerPNID = $1;
    $workThingSyn = $2;
  } elsif ($CWID =~ /^([^:]*):(.*)/ ) {
    $composerPNID = $1;
    $workThingSyn = $2;
  }
  return (&trims($composerPNID), &trims($workThingSyn) );

}# end of &decodeCWID();

#2009_11_28 add arg labelLFNAME
#($RECID, $name0, $name1) = &genRECID($labelPNID, $labelLFNAME, $mediumText, $numsText);
sub genRECID {
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  #STATIC 
  my ($labelPNID, $labelLFNAME, $mediumText, $numsText) = @_;

  #
  # get medium ThingSyn from medium text
  #
  my $mediumThingSyn = &genMediumThingSyn($mediumText);

  #
  # get nums ThingSyn from nums text
  #
  my $numsThingSyn = &genNumsThingSyn($numsText);

  #
  # NOTE: RECID is same as THINGSYN
  #
  my $RECID = $labelPNID . "_" . $mediumThingSyn . "_" . $numsThingSyn;

  #
  # make LFName
  #
  my ($LFName, $name0, $name1) = &genCatalogLFName($labelLFNAME, $mediumText, $numsText);

  return ($RECID, $name0, $name1);

}# end of &genRECID();

#my ($name0, $name1) = &getName1FromText($text);
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
sub getName1FromText {
  my ($text) = @_;

  my $name0 = "";
  my $name1 = "";

  $text =~ s/^\W+//;
  $text =~ s/\W+$//;

  #
  # detatch initials
  #
  $text =~ s/([A-Z])\.([^ ])/$1. $2/g;

  my $JrETC = "";
  my @nameTokens = split(/\s+/, $text);
  if ($nameTokens[$#nameTokens] =~ /^(Jr|Sr|I|II|III|IV|V|VI|VII|VIII|IX|X|XI|XII|XIII|XIV|XV) *$/i ) {
    $JrETC = $1;
    pop(@nameTokens);
  }

  if ($#nameTokens == 0) {	# single name given
    $name0 = $nameTokens[0];
    $name1 = "";
  } elsif ($#nameTokens == 1) {	# 2 names given
    $name0 = $nameTokens[1];	# last
    $name1 = $nameTokens[0];	# first
  } else {	# 3 or more names given
    my $initials = "";
    #
    # accumulate leading initials
    #
    while ($nameTokens[0] =~ /\./) {
      $initials .= " " . shift(@nameTokens);
    } 
    $name0 = pop(@nameTokens);	# last is last token
    $name1 = join (" ", @nameTokens);	# first is all the other remaining tokens
    $name1 = $initials . " " . $name1 if $initials;

    $name0 =~ s/^\s+//;
    $name1 =~ s/^\s+//;
    $name0 =~ s/\s+$//;
    $name1 =~ s/\s+$//;
  }# cases of number of tokens 
  $name0 .= " $JrETC" if $JrETC;
  
  #2010_05_07 -- remove nbsp from name0 and name1
  $name0 = &removeNBSPs($name0);
  $name1 = &removeNBSPs($name1);

  return ($name0, $name1);

}# end of  &getName1FromText();

#$name1 = &removeNBSPs($name1);
sub removeNBSPs {
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  my ($txt) = @_;
  $txt =~ s/&nbsp;/ /ig;
  $txt =~ s/&nbsp/ /ig;
  $txt =~ s/nbsp;/ /ig;
  $txt =~ s/nbsp/ /ig;
  $txt =~ s/\N{NO-BREAK SPACE}/ /g;

  return ($txt);

}# end of &removeNBSPs();

#my ($LFName, $name0, $name1) = &genWorkLFName($composerPNID, $workDisplayName);
sub genWorkLFName {
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  #STATIC 
  my ($composerPNID, $workDisplayName) = @_;

  my $name0 = $workDisplayName;

  $name0 =~ s/'/’/g;	#escape SINGLE QUOTE
  $name0 =~ s/[<>]//g;	#escape ANGLE BRACKETs

  my $name1 = "";
  my $LFName = $name0;

  #warn "NEW_WORK_LFNAME: $LFName, $name0, $name1\n";
  return ($LFName, $name0, $name1);

}# end of &genWorkLFName();

#my $legalValidityCode = &FFATLASSyntax::legalizeValidityCode($historicalValidityCode);
sub legalizeValidityCode {
  #warn "FFATLASSyntax LOON \[@_\]\n";
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  #warn "FFATLASSyntax LOON2 \[@_\]\n";
  my ($historicalValidityCode) = @_;

my %legalValidityCodesOfHistoricals = (
  '==' => '==',
  '=' => '==',
  '=?' => '=?',
  '?' => '=?',
  '??' => '=?',
  '=!' => '=!',
  '!=' => '=!',
  '!' => '=!',
  '!!' => '!!',
);

my $legalValidityCode = $legalValidityCodesOfHistoricals{$historicalValidityCode};
unless ($legalValidityCode) {
  comeToJesus ("FFATLASSyntax->legalizeValidityCode CANNOT LEGALIZE VALIDITY CODE \[$historicalValidityCode\]", @_);
}

  return $legalValidityCode;

}# end of &legalizeValidityCode();

#my $updatedEXPRVAL = &FFATLASSyntax::getExprValidityText($updatedWVAL);
sub getExprValidityText {
  shift(@_) if (ref($_[0]) eq 'FFATLASSyntax' ); 	# STATIC even if called on instance
  my ($WORKSHEET_VALIDITY_CODE) = @_;

  my %legalExprValidityText = (
    '==' => 'OK',
    '=?' => 'MAYBE',
    '=!' => 'NEW',
    '!!' => 'REQUIRED_NEW',
  );

  my $exprValidityText = $legalExprValidityText{ $WORKSHEET_VALIDITY_CODE };
  if ($exprValidityText) {
    return ($exprValidityText);
  } else {
    &comeToJesus( "CANNOT GET EXPR_VALIDITY TEXT FOR BOGUS WORKSHEET VALIDITY CODE \[$WORKSHEET_VALIDITY_CODE\]", @_ );
  }
}# end of getExprValidityText();

  

#my ($XIDType, $XIDFromScratch, $LFNameFromScratch, $thingSynFromScratch) = &FFATLASSyntax::XIDFromScratch ($synType, $text, $auxThingSyn, $auxLFNAME, $auxPNID, $auxMediumText);

sub XIDFromScratch {
  my ($synType, $text, $auxThingSyn, $auxLFNAME, $auxPNID, $auxMediumText) = @_;

  $synType =~ tr/A-Z/a-z/;

  my ($XIDType, $XIDFromScratch, $LFNameFromScratch, $thingSynFromScratch) = ();

  #warn "SYNTAX:XIDFromScratch ARGS: \[$synType\] \[$text\] \[$auxPNID\] \[$auxMediumText\]\n";

  #
  # determine the XID type
  #
  $XIDType = 'PNID';
  $XIDType = 'CWID' if ($synType eq 'works');
  $XIDType = 'RECID' if ($synType eq 'catalog');

  #
  # generate the thingSyn corresponding to the text from scratch
  #
  
  my ($basicThingSynFromScratch) = &FFATLASSyntax::genThingSyn($text);

  #
  # adjust the thingsyn for XID type,
  # and generate the XID and LFName from scratch
  #
  #warn "XIDTYPE IS \[$XIDType\]\n";
  if ($XIDType eq 'PNID') {
    #
    # the products for ordinary PNIDs are
    # thingsyn:		basicThingSynFromScratch
    # LFName:		basicLFNameFromScratch (name0_name1)
    # PNID:		basicPNIDFromScratch
    #

    #
    # if text contains _, it is an asserted LFName, so gen PNID using names
    # otherwise, gen PNID using text
    #
    my ($new_PNID, $new_name0, $new_name1) = ();
    if ($text =~ /^(.*)_(.*)$/) {
      ($new_PNID, $new_name0, $new_name1) = &genPNID($synType, $1, $2, "");
    } else {
      ($new_PNID, $new_name0, $new_name1) = &genPNID($synType, "", "", $text);
    }
    $XIDFromScratch = $new_PNID;
    $LFNameFromScratch = $new_name0 . "_" . $new_name1;
    $thingSynFromScratch = $basicThingSynFromScratch;

  } elsif ($XIDType eq 'CWID') {
    #
    # the products for CWIDs is
    # thingsyn:		composerThingsyn . "_" . basicThingSynFromScratch
    # LFName:		composerLFName . _ . basicLFNameFromScratch
    # CWID:		composer_PNID . _ . basicPNIDFromScratch
    #
    $thingSynFromScratch = $auxPNID . $basicThingSynFromScratch;
    my $workDisplayName = $text;
    $workDisplayName =~ s/[.;]$//;
    
    my ($CWID, $name0, $name1) = &genCWID($auxPNID, $workDisplayName);
    $XIDFromScratch = $CWID;
    #2010_06_13 -- work LFName is now split by :, not _
    ##$LFNameFromScratch = $auxLFNAME . "_" . $name0;
    $LFNameFromScratch = $auxLFNAME . ":" . $name0;
    $thingSynFromScratch = $auxThingSyn . "_" . $basicThingSynFromScratch;

    #warn "  XID IS \[$XIDType\] \[$XIDFromScratch\] \[$LFNameFromScratch\] \[$thingSynFromScratch\]\n";
  } elsif ($XIDType eq 'RECID') {
    #
    # 2009_11_28 -- specific attrs for CATALOG data

    # the products for RECIDs is
    # thingsyn:		labelThingSyn . _ . mediumThingSyn . _ . basicThingSynFromScratch
    # LFName:		labelLFName . _ . mediumLFName . _ . basicThingSynFromScratch
    # PNID:		labelPNID . _ . mediumPNID . _ . numparts
    #
    
    $auxMediumText = &trims($auxMediumText);
    
    my $mediumThingSyn = &genMediumThingSyn($auxMediumText);
    my $numsThingSyn = &genNumsThingSyn($text);
    $thingSynFromScratch = $auxThingSyn . "_" . $mediumThingSyn . "_" . $numsThingSyn;
    my $numsDisplayName = $text;
    
    my ($RECID, $name0, $name1) = &genRECID($auxPNID, $auxLFNAME, $auxMediumText, $numsDisplayName);
    unless ($RECID =~ /[A-Za-z0-9]/ && $name0 =~ /[A-Za-z0-9]/ && $name1 =~ /[A-Za-z0-9]/ ) {
      &comeToJesus ( "FFATLASSyntax_GENERATED_BAD_RECID: \($RECID, $name0, $name1\) = \&genRECID\($auxPNID, $auxLFNAME, $auxMediumText, $numsDisplayName\)", @_ ) ;
    }

    $XIDFromScratch = $RECID;
    #2009_11_28 -- 
    $LFNameFromScratch = $name0 . $name1;

    #warn "  XID IS \[$XIDType\] \[$XIDFromScratch\] \[$LFNameFromScratch\] \[$thingSynFromScratch\]\n";
  } else {
    &comeToJesus( "STRANGE XID TYPE \[$XIDType\]\n", @_ );
  }


  return ($XIDType, $XIDFromScratch, $LFNameFromScratch, $thingSynFromScratch);

}# end of &FFATLASSyntax::XIDFromScratch ();

#my $cleanLFName = &FFATLASSyntax::cleanLFName($uncleanLFName);
sub cleanLFName {
  my ($uncleanLFName) = @_;
  my ($cleanLFName) = $uncleanLFName;
  $cleanLFName =~ s/'/’/g;	# escape all quotes to RIGHT SINGLE QUOTES
  $cleanLFName =~ s/<[^<>]*>//g;	# escape all things in angle brackets
  $cleanLFName =~ s/[<>]+//g;	# escape all remaining angle brackets

  #
  # 2009_11_11 -- LFName cannot be '_'
  #
  $cleanLFName = "" unless ($cleanLFName =~ /[A-Za-z0-9]/ );

  return $cleanLFName;

}# end of &cleanLFName();

#my $t = &trims($t);
sub trims {
  my ($t) = @_;
  $t =~ s/^\s+//;
  $t =~ s/\s+$//;
  return $t;
}# end of &trims();

#my $t = &trimW($t);
sub trimW {
  my ($t) = @_;
  $t =~ s/^\W+//;
  $t =~ s/\W+$//;
  return $t;
}# end of &trimW();

#my $niceNameLastFirst = FFATLASSyntax::niceNameFromLFName($article_first_composer_lfname, 'LF');
#my $niceNameFirstLast = FFATLASSyntax::niceNameFromLFName($article_first_composer_lfname, 'FL');
#my $niceNameLast = FFATLASSyntax::niceNameFromLFName($article_first_composer_lfname, 'L');
sub niceNameFromLFName {
  my ($LFName, $order) = @_;
  
  my $name = "";
  my ($l, $f) = split(/_/, $LFName);
  if ($f) {
    if ($order eq 'LF') {
      $name = "$l, $f";
    } elsif ($order eq 'FL') {
      $name = "$f $l";
    } elsif ($order eq 'L') {
      $name = "$l";
    } else {
      &comeToJesus( "niceNameFromLFName called with strange ORDER param \[$order\] LEGAL: LF|FL|L ", @_) ;
    }
  } else {
    $name = "$l";
  }

  #
  # 2011_07_27 -- eliminate trailing [;,] from nice name
  #

  $name =~ s/\s*[;,]\s*$//;
#2011_07_30 -- trims nice name
  $name = &trims($name);
  $name =~ s/ +/ /g;

  return $name;

}# end of &niceNameFromLFName();

#my $niceNameWork = FFATLASSyntax::niceNameFromWorkLFName($LFName, 'LFW');
#my $niceNameWork = FFATLASSyntax::niceNameFromWorkLFName($LFName, 'FLW');
#my $niceNameWork = FFATLASSyntax::niceNameFromWorkLFName($LFName, 'LW');
#my $niceNameWork = FFATLASSyntax::niceNameFromWorkLFName($LFName, 'W');
sub niceNameFromWorkLFName {
  my ($LFName, $op) = @_;
  $op = "W" unless $op;
  my $niceNameWork = "unstated";
  if ($LFName =~ m%^([^_]*_[^_]*)_*([^_]*)$%) {
    my $compLFName = $1;
    my $workName = $2;
    my $op =~ s/W//;
    if ($op) {
      my $niceComposerName = FFATLASSyntax::niceNameFromLFName($compLFName, $op);
      $niceNameWork = qq{$niceComposerName: $workName};
    } else {
      $niceNameWork = $workName;
    }
  } else {
    warn "INVALID WORK LFName \[$LFName\]\n"
    #&murmurToJesus( "NO NICENESS IN INVALID WORK LFName \[$LFName\]", @_);
  }

  return $niceNameWork;
}# end of &niceNameFromWorkLFName();

#comeToJesus( $msg, @_ );
sub comeToJesus {
  my ( $msg, @callingArgs ) = @_;

  my $maxLevel = 50;

  for (my $i = 1; $i <= $maxLevel; $i++) {
    my ($package, $filename, $line, $subroutine, $hasargs, $wantarray, $evaltext, $is_require, $hints, $bitmask) = caller($i);
 
    last unless $package;
    warn "\[$i\]: \[$package, $filename, $line, $subroutine\]\n";
 
    if ($i == 1 ) {
      warn "\n  $msg\n\n";
      for (my $argi = 0; $argi <= $#callingArgs; $argi++ ) {
        my $arg = $callingArgs[$argi];
        warn "  ARG $argi: \[$arg\]\n";
      }
    }
  }# each useful stack level
  my $briefMsg = $msg;
  $briefMsg =~ s/dx=.*?\]//;

   die "\nFFATLASSyntax was called to Jesus. \[$briefMsg\]. Sorry.\n";

}# end of comeToJesus();

#murmurToJesus( $msg, @_ );
sub murmurToJesus {
  my ( $msg, @callingArgs ) = @_;

  my $maxLevel = 50;

  for (my $i = 1; $i <= $maxLevel; $i++) {
    my ($package, $filename, $line, $subroutine, $hasargs, $wantarray, $evaltext, $is_require, $hints, $bitmask) = caller($i);
 
    last unless $package;
    warn "\[$i\]: \[$package, $filename, $line, $subroutine\]\n";
 
    if ($i == 1 ) {
      warn "\n  $msg\n\n";
      for (my $argi = 0; $argi <= $#callingArgs; $argi++ ) {
        my $arg = $callingArgs[$argi];
        warn "  ARG $argi: \[$arg\]\n";
      }
    }
  }# each useful stack level
  my $briefMsg = $msg;
  $briefMsg =~ s/dx=.*?\]//;

   warn "\nFFATLASSyntax murmured to Jesus. \[$briefMsg\]. Sorry.\n";

}# end of murmurToJesus();


#####################################################################
#END OF MODULE
#####################################################################
1


