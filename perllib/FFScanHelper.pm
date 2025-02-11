package FFScanHelper;
#2010_10_10 -- new
#2011_01_13 -- KEEP FFATLASXIDs innocent about ADDONS -- OK
#2011_01_13 -- SKIP NON_DEFINITIVE ADDONS IF THEY WILL POP UP IN THIS PROG -- OK
#2011_01_13 -- DETECT NEVER_BEFORE_SEEN ADDON POPUP
#2011_01_13 -- LOOK UP OUR OWN ADDONS ARRAY FIRST -- IF MISS THEN CONSULT W
#2011_01_30 -- basic ASSERTION methods
#2011_02_06 -- ADDONShortTextValidity()
#2011_06_19 -- DIE IF ASS_FILLER passed to registerScannedLFName()
#2011_06_21 -- DIE IF <\/?sup> passed to registerScannedLFName()
#2011_06_23 -- preserve ASS_FILLERS!
#2011_06_29 -- encode/decode DATUM PR assertions
#2011_07_20 -- support UNIFIED DATUM MEDIUM determination
#2011_07_20 -- get ability to validate deptCodes (to help get MEDIA defaults)
#2011_08_03 -- add genLFKeyFromLFName
#2011_08_09 -- add gentle FYI synonym to ALARM
#2011_08_23 -- adapt to @nn@
#2011_08_26 -- revise ultraUltimate to ultraUltimateADDONFromText($synType, $text)
#2011_08_26a -- revise registerScannedLFName return arguments to reflect short validity and LFKey
#2011_08_27 -- detect, warn and ignore ILLEGAL LFNames (_ >1)
#2011_08_28 -- improve resolution of PARENS e.g. MEMBERS, VROLES, DIRS
#2011_08_30 -- produce improved @typedPrNames to better infer roleTypeHints
#2011_08_31 -- recognize FFLOGLEVEL environment variable
#2011_09_01 -- read and write ADDONS with checksum
#2011_09_02 -- TAME THE INFAMOUS CALL TO JESUS
#2011_09_03 -- deal with in-paren assertions causing mis-classing downstream
#2011_09_05 -- make local hash of legal syntypes
#2011_09_05a -- remove FASTER and ALWAYS if not blessed and not = or ?
#2011_09_05b -- replace greps on SELECTED SYNTYPES -- hashify
#2011_09_06 -- MAKE 'THING' LFNames correctly
#2011_10_25 -- see if WLENS -- new WL ensemble synType
#2011_11_07 -- find SW_VERSION automagically from a SINGLE source
#2011_11_08  -- skip reading all but = lines
#2011_11_14 -- read_ADDONS_EDITABLE can be passed a linesList
#2011_12_10  -- resume reading ALL lines (for preserving CONCORDANCE)
#2011_12_18 -- CONCORDANCE utility methods

#2011_12_21 -- CONCORDANCE SERNUM FIELDS
#2011_12_21 -- CONCORDANCE LFName and Validity FIELDS
#2011_12_21 -- CONCORDANCE THINGSYN FIELD
#2011_12_21 -- CONCORDANCE CHECKSUM FIELD

#2012_12_11 -- writeCONCORDANCERecFromFFScanHelper($ADDONS_OUT);
#2012_01_12 -- revise for > occurring ONLY ONCE
#2012_01_17 -- check for WLENS and ENSEMBLE for this before registering it
#2012_01_17 -- work up the WLENS and ENSEMBLE names
#2012_01_19 -- ADD ! as default short Validity
#2012_02_07 -- ADD ESCAPEMENT FOR O'MALLY
#2012_02_09 -- make FIND SW_VERSION ok for C's machine
#2012_02_10 -- make ADDON SHORT VALIDITY ! if reviewer
#2012_02_11 -- make so ! is discarded upon input
#2012_06_09 -- accomodate ASS_VARs!
#2012_07_01 -- fix the blowout due to ASS_ENSEMBLE etc. not looking up
#2012_07_12 -- BODY_OL and BODY_BR PARAS
#2012_07_17 -- ignore all but = lines (if desired)
#2012_07_24 -- add soloists et. to escapeVarious
#2012_11_17 -- resolve conflict to DVDs
#2013_01_03 -- Fix the THE problem
#2013_01_24 -- find VERSION FILE if we are somewhere in /factory
#2013_03_14 -- make so ! is RETAINED upon input
#2013_03_18 -- FREE: let duplicate ADDON NAMES and their thingSyns BE published
#2013_03_18 -- REGEN: let ENSEMBLE and WLENS and WLPERF NAMES BE REGENERATED
#2013_08_08 -- get the SW_VERSION seeking correct for PFSs new machine
#2013_08_25 -- implement SUBSTITUTIONS.editable
#2013_12_25 -- change &amp and & to leave residue
#2013_12_30 -- elevate ? to G status except for REVIEWER
#2014_01_27 -- change and to &amp;
#2014_01_28 -- change next 4 to reflect end of line
#2014_01_29 -- change so _ is a word boundary
#2014_02_01 -- add sub PEEDecide
#2014_02_04 -- #pete -- UNCOMMENT THE FOLLOWING 5 LINES TO GET EXCEPTIONS
#2014_02_08 -- fix multiple CONDUCTORS
#2014_02_13 -- fix MEMBERS vs. VROLE
#2014_02_17 -- get MEDIUM to ADVANCED AUDIO
#2014_05_08 -- add www/perl/make_modx_db to SW_VERSION path
#2014_10_27 -- allow DOWNLOAD as medium
#2014_11_14 -- increase BCMP and GCMP font size from 18 to 20 points
#2015_02_07 -- fix Anonymous 4 bug
#2015_11_06 -- extend ULTshortValidity to =?
#2015_12_24 -- check for missing VROLE
#2015_12_25 -- extend discoverLabelName to =~
#2016_01_07 -- warn before dying in genLFKeyFromLFName
#2016_01_21 -- do not invoke members if TOKEN does'nt contain ;  or ,
#2016_02_03 -- make ; delimited parens into VROLES
#2016_02_03a -- check for , instrument or leadermode
#2017_01_19 -- add STREAMING_AUDIO and STREAMING_VIDEO
#2017_06_16 -- make correction to STREAMING_AUDIO and STREAMING_VIDEO
#2023_07_07 -- Celeste added check to see if this is for user jacqueline, who will be taking over Archive maintenance.
#





use 5.014002;	# I'm using 5.14.2 to develop this

use strict;
no strict 'refs';
use utf8;
use charnames qw/:full/;
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";


use Cwd 'realpath';

# MODULES
#require FFATLASXIDs;
#2011_07_20 -- support UNIFIED DATUM MEDIUM determination
require FFATLASSyntax;
require FFConstants;
require FFUTF;

################ METHOD INDEX #################
#peter@ginger:~/factory/COLLIDER/343/00_SCAN/bin$ grep "^sub " FFScanHelper.pm | sed -e "s/^/# /; s/ *[{}]//; "
# sub new
# sub _checkArgs
# sub _initializeEnsembleAbbreviations
# sub expandEnsembleAbbreviations
# sub abbreviateEnsembles
# sub registerScannedLFName
# sub OBSELETE_write_ADDONS_OUT
# sub read_ADDONS_EDITABLE
# sub synTypeIsLegal
# sub genLFKeyFromLFName
# sub genThingSyn
# sub synTypeMustExist
# sub updateHead
# sub checkCSS
# sub assembleMarkupStylesheet
# sub discoverLabelName
# sub flagUnbalancedTags
# sub postADDON
# sub unpostADDON
# sub getPOPUPsFromLFName
# sub seekADDONFromThingSyn
# sub getADDONFromLFName
# sub getADDON_LFNames
# sub testASSEscapes
# sub testASSHandles
# sub cacheAssertedString
# sub retrieveAssertedString
# sub escapeAssertions
# sub unescapeAssertions
# sub unescapeAndDetagAssertions
# sub getSynTypesOfText
# sub getSynTypeProfile
# sub isLikelyEnsemble
# sub isLikelyInstrument
# sub cleanDatumAVPair
# sub unifiedLFNameFromText
# sub unifiedEnsembleNameFromText
# sub genUnifiedMedium
# sub decodeAndValidateDocID
# sub unifyDeptCode
# sub LFNameFromScratch
# sub ultraUltimateADDONFromText
# sub removeNBSPs
# sub getParentheticalType
# sub isLikelyWLEnsemble
# sub encodeCONCORDANCERec
# sub encode_CONCORDANCE_FIELD_LFNAME
# sub encodeCONCORDANCERecogSynThingsField
# sub encodeCONCORDANCECitField
# sub uniqueScalars
# sub decodeCONCORDANCERec
# sub writeCONCORDANCERecFromFFScanHelper
# sub isUNChanged
# sub genCanonicalEnsembleLFKey
# sub genCanonicalPeopleThingLFKey
# sub escapeVarious
# sub unescapeVarious
# sub genConductorConstruct
# sub setUpSubstitutions
# sub doSubstitutions
# sub queueDuplicate
# sub queueBang
# sub fetchDuplicateQueue
# sub fetchBangQueue
# sub queueCities
# sub fetchCitiesQueue
# sub PEEDecide
# sub setWatchSerNums
# sub log
# sub getSWVersion
# sub removeNullSpans
# sub trims
# sub trimw
# sub murmurToJesus
# sub comeToJesus

################ END METHOD INDEX #################

###################
#GLOBALS -- GENERAL
###################

#2013_08_25 -- implement SUBSTITUTIONS.editable
my %SUBSTITUTIONS = ();

#2011_12_21 -- CONCORDANCE SERNUM FIELDS
my $MAX_CITATIONS = 200000;	#MAX SERNUM CITATIONS TO OUTPUT TO CONCORDANCE

#2011_09_05 -- make local hash of legal syntypes

my %LEGAL_SYNTYPES = ();

#2011_09_05 -- make local hash of legal syntypes
foreach my $s (@FFATLASSyntax::LEGAL_SYN_TYPES) {
  $LEGAL_SYNTYPES{$s} = 1;
};

#2011_07_20 -- get ability to validate deptCodes (to help get MEDIA defaults)
my %textOfDeptCodes = &FFConstants::departmentTextByCode();
my %deptCodesOfText = &FFConstants::departmentCodeByText();
 
my %markupClassDefs = (

###########################################
# SPANS -- GENERALLY DENOTE METADATA STATUS
###########################################

  #
  # DEFAULTS UNLESS RETAGGED
  #
  'ARIAL' => '{ font:14.00pt "Arial", sans-serif; }',
  'TIMES' => '{ font:14.00pt "Times", serif; color: #300;}',
  #
  # STET INSTRUCTIONS
  #
  'STET_TIMES' => '{ font-family:"Times New Roman"; font-size: 12pt; font-weight: normal; color: #000; }',
  'STET_ARIAL' => '{ font-family:"Arial"; font-size: 12pt; font-weight: normal; color: #000; }',
  #
  # BODY TABLES
  #
  'BODY_TABLE_PARA' => '{ font-family:"DejaVue Sans Mono"; font-size: 16pt; font-weight: bold; color: #060; }',
  'BODY_TABLE_SPAN' => '{ font-family:"DejaVue Sans Mono"; font-size: 16pt; font-weight: bold; color: #060; }',

  #2012_07_12 -- BODY_OL and BODY_BR PARAS
  'BODY_BR_PARA' => '{ font-family:"DejaVue Sans Mono"; font-size: 16pt; font-weight: bold; color: #060; }',
  'BODY_OL_PARA' => '{ font-family:"DejaVue Sans Mono"; font-size: 16pt; font-weight: bold; color: #060; }',
  'BODY_BR_SPAN' => '{ font-family:"DejaVue Sans Mono"; font-size: 16pt; font-weight: bold; color: #060; }',
  'BODY_OL_SPAN' => '{ font-family:"DejaVue Sans Mono"; font-size: 16pt; font-weight: bold; color: #060; }',

  #
  # ISSUE AND DEPARTMENT ANNOUNCEMENTS
  #
  'GDEP' => '{ font-family:"DejaVue Sans Mono"; font-size: 24pt; font-weight: bold; color: #060; }',
  'ISSUE' => '{ font-family:"DejaVue Sans Mono"; font-size: 28pt; font-weight: bold; color: #600; }',
  #
  # POSSIBLE, BAD, AND GOOD ARTICLE TITLES, SIGLINES AND BYLINES
  #
  'PART' => '{ font:18.00pt "Arial", sans-serif; color: #660;}',
  'GART' => '{ font:18.00pt "Arial", sans-serif; color: #00F;}',
  'PBYL' => '{ font:16.00pt "Arial", sans-serif; color: #660;}',
  'GBYL' => '{ font:16.00pt "Arial", sans-serif; color: #00F;}',
  'BBYL' => '{ font:16.00pt "Arial", sans-serif; color: #F00;}',
  'GSIG' => '{ font-family:"Times New Roman"; font-size: 14pt; font-weight: bold; color: #00F; }',
  'BSIG' => '{ font-family:"Times New Roman"; font-size: 14pt; font-weight: bold; color: #F00; }',
  #
  # ZONE BULLETS
  #
  'BULLET1' => '{ font-size: 18pt; color: #00C; }',
  'BULLET2' => '{ font-size: 18pt; color: #00C; }',
  #
  # UNREC SPAN
  #

  'UNREC_SPAN' => '{ font:18.00pt "Arial", sans-serif; color: #F00;}',
  #
  # GOOD AND BAD COMPOSERS, WORKS, or RELEASE TITLES
  #
#2014_11_14 -- increase BCMP and GCMP font size from 18 to 20 points
	#'GCMP' => '{ font:18.00pt "Arial", sans-serif; color: #060;}',
  'GCMP' => '{ font:24.00pt "Arial", sans-serif; color: #060;}',
  'BOOK' => '{ font:18.00pt "Arial", sans-serif; color: #060;}',
  'BOOK_TITLE' => '{ font:18.00pt "Arial", sans-serif; color: #060;}',
  'BOOK_AUTHOR' => '{ font:18.00pt "Arial", sans-serif; color: #060;}',
  'BOOK_DATA' => '{ font:18.00pt "Arial", sans-serif; color: #060;}',
  'COMPOSER_CONT' => '{ font:16.00pt "Arial", sans-serif; color: #060;}',
  'CLIST_INTRODUCER' => '{ font:18.00pt "Arial", sans-serif; color: #060;}',
#2014_11_14 -- increase BCMP and GCMP font size from 18 to 20 points
	#'BCMP' => '{ font:18.00pt "Arial", sans-serif; color: #F00;}',
  'BCMP' => '{ font:24.00pt "Arial", sans-serif; color: #F00;}',
  'WORKSTRING' => '{ font:16.00pt "Arial", sans-serif; color: #060;}',
  'WLIST' => '{ font:16.00pt "Arial", sans-serif; font-style: italic; color: #060;}',
  'RTITLE' => '{ font:18.00pt "Arial", sans-serif; color: #0C0;}',
  'RTITLEPERF' => '{ font:16.00pt "Arial", sans-serif; color: #F00;}',
  'NAKED_RTITLE' => '{ font:16.00pt "Arial", sans-serif; color: #F00;}',
  #
  # NOT-YET-RESOLVED WORK PLUS PERFZONE (Legal so far...)
  #
  'WORKPERFSTRING' => '{ font:14.00pt "Arial", sans-serif; color: #006;}',
  #
  # GOOD AND BAD PERFZONES
  #
  'BAD_PERFSTRING_UNDETACHABLE' => '{ font:16.00pt "Arial", sans-serif; color: #F00;}',
  'BAD_PERFSTRING_EMPTY_START' => '{ font:16.00pt "Arial", sans-serif; color: #F00;}',
  'PERFZONE' => '{ font:16.00pt "Arial", sans-serif; color: #9400D3;}',
  #
  # GOOD AND BAD PERFZONE OCCUPANTS BY SYNTYPE
  #
  'GLEADER' => '{ font:18.00pt "Arial", sans-serif; color: #099}',
  'BLEADER' => '{ font:18.00pt "Arial", sans-serif; color: #F00;}',
  'GENSEMBLE' => '{ font:18.00pt "Arial", sans-serif; color: #00F;}',
  'BENSEMBLE' => '{ font:18.00pt "Arial", sans-serif; color: #F00;}',
  'GLEADERMODE' => '{ font:14.00pt "Arial", sans-serif; color: #0F0;}',
  'BLEADERMODE' => '{ font:14.00pt "Arial", sans-serif; color: #F00;}',
  'GSINGER' => '{ font:18.00pt "Arial", sans-serif; color: #099}',
  'BSINGER' => '{ font:18.00pt "Arial", sans-serif; color: #F00;}',
  'GINSTRUMENTALIST' => '{ font:18.00pt "Arial", sans-serif; color: #066}',
  'BINSTRUMENTALIST' => '{ font:18.00pt "Arial", sans-serif; color: #F00;}',
  'GVROLE' => '{ font:18.00pt "Arial", sans-serif; color: #033}',
  'BVROLE' => '{ font:18.00pt "Arial", sans-serif; color: #F00;}',
  'GVOICE' => '{ font:18.00pt "Arial", sans-serif; color: #066}',
  'BVOICE' => '{ font:18.00pt "Arial", sans-serif; color: #F00;}',
  'GINSTRUMENT' => '{ font:18.00pt "Arial", sans-serif; color: #0CC}',
  'BINSTRUMENT' => '{ font:18.00pt "Arial", sans-serif; color: #F00;}',
  'BPERFORMER' => '{ font:18.00pt "Arial", sans-serif; color: #F00;}',
  'GPERFORMER' => '{ font:18.00pt "Arial", sans-serif; color: #0CC}',
  'BWLPERF' => '{ font:18.00pt "Arial", sans-serif; color: #F00;}',
  'BWLENS' => '{ font:18.00pt "Arial", sans-serif; color: #F00;}',
  'GWLPERF' => '{ font:18.00pt "Arial", sans-serif; color: #0CC}',
  'GWLENS' => '{ font:18.00pt "Arial", sans-serif; color: #0CC}',
#2012_06_09 -- accomodate ASS_VARs!
  'VAR' => '{ font:18.00pt "Arial", sans-serif; color: #066}',

  #
  # GOOD AND BAD LABELS AND RECZONES
  #
  'GLAB' => '{ font:16.00pt "Arial", sans-serif; color: #00F;}',
  'BLAB' => '{ font:16.00pt "Arial", sans-serif; color: #F00;}',
  'CATALOG' => '{ font:16.00pt "Arial", sans-serif; color: #000;}',
  'RECNOTES' => '{ font:14.00pt "Arial", sans-serif; color: #999;}',
  #
  # SIGNIFICANT AND DECORATIVE ASTERISKS
  #
  'STARZ' => '{ font:16.00pt "Arial", sans-serif; color: #006;}',
  'ASTERZ' => '{ font:16.00pt "Arial", sans-serif; color: #600;}',
  #
  # FILLER
  #
  'FILLER' => '{ font:18.00pt "Arial", sans-serif; color: #0CC}',
  'MEMBERS' => '{ font:18.00pt "Arial", sans-serif; color: #0CC}',
  'DIRECTOR' => '{ font:18.00pt "Arial", sans-serif; color: #0CC}',
  'CITY' => '{ font:18.00pt "Arial", sans-serif; color: #0CC}',

##############################################
# PARAS -- GENERALLY DENOTE SOURCE TEXT STATUS
##############################################
  #
  # ARTICLES
  #
  'GOOD_ARTICLE' => '{ font-family:"DejaVue Sans Mono"; font-size: 16pt; font-weight: bold; color: #006; }',
  'BAD_ARTICLE' => '{ font-family:"DejaVue Sans Mono"; font-size: 16pt; font-weight: bold; color: #600; }',

  #
  # STET INSTRUCTIONS
  #
  'STET_TIMES' => '{ font-family:"Times New Roman"; font-size: 12pt; font-weight: normal; color: #000; }',
  'STET_ARIAL' => '{ font-family:"Arial"; font-size: 12pt; font-weight: normal; color: #000; }',
  #
  # MALFORMED PARAS
  #
  'BAD_PARA_FIX_UNBALANCED_TAG tag=p' => '{ font-family:"Arial"; font-size: 12pt; font-weight: normal; color: #000; }',
  'BAD_PARA_FIX_UNBALANCED_TAG tag=span' => '{ font-family:"Arial"; font-size: 12pt; font-weight: normal; color: #000; }',
  'BAD_PARA_FIX_UNBALANCED_TAG tag=b' => '{ font-family:"Arial"; font-size: 12pt; font-weight: normal; color: #000; }',
  'BAD_PARA_FIX_UNBALANCED_TAG tag=i' => '{ font-family:"Arial"; font-size: 12pt; font-weight: normal; color: #000; }',
  'BAD_PARA_FIX_UNBALANCED_TAG tag=sup' => '{ font-family:"Arial"; font-size: 12pt; font-weight: normal; color: #000; }',
  'BAD_HN1_FIX_UNBALANCED_PAREN' => '{ font-family:"Arial"; font-size: 12pt; font-weight: normal; color: #000; }',
  'BAD_HN1_FIX_ORPHAN_CONDUCTOR' => '{ font-family:"Arial"; font-size: 12pt; font-weight: normal; color: #000; }',
  'BAD_HN1_NEED_PR_HINTS' => '{ font-family:"Arial"; font-size: 12pt; font-weight: normal; color: #000; }',
  'BUG_HN1' => '{ font-family:"Arial"; font-size: 12pt; font-weight: normal; color: #000; }',
  'BAD_HN1_BOOKREVIEW' => '{ font-family:"Arial"; font-size: 12pt; font-weight: normal; color: #000; }',
  

  #
  # GOOD HEADNOTES
  #
  'SIGLINE' => '{ color: #000; background-color: #FFF; }',
  'HN1_COL' => '{ color: #000; background-color: #B0E0E6; }',
  'HN1_CW' => '{ color: #000; background-color: #B0E0E6; }',
  'HN1_BOOKREVIEW' => '{ color: #000; background-color: #B0E0E6; }',
  'HN2_CLIST' => '{ color: #000; background-color: #E0FFFF; }',
  'HN2_CWLIST' => '{ color: #000; background-color: #E0FFFF; }',
  'HN2_SELECTIONSLIST' => '{ color: #000; background-color: #E0FFFF; }',
  'HN2_WLIST' => '{ color: #066; background-color: #E0FFFF; }',
  'BONUS' => '{ color: #000; background-color: #E0FFFF; }',
  #
  # BAD HEADNOTES
  #
  'BAD_HN1_MISSING_TITLE' => '{ color: #000; background-color: #FF0; }',
  'BAD_HN1_HN1_BOOKREVIEW' => '{ color: #000; background-color: #FF0; }',
  'BAD_HN1_NOLABEL' => '{ color: #000; background-color: #FF0; }',
  'BAD_HN1_MISSING_TITLE' => '{ color: #000; background-color: #FF0; }',
  'BAD_HN1_NOLABEL' => '{ color: #000; background-color: #FF0; }',
  'BAD_HN1_CW_PERFSTRING_EMPTY_START' => '{ color: #000; background-color: #FF0; }',
  'BAD_HN1_CW_PERFSTRING_UNDETACHABLE' => '{ color: #000; background-color: #FF0; }',
  'BAD_ARIAL_PARA_UNREC' => '{ color: #000; background-color: #FF0; }',
  'BAD_PARA_RESIDUAL_ARIAL' => '{ color: #000; background-color: #FF0; }',
  'BAD_HN1_NO_PERFSTRING' => '{ color: #000; background-color: #FF0; }',
  'BAD_HN1_NO_PERFORMER_TEXT' => '{ color: #000; background-color: #FF0; }',
  'BAD_HN1_NAKED_TITLE' => '{ color: #000; background-color: #FF0; }',
  'BAD_ARIAL_PARA_TO_BE_CLASSIFIED' => '{ color: #000; background-color: #FFA500; }',
  'BAD_ARIAL_PARA_TO_BE_CLASSIFIED2' => '{ color: #000; background-color: #FFA500; }',
  'BAD_HN2_LEADING' => '{ color: #000; background-color: #FF0; }',
  #
  # DIAGNOSTIC PARAS
  #
  'Dx' => '{ font:16.00pt "DejaVue Sans Mono", font-weight: bold; color: #000; background-color: #FF0; }',
);

my %PRIMACY_BY_ATLAS_HEADNOTE_CLASS = (
  'BOLLY_HEADNOTE' => 'PRIMARY',
  'BOOK_HEADNOTE' => 'PRIMARY',
  'COL_HEADNOTE' => 'PRIMARY',
  'CPR_HEADNOTE' => 'PRIMARY',

  'CLIST_HEADNOTE' => 'SECONDARY',
  'COL2_HEADNOTE' => 'SECONDARY',
  'EXTRAS_HEADNOTE' => 'SECONDARY',
  'SELECTIONS_HEADNOTE' => 'SECONDARY',
  'WLIST_HEADNOTE' => 'SECONDARY',

);# PRIMACY_BY_ATLAS_HEADNOTE_CLASS 

my %ATLAS_ARTICLE_TITLE_TO_LXC_DEPARTMENT = (
  # BEFORE means collate the columns BEFORE the other articles in the dept
  'Film Musings' => 'Film Musings_Feature Articles_AFTER',
  'Past Music Present' => 'Past Music Present_Feature Articles_AFTER',
  'The Common-Sense Audiophile' => 'The Common-Sense Audiophile_Feature Articles_AFTER',
  'The Historical Record' => 'The Historical Record_Feature Articles_AFTER',
  'The Jazz Column' => 'The Jazz Column_Jazz_BEFORE',
  'Technophile' => 'Technophile_Feature Articles_AFTER',
  'The Technofile' => 'Technofile_Feature Articles_AFTER',
);

my %ATLAS_DEPARTMENT_NAME_TO_LXC_DEPARTMENT_NAME = (

'Bollywood and Beyond' => 'Bollywood and Beyond',
'Book Reviews' => 'Book Reviews',
'Collections: Choral' => 'Collections: Choral',
'Collections: Early' => 'Collections: Early',
'Collections: Ensemble' => 'Collections: Ensemble',
'Collections: Instrumental' => 'Collections: Instrumental',
'Collections: Miscellaneous' => 'Collections: Miscellaneous',
'Collections: Orchestral' => 'Collections: Orchestral',
'Collections: Vocal' => 'Collections: Vocal',
'Composers' => 'Composers',
'DVDs' => 'Composers',
'Feature Articles' => 'Feature Articles',
'Film' => 'Composers',
'Hall of Fame' => 'Hall of Fame',
'Jazz' => 'Jazz',
'Want List' => 'Want List',
);

#####################################################################
#CONSTRUCTOR
#####################################################################

#2013_03_18 -- FREE: let duplicate ADDON NAMES and their thingSyns BE published
#2013_03_18 -- REGEN: let ENSEMBLE and WLENS and WLPERF NAMES BE REGENERATED
#my $helper = FFSCANHelper->new($helperOP, $REGEN, $ADDONS_EDITABLE, $FREE, $ADDONS_OUT, @SELECTED_SYNTYPES);

sub new {
  my $class = shift;
  my $OP = shift;
  my $REGEN = shift;
  my $ADDONS_EDITABLE = shift;
  my $FREE = shift;
  my $ADDONS_OUT = shift;
  my @SELECTED_SYNTYPES = @_;

  #warn "NEW_SELECTED_SYNTYPES \[@SELECTED_SYNTYPES\]\n";
	#warn "REGEN: \[$REGEN\] FREE: \[$FREE\]\n";

  my $self =  {
		#'SCALAR' => "",
		'OP' => $OP,
		'REGEN' => $REGEN,
		'ADDONS_EDITABLE' => $ADDONS_EDITABLE,
		'FREE' => $FREE,
		'ADDONS_OUT' => $ADDONS_OUT,

		#'HASH' => {},
	      };

  bless ($self, $class);
  #warn "OP = $OP\n";

  if ($OP eq 'NO_ADDON_OPS' ) {
    $self->getSWVersion();
    $self->_initializeEnsembleAbbreviations();
    return ($self);
  }

  $self->_checkArgs();
  $self->_initializeEnsembleAbbreviations();
  $self->getSWVersion();

#2013_08_25 -- implement SUBSTITUTIONS.editable

        my $subFile = $ADDONS_EDITABLE;
        $subFile =~ s/[^\/]+$/SUBSTITUTIONS.editable/;
	$self->setUpSubstitutions($subFile);

  #
  # Define which synTypes we will read; default ALL LEGAL_SYNTYPES
  #
  unless (@SELECTED_SYNTYPES) {
#2011_09_05b -- replace greps on SELECTED SYNTYPES -- hashify
    @SELECTED_SYNTYPES = sort keys %LEGAL_SYNTYPES;
  }
#2011_09_05b -- replace greps on SELECTED SYNTYPES -- hashify
  foreach my $sst (@SELECTED_SYNTYPES) {
    unless ($LEGAL_SYNTYPES{$sst}) {
      die "FFScanHelper->new was passed an ILLEGAL SYNTYPE \[$sst\]\n";
    }
    ${$self->{SELECTED_SYNTYPES}->{$sst}}++;
  }

  #print "INITIALIZING \(@SELECTED_SYNTYPES\) XIDs FROM W_EDITABLE $W_EDITABLE.\n";
  #$self->_initializeFromPNID_WORKSHEET(@SELECTED_SYNTYPES);


  return $self;
}# end of new();

#####################################################################

#####################################################################
#METHODS

#
# CHECK ARGUMENTS
#

sub _checkArgs {
  my $self = shift;
  if ($self->{OP} eq 'READ_W_AND_ADDONS' ) {		# read and preserve all current ASIN data
  } elsif ($self->{OP} eq 'READ_SELECTED_SYNTYPES_NO_OUT' ) {		# read selected synTypes; do not write output 
  } else {
    die "FFScanHelper GOT ILLEGAL OP \[$self->{OP}\]. LEGAL ARE: \[READ_W_AND_ADDONS|READ_SELECTED_SYNTYPES_NO_OUT\]\n";
  }
#2013_03_18 -- REGEN: let ENSEMBLE and WLENS and WLPERF NAMES BE REGENERATED
  my $REGEN = "";
  if ($self->{REGEN} eq "REGEN") {
    $REGEN = "REGEN";
  }
  my $FREE = "";
  if ($self->{FREE} eq "FREE") {
    $FREE = "FREE";
  }

  #warn "FFScanHelper INITIALIZING WITH OP=\[$self->{OP}\] $FREE $REGEN\n";
}# end of _checkArgs

#
# ENSEMBLE NAMES METHODS
#
sub _initializeEnsembleAbbreviations {
  my $self = shift;

  # INITIALIZE THE ENSEMBLE ABBREVIATION PATTERNS
  #if ($perfString =~ /(^| )(O|SO|RSO|PO|Ch)( |$)/) {
  my $abbrevPat = "";
  my @abbrevs = (sort keys %FFATLASSyntax::ensembleAbbreviations);
  my $abbrevStr = join("|", @abbrevs);
  $self->{'ENSEMBLE_ABBREV_PAT'} = $abbrevStr;

  #2006_12_11 -- enable ensemble name contractions
  
  my %contractions = ();
  foreach my $abbrev (keys %FFATLASSyntax::ensembleAbbreviations) {
    my $fullName = $FFATLASSyntax::ensembleAbbreviations{$abbrev};
    #warn "\[$abbrev\] \[$fullName\]\n";
    $contractions{$fullName} = $abbrev;
  }# each abbrev
  %{$self->{'ENSEMBLE_CONTRACTIONS'}} = %contractions;
  @{$self->{'ENSEMBLE_CONTRACTION_APPLY_ORDER'}} = (reverse sort keys %contractions);

}#end of _initializeEnsembleAbbreviations

#my ($expandedString, $changed) = $properNameObj->expandEnsembleAbbreviations($str);
sub expandEnsembleAbbreviations {
  my ($self, $str) = @_;
  my $abbrevPat = $self->{'ENSEMBLE_ABBREV_PAT'};
  #warn "ABBREV PATTERN IS $abbrevPat\n";

  #2009_11_01 -- guard against O'Reilly becoming an Orchestra
  $str =~ s/O['’]/_OAPOSTROPHE_/g;

  my $changed = "";
  $str =~ s/&#0*44;/,/g;
	#2014_01_27 -- change and to &amp;
  $str =~ s/ and / &amp; /g;
  $str =~ s/ & / &amp; /g;
  #2009_06_17 -- make able to withstand tokens that replace themselves
  my @expandedTokens = ();
	#2014_01_29 -- change so _ is a word boundary
	#my @unexpandedTokens = split(/(\W+)/, $str);
  my @unexpandedTokens = split(/([_\W]+)/, $str);
  foreach my $unexpandedToken (@unexpandedTokens) {
    my $longForm = $FFATLASSyntax::ensembleAbbreviations{$unexpandedToken};
    if ($longForm) {
      push(@expandedTokens, $longForm);
      $changed = $longForm;
    } else {
      push(@expandedTokens, $unexpandedToken);
    }
  }# each token
  my $expanded = join("", @expandedTokens);

  #2009_11_01 -- guard against O'Reilly becoming an Orchestra
  $expanded =~ s/_OAPOSTROPHE_/O’/g;
  #warn "helper EXPANDED \[$str\] to \[$expanded\]\n";
  return ($expanded, $changed);
  
}# end of expandEnsembleAbbreviations($str);

#my ($abbreviatedString, $changed) = $properNameObj->abbreviateEnsembles($str);
sub abbreviateEnsembles {
  my $self = shift;
  my $s = shift;	# a string to contract, e.g. Philharmonic Orchestra ->PO
  my $changed = "";

  #2009_11_01 -- guard against O'Reilly becoming an Orchestra
  $s =~ s/O['’]/_OAPOSTROPHE_/g;

  #%{$self->{'ENSEMBLE_CONTRACTIONS'}} = %contractions;
  #@{$self->{'ENSEMBLE_CONTRACTION_APPLY_ORDER'}} = (reverse sort keys %contractions);

  foreach my $longName (@{$self->{'ENSEMBLE_CONTRACTION_APPLY_ORDER'}}) {
    #warn "LONGNAME: \[$longName\]\n";
    my $abbrev = ${$self->{'ENSEMBLE_CONTRACTIONS'}}{$longName};
    #warn "ABBREV: \[$abbrev\]\n";
    if ($s =~ s/$longName/$abbrev/g ) {
      $changed = $longName;
    }
  }# each reverse ordered longName

  #2009_11_01 -- guard against O'Reilly becoming an Orchestra
  $s =~ s/_OAPOSTROPHE_/O’/g;
  return ($s, $changed);
}# end of abbreviateEnsembles();

#$self->_initializeFromPNID_WORKSHEET(@SELECTED_SYNTYPES);
#sub _initializeFromPNID_WORKSHEET {
#  my ($self, @SELECTED_SYNTYPES) = @_;
#
#  my $XIDS_OP = 'PASS_ON_NUMREFS' ;	# read and preserve all refCounts
#  if (@SELECTED_SYNTYPES) {
#    $XIDS_OP = 'READ_SELECTED_SYNTYPES_NO_OUT';
#  }
#  #my $XIDS_OP = 'RECOUNT_NUMREFS' ;	# accept new refs and recount
#  my $XIDsObject = FFATLASXIDs->new($XIDS_OP, $self->{W_EDITABLE}, 'NO_OUT', @SELECTED_SYNTYPES );
#  $XIDsObject->readWORKSHEET();
#  $self->{XIDS_OBJECT} = $XIDsObject;
#
#}# end of initializeFromPNID_WORKSHEET()

#2011_08_26a -- revise registerScannedLFName return arguments to reflect short validity and LFKey
#my ($shortValidity, $LFKey, $LFName, $canonicalThingSyn) = $helper->registerScannedLFName($synType, $XIDLFName, '999'[, $assertedShortValidity]); 

sub registerScannedLFName {
  my ($self, $synType, $text, $serNum, $assertedShortValidity) = @_; 

  #2013_01_02 -- look for missing leading THE
  #warn "THE60: $text\n" if ($text =~ /ater of Voices/);

  my $placePrefix = "registerLFName";
  my $place = "";

  #if ($text =~ /RIVO ALTO/ ) {
  #$place = $placePrefix . "000";
  #$self->log("ALARM", "registerScannedLFName called with ARGS synType \[$synType\] text \[$text\] serNum \[$serNum\] assertedShortValidity \[$assertedShortValidity\]\n" , $serNum, $place, @_ );
  #}



  #2011_06_19 -- DIE IF ASS_FILLER passed to registerScannedLFName()
  if ($text =~ m%ASS_[^_]+_\d\d\d\d\d% ) {
    &comeToJesus( "ASSERTION ILLEGALLY PASSED TO registerScannedLFName. TEXT: \[$text\]\n", @_);
  }

  #2011_06_21 -- DIE IF <\/?sup> passed to registerScannedLFName()
  if ($text =~ m%</?sup>% || $text =~ m%sup[0-9]% ) {
	  #&comeToJesus( "SUPER ILLEGALLY PASSED TO registerScannedLFName. TEXT: \[$text\]\n", @_);
    &murmurToJesus( "SUPER ILLEGALLY PASSED TO registerScannedLFName. TEXT: \[$text\]\n", @_);
  }

  #
  # make sure the LFName is in correct form (can be entered as joe shultz)
  #
  #my ($longValidity, $PNID, $LFName, $thingSyn) = $self->ultraUltimatePNIDFromText($synType, $text);
#2011_08_26 -- revise ultraUltimate to ultraUltimateADDONFromText($synType, $text)
#2011_08_26a -- revise registerScannedLFName return arguments to reflect short validity and LFKey

  #
  # 2012_01_17 -- check for WLENS and ENSEMBLE for this before registering it
  # we are in &registerScannedLFName(); 
  #
  if ($synType eq 'wlens' || $synType eq 'ensemble' ) {
    #warn "FFScanHelper: ENSEMBLE_01: $synType \[$text\]\n";
    my ($niceShort, $changedshort) = $self->abbreviateEnsembles($text);
    #warn "FFScanHelper: ENSEMBLE_02: $synType \[$text\] -> \[$niceShort, $changedshort\]\n";
    unless ($niceShort) {
      $niceShort = $text;
    }

    # PUT THE OUTPUT INTO EVERY THING BELOW abbreviateEnsembles

  #2013_01_02 -- look for missing leading THE
  #warn "THE61: $niceShort\n" if ($text =~ /ater of Voices/);

    my ($theLFName, $theLFKey) = $self->genCanonicalEnsembleLFKey($niceShort);
    #warn "FFScanHelper: ENSEMBLE_03: $synType $niceShort $theLFName \n";
    $text = $theLFName;
    $text =~ s/_$//;

    #warn "FFScanHelper: ENSEMBLE_04: $synType $niceShort $theLFName \[$text\]\n";
  }

  #2013_01_02 -- look for missing leading THE
  #warn "THE62: $text\n" if ($text =~ /ater of Voices/);

  my ($ADDONSShortValidity, $LFKey, $LFName, $canonicalThingSyn, @recognitionThingSyns) = $self->ultraUltimateADDONFromText($synType, $text);

  #my $ADDONSShortValidity = &validityLongToShort($synType, $longValidity);

  my $shortValidity = $ADDONSShortValidity;	# default unless asserted otherwise

  #
  # 2012_01_19 -- ADD ! as default short Validity
  #
  $shortValidity = '!' unless $shortValidity;

  if ($assertedShortValidity) {
    $shortValidity = $assertedShortValidity ;	# is asserted otherwise
    warn "REGISTERING_ASSERTED_ADDON \[$synType, $text\] FROM DATA \[$ADDONSShortValidity, $LFKey, $LFName, $canonicalThingSyn, $assertedShortValidity\]\n";


#2013_12_30 -- elevate ? to G status except for REVIEWER
  } elsif ($ADDONSShortValidity eq '=' || $ADDONSShortValidity eq '?') {
    print "POSTING_ADDON $ADDONSShortValidity \[$synType, $text\] RETURNS \[$ADDONSShortValidity, $LFKey, $LFName, $canonicalThingSyn, $serNum\]\n";
  }

  #if ($text =~ /RIVO ALTO/ ) {
  $place = $placePrefix . "000";
	#$self->log("ALARM", "registerScannedLFName POSTING ADDON WITH ARGS synType \[$synType\] canonicalThingSyn \[$canonicalThingSyn\] LFName \[$LFName\] shortValidity \[$shortValidity\] serNum \[$serNum\]\n" , $serNum, $place, @_ ) if ($canonicalThingSyn =~ /rigoletto/);
  #}

  $self->postADDON($synType, $canonicalThingSyn, $LFName, $shortValidity, $serNum, 'CHANGED');



  return ($shortValidity, $LFKey, $LFName, $canonicalThingSyn, $ADDONSShortValidity);
  
}# end of &registerScannedLFName(); 


#$helper->OBSELETE_write_ADDONS_OUT(@SELECTED_SYNTYPES);

sub OBSELETE_write_ADDONS_OUT {
  my ($self, @SELECTED_SYNTYPES) = @_;
#2011_09_05b -- replace greps on SELECTED SYNTYPES -- hashify

  #
  # ignore the @SELECTED_SYNTYPES passed -- use the initial ones
  # (or the circularity trap won't work)
  #
  my %SELECTED_SYNTYPES = %{$self->{SELECTED_SYNTYPES}};

  my $ADDONS_OUT = $self->{'ADDONS_OUT'};
  open (ADDONS_OUT, ">:utf8", $ADDONS_OUT) or die "CANNOT WRITE ADDONS_OUT \[$ADDONS_OUT\]:$!\n";

  #2010_06_11 -- include synonymous thingSyns in $self->{'ADDONS'} struct
  #my ${$self->{'ADDONS'}->{$synType}->{$ADDONS_ENTRY}->{$thingSyn}}++;
  foreach my $synType (sort @FFATLASSyntax::LEGAL_SYN_TYPES ) {
    my %uniqueThingSyns = ();
    next unless $synType;
    #2010_06_11 -- make ADDONS.out correct
    print ADDONS_OUT "\n#$synType\n\n";
    #
    # get all the ADDONLFNames for this synType
    # 

    #warn "FETCHING_LFNAMES \[$synType\]\n";
    my @LFNames = $self->getADDON_LFNames($synType);
    foreach my $LFName (@LFNames) {
      next unless $LFName;

      my ($ADDONSShortValidity, @thingSyns) = $self->getADDONFromLFName($synType, $LFName);
      next unless $ADDONSShortValidity;
      next unless @thingSyns;

      my $ADDON_REC = qq{$synType $ADDONSShortValidity$LFName};
      #warn "INITIAL_ADDON_REC \[$ADDON_REC\]\n" if ($ADDON_REC =~ /claris/i);

      #2010_06_11 -- include synonymous thingSyns in $self->{'ADDONS'} struct

      foreach my $thingSyn (sort @thingSyns) {
	next unless ($thingSyn =~ /\S/);
	next if ($synType eq 'works' && $thingSyn !~ /_/ );	#historic

	#
	# check for circularity IFF this is a synType handled by this prog
	#
#2011_09_05b -- replace greps on SELECTED SYNTYPES -- hashify
	if ($SELECTED_SYNTYPES{$synType} ) {
	  my $circularTrapKey = qq{$synType:$thingSyn};

	  if ($uniqueThingSyns{$circularTrapKey}++ ) {
	    die "*** CIRCULAR_ADDON_DEFINITION: \[$circularTrapKey\] synType \[$synType\] ADDON_ENTRY \[$ADDON_REC\] thingSyn \[$thingSyn\]\n";
	  }# is circular ADDONS definition
	}# this is a synType under current consideration

	$ADDON_REC .= " > $thingSyn";
      }
      my (@serNums) = $self->getPOPUPsFromLFName($synType, $LFName);
      if (@serNums) {
	$ADDON_REC .= " #";
	foreach my $serNum (@serNums) {
	  $ADDON_REC .= " $serNum";
	}
      }

#2011_09_01 -- read and write ADDONS with checksum
	
      my $ADDON_REC_TO_CHECK = qq{$ADDON_REC};
      my $checksum = unpack ("%32C*", $ADDON_REC_TO_CHECK) % 65535;
      print ADDONS_OUT "$ADDON_REC_TO_CHECK %$checksum\n";
    }# each ADDON ENTRY
  }# each synType

  close (ADDONS_OUT);

}# end of OBSELETE_write_ADDONS_OUT();

#$helper->read_ADDONS_EDITABLE(@linesList);
sub read_ADDONS_EDITABLE {
  my ($self, @linesList) = @_;
  #my $XIDsObject = $self->{XIDS_OBJECT};
#2011_09_05b -- replace greps on SELECTED SYNTYPES -- hashify
  #my @SELECTED_SYNTYPES = @{$self->{SELECTED_SYNTYPES}};
  my %SELECTED_SYNTYPES = %{$self->{SELECTED_SYNTYPES}};
  my $placePrefix = "READADDONS";
  my $place = "";
  my $serNum = "";

#2013_03_18 -- FREE: let duplicate ADDON NAMES and their thingSyns BE published
  my $FREE = "";
  if ($self->{FREE} eq "FREE") {
    $FREE = "FREE";
  }

  #
  #2011_11_14 -- read_ADDONS_EDITABLE can be passed a linesList
  # If so, it will be used to populate the ADDONS structures
  # Else the file specified in constructor argument ADDONS_EDITABLE will be read
  #

  unless (@linesList) {
    my $addonsFile = $self->{'ADDONS_EDITABLE'};

    $place = $placePrefix . "000";
    #$self->log("NOTE", "READING ATLAS ADDONS FILE: \[$addonsFile\] SYNTYPES \[@SELECTED_SYNTYPES\]\n" , $serNum, $place, @_ );
    
    #
    # read ADDONS_EDITABLE for our local scan ADDONS records
    #
    open (ADDONS_EDITABLE, "<:utf8", $addonsFile) or die "CANNOT READ ADDONS_EDITABLE FILE \[$addonsFile\]: $!\n";
    while (<ADDONS_EDITABLE>) {
      chop;
      push (@linesList, $_);
    }
    close (ADDONS_EDITABLE);
  }
    
  #
  # run through the lines
  #
  foreach my $line (@linesList) {
    $line =~ s/^#.*//;
    next unless ($line =~ /\w/);	# skip airballs
    my $spareLine = $line;

    #2011_11_08  -- skip reading all but = lines
#2011_12_10  -- resume reading ALL lines (for preserving CONCORDANCE)
    #2012_07_17 -- ignore all but = lines (if desired)
    #next unless ($line =~ m/^\S*\s+=/);

#2011_09_01 -- read and write ADDONS with checksum
      
    #print ADDONS_OUT "$ADDON_REC_TO_CHECK %$checksum\n";
    my $isFrozen = "";
    if ($line =~ /^(.*)(%)(\d+)$/) { 
      $line = &trims($1);
      my $sep = $2;
      my $cs = $3;
      my $checksum = unpack ("%32C*", $line) % 65535;
      if ($checksum == $cs) {
	$isFrozen = 1;
	$place = $placePrefix . "100";
	#$self->log("ALARM", "GOT FROZEN ADDON \[$line\]" , $serNum, $place, @_ ) if ($line =~ /Women of the RIAS C Ch .amp; Berlin R SO/);
      } else {
	$place = $placePrefix . "110";
	#$self->log("ALARM", "RE_FREEZING ADDON \[$line\]" , $serNum, $place, @_ ) if ($line =~ /Women of the RIAS C Ch .amp; Berlin R SO/);
      }
    }# if this line has a checksum

    #
    # get ADDONS components
    #
    my $synType = "";
    my $ADDONSShortValidity = "";
    my $ADDONSTextName = "";
    my $ADDONSThingSynString = "";
    my $ADDON_ENTRY = "";
    my $ADDON_PREFIX = "";
    my $ADDONSLFName = "";	
    my $popupSerNumString = "";

    #label =POINT_ > point > foobar
    if ($line =~ m/^(\S*)\s+([=?!])([^<>]+)(.*)#(.*)/ ) {
      $synType = &trims($1);
      $ADDONSShortValidity = &trims($2);
      $ADDONSTextName = &trims($3);
      $ADDONSThingSynString = &trims($4);
      $popupSerNumString = &trims($5);
      #2011_08_23 -- adapt to @nn@
      $popupSerNumString =~ s/^.*\@\s*//;
    } elsif ($line =~ m/^(\S*)\s+([=?!])([^<>]+)(.*)/ ) {
      $synType = &trims($1);
      $ADDONSShortValidity = &trims($2);
      $ADDONSTextName = &trims($3);
      $ADDONSThingSynString = &trims($4);
    } else {
      #comeToJesus( "FUNNY ADDONS_EDITABLE LINE \[$line\]\n", @_);
      #leader !</i_Giancarlo Amati <i>(songs). > giancarloamatiisongs/i
      warn "FUNNY ADDONS_EDITABLE LINE \[$line\]\n";
      next;
    }

#2013_12_25 -- change &amp and & to leave residue
    #2011_09_01 -- fast postADDON if entry is frozen
    if ($isFrozen) {
			#warn "ARRGH_02:$line\n" if ($line =~ /Women of the RIAS C Ch .amp; Berlin R SO/);
      #
      # include all thingsyns mentioned in the ADDON line
      #

      #2012_01_12 -- revise for > occurring ONLY ONCE

      #while ($ADDONSThingSynString =~ s/\s*>\s*(\S+)// ) { #}

      #
      # 2012_02_11 -- make so ! is discarded upon input
      #
      # 2013_03_14 -- make so ! is RETAINED upon input
      #next if ( $ADDONSShortValidity eq '!');

      $ADDONSThingSynString =~ s/>/ /g;
      $ADDONSThingSynString = &trims($ADDONSThingSynString);
      my @thingSyns = split(/\s+/, $ADDONSThingSynString);
      foreach my $thingSynText (@thingSyns) {
	#
	# store record of this for ADDONS_OUT
	#
	$self->postADDON($synType, $thingSynText, $ADDONSTextName, $ADDONSShortValidity, $popupSerNumString, $spareLine);
      }# each thingSyn (possiply non-canonical, but we are asserting that it is TRUE, because it was asserted to be so, and the checksum is valid.
      next;
    }# if is frozen

    #
    # ELSE: if we are here, this was not frozen, so recompute EVERYTHING from scratch
    #

	$self->log("ALARM", "CONTINUING ADDON \[$line\]" , $serNum, $place, @_ ) if ($ADDONSLFName =~ /Women of the RIAS C Ch .amp; Berlin R SO/);
    #
    # if we are regenerating ENSEMBLES, 
    #   make sure the LFName is in EXPANDED FORM
    #

#2011_09_05b -- replace greps on SELECTED SYNTYPES -- hashify
    if ($SELECTED_SYNTYPES{$synType} ) {

      # 2012_01_17 -- check for WLENS and ENSEMBLE for this before registering it
      # we are in read_ADDONS_EDITABLE, computing EVERYTHING
      if ($synType eq 'wlens' || $synType eq 'ensemble' ) {
	#ensemble =Swedish RO_ > swedishro
	my $string = $ADDONSTextName;
	$string =~ s/_//;

	my ($niceShort, $changedToken) = $self->abbreviateEnsembles($string);
	unless ($niceShort) {
	  $niceShort = $string;
	}
	my ($theLFName, $theLFKey) = $self->genCanonicalEnsembleLFKey($niceShort);
	#my ($expandedString, $changedToken) = $self->expandEnsembleAbbreviations($string);

	if ($theLFName ne $string) {
	  #warn "CONTRACTING ENSEMBLE LFName FROM \[$string\] TO \[$theLFName\]\n";
	  $ADDONSTextName = $theLFName;
	}
      }# if is ensemble
    }# if this is a selected synType ensembles

    #2011_09_05a -- remove FASTER and ALWAYS if not blessed and not = or ?
    # logic here was moved up

    #
    # make sure the LFName is in correct form (can be entered as joe shultz)
    #
    next unless ($ADDONSTextName =~ /\w/);	# skip airballs
    #2011_08_27 -- detect, warn and ignore ILLEGAL LFNames (_ >1)
    if ($ADDONSTextName =~ /_.*_/) {
      $place = $placePrefix . "100";
      $self->log("WARN", "IGNORING ILLEGAL ADDON \[$ADDONSTextName\] BECAUSE OF TOO MANY _s" , $serNum, $place, @_ );
      next;
    }

    #my ($ig1, $ig2, $generatedLFName, $generatedThingSyn) = $self->ultraUltimatePNIDFromText($synType, $ADDONSTextName);
#2011_08_26 -- revise ultraUltimate to ultraUltimateADDONFromText($synType, $text)
    #my ($shortValidity, $LFKey, $LFName, $canonicalThingSyn, @recognitionThingSyns) = $self->ultraUltimateADDONFromText($synType, $text);
    my ($shortValidity, $LFKey, $generatedLFName, $generatedThingSyn, @recognitionThingSyns) = $self->ultraUltimateADDONFromText($synType, $ADDONSTextName);

    $place = $placePrefix . "200";
    #$self->log("NOTE", "ultraUltimateADDONFromText \[$synType, $ADDONSTextName\] RETURNS shortValidity \[$shortValidity\] LFKey \[$LFKey\] LFName \[$generatedLFName\] canonicalThingSyn \[$generatedThingSyn\] recognitionThingSyns \[@recognitionThingSyns\]\n" , $serNum, $place, @_ );

    if ($ADDONSTextName =~ /^[^_]*_[^_]*$/ ) {	# if display name has already been supplied an LFName in the ADDONS file
      $ADDONSLFName = $ADDONSTextName;	# a proper LFName is ASSUMED to be OK
    } else {
      $ADDONSLFName = $generatedLFName;	# else we supply one
    }

    $place = $placePrefix . "300";
    #$self->log("NOTE", "POSTING_ADDON: synType \[$synType\] generatedThingSyn \[$generatedThingSyn\] ADDONSLFName \[$ADDONSLFName\] ADDONSShortValidity \[$ADDONSShortValidity\] popupSerNumString \[$popupSerNumString\]\n" , $serNum, $place, @_ );
    
    $self->postADDON($synType, $generatedThingSyn, $ADDONSLFName, $ADDONSShortValidity, $popupSerNumString, 'CHANGED');

    #
    # include all thingsyns mentioned in the ADDON line
    #

    #while ($ADDONSThingSynString =~ s/\s*>\s*(\S+)// ) {
    #  my $thingSynText = $1;

    #2012_01_12 -- revise for > occurring ONLY ONCE

    #while ($ADDONSThingSynString =~ s/\s*>\s*(\S+)// ) { #}

    $ADDONSThingSynString =~ s/>/ /g;
    $ADDONSThingSynString = &trims($ADDONSThingSynString);
    my @thingSyns = split(/\s+/, $ADDONSThingSynString);

    #
    # store record of this for ADDONS_OUT
    #
    #my $ADDONThingSyn = &FFATLASSyntax::genThingSyn($thingSynText);
    #push(@thingSyn, $ADDONThingSyn);

    foreach my $thingSynText (@thingSyns) {
      next unless $thingSynText =~ /\w/;
      $self->postADDON($synType, $thingSynText, $ADDONSLFName, $ADDONSShortValidity, $popupSerNumString, 'CHANGED');

    }# each thingSyn

    #
    # if we are regenerating ENSEMBLES, 
    #   make sure the thingSyn of the CONTRACTED form is present
    #
#2011_09_05b -- replace greps on SELECTED SYNTYPES -- hashify
    if ($SELECTED_SYNTYPES{$synType} ) {
      # 2012_01_17 -- check for WLENS and ENSEMBLE for this before registering it
      # we are in read_ADDONS_EDITABLE, computing EVERYTHING
      if ($synType eq 'wlens' || $synType eq 'ensemble' ) {
	my $contractedThingSyn = "";
	#ensemble =2E 2M Percussion Ensemble_ > 2e2mpercussionensemble
	#ensemble =The Bach Ensemble_ > thebachensemble
	my $string = $ADDONSLFName;
	$string =~ s/_$//;
	
	#
	#2012_01_17 -- work up the WLENS and ENSEMBLE names
	#
	my ($niceShort, $changedToken) = $self->abbreviateEnsembles($string);
	unless ($niceShort) {
	  $niceShort = $string;
	}
	my ($theLFName, $theLFKey) = $self->genCanonicalEnsembleLFKey($string);
	
	if ($theLFName ne $string) {

	  #warn "CONTRACTING ENSEMBLE LFName FROM \[$string\] TO \[$theLFName\]\n";

	  $contractedThingSyn = &genThingSyn($theLFName);
	  $self->postADDON($synType, $contractedThingSyn, $ADDONSLFName, $ADDONSShortValidity, $popupSerNumString, 'CHANGED');
	}
      }# if is ensemble
    }# if regenerating ensembles

  }# lines in ADDONS_EDITABLE


}# end of read_ADDONS_EDITABLE();

#my $synTypeisLegal = $exprHelperObject->synTypeIsLegal($synType);
sub synTypeIsLegal {
  shift(@_) if (ref($_[0]) eq 'FFScanHelper' ); 	# STATIC even if called on instance
  my ($synType) = @_;

#2011_09_05 -- make local hash of legal syntypes
  #return (grep(/^$synType$/, @FFATLASSyntax::LEGAL_SYN_TYPES) ) ;
  if ($LEGAL_SYNTYPES{$synType}) {
    return 1;
  }
  return undef;

}# end of $exprHelperObject->synTypeIsLegal();

#2011_08_03 -- add genLFKeyFromLFName

#my ($LFKey) = &FFScanHelper::genLFKeyFromLFName($LFName);
sub genLFKeyFromLFName {
  shift(@_) if (ref($_[0]) eq 'FFScanHelper' ); 	# STATIC even if called on instance
  my ($LFName) = @_;

  # if LFName has a _ in it, it is an asserted LFName HERE IT MUST BE SO!
  if ($LFName =~ /_/ ) {
    #$text =~ s/^(.*)_(.*)/$2$1/;	# we keep the LFName order for this
  } else {
    &comeToJesus( "genLFKeyFromLFName CALLED WITH NON-LFNAME TEXT \[$LFName\]", @_);
  }

  my $LFKey = lc(FFUTF::toIdiomaticLatinSafe($LFName));

  #2010_06_12 -- CWID now allows [/-] in workThingSyn for op 33/1
  ##$THINGSYNFlatName =~ s/[^a-z0-9]+//g;
  #$THINGSYNFlatName =~ s/[^a-z0-9\/-]+//g;
  #2011_08_03 -- MUST remove SLASH if it is to be URL-SAFE
  $LFKey =~ s/[^a-z0-9-]+//g;	# so flat LC alphas and - ONLY
  $LFKey = substr($LFKey, 0, 100);

  return $LFKey;
  
}# end of &genLFKeyFromLFName();

#my ($thingSyn) = &FFScanHelper::genThingSyn($text);
sub genThingSyn {
  shift(@_) if (ref($_[0]) eq 'FFScanHelper' ); 	# STATIC even if called on instance
  &FFATLASSyntax::genThingSyn;
}# end of &genThingSyn();

#my ($validity, $PNID, $LFName) = $self->ultimatePNIDFromThingSyn($synType, $thingSyn);
#sub ultimatePNIDFromThingSyn {
#  my ($self, $synType, $thingSyn) = @_;
#  my $PNID = "";
#  my $syn = $thingSyn;
#
#  my ($p, $f, $l) = caller();
#  #
#  # determine if synType is legal
#  #
#  my ($legalSynType)  = grep(/^$synType$/i, @FFATLASSyntax::LEGAL_SYN_TYPES);
#  unless ($legalSynType) {
#    comeToJesus( "FFScanHelper SAYS ILLEGAL_SYNTYPE: \[$synType\] LOOKING UP THINGSYN $thingSyn\n", @_);
#  }
#
#  unless ($thingSyn ) {
#    #print "FFScanHelper NOTICES EMPTY_THINGSYN OF TYPE \[$synType\] LOOKING UP THINGSYN \[$thingSyn\]\n";
#    return undef;
#  }
#  my $parentXID =  $self->{XIDS_OBJECT}->getParentXID( $synType, $thingSyn);
#  unless ( $parentXID ) {	# unless W_EDITABLE knows about this thingSyn
#    #
#    # this is used to try many synType/thingSyn combos, so undef is always OK
#    #
#    #print "FFScanHelper ultimatePNIDFromThingSyn NOTICES UNDEFINED_THINGSYN OF TYPE \[$synType\] LOOKING UP THINGSYN \[$thingSyn\]\n";
#    return undef;
#  }
#  my ($validityCode, $LFName, @thingSyns) = $self->{XIDS_OBJECT}->getXIDProperties($synType, $parentXID);
#  #print "FFScanHelper ultimatePNIDFromThingSyn NOTICES DEFINED_THINGSYN OF TYPE \[$synType\] parentXID \[$parentXID\] validityCode \[$validityCode\] LFName \[$LFName\] thingSyns \[@thingSyns\] LOOKING UP THINGSYN \[$thingSyn\]\n";
#  
#  return ($validityCode, $parentXID, $LFName);
#
#}# end of ultimatePNIDFromThingSyn();

#my ($thingSyn) = &FFScanHelper::genPNID($synType, $name0, $name1, $text);
#sub genPNID {
#  shift(@_) if (ref($_[0]) eq 'FFScanHelper' ); 	# STATIC even if called on instance
#  &FFATLASSyntax::genPNID;
#}# end of &genPNID();

#my $synTypeMustExist = $exprHelperObject->synTypeMustExist($synType);
sub synTypeMustExist {
  shift(@_) if (ref($_[0]) eq 'FFScanHelper' ); 	# STATIC even if called on instance
  my ($synType) = @_;
  return ($FFATLASSyntax::mustExistFlags{$synType});
}# end of $exprHelperObject->synTypeMustExist();

#######################
# SCAN SPECIFIC METHODS
#######################

#my $outText = &FFScanHelper::updateHead("ISSUE $VVI WITH BASE MARKUP TAGS", @headLines);

sub updateHead{
  my ($title, @headLines) = @_;

  my @stylesheet = &assembleMarkupStylesheet();

  my @newLines = ();
  my $inCSS = 0;

  foreach my $line (@headLines) {
    if ($inCSS == 0) {
      $line =~ s%^\s*<title>[^<>]*</title>\s*$%<title>$title</title>%;
      #
      # slew and copy until <style tag
      #
      if ($line =~ m%<style type="text/css">% ) {
	$inCSS = 1;
      }
      push (@newLines, $line);
    } elsif ($inCSS == 1) {
      #
      # slew and copy until <style tag
      #
      if ($line =~ m%</style>% ) {
	$inCSS = 2;
	push(@newLines, @stylesheet);
	push (@newLines, $line);
      } else {
	#
	# slew and discard until </style> tag
	#
	next;
      }
    } else {
      #
      # slew and copy until end
      #
      push (@newLines, $line);
    }
  }# while <head> lines

  my $newHeadText = join("\n", @newLines);
  $newHeadText .= "\n";

  return $newHeadText;

}# end of &FFScanHelper::updateHead();

#my @stylesheet = &FFScanHelper::checkCSS(%baseClassesUsed);
sub checkCSS {
  my (%baseClassesUsed) = @_;

  foreach my $baseClass (sort keys %baseClassesUsed) {
    $baseClass =~ s/\s*id=.*//;
    unless ($markupClassDefs{$baseClass} ) {
      warn "WARNING: NO DEFINITION IN FFScanHelper FOR MARKUP CSS CLASS \[$baseClass\]\n";
    }
  }

  my @stylesheet = &assembleMarkupStylesheet();

  return @stylesheet;
  
}# end of &FFScanHelper::checkCSS();

#my @stylesheet = &assembleMarkupStylesheet();
sub assembleMarkupStylesheet {
  # no args();
  #
  # assemble a markup stylesheet
  #
  my @stylesheet = ();
  foreach my $markupClass (sort keys %markupClassDefs ) {
    my $markupClassDef = $markupClassDefs{$markupClass};
    push (@stylesheet, qq{ .$markupClass $markupClassDef} );
  }

  return @stylesheet;

}# end of &assembleMarkupStylesheet();

#($longValidity, $labelName, $replacementString, $residue) = $helper->discoverLabelName(@words);
sub discoverLabelName {
  my ($self, @words) = @_;
  my $currentPNID;
  my $PNIDExists = "";
  my @residue = ();
  my $replacementString = "";
  my $residueString = "";
  my $isHit = 0;
  
  my $shortValidity = "";
  my $LFKey = "";
  my $LFName = "";
  my $canonicalThingSyn = "";
  my @recognitionThingSyns = ();

  my $labelName = "";

  while (@words) {
    my $trialString = join(" ", @words);	# make a trial string
    $trialString =~ s/^\s+//;		# trim leading ws
    $trialString =~ s/\s+$//;		# trim trailing ws
    #warn " TRYING \[$trialString\]\n";
    #($longValidity, $PNID, $LFName, $thingSyn) = $self->ultraUltimatePNIDFromText('label', $trialString);
#2011_08_26 -- revise ultraUltimate to ultraUltimateADDONFromText($synType, $text)
    #my ($shortValidity, $LFKey, $LFName, $canonicalThingSyn, @recognitionThingSyns) = $self->ultraUltimateADDONFromText($synType, $text);
    ($shortValidity, $LFKey, $LFName, $canonicalThingSyn, @recognitionThingSyns) = $self->ultraUltimateADDONFromText('label', $trialString);
    
#2015_12_25 -- extend discoverLabelName to =~
    if ($shortValidity eq '=' || $shortValidity eq '?' ) {	# if we match a proper name
      #warn "NUNK:00 \[$longValidity, $LFName, $thingSyn\]\n";
      #warn "FOUND CLEAN $synType: $definedDisplayName\n";
      $isHit++;
      $labelName = $LFName;
      last;
    } else {
      #warn "NUNK:01 \[$longValidity, $LFName, $thingSyn\]\n";
      unshift(@residue, pop(@words));	# discard the rightmost word to residue
    }
  }# as long as there are words in the remaining recording string

  if ($isHit) {
    $replacementString = join(" ", @words);	# the original text of the label
    $residueString = join(" ", @residue);	# the words after the synonym
  } else {
    $labelName = "";
  }

  return ($shortValidity, $labelName, $replacementString, $residueString);
}# end of &discoverLabelName(@words);

#my $newLine = &FFScanHelper::flagUnbalancedTags($line);
sub flagUnbalancedTags {
  my ($line) = @_;

  return "" if ($line =~ /STET_/);
  return "" if ($line =~ /BAD_PARA_FIX_UNBALANCED_TAG/);

  my $newLine = "";
  #my @insistOnAntiTag = qw{ p span b i sup};
  my @insistOnAntiTag = qw{ p span sup};

  my %tags = ();
  my %antiTags = ();

  my $residue = $line;
  while ($residue =~ s/<([^<>]*)>//) {
    my $tag = $1;
    $tag =~ tr/A-Z/a-z/;
    $tag =~ s/\s*class.*//;
    if ($tag =~ s%^/%%) {
      $antiTags{$tag}++;
    } else {
      $tags{$tag}++;
    }
  }# while extracting tags

  #
  # now check for balance
  #

  foreach my $tag (@insistOnAntiTag) {
    my $numTags = $tags{$tag};
    $numTags = 0 unless $numTags;
    my $numAntiTags = $antiTags{$tag};
    $numAntiTags = 0 unless $numAntiTags;
    if ($numTags == $numAntiTags) {
      #warn "BALANCED: \[$tag\] \[$numTags\] \[$numAntiTags\]\n" if ($numTags > 0);
    } else {
      warn "FIX_UNBALANCED_TAG: \[$tag\] \[$numTags\] \[$numAntiTags\] \[$line\]\n";
      $newLine = $line;
      $newLine =~ s%<p[^<>]*>%<p class=BAD_PARA_FIX_UNBALANCED_TAG tag=$tag>%;
      last;
    }
  }# each tag that ought to be balanced


  return $newLine;

}# end of &flagUnbalancedTags();

#$helper->postADDON($synType, $thingSyn, $ADDONSLFName, $ADDONSShortValidity, $serNum, $changed);
sub postADDON {
  my ($self, $synType, $thingSyn, $ADDONSLFName, $ADDONSShortValidity, $serNum, $changed) = @_;

  $thingSyn = &trims($thingSyn);
  $ADDONSLFName = &trims($ADDONSLFName);

  $ADDONSShortValidity = &trims($ADDONSShortValidity);

#2014_01_10 -- put in local queues
	if ($ADDONSShortValidity eq '!') {
		$self->queueBang($synType, $ADDONSShortValidity, $ADDONSLFName, $thingSyn, $serNum);
	}

#2013_03_18 -- FREE: let duplicate ADDON NAMES and their thingSyns BE published
  my $FREE = "";
  if ($self->{FREE} eq "FREE") {
    $FREE = "FREE";
  }

  my $placePrefix = "POSTADDON";
  my $place = "";

  $place = $placePrefix . "000";

#2013_12_25 -- change &amp and & to leave residue
  #
  # check for multiply defined thingSyn
  #
  my $thingSynDef = "";
  if (defined ${$self->{'THINGSYN'}->{$synType}->{$thingSyn}} ) {
    $thingSynDef = ${$self->{'THINGSYN'}->{$synType}->{$thingSyn}};
  }

	$place = $placePrefix . "010";
	#$self->log("ALARM", "ARRGH_03:$synType, $thingSyn, $ADDONSLFName, $ADDONSShortValidity, $serNum, $changed\n" , $serNum, $place, @_ ) if ($ADDONSLFName =~ /Women of the RIAS C Ch .amp; Berlin R SO/);
  if ($thingSynDef) {
    if ($thingSynDef eq $ADDONSLFName) {
      #
      # we already know about this thingSyn ADDON_ENTRY relationship
      # see if we should bump its validity (e.g. due to assertion in BASE)
      #
      my $currentShortValidity = ${$self->{'ADDONS_SHORT_VALIDITY'}->{$synType}->{$ADDONSLFName}};
      my %validityRank = (
	'=' => 3,
	'?' => 2,
	'!' => 1,
      );
      if ($validityRank{$ADDONSShortValidity} > $validityRank{$currentShortValidity} ) {
	${$self->{'ADDONS_SHORT_VALIDITY'}->{$synType}->{$ADDONSLFName}} = $ADDONSShortValidity;
      }

#2013_03_18 -- FREE: let duplicate ADDON NAMES and their thingSyns BE published
    } elsif ($FREE) {
      $place = $placePrefix . "010";

			#$self->log("ALARM", "POSTING_FREE: synType \[$synType\] thingSyn \[$thingSyn\] ADDONSLFName \[$ADDONSLFName\] ADDONSShortValidity \[$ADDONSShortValidity\] serNum \[$serNum\] changed \[$changed\]\n" , $serNum, $place, @_ );

      #warn "\nPOSTING_FREE: synType \[$synType\] thingSyn \[$thingSyn\] serNum \[$serNum\] \n";
      my $LFName2 = $thingSynDef;
      my $val2 = ${$self->{'ADDONS_SHORT_VALIDITY'}->{$synType}->{$LFName2}};
      my @ts2 = sort keys %{$self->{'ADDONS_LFNAME'}->{$synType}->{$ADDONSLFName}};
      my $ts2 = join(" ", @ts2);
      warn " FFScanHelper->postADDON reports EXISTING_PAIR $synType $ADDONSShortValidity$ADDONSLFName VS. $val2$LFName2\n"; 

#2014_01_10 -- put in local queues
			$self->queueDuplicate($synType, $ADDONSShortValidity, $ADDONSLFName, $synType, $val2, $LFName2);
    } else {
      #
      # we are attempting to assign this thingSyn to more than 1 ADDON_ENTRY
      #

      #
      # line up the output
      #

      my $rec1 = "$synType\t$ADDONSShortValidity$ADDONSLFName\t>$thingSyn\n"; 

      my $LFName2 = $thingSynDef;
      my $val2 = ${$self->{'ADDONS_SHORT_VALIDITY'}->{$synType}->{$LFName2}};
      my @ts2 = sort keys %{$self->{'ADDONS_LFNAME'}->{$synType}->{$ADDONSLFName}};
      my $ts2 = join(" ", @ts2);

      #${$self->{'ADDONS_LFNAME'}->{$synType}->{$ADDONSLFName}->{$thingSyn}}++;
      #${$self->{'ADDONS_SHORT_VALIDITY'}->{$synType}->{$ADDONSLFName}} = $ADDONSShortValidity;

      my $rec2 = "$synType\t$val2$LFName2\t>$ts2\n"; 

      $place = $placePrefix . "899";
      $self->log("WARN", "REC1: $rec1\n" , $serNum, $place, @_ );
      $self->log("WARN", "REC2: $rec2\n" , $serNum, $place, @_ );
      #
      # this is picked up in sub writeCONCORDANCERecFromFFScanHelper
      #
      ${$self->{REC2}->{$rec2}->{$rec1}}++;


      $place = $placePrefix . "900";
      $self->log("WARN", "IGNORING ATTEMPT TO ASSIGN THINGSYN: synType \[$synType\] thingSyn \[$thingSyn\] ADDONSLFName \[$ADDONSLFName\] ADDONSShortValidity \[$ADDONSShortValidity\] serNum \[$serNum\] changed \[$changed\] BECAUSE CANONICAL THINGSYN \[$thingSyn\] ALREADY HAS LFNAME \[$thingSynDef\]\n" , $serNum, $place, @_ );
      return "";
    }
  } 
  #
  # this thingSyn can and should be assigned to this ADDON_ENTRY
  #
  ${$self->{'THINGSYN'}->{$synType}->{$thingSyn}} = $ADDONSLFName;
  ${$self->{'ADDONS_LFNAME'}->{$synType}->{$ADDONSLFName}->{$thingSyn}}++;
  ${$self->{'ADDONS_SHORT_VALIDITY'}->{$synType}->{$ADDONSLFName}} = $ADDONSShortValidity;
  ${$self->{'ADDONS_IS_CHANGED'}->{$synType}->{$ADDONSLFName}} = $changed;

  push (@{$self->{'ADDONS_POPUP_SERNUMS'}->{$synType}->{$ADDONSLFName}}, $serNum) if $serNum;

  return "";

}# end of &postADDON();

#my ($validity, \@thingSyns, \@citations) = $helper->unpostADDON($synType, $ADDONSLFName );
sub unpostADDON {
  my ($self, $synType, $ADDONSLFName) = @_;

	#${$self->{'THINGSYN'}->{$synType}->{$thingSyn}} = $ADDONSLFName;

	#${$self->{'ADDONS_LFNAME'}->{$synType}->{$ADDONSLFName}->{$thingSyn}}++;
	#${$self->{'ADDONS_SHORT_VALIDITY'}->{$synType}->{$ADDONSLFName}} = $ADDONSShortValidity;
	#${$self->{'ADDONS_IS_CHANGED'}->{$synType}->{$ADDONSLFName}} = $changed;
	#push (@{$self->{'ADDONS_POPUP_SERNUMS'}->{$synType}->{$ADDONSLFName}}, $serNum) if $serNum;

	#
	# get all the present values
	#

	my @thingSyns = sort keys (%{$self->{'ADDONS_LFNAME'}->{$synType}->{$ADDONSLFName}}) ;
	
	my @citations = @{$self->{'ADDONS_POPUP_SERNUMS'}->{$synType}->{$ADDONSLFName}};
	my $validity = ${$self->{'ADDONS_SHORT_VALIDITY'}->{$synType}->{$ADDONSLFName}};
	my $changed = ${$self->{'ADDONS_IS_CHANGED'}->{$synType}->{$ADDONSLFName}};

	#
	# obliterate the records
	#
	undef %{$self->{'ADDONS_LFNAME'}->{$synType}->{$ADDONSLFName}};
	undef @{$self->{'ADDONS_POPUP_SERNUMS'}->{$synType}->{$ADDONSLFName}};
	undef ${$self->{'ADDONS_SHORT_VALIDITY'}->{$synType}->{$ADDONSLFName}};
	undef ${$self->{'ADDONS_IS_CHANGED'}->{$synType}->{$ADDONSLFName}};

	#warn "($validity, @thingSyns, @citations)\n";
	return ($validity, \@thingSyns, \@citations);

}# end of unpostADDON()


#my (@serNums) = $self->getPOPUPsFromLFName($synType, $LFName);
sub getPOPUPsFromLFName {
  my ($self, $synType, $LFName) = @_;
  my %uniqueSerNums = ();
  foreach my $serNumString (@{$self->{'ADDONS_POPUP_SERNUMS'}->{$synType}->{$LFName}} ) {
    my @fetchedSerNums = split(/\s+/, $serNumString);
    foreach my $serNum (@fetchedSerNums) {
      next unless $serNum;
      $serNum = &trims($serNum);
      $uniqueSerNums{$serNum}++;
    }
  }
  my @serNums = (sort keys %uniqueSerNums);
  return (@serNums);
}# end of &getPOPUPsFromLFName();

#my ($ADDONSLFName, $ADDONSShortValidity, @thingSyns) = $self->seekADDONFromThingSyn($synType, $thingSyn);
sub seekADDONFromThingSyn {
  my ($self, $synType, $thingSyn) = @_;
  
  #2013_01_02 -- look for missing leading THE
  #warn "THE30: $thingSyn\n" if ($thingSyn =~ /aterofvoices/);
  


  my $ADDONSLFName = "";
  my $ADDONSShortValidity = "";
  my @thingSyns = ();

    if (defined ${$self->{'THINGSYN'}->{$synType}->{$thingSyn}} ) {
      $ADDONSLFName = ${$self->{'THINGSYN'}->{$synType}->{$thingSyn}};
    }
  
  #2013_01_02 -- look for missing leading THE
  #warn "THE31: $ADDONSLFName\n" if ($thingSyn =~ /aterofvoices/);

    if (defined ${$self->{'ADDONS_SHORT_VALIDITY'}->{$synType}->{$ADDONSLFName}} ) {
      $ADDONSShortValidity = ${$self->{'ADDONS_SHORT_VALIDITY'}->{$synType}->{$ADDONSLFName}};
    }
    if (%{$self->{'ADDONS_LFNAME'}->{$synType}->{$ADDONSLFName}} ) {
      @thingSyns = sort keys %{$self->{'ADDONS_LFNAME'}->{$synType}->{$ADDONSLFName}};
    }
  
  #2013_01_02 -- look for missing leading THE
  #warn "THE39: $ADDONSLFName, $ADDONSShortValidity, @thingSyns\n" if ($thingSyn =~ /aterofvoices/);

  return ($ADDONSLFName, $ADDONSShortValidity, @thingSyns);

}# end of &seekADDONFromThingSyn();

#my ($ADDONSShortValidity, @thingSyns) = $self->getADDONFromLFName($synType, $LFName);
sub getADDONFromLFName {
  my ($self, $synType, $ADDONSLFName) = @_;
  my $ADDONSShortValidity = ""; 
  my @thingSyns = ();
  $ADDONSShortValidity = ${$self->{'ADDONS_SHORT_VALIDITY'}->{$synType}->{$ADDONSLFName}};
  @thingSyns = sort keys %{$self->{'ADDONS_LFNAME'}->{$synType}->{$ADDONSLFName}};

  return ($ADDONSShortValidity, @thingSyns);

}# end of &getADDONFromLFName();

#my (@LFNames) = $self->getADDON_LFNames($synType);
sub getADDON_LFNames {
  my ($self, $synType) = @_;

  my @LFNames = sort keys %{$self->{'ADDONS_LFNAME'}->{$synType}};
	my @nonEmpty = ();

	foreach my $LFName (@LFNames) {
		if (%{$self->{'ADDONS_LFNAME'}->{$synType}->{$LFName}} ) {
			push(@nonEmpty, $LFName);
		} else {
			#warn "EMPTY LFNAME: $LFName\n";
			next;
		}
	}

  return @nonEmpty;

}# end of &getADDON_LFNames();

#my $ADDONSShortValidity = &validityLongToShort($synType, $longValidity);
#sub validityLongToShort {
#  my ($synType, $longValidity) = @_;
#  my %longToShort = (
#    '!!' => '!',
#    '=!' => '!',
#    '=?' => '?',
#    '==' => '=',
#  );
#  return "" unless ($longValidity);
#  my $lookupVal = $longToShort{$longValidity};
#  if ($lookupVal) {
#    return $lookupVal;
#  } else {
#    &comeToJesus("CANNOT LOOK UP STRANGE LONG_VALIDITY \[$longValidity\]", @_);
#  }
#}# end of &validityLongToShort();

#my $ADDONShortTextValidity = $helper->ADDONShortTextValidity('voice', $roleText);
#sub ADDONShortTextValidity {
#  my ($self, $synType, $text) = @_;
#
#  $text = &trims($text);
#  return "" unless $text =~ /\w/;
##2011_08_26 -- revise ultraUltimate to ultraUltimateADDONFromText($synType, $text)
#  my ($shortValidity, $LFKey, $LFName, $canonicalThingSyn, @recognitionThingSyns) = $self->ultraUltimateADDONFromText($synType, $text);
#
#  my $ADDONShortTextValidity = ($sv =~ /!/) ? "" : $shortValidity;
#  
#  return $ADDONShortTextValidity;
#  
#}# end of &ADDONShortTextValidity();

#my $longValidity = &validityShortToLong($synType, $ADDONSShortValidity);
#sub validityShortToLong {
#  my ($synType, $ADDONSShortValidity) = @_;
#  my $longValidity = "";
#  my %shortToLong = (
#    '!' => '=!',
#    '?' => '=?',
#    '=' => '==',
#  );
#  my $lookupVal = $shortToLong{$ADDONSShortValidity};
#  if ($lookupVal) {
#    if ($lookupVal eq '=!') {
#      if ($FFATLASSyntax::mustExistFlags{$synType} ) {
#	$lookupVal = '!!';
#      }
#    }
#    return $lookupVal;
#  } else {
#    &comeToJesus("CANNOT LOOK UP STRANGE SHORT_VALIDITY \[$ADDONSShortValidity\]", @_);
#  }
#}# end of &validityShortToLong();

#my $PNID = &PNIDFromScratch($synType, $LFName);
#sub PNIDFromScratch {
#  my ($synType, $text) = @_;
#  my $PNID = "";
#  my $LFName = "";
#
#  #
#  # if text contains _, it is an asserted LFName, so gen PNID using names
#  # otherwise, gen PNID using text
#  #
#  my ($PNID, $new_name0, $new_name1) = ();
#  if ($text =~ /^(.*)_(.*)$/) {
#    ($PNID, $new_name0, $new_name1) = &genPNID($synType, $1, $2, "");
#  } else {
#    ($PNID, $new_name0, $new_name1) = &genPNID($synType, "", "", $text);
#  }
#
#  if ($FFATLASSyntax::synType_is_person{$synType} ) {
#    #
#    # LFName is a person
#    #
#    $LFName = $new_name0 . '_' . $new_name1;
#  } else {
#    #
#    # LFName is a thing
#    #
#    $LFName = $new_name0 . '_';
#    if ($new_name1) {
#      warn "FUNNY THING LFName HAS NAME1: \[$new_name0\] \[$new_name1\]\n";
#    }
#  }
#
#  return ($PNID, $LFName);
#}# end of &PNIDFromScratch();

#$helper->testASSEscapes();
sub testASSEscapes {
  my ($self) = @_;

  my @origLines = (
    qq{A1 <PIG>pig1</PIG> A2 <PIG>pig2</PIG> Z1},
    qq{B1 <CLAM>clam1</CLAM> B2 <CLaM>clam2</clam> Z2},
    qq{C1 <PIG>pig3</PIG> C2 <CLAM>clam3</CLAM> Z3},
  );

  #
  #  ESCAPE PIGS
  #
  foreach my $origLine(@origLines) {
    my @ASSTypes = ('PIG');
    my $newLine = $self->escapeAssertions($origLine, @ASSTypes);
    warn "ESCAPE of ASSERTIONS \[@ASSTypes\]: \[$origLine\] => \[$newLine\]\n";
    my $recoveredLine = $self->unescapeAssertions($newLine, @ASSTypes);
    warn "UNESCAPE of ASSERTIONS \[@ASSTypes\]: \[$origLine\] => \[$recoveredLine\]\n";
  };

  #
  #  ESCAPE CLAMS
  #
  foreach my $origLine(@origLines) {
    my @ASSTypes = ('CLAM');
    my $newLine = $self->escapeAssertions($origLine, @ASSTypes);
    warn "ESCAPE of ASSERTIONS \[@ASSTypes\]: \[$origLine\] => \[$newLine\]\n";
    my $recoveredLine = $self->unescapeAssertions($newLine, @ASSTypes);
    warn "UNESCAPE of ASSERTIONS \[@ASSTypes\]: \[$origLine\] => \[$recoveredLine\]\n";
  };

  #
  #  ESCAPE BOTH
  #
  foreach my $origLine(@origLines) {
    my @ASSTypes = ('PIG', 'CLAM');
    my $newLine = $self->escapeAssertions($origLine, @ASSTypes);
    warn "ESCAPE of ASSERTIONS \[@ASSTypes\]: \[$origLine\] => \[$newLine\]\n";
    my $recoveredLine = $self->unescapeAssertions($newLine, @ASSTypes);
    warn "UNESCAPE of ASSERTIONS \[@ASSTypes\]: \[$origLine\] => \[$recoveredLine\]\n";
  };

}# end of %testASSEscapes();

#$helper->testASSHandles();
sub testASSHandles {
  my ($self) = @_;

  my @types = qw{FROG PIG TOAD PEACOCK};
  my @strings = qw{lard fat grease};
  my @ASSHandles = ();

  #
  # TEST CACHING
  #

  foreach my $type (@types) {
    foreach my $string (@strings) {
    my $assertedString = $type . $string;
      my $ASSHandle = $self->cacheAssertedString($assertedString, $type);
      warn "RETURNED_ASSHANDLE IS \[$ASSHandle\] for \[$type\] \[$assertedString\]\n";
      push (@ASSHandles, $ASSHandle);
    }
  }

  #
  # NOW GET THEM BACK
  #
  foreach my $ASSHandle (@ASSHandles) {
    my $assertedString = $self->retrieveAssertedString($ASSHandle);
    warn "ASSHANDLE \[$ASSHandle\] RETURNS ASSERTION_STRING \[$assertedString\]\n";
  }

}# end of &testASSHandles();

#my $ASSHandle = $helper->cacheAssertedString($assertedString, $type);
sub cacheAssertedString {
  my ($self, $assertedString, $type) = @_;
  my $ASSHandle = "";

  #ASS_FROG_00002
  $ASSHandle = sprintf("ASS_%s_%05d", $type, ${$self->{'ASSNUM'}->{$type}}++); 
  ${$self->{'ASSHANDLES'}->{$ASSHandle}} = $assertedString;

  return $ASSHandle;
  
}# end of &cacheAssertedString();

#my $assertedString = $helper->retrieveAssertedString($ASSHandle);
sub retrieveAssertedString {
  my ($self, $ASSHandle) = @_;

  my $assertedString = ${$self->{'ASSHANDLES'}->{$ASSHandle}};

  return $assertedString;
  
}# end of &retrieveAssertedString();

#my $newLine = $helper->escapeAssertions($line, @ASSTypes);
sub escapeAssertions {
  my ($self, $line, @ASSTypes) = @_;
  my $newLine = $line;

  foreach my $ASSType (@ASSTypes) {
    $ASSType =~ tr/[a-z]/[A-Z]/;
    while ($newLine =~ s%<$ASSType>(.*?)</$ASSType>%GORGO%i ) {
      my $assertedString = $1;

      #
      # move trailing significant punctuation outside of asserted string
      #
      my $trailingPunct = "";
      if ($assertedString =~ s%([ ;,]+)$%% ) {	# vrole Josef K.
	$trailingPunct = $1;
      }

      my $ASSHandle = $self->cacheAssertedString($assertedString, $ASSType);
      $newLine =~ s/GORGO/$ASSHandle$trailingPunct/;
    }# while line contains assertions of this type
  }# each assertion type we are asked to escape

  return $newLine;

}# end of &escapeAssertions();

#my $newLine = $helper->unescapeAssertions($line, @ASSTypes);
sub unescapeAssertions {
  my ($self, $line, @ASSTypes) = @_;
  my $newLine = $line;

  foreach my $ASSType (@ASSTypes) {
    $ASSType =~ tr/[a-z]/[A-Z]/;
    my $ASSHandlePrefix = "ASS_" . $ASSType . "_";
    while ($newLine =~ s%($ASSHandlePrefix\d\d\d\d\d)%GORGO%i ) {
      my $ASSHandle = $1;
      my $assertedString = $self->retrieveAssertedString($ASSHandle);
      $newLine =~ s%GORGO%<$ASSType>$assertedString</$ASSType>%;
    }# while escaped string has ASSHandles of this type
  }# each assertion type we are asked to unescape

  return $newLine;

}# end of &unescapeAssertions();

#my $newLine = $helper->unescapeAndDetagAssertions($line, @ASSTypes);
sub unescapeAndDetagAssertions {
  my ($self, $line, @ASSTypes) = @_;
  my $newLine = $self->unescapeAssertions($line, @ASSTypes);

  foreach my $ASSType (@ASSTypes) {
    $newLine =~ s%</?$ASSType>%%ig;
  }

  return $newLine;

}# end of &unescapeAndDetagAssertions();

#my @synTypesOfName = $helper->getSynTypesOfText($PRName, @possibleSynTypes);
sub getSynTypesOfText {
  my ($self, $PRName, @possibleSynTypes) = @_;
  my @synTypesOfName = ();


  my $placePrefix = "GETSYNTYPESOFTEXT";
  my $place = "";
  my $serNum = "";

  $place = $placePrefix . "000";
#2015_12_24 -- check for missing VROLE
  #$self->log("ALARM", "getSynTypesOfText ENTRY: PRNAME: \[$PRName\] POSSIBLE_SYNTYPES: \[@possibleSynTypes\]" , $serNum, $place, @_ ) if ($PRName =~ /david thomas|John Milne|Elisabeth Grümmer/i);
	#$self->log("NOTE", "getSynTypesOfText ENTRY: PRNAME: \[$PRName\] POSSIBLE_SYNTYPES: \[@possibleSynTypes\]" , $serNum, $place, @_ );

	if ($PRName =~ /VROLE/) {
		@synTypesOfName = qw(vrole);
		return @synTypesOfName;
	}


  $PRName =~ s/ASS_SUP_\d\d\d\d\d//g;	# ditch the SUP assertions

  #
  # use assertion if we've got one
  #

  #2012_07_01 -- remove vrole -- we have already got it if it is there
  if ($PRName =~ /^\s*ASS_(.*?)_\d\d\d\d\d\s*$/ ) {
    my $assertedSynType = $1;
    $assertedSynType =~ tr/[A-Z]/[a-z]/;
    if ($assertedSynType =~ /paren/i) {
      #
      # is paren, see if there is a VROLE assertion inside
      #
      my $parenExpr = $self->unescapeAssertions($PRName, "PAREN");
      if ($assertedSynType =~ /^\s*ASS_(VROLE)_\d\d\d\d\d\s*$/i ) {
	$assertedSynType = 'VROLE';
	$place = $placePrefix . "100";
	$self->log("NOTE", "getSynTypesOfText RETURNING_VROLE: \[$assertedSynType\] PRNAME: \[$PRName\] POSSIBLE_SYNTYPES: \[@possibleSynTypes\]" , $serNum, $place, @_ );
	return ($assertedSynType);
      }
    } else {
      #
      # the syntype is the syntype of the assertion
      #
      $place = $placePrefix . "110";
      $self->log("NOTE", "getSynTypesOfText RETURNING_OTHER_ASSERTION: \[$assertedSynType\] PRNAME: \[$PRName\] POSSIBLE_SYNTYPES: \[@possibleSynTypes\]" , $serNum, $place, @_ );
      return ($assertedSynType);
    }
  }

  $PRName = &trims($PRName);		# trim it

  return ("_MT_") unless $PRName;

		$place = $placePrefix . "110";
		#$self->log("NOTE", "getSynTypesOfText HERE WITH PRNAME \[$PRName\] AND POSSIBLEPSYNTYPES \[@possibleSynTypes\]" , $serNum, $place, @_ );

  if ($PRName =~ /PAREN/) {
    #
    # this is a parenthetical expression -- determine its habits
    #
	print "CALLING getParentheticalType: \[$PRName\]\n";
#2011_08_28 -- improve resolution of PARENS e.g. MEMBERS, VROLES, DIRS
    my $parentheticalType = $self->getParentheticalType($PRName);
	print "RETURNING FROM getParentheticalType: \[$PRName\] \[$parentheticalType\]\n";

    #'VROLE'
    #'MEMBERS'
    #'DIRECTOR'
    #'CITY'

    #
    # could be a VROLE
    #
#2014_02_13 -- fix MEMBERS vs. VROLE
		$place = $placePrefix . "110";
		#$self->log("NOTE", "WE ARE HERE WITH PARENTHETAL_TYPE \[$parentheticalType\]" , $serNum, $place, @_ );

    #if ($ULTshortValidity eq '=') {	#}

#2016_01_21 -- do not invoke members if TOKEN does'nt contain ;  or ,
    if ($parentheticalType =~ /vrole/i) {
      push(@synTypesOfName, 'vrole');
    } elsif ($parentheticalType =~ /city/i) {
      push(@synTypesOfName, 'city');
    } elsif ($parentheticalType =~ /director/i) {
      push(@synTypesOfName, '_DIRECTOR_');
    } elsif ($parentheticalType =~ /members/i) {
      push(@synTypesOfName, '_MEMBERS_');
    } else {
      push(@synTypesOfName, "_UNKN_");
    }
    $place = $placePrefix . "200";
    $self->log("NOTE", "getSynTypesOfText RETURNING_PAREN: \[$parentheticalType\] SYNTYPES_OF_NAME: \[@synTypesOfName\] PRNAME: \[$PRName\] POSSIBLE_SYNTYPES: \[@possibleSynTypes\]" , $serNum, $place, @_ );
    print "getSynTypesOfText RETURNING_PAREN: SYNTYPES_OF_NAME: \[@synTypesOfName\] PRNAME: \[$PRName\] POSSIBLE_SYNTYPES: \[@possibleSynTypes\]\n";
    return @synTypesOfName;
  } elsif ($PRName =~ /[a-z]/) {
    #
    # likely name of something or somebody
    #
    #2012_07_01 -- remove vrole -- we have already got it if it is there
    #
    foreach my $possibleSynType (@possibleSynTypes ) {
      next if ($possibleSynType =~ /vrole/i);
    
      my ($ULTshortValidity, $ULTLFKey, $ULTLFName, $ULTcanonicalThingSyn, @ULTrecognitionThingSyns) = $self->ultraUltimateADDONFromText($possibleSynType, $PRName);
      if ($ULTshortValidity eq '=' || $ULTshortValidity eq '?') {
	#
	# FOUND DEFINITION IN ADDONS
	#
	push(@synTypesOfName, $possibleSynType);
      }
    }# each possible syntype
  } else {
    #
    # NOT A NAME -- IS PUNCT
    #
    push(@synTypesOfName, "_PUNCT_");
  }

  unless (@synTypesOfName) {
    push(@synTypesOfName, "_UNKN_");
  }

  $place = $placePrefix . "900";
	#$self->log("NOTE", "getSynTypesOfText RETURNING_SYNTYPES: \[@synTypesOfName\] PRNAME: \[$PRName\] POSSIBLE_SYNTYPES: \[@possibleSynTypes\]" , $serNum, $place, @_ );
  return @synTypesOfName;
  
}# end of &getSynTypesOfText();

#($synTypeProfile, @typedPRNames) = $helper->getSynTypeProfile(\@PRNames, \@possibleSynTypes);
sub getSynTypeProfile {
  my ($self, $namesRef, $possibleSynTypesRef) = @_;

  my $placePrefix = "SYNTYPEPROFILE";
  my $place = "";
  my $serNum = "";

  my @names = @$namesRef;
  my @possibleSynTypes = @$possibleSynTypesRef;

  my @typednames = ();
  my %uniqueDiscoveredSynTypes = ();

  for (my $i=0; $i <= $#names; $i++) {
    my $name = $names[$i];
    #2011_06_20 exclude ASS_FILLERS
    #next if ($name =~ /^\s*ASS_FILLER_\d\d\d\d\d\s*$/ );

    #2011_06_23 -- preserve ASS_FILLERS!
    if ($name =~ /^\s*ASS_FILLER_\d\d\d\d\d\s*$/ ) {
      $typednames[$i] = $name;
      next;
    }

    #2012_06_09 -- accomodate ASS_VARs!
    if ($name =~ /^\s*ASS_VAR_\d\d\d\d\d\s*$/ ) {
      $typednames[$i] = $name;
      next;
    }

    #2012_07_01 -- fix the blowout due to ASS_ENSEMBLE etc. not looking up
    # need to look upon ASS_SYNTYPE_\d{5,5} for definitive results

    #} elsif (grep(/$firstSynType$/, (ASS_ENSEMBLE ASS_LEADERMODE ASS_LEADER ASS_VOICE ASS_VROLE ASS_INSTRUMENT ASS_SINGER ASS_INSTRUMENTALIST ASS_CITY ASS_PERFORMER) ) ) {
    #
    # a true (???) synType -- add to our list of unique ones
    #
    #$uniqueDiscoveredSynTypes{$firstSynType}++;
    #my $discoveryEntry = "_" . $firstSynType . "_" . $name;
    #$typednames[$i] = $discoveryEntry;
    # 

    #
    # take care of parens with vroles
    #
#2014_02_13 -- fix MEMBERS vs. VROLE
    $place = $placePrefix . "100";
		#$self->log("NOTE", "getSynTypeProfile IS_CALLING getSynTypesOfText WITH ARGS \[$name\] \[@possibleSynTypes\]" , $serNum, $place, @_ );
    my @synTypesOfName = $self->getSynTypesOfText($name, @possibleSynTypes);

#2015_12_24 -- check for missing VROLE
	#$self->log("ALARM", "getSynTypeProfile HAS_CALLED getSynTypesOfText WITH ARGS \[$name\] \[@possibleSynTypes\] WITH_RESULTS \[@synTypesOfName\]" , $serNum, $place, @_ ) ;
		#$self->log("NOTE", "getSynTypeProfile HAS_CALLED getSynTypesOfText WITH ARGS \[$name\] \[@possibleSynTypes\] WITH_RESULTS \[@synTypesOfName\]" , $serNum, $place, @_ );

    #
    # just take the first one -- the possibleSynTypes are ordered
    #
    my $firstSynType = $synTypesOfName[0];
#2014_02_13 -- fix MEMBERS vs. VROLE
		#$self->log("NOTE", "RESULTS \[$firstSynType\]" , $serNum, $place, @_ );

    if ($firstSynType =~ /^_.*_$/ ) {	# not a real synType, e.g. _PUNCT_
      my $discoveryEntry = "$firstSynType" . $name;
      $typednames[$i] = $discoveryEntry;
      #
      # IMPLY ensemble if MEMBERS CITY AND DIRECTOR found
      #
      if ($firstSynType =~ /(CITY|MEMBERS|DIRECTOR)/ ) {
	my $ensHint = $1;
	$place = $placePrefix . "200";
	$uniqueDiscoveredSynTypes{'ensemble'}++;
	#$self->log("NOTE", "getSynTypeProfile IS_INFERRING synType ENSEMBLE from presence of \[$ensHint\]" , $serNum, $place, @_ );
      } elsif ($firstSynType =~ /(VROLE)/ ) {
	my $vHint = $1;
	$place = $placePrefix . "210";
	$uniqueDiscoveredSynTypes{'vrole'}++;
	$self->log("ALARM", "getSynTypeProfile IS_INFERRING synType VROLE from presence of \[$vHint\]" , $serNum, $place, @_ );
      }
    } elsif (grep(/^$firstSynType$/, @possibleSynTypes) ) {
      #
      # a true synType -- add to our list of unique ones
      #
      $uniqueDiscoveredSynTypes{$firstSynType}++;
      my $discoveryEntry = "_" . $firstSynType . "_" . $name;
      $typednames[$i] = $discoveryEntry;
    } else {
      if ($name =~ /ASS/) {
	$name = $self->unescapeAssertions($name, ('PAREN', 'VROLE', 'MEMBERS', 'DIRECTOR', 'CITY', 'ENSEMBLE'));
      }
      &comeToJesus( "GOT STRANGE FIRST SYNTYPE FROM getSynTypesOfText \[$firstSynType\] FOR NAME \[$name\]\n", @_);
    }
  }# each name by $i;

  my $synTypeProfile = join(" ", (sort keys %uniqueDiscoveredSynTypes) );

  return ($synTypeProfile, @typednames);

}# end of &getSynTypeProfile();

#my ($isLikelyEnsemble) = $helper->isLikelyEnsemble($string);
sub isLikelyEnsemble {
  my ($self, $string) = @_;

  my $isLikelyEnsemble = "";
  my $contractedEnsemble = "";
  my $expandedEnsemble = "";

  $string =~ s/ASS_SUP_\d\d\d\d\d//g;

  #2012_02_07 -- ADD ESCAPEMENT FOR O'MALLY

  #warn "IS AN O'MALLY BLOCK \[$string\]\n" if ($string =~ /O[’']/); 
  $string =~ s/O[’']/O_APOSTROPHE_/;

  #
  # can it be expanded?
  #
  my ($expandedString, $changed) = $self->expandEnsembleAbbreviations($string);
  if ($expandedString ne $string) {
    $isLikelyEnsemble++;
    $expandedEnsemble = $expandedString;
  }

  #
  # can it be contracted?
  #
  my ($contractedString, $changed2) = $self->abbreviateEnsembles($string);
  if ($contractedString ne $string) {
    $isLikelyEnsemble++;
    $contractedEnsemble = $expandedString;
  }

  return ($isLikelyEnsemble);

}# end of &isLikelyEnsemble();

#my ($isLikelyInstrument) = $helper->isLikelyInstrument($string);
sub isLikelyInstrument {
  my ($self, $string) = @_;
  my $isLikelyInstrument = "";

  $string =~ s/ASS_SUP_\d\d\d\d\d//g;

  $string = &trims($string);

  #
  # looking for lower case beginning of last word of string
  # e.g. the v in violin or Baroque violin 
  #
  $string =~ s/.* //;

  if ($string =~ /^[a-z]/ ) {
    $isLikelyInstrument++;
  }

  return ($isLikelyInstrument);

}# end of &isLikelyInstrument();

#my $cleanDatumAVPair = FFScanHelper::cleanDatumAVPair($a, $v);
sub cleanDatumAVPair {
  my ($a, $v) = @_;

  unless ($a =~ /__/) {
    $v = &trims($v);
    $v =~ s/\.$//;
    #
    # get all sups and angle brackets out of non-diagnostic DATUM ASSERTIONS
    #
    $v =~ s%<sup>[^<>]*</sup>%%g;
    $v =~ s%<[^<>]+>%%g;
    $v =~ s%[<>]+%%g;
  }

  return $v;

}# end of &cleanDatumAVPair();

#my $unifiedName = $helper->unifiedLFNameFromText($synType, $text, $order);
sub unifiedLFNameFromText {
  my ($self, $synType, $text, $order) = @_;

  my $unifiedName = &trims($text);	# default is trimmed name as is

  #
  # see if we have an ADDON definition for this text
  #
  #my ($validity, $PNID, $LFName, $thingSyn) = $self->ultraUltimatePNIDFromText($synType, $text);
#2011_08_26 -- revise ultraUltimate to ultraUltimateADDONFromText($synType, $text)
    #my ($shortValidity, $LFKey, $LFName, $canonicalThingSyn, @recognitionThingSyns) = $self->ultraUltimateADDONFromText($synType, $text);
  my ($shortValidity, $LFKey, $LFName, $canonicalThingSyn, @recognitionThingSyns) = $self->ultraUltimateADDONFromText($synType, $text);

#2013_12_30 -- elevate ? to G status except for REVIEWER
	
  if ($shortValidity eq "=" || $shortValidity eq "?") {
    #
    # we have an blessed ADDON LFName for this text
    #

    #
    # preserve spaces
    #
    #$LFName =~ s/ /\N{NO-BREAK SPACE}/g;
    #$LFName =~ s/ +/=/g;
    my $niceName = FFATLASSyntax::niceNameFromLFName($LFName, $order);
    #warn "NICE NAME \[$niceName\] FROM TEXT \[$text\]\n";
    $unifiedName = $niceName;
  }# found valid ADDONS LFName

  return $unifiedName;

}# end of unifiedNameFromText();

#my $nice = $helper->unifiedEnsembleNameFromText('ensemble', $currentPerformer, "SHORT");
sub unifiedEnsembleNameFromText {
  my ($self, $synType, $currentPerformer, $SHORTLONG) = @_;
  my $nice = $currentPerformer;		#default

  
  my $nicer = $self->unifiedLFNameFromText('ensemble', $currentPerformer, "FL");
  if ($nicer ne $nice) {
    #warn "SUBSTITUTING NICER ENSEMBLE NAME \[$nicer\] FOR \[$nice\]\n";
    $nice = $nicer;
  }
  if ($SHORTLONG =~ /SHORT/i ) {
    my ($abbreviatedString, $changed) = $self->abbreviateEnsembles($currentPerformer);
    if ($abbreviatedString ne $nice) {
      #warn "SUBSTITUTING ABBREVIATED ENSEMBLE NAME \[$abbreviatedString\] FOR \[$nice\]\n";
      $nice = $abbreviatedString;
    }
  } elsif ($SHORTLONG =~ /LONG/i ) {
    my ($expandedString, $changed) = $self->expandEnsembleAbbreviations($currentPerformer);
    if ($expandedString ne $nice) {
      #warn "SUBSTITUTING EXPANDED ENSEMBLE NAME \[$expandedString\] FOR \[$nice\]\n";
      $nice = $expandedString;
    }
  } 
  
  return $nice;

}# end of &unifiedEnsembleNameFromText();

#my ($shortValidity, $LFName, $canonicalThingSyn) = $helper->getADDONSFundamentals($thingSynType, $thingText, $currentSerNum);
#sub getADDONSFundamentals {
#  my ($self, $thingSynType, $currentThingText, $currentSerNum) = @_;
#
#  my $placePrefix = "HELPER_ADDONS_FUND";
#  my $place = "";
#
#  my ($longValidity, $PNID, $LFName, $thingSyn) = $self->ultraUltimatePNIDFromText($thingSynType, $currentThingText);
##2011_08_26 -- revise ultraUltimate to ultraUltimateADDONFromText($synType, $text)
#    #my ($shortValidity, $LFKey, $LFName, $canonicalThingSyn, @recognitionThingSyns) = $self->ultraUltimateADDONFromText($synType, $text);
#  $place = $placePrefix . "200";
#  $self->log("IGNORE", "FOR \[$thingSynType, $currentThingText\] ULTRA_ULTIMATE_RESULTS WERE: longValidity \[$longValidity\] PNID \[$PNID\] LFName \[$LFName\] thingSyn \[thingSyn\]\n", $currentSerNum, $place, @_ );
#
#  unless ($longValidity) {
#    $place = $placePrefix . "210";
#    $self->log("IGNORE", "NO_ADDON_FOUND_FOR \[$thingSynType, $currentThingText\] ULTRA_ULTIMATE_RESULTS WERE: longValidity \[$longValidity\] PNID \[$PNID\] LFName \[$LFName\] thingSyn \[$thingSyn\]\n", $currentSerNum, $place, @_ );
#  }
#  
#  my $ADDONSShortValidity = &validityLongToShort($thingSynType, $longValidity);
#
#  return ($ADDONSShortValidity, $LFName, $thingSyn);
#  
#}# end getADDONSFundamentals();

#2011_07_20 -- support UNIFIED DATUM MEDIUM determination

#my $unifiedMedium = $helper->genUnifiedMedium($currentSerNum, $vvi, $n, $currentDeptCode, $currentRecString);
sub genUnifiedMedium {
  my ($self, $serNum, $vvi, $headnoteNum, $deptCode, $recString) = @_;
  my $medium = "";

  #2011_07_18 -- make a unified MEDIUM ASSERTION after each HEADNOTE

  my $placePrefix = "UNIFYMEDIUM";
  my $place = "";
  $place = $placePrefix . "000";
#2014_02_17 -- get MEDIUM to ADVANCED AUDIO
	
	$self->log("NOTE", "SORTING_OUT_UNIFIED_MEDIUM serNum \[$serNum\] headnoteNum \[$headnoteNum\] recString \[$recString\] deptCode \[$deptCode\] \n" , $serNum, $place, @_ );

  #
  # EXPLICIT: find Medium from recString
  #
#2017_01_19 -- add STREAMING_AUDIO and STREAMING_VIDEO
#2017_06_16 -- make correction to STREAMING_AUDIO and STREAMING_VIDEO
  #if ($recString =~ / STREAMING.AUDIO/i) {	#}
	if ($recString =~ /STREAMING.AUDIO/i) {
		$medium = "STREAMING_AUDIO";
		return $medium;
	}
	#if ($recString =~ / STREAMING.VIDEO/i) { #} 
	if ($recString =~ /STREAMING.VIDEO/i) {
		$medium = "STREAMING_VIDEO";
		return $medium;
	}

	#
	#2014_10_27 -- allow DOWNLOAD as medium
	#

	if ($recString =~ /\(\s*DOWNLOAD/i) {
		$medium = "Download";
		return $medium;
	}

  if ($recString =~ /compact disc/i) {
    $medium = "CD";
  }
  if ($recString =~ /\bDVD/) {
    $medium = "DVD";
		if ($recString =~ /\((.*dvd.*)\)/i) {
			my $DVDString = $1;
			if ($DVDString =~ /music-only/i || $DVDString =~ /audio/i || $DVDString =~ /DVD.A/i) {
				$medium .= "_A";
				$place = $placePrefix . "100";
				$self->log("NOTE", "UNIFIED_MEDIUM_EXPLICIT_DVD_A: \[$medium\] headnoteNum \[$headnoteNum\] recString \[$recString\] deptCode \[$deptCode\] \n" , $serNum, $place, @_ );
			}
		}
  }
  if ($recString =~ /\bSACD|Super Audio.*CD|Hybrid.*Multi.*Channel/i) {
    $medium = "SACD";
  }
  if ($recString =~ /Blu.RAY/i) {
    $medium = "BLU-RAY";
		if ($recString =~ /\((.*blu.ray.*)\)/i) {
			my $bluRayString = $1;
			if ($bluRayString =~ /music-only/i || $bluRayString =~ /audio/i) {
				$medium .= "_A";
				$place = $placePrefix . "100";
				$self->log("NOTE", "UNIFIED_MEDIUM_EXPLICIT_BLU-RAY_A: \[$medium\] headnoteNum \[$headnoteNum\] recString \[$recString\] deptCode \[$deptCode\] \n" , $serNum, $place, @_ );
			}
		}
  }

  if ($medium) {
    $place = $placePrefix . "100";
    $self->log("NOTE", "UNIFIED_MEDIUM_EXPLICIT: \[$medium\] headnoteNum \[$headnoteNum\] recString \[$recString\] deptCode \[$deptCode\] \n" , $serNum, $place, @_ );
    return $medium;
  }
  #
  # IMPLICIT PASS 1: find medium from deptCode
  #

  #  "zz8" => "DVDs",
  #  "zz80" => "DVDs",

  if ($deptCode eq "zz8" || $deptCode eq "zz80" ) {
    $medium = "DVD";
  }

  if ($medium) {
    $place = $placePrefix . "200";
    $self->log("NOTE", "UNIFIED_MEDIUM_FROM_DEPTCODE: \[$medium\] headnoteNum \[$headnoteNum\] recString \[$recString\] deptCode \[$deptCode\] \n" , $serNum, $place, @_ );
    return $medium;
  }

  #
  # IMPLICIT PASS 2: find default medium from era
  #

  if ($vvi <= 121) {
    $medium = "LP";	# default
  } else {
    $medium = "CD";	# default
  }


  if ($medium) {
    $place = $placePrefix . "300";
    $self->log("NOTE", "UNIFIED_MEDIUM_FROM_VVI: \[$medium\] FROM serNum \[$serNum\] headnoteNum \[$headnoteNum\] recString \[$recString\] deptCode \[$deptCode\] \n" , $serNum, $place, @_ );
    return $medium;
  }

  #
  # no soap
  #

  $place = $placePrefix . "900";
  $self->log("DIE", "CANNOT_FIND_UNIFIED_MEDIUM serNum \[$serNum\] headnoteNum \[$headnoteNum\] recString \[$recString\] deptCode \[$deptCode\] \n" , $serNum, $place, @_ );
  return $medium;

} #end of genUnifiedMedium();

#my ($serNum, $vvi, $deptCode, $deptText, $articleToken) = $helper->decodeAndValidateDocID($docID);

sub decodeAndValidateDocID {
  my ($self, $docID) = @_;

  my $serNum = "";
  my $vvi = "";
  my $deptCode = "";
  my $deptText = "";
  my $articleToken = "";

  my $placePrefix = "DECODEDOCID";
  my $place = "";
  $place = $placePrefix . "000";
  #$self->log("IGNORE", "DECODING AND VALIDATING DOCID \[$docID\]\n" , $serNum, $place, @_ );

  if ($docID =~ /^(\d+)[-_.]([a-z0-9]+)(.*)/) {
    $serNum = $1;
    $deptCode = $2;
    $articleToken = $3;
    $vvi = substr($serNum, 0, 3);
  } elsif ($docID =~ /^(\d+)[-_.](.*)/) {
    $serNum = $1;
    $deptCode = "";
    $articleToken = $2;
    $vvi = substr($serNum, 0, 3);
  } else {
    $place = $placePrefix . "100";
    $self->log("WARN", "ILLEGAL DOCID \[$docID\]\n" , $serNum, $place, @_ );
  }

  #
  # check for valid deptCode
  #

  #
  # some early docIDs have no deptCode field
  # we will deal with them later
  #

  if ($deptCode) {
    #
    # correct for ultra-picky deptCodes (e.g. zz4tpt) from early sources
    #
    $deptCode =~ s/^(zz[1-7]).*/$1/;

    #
    # straighten out historical aliases -- e.g. past_music_present => aa
    #

    my %historicalDeptCodeTranslations = (
      'zz84' => 'aa',		# past music present
      'zz8' => 'zz80',		# DVDs -- two forms
      '1' => 'aa',		# e.g. my article
    );
    
    my $historicalDeptCodeTranslation = $historicalDeptCodeTranslations{$deptCode};
    $deptCode = $historicalDeptCodeTranslation if $historicalDeptCodeTranslation;
    #
    # look up the conditioned deptCode in the list provided by FFConstants.pm
    #
    $deptText = $textOfDeptCodes{$deptCode};
    unless ($deptText) {
      $place = $placePrefix . "200";
      $self->log("DIE", "ILLEGAL DEPTCODE \[$deptCode\] FROM DOCID \[$docID\]\n" , $serNum, $place, @_ );
    }
  } else {
    $place = $placePrefix . "250";
    #$self->log("NOTE", "WILL_NEED_TO_INFER_DEPTCODE FROM currentArticleType AND currentArticleSubtype FOR \[$docID\] \n" , $serNum, $place, @_ );
  }

  $place = $placePrefix . "900";
  #$self->log("IGNORE", "VALID_DOCID \[$docID\] \[$serNum\] \[$vvi\] \[$deptCode\] \[$deptText\] \[$articleToken\]\n" , $serNum, $place, @_ );

  return ($serNum, $vvi, $deptCode, $deptText, $articleToken);
  
}# end of decodeAndValidateDocID();

#($currentDeptCode, $currentDeptText) = $helper->unifyDeptCode($currentSerNum, $currentArticleType, $currentArticleSubtype, $currentDeptCode, $currentDeptText);

sub unifyDeptCode {
  my ($self, $serNum, $articleType, $articleSubtype, $docIDDeptCode, $docIDDeptText) = @_;
  my $deptCode = "";
  my $deptText = "";

  my $placePrefix = "UNIFYDEPTCODE";
  my $place = "";
  $place = $placePrefix . "000";
  #$self->log("IGNORE", "UNIFYING_DEPTCODE FROM \[$articleType\] \[$articleSubtype\]\n" , $serNum, $place, @_ );
  
  #
  # the article Subtype is now (2011_07_20) only Bollywood and Beyond; make it the Type
  #
  unless ($articleType) {
    #
    # treat Feature Article about Bollywood
    #
    $articleType = $articleSubtype if ($articleSubtype);
  }
  my $articleTypeDeptCode = $deptCodesOfText{$articleType};
  my $articleTypeDeptText = $textOfDeptCodes{$articleTypeDeptCode};	# standardize it
  if ($articleTypeDeptCode) {
    if ($docIDDeptCode) {
      if ($articleTypeDeptCode eq $docIDDeptCode) {
	#
	# two sources of deptCode and they are identical (IDEAL!) Note this.
	#
	$deptCode = $docIDDeptCode;
	$deptText = $docIDDeptText;
	$place = $placePrefix . "100";
	#$self->log("IGNORE", "UNIFIED_DEPTCODE \[$deptCode\] \[$deptText\] FROM \[$articleType\] \[$articleSubtype\] \[$docIDDeptCode\] \[$docIDDeptText\]\n" , $serNum, $place, @_ );
      #2012_11_17 -- resolve conflict to DVDs
      } elsif ($articleTypeDeptCode eq 'zz80') {
	#
	# two sources of deptCode and docIDDeptCode = zz80
	#
	$deptCode = $articleTypeDeptCode;
	$deptText = $articleTypeDeptText;
	$place = $placePrefix . "100";
	$self->log("IGNORE", "DEPTCODE_IS_DVDs \[$deptCode\] \[$deptText\] FROM \[$articleType\] \[$articleSubtype\] \[$docIDDeptCode\] \[$docIDDeptText\]\n" , $serNum, $place, @_ );
      } else {
	#
	# two different deptCodes! Choose the docID one and warn
	#
	$deptCode = $docIDDeptCode;
	$deptText = $docIDDeptText;
	$place = $placePrefix . "110";
	$self->log("NOTE", "CONFLICTING_DEPTCODES \[$articleTypeDeptCode\] \[$docIDDeptCode\] FROM \[$articleType\] \[$articleSubtype\] \[$docIDDeptCode\] \[$docIDDeptText\]\n" , $serNum, $place, @_ );
      }
    } else {
      #
      # The docID was an old one which had no deptCode field in it
      # But we have an articleType-derived deptCode: use this and note
      #
      $deptCode = $articleTypeDeptCode;
      $deptText = $articleTypeDeptText;
      $place = $placePrefix . "120";
      #$self->log("NOTE", "USING_SOLE_DEPTCODE_FROM_ARTICLE_TYPE: \[$articleTypeDeptCode\] \[$articleTypeDeptText\] FROM \[$articleType\] \[$articleSubtype\] \[$docIDDeptCode\] \[$docIDDeptText\]\n" , $serNum, $place, @_ );
    }
  } else {
    #
    # there is no ARTICLE_TYPE deptCode
    #
    if ($docIDDeptCode) {
      #
      # use the docID deptCode
      #
      $place = $placePrefix . "200";
      $self->log("WARN", "USING_SOLE_DEPTCODE_FROM_DOCID: \[$docIDDeptCode\] \[$docIDDeptText\] FROM \[$articleType\] \[$articleSubtype\] \[$docIDDeptCode\] \[$docIDDeptText\]\n" , $serNum, $place, @_ );
    } else {
      #
      # NO DEPTCODES AT ALL?
      #
      $place = $placePrefix . "300";
      $self->log("DIE", "NO_DEPTCODES_AT ALL FROM \[$articleType\] \[$articleSubtype\] \[$docIDDeptCode\] \[$docIDDeptText\]\n" , $serNum, $place, @_ );
      #
    }
  }# cases of discovered deptCodes

  return ($deptCode, $deptText);

}# end of &unifyDeptCode();

#my $LFName = $helper->LFNameFromScratch($synType, $text);
sub LFNameFromScratch {
  my ($self, $synType, $text) = @_;	# $self so we can log

  #2013_01_02 -- look for missing leading THE
  #warn "THE40: $text\n" if ($text =~ /ater of Voices/);

  my $placePrefix = "LFNAMESCRATCH";
  my $place = "";
  my $serNum = "";

  if ($text =~ /_/ ) {
    $place = $placePrefix . "100";
    $self->log("WARN", "LFNameFromScratch CALLED WITH LFNAME! \[$synType\] \[$text\]" , $serNum, $place, @_ );
  }

  my $LFName = "";
  my $name0 = "";
  my $name1 = "";

  $text =~ s/^\W+//;
  $text =~ s/\W+$//;

  #2011_09_06 -- MAKE 'THING' LFNames correctly
  my $isPersonThing = ($FFATLASSyntax::synType_is_person{$synType}) ? "IS_PERSON" : "IS_THING";
  if ($isPersonThing eq 'IS_THING' || $synType eq 'ensemble' ) {
    $LFName = $text . "_";	# thing LFNames and ens have ONLY a last name
    return $LFName;
  }

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

  $LFName = $name0 . "_" . $name1;

  return $LFName;

}# end of &LFNameFromScratch();

#my ($shortValidity, $LFKey, $LFName, $canonicalThingSyn, @recognitionThingSyns) = $self->ultraUltimateADDONFromText($synType, $text);
sub ultraUltimateADDONFromText {
  my ($self, $synType, $text) = @_;

  my $placePrefix = "ULTRA";
  my $place = "";
  my $serNum = "";

  $place = $placePrefix . "000";
  $self->log("NOTE", "ultraUltimateADDONFromText CALLED with ARGS $synType \[$text\]", $serNum, $place, @_ );
#2016_01_07 -- warn before dying in genLFKeyFromLFName
  #print "ultraUltimateADDONFromText CALLED with ARGS $synType \[$text\]\n";

  unless (&synTypeIsLegal($synType) ) {
    comeToJesus( "FFScanHelper ultraUltimateADDONFromText CALLED WITH ILLEGAL_SYNTYPE: \[$synType\] LOOKING UP TEXT $text\n", @_);
  }

  unless ($text =~ /\w/ ) {

    $place = $placePrefix . "010";
    $self->log("WARN", "FFScanHelper ultraUltimateADDONFromText CALLED WITH EMPTY TEXT ON SYNTYPE \[$synType\]", $serNum, $place, @_ );
    #2011_09_02 -- TAME THE INFAMOUS CALL TO JESUS
    #comeToJesus( "FFScanHelper ultraUltimateADDONFromText CALLED WITH EMPTY TEXT: \[$synType\] LOOKING UP TEXT \[$text\]\n", @_);
    return undef;
  }

  #
  # generate the recognitionThingSyn for this text
  #
  
  #2013_01_02 -- look for missing leading THE
  #warn "THE20: $text\n" if ($text =~ /ater of Voices/);
  


  my $textThingSyn = &genThingSyn($text);
  
  #2013_01_02 -- look for missing leading THE
  #warn "THE21: $textThingSyn\n" if ($text =~ /ater of Voices/);

  #2011_01_13 -- LOOK UP OUR OWN ADDONS ARRAY FIRST

  my ($ADDONSLFName, $ADDONSShortValidity, @recognitionThingSyns) = $self->seekADDONFromThingSyn($synType, $textThingSyn);

  $place = $placePrefix . "100";
  #$self->log("NOTE", "ultraUltimateADDONFromText SOUGHT ADDON USING RECOGNITION THINGSYN \[$textThingSyn\] GENERATED FROM \[$text\] GOT ADDONSLFName \[$ADDONSLFName\] ADDONSShortValidity \[$ADDONSShortValidity\] recognitionThingSyns \[@recognitionThingSyns\]", $serNum, $place, @_ );

  
  #2013_01_02 -- look for missing leading THE
  #warn "THE22: $ADDONSLFName\n" if ($text =~ /ater of Voices/);

  if ($ADDONSLFName) {
    #
    # ADDON found -- derive some additional properties and return
    #

    #ALL BELOW NEEDS TO CONFORM TO LFName mechanics
    #2011_08_26 -- revise ultraUltimate to ultraUltimateADDONFromText($synType, $text)

    my $canonicalThingSyn = &genThingSyn($ADDONSLFName);
  
  #2013_01_02 -- look for missing leading THE
  #warn "THE23: ultraUltimateADDONFromText HAS_HIT USING RECOGNITION THINGSYN \[$textThingSyn\] GENERATED FROM \[$text\] RETURNING ADDONSShortValidity \[$ADDONSShortValidity\] ADDONSLFName \[$ADDONSLFName\] canonicalThingSyn \[$canonicalThingSyn\] recognitionThingSyns \[@recognitionThingSyns\]\n" if ($text =~ /ater of Voices/);
    my $LFKey = &genLFKeyFromLFName($ADDONSLFName);

  
  #2013_01_02 -- look for missing leading THE
  #warn "THE24: ultraUltimateADDONFromText HAS_HIT USING RECOGNITION THINGSYN \[$textThingSyn\] GENERATED FROM \[$text\] RETURNING ADDONSShortValidity \[$ADDONSShortValidity\] LFKey \[$LFKey\] ADDONSLFName \[$ADDONSLFName\] canonicalThingSyn \[$canonicalThingSyn\] recognitionThingSyns \[@recognitionThingSyns\]\n" if ($text =~ /ater of Voices/);
    #return ($longValidity, $PNID, $ADDONSLFName, $thingSyn);

    $place = $placePrefix . "200";
    #$self->log("NOTE", "ultraUltimateADDONFromText HAS_HIT USING RECOGNITION THINGSYN \[$textThingSyn\] GENERATED FROM \[$text\] RETURNING ADDONSShortValidity \[$ADDONSShortValidity\] LFKey \[$LFKey\] ADDONSLFName \[$ADDONSLFName\] canonicalThingSyn \[$canonicalThingSyn\] recognitionThingSyns \[@recognitionThingSyns\]", $serNum, $place, @_ );
  
  #2013_01_02 -- look for missing leading THE
  #warn "THE28: ultraUltimateADDONFromText HAS_HIT USING RECOGNITION THINGSYN \[$textThingSyn\] GENERATED FROM \[$text\] RETURNING ADDONSShortValidity \[$ADDONSShortValidity\] LFKey \[$LFKey\] ADDONSLFName \[$ADDONSLFName\] canonicalThingSyn \[$canonicalThingSyn\] recognitionThingSyns\n" if ($text =~ /ater of Voices/);

    return ($ADDONSShortValidity, $LFKey, $ADDONSLFName, $canonicalThingSyn, @recognitionThingSyns);


  } else {
    #
    # no ADDON found -- generate a candidate one
    #
    my $newLFName = $text;
    unless ($newLFName =~ /^[^_]*_[^_]*$/ ) {	# unless a valid LFName already
      $newLFName = $self->LFNameFromScratch($synType, $text);
      #warn "THE25: $newLFName\n" if ($text =~ /ater of Voices/);
    }
    #die "zyzzy -- if text was an LFNAME, USE IT, not FROMSCRATCH";
    my $newCanonicalThingSyn = &genThingSyn($newLFName);
    #warn "THE26: $newCanonicalThingSyn\n" if ($text =~ /ater of Voices/);
    my $newLFKey = &genLFKeyFromLFName($newLFName);
    #warn "THE27: $newLFKey\n" if ($text =~ /ater of Voices/);
    my $newShortValidity = '!';
    my @newRecognitionThingSyns = ($newCanonicalThingSyn);
  
  #2013_01_02 -- look for missing leading THE
  #warn "THE29: ultraUltimateADDONFromText HAS_MISS GENERATED FROM \[$text\] RETURNING ADDONSShortValidity \[$newShortValidity\] LFKey \[$newLFKey\] ADDONSLFName \[$newLFName\] canonicalThingSyn \[$newCanonicalThingSyn\] recognitionThingSyns \[@newRecognitionThingSyns\]\n" if ($text =~ /ater of Voices/);

    $place = $placePrefix . "300";
    #$self->log("NOTE", "ultraUltimateADDONFromText HAS_MISS USING RECOGNITION THINGSYN \[$textThingSyn\] GENERATED FROM \[$text\] RETURNING newShortValidity \[$newShortValidity\] newLFKey \[$newLFKey\] newLFName \[$newLFName\] newCanonicalThingSyn \[$newCanonicalThingSyn\] newRecognitionThingSyns \[@newRecognitionThingSyns\]", $serNum, $place, @_ );
    return ($newShortValidity, $newLFKey, $newLFName, $newCanonicalThingSyn, @newRecognitionThingSyns);
  }# cases of sought ADDON found

}# end of ultraUltimateADDONFromText();

#$name1 = &removeNBSPs($name1);
#$name1 = &removeNBSPs($name1);
sub removeNBSPs {
  shift(@_) if (ref($_[0]) eq 'FFScanHelper' ); 	# STATIC even if called on instance
  my ($txt) = @_;
  $txt =~ s/&nbsp;/ /ig;
  $txt =~ s/&nbsp/ /ig;
  $txt =~ s/nbsp;/ /ig;
  $txt =~ s/nbsp/ /ig;
  $txt =~ s/\N{NO-BREAK SPACE}/ /g;

  return ($txt);

}# end of &removeNBSPs();

#2011_08_28 -- improve resolution of PARENS e.g. MEMBERS, VROLES, DIRS
#my $parentheticalType = $self->getParentheticalType($PRName);
sub getParentheticalType {
  my ($self, $parenthesizedUtterance) = @_;

  # 
  # if return non-empty, can be:
  #   CITY
  #   MEMBERS
  #   VROLE
  #   DIRECTOR
  #
  my @orderedSynTypeCandidates = qw{
    instrument
    voice
    leadermode
    vrole
    singer
    instrumentalist
    leader
    city
  };

#2016_01_21 -- do not invoke members if TOKEN does'nt contain ;  or ,
#  my %parentheticalTypesFromSynTypes = (
#    'vrole' => 'VROLE',
#    'instrument' => 'MEMBERS',
#    'voice' => 'MEMBERS',
#    'singer' => 'MEMBERS',
#    'instrumentalist ' => 'MEMBERS',
#    'leadermode' => 'DIRECTOR',
#    'leader' => 'MEMBERS',
#    'city' => 'CITY',
#  );
  my $parentheticalType = "";
	my $assertionType = "";

  my $placePrefix = "PARENTYPE";
  my $place = "";

  #
  # get the pure parenthetical expression
  #
  my $parenthesizedExpression = $self->unescapeAssertions($parenthesizedUtterance, 'PAREN', 'VROLE', 'MEMBERS', 'DIRECTOR', 'CITY');

  $parenthesizedExpression =~ s%</?PAREN>%%g;	# works whether or not escaped

  if ($parenthesizedExpression =~ /<(VROLE|MEMBERS|DIRECTOR|CITY)/i) {
    $assertionType = $1;
    $place = $placePrefix . "010";
    #$self->log("IGNORE", "getParentheticalType GOT_VALID_ASSERTION assertionType \[$assertionType\] FOR NAME \[$parenthesizedExpression\] " , $place, @_ );
    return $assertionType;
  }

#2016_01_21 -- do not invoke members if TOKEN does'nt contain ;  or ,
  if ($parenthesizedUtterance =~ /;/) {
	  #
	  # this has a semi in it, but are there any commas?
	  #
	  if ($parenthesizedUtterance =~ /,/) {
		  # yes -- this is presumably a MEMBER
		  $assertionType = "MEMBERS";
		  return $assertionType;
		} else {
#2016_02_03 -- make ; delimited parens into VROLES
			#
			# we have semi but no commas -- vrole
			#
			
		  $assertionType = "VROLE";
		  return $assertionType;
		}
	} else {
		#
		# no semicolon
		#

#2016_02_03a -- check for , instrument or leadermode
		  if ($parenthesizedUtterance =~ /,/) {
			  #warn "HERE IS NO SEMICOLON BUT A COMMA $parenthesizedUtterance\n";
			  print "HERE IS NO SEMICOLON BUT A COMMA $parenthesizedUtterance\n";
			  if ($parenthesizedUtterance =~ /.*,(.*)/ ) {
			  my $littleToken = trims($1);
			  $littleToken =~ s%</PAREN>%%;
			  my @synTypes = ("instrument", "leadermode", "vrole" );
				foreach my $synType (@synTypes) {
					print "VISITING ULTRA: $synType $littleToken\n";
				  my ($ULTshortValidity, $ULTLFKey, $ULTLFName, $ULTcanonicalThingSyn, @ULTrecognitionThingSyns) = $self->ultraUltimateADDONFromText($synType, $littleToken);
				  if ($ULTshortValidity eq "!" ) {
					  next;
					}
				  $assertionType = $synType;
				  $assertionType = "members" if ($synType eq "instrument");
				  $assertionType = "director" if ($synType eq "leadermode");
				  #warn "OUR SYNTYPE IS: $assertionType FOR $littleToken\n";
				  print "OUR SYNTYPE IS: $assertionType FOR $littleToken\n";
				  return $assertionType;

				  $place = $placePrefix . "100";
						
				  warn "GOT_SOMETHING: ULTshortValidity \[$ULTshortValidity\] ULTLFKey \[$ULTLFKey\] ULTLFName \[$ULTLFName\] ULTcanonicalThingSyn \[$ULTcanonicalThingSyn\] ULTrecognitionThingSyns \[@ULTrecognitionThingSyns\] FROM ultraUltimateADDONFromText WITH ARGS \[$synType\] \[$littleToken\]\n";
				}
		  }
			}
		}
	  
    $place = $placePrefix . "000";
    #$self->log("IGNORE", "getParentheticalType CALLED WITH ARGS parenthesizedUtterance \[$parenthesizedUtterance\]" , $place, @_ );

  #2011_08_28 -- improve resolution of PARENS e.g. MEMBERS, VROLES, DIRS

  $parenthesizedExpression =~ s/ASS_SUP_\d\d\d\d\d//g;	# ditch the SUP assertions

#2016_01_21 -- do not invoke members if TOKEN does'nt contain ;  or ,
  my @tokens = split(m%[,/]%, $parenthesizedExpression);
	$place = $placePrefix . "100";
	$self->log("NOTE", "\[@tokens\]" , $place, @_ );
	print "TOKENS: \[@tokens\]\n";
  TOKEN:
  while (@tokens) {
    my $token = pop(@tokens);	# go right-to-left; instruments before people
    $token = &trims($token);
    $token =~ s/\s*\.$//;
    next unless ($token =~ /\w/);
    foreach my $synType (@orderedSynTypeCandidates) {
		print "GOING TO ULTRA: $synType $token\n";
      my ($ULTshortValidity, $ULTLFKey, $ULTLFName, $ULTcanonicalThingSyn, @ULTrecognitionThingSyns) = $self->ultraUltimateADDONFromText($synType, $token);

#2014_02_13 -- fix MEMBERS vs. VROLE
      $place = $placePrefix . "100";
			#$self->log("NOTE", "getParentheticalType GOT_RESULTS ULTshortValidity \[$ULTshortValidity\] ULTLFKey \[$ULTLFKey\] ULTLFName \[$ULTLFName\] ULTcanonicalThingSyn \[$ULTcanonicalThingSyn\] ULTrecognitionThingSyns \[@ULTrecognitionThingSyns\] FROM ultraUltimateADDONFromText WITH ARGS \[$synType\] \[$token\]" , $place, @_ );
			print "getParentheticalType GOT_RESULTS ULTshortValidity \[$ULTshortValidity\] ULTLFKey \[$ULTLFKey\] ULTLFName \[$ULTLFName\] ULTcanonicalThingSyn \[$ULTcanonicalThingSyn\] ULTrecognitionThingSyns \[@ULTrecognitionThingSyns\] FROM ultraUltimateADDONFromText WITH ARGS \[$synType\] \[$token\]\n";



#2015_11_06 -- extend ULTshortValidity to =?
      if ($ULTshortValidity eq '=' || $ULTshortValidity eq '?'){
				$place = $placePrefix . "110";
				$self->log("NOTE", "getParentheticalType GOT_HIT \[$synType\] ON_TOKEN \[$token\]" , $place, @_ );
				#
				$parentheticalType = $synType;
				last TOKEN;
      }# if hit
    }# each synType

    #
    # no hit
    #
    $place = $placePrefix . "200";
    $self->log("NOTE", "getParentheticalType GOT_MISS_FOR_TOKEN \[$token\]" , $place, @_ );
  }# each token

  #
  # see what we have found for the whole parenthetical expression
  #
  if ($parentheticalType) {
    $place = $placePrefix . "300";
    $self->log("NOTE", "getParentheticalType GOT_TYPE_FOR_PAREN \[$parentheticalType\] FOR_PAREN \[$parenthesizedExpression\]" , $place, @_ );
    print "getParentheticalType GOT_TYPE_FOR_PAREN \[$parentheticalType\] FOR_PAREN \[$parenthesizedExpression\]\n";
  } else {
    $place = $placePrefix . "400";
    #$self->log("NOTE", "getParentheticalType GOT_MISS_FOR_PAREN \[$parenthesizedExpression\]" , $place, @_ );
    print "getParentheticalType GOT_MISS_FOR_PAREN \[$parentheticalType\] FOR_PAREN \[$parenthesizedExpression\]\n";
  }

  return $parentheticalType;

}#end of getParentheticalType();


#
#2011_10_25 -- see if WLENS -- new WL ensemble synType
#

#my $isLikelyWLENS = $helper->isLikelyWLEnsemble($WLPerf);
sub isLikelyWLEnsemble {
  my ($self, $WLPerfString) = @_;
  my $isLikelyWLENS = "";

  my $placePrefix = "WLENS";
  my $place = "";

  #
  # First, see if an unambiguous blessed ensemble of this name is known to ADDONS
  #

  my @possibleSynTypes = qw{ensemble leadermode leader voice vrole instrument singer instrumentalist city performer wlperf wlens};
  my @synTypesOfName = $self->getSynTypesOfText($WLPerfString, @possibleSynTypes);

  $place = $placePrefix . "100";
  $self->log("NOTE", "SYNTYPES OF NAME \[$WLPerfString\] ARE \[@synTypesOfName\]", "", $place, @_ );

  my @ensembleHits = (grep(/^(ensemble|wlens)$/i, @synTypesOfName));
  if (@ensembleHits) {
    $isLikelyWLENS = join(" ", @ensembleHits);
    $place = $placePrefix . "100";
		#$self->log("ALARM", "WLNAME \[$WLPerfString\] IS_AN_ENSEMBLE \[$isLikelyWLENS\]", "", $place, @_ );
  } else {

    #
    # Otherwise, see if it LOOKS like an ensemble
    #
    my $isLikelyEnsemble = $self->isLikelyEnsemble($WLPerfString);
    if ($isLikelyEnsemble) {
      $isLikelyWLENS = 'likely';
      $place = $placePrefix . "200";
			#$self->log("ALARM", "WLNAME \[$WLPerfString\] IS_LIKELY_ENSEMBLE \[$isLikelyWLENS\]", "", $place, @_ );
    }
  }

  if ($isLikelyWLENS) {
    $place = $placePrefix . "900";
    $self->log("NOTE", "WLNAME \[$WLPerfString\] IS_AN_WLENSEMBLE \[$isLikelyWLENS\]", "", $place, @_ );
  }

  return $isLikelyWLENS;
  
}# end of = &isLikelyWLEnsemble();

#2011_12_18 -- CONCORDANCE utility methods

####################################
# CONCORDANCE utility methods
####################################

#my ($rec) = $helper->encodeCONCORDANCERec($recType, $synType, $LFName, $validity, $recogThingSynsRef, $numCitations, $citationsRef[, $VVI]);
sub encodeCONCORDANCERec {
  my ($self, $recType, $synType, $LFName, $validity, $recogThingSynsRef, $numCitations, $citationsRef, $VVI) = @_;

  my %recogThingSyns = $self->uniqueScalars("THINGSYNS", $recogThingSynsRef);
  my %citations = $self->uniqueScalars("CITATIONS", $citationsRef);

  my @recogThingSyns = sort keys %recogThingSyns;
  my @citations = sort keys %citations;

  my $rec = "";

  my $placePrefix = "encodeCONCORDANCE";
  my $place = "";

  $place = $placePrefix . "900";
  $self->log("IGNORE", "ENCODING_CONCORDANCE_REC recType \[$recType\] synType \[$synType\] LFName \[$LFName\] validity \[$validity\] recogThingSyns \[@recogThingSyns\] numCitations \[$numCitations\] citations \[@citations\] VVI \[$VVI\]", "", $place, @_ );

  

  if ($recType eq 'TOPLINE') {
    my @legalSynTypes = (sort keys %LEGAL_SYNTYPES);
    my $str = join(" ", @legalSynTypes);
    $rec = qq{#$str}; 

  } elsif ($recType eq 'SYNTYPELINE') {
    $rec = qq{\n\n#NEXT: $synType\n};

  } elsif ($recType eq 'ENTRY') {
    my @recList = ();

    #
    # SYNTYPE LFNAME and VALIDITY
    #
    my $LFNameField = $self->encode_CONCORDANCE_FIELD_LFNAME($synType, $validity, $LFName, $VVI, @citations);
    
    push (@recList, $LFNameField);

    #
    # RECOGNITION THINGSYNS
    #
    my $rtsField = $self->encodeCONCORDANCERecogSynThingsField($synType, $LFName, @recogThingSyns);
    push (@recList, $rtsField);

    #
    # NUMBER OF CITATIONS AND TRUNCATED CITATION STRING
    #
    my $citField = $self->encodeCONCORDANCECitField($numCitations, $MAX_CITATIONS, @citations);

    push (@recList, $citField);

    #
    # RECORD STRING AND CHECKSUM
    #

    my $recSep = "\t ";
    $rec = join($recSep, @recList);
    my $ADDON_REC_TO_CHECK = qq{$rec};
    my $checksum = unpack ("%32C*", $ADDON_REC_TO_CHECK) % 65535;
    $rec .= "$recSep%$checksum";

  } else {
    &comeToJesus("FFScanHelper::formatCONCORDANCERec CALLED WITH ILLEGAL recType \[$recType\]", @_);
  }

  return ($rec);

}# end of encodeCONCORDANCERec();

#2011_12_21 -- CONCORDANCE LFName and Validity FIELDS
#my $LFNameField = $self->encode_CONCORDANCE_FIELD_LFNAME($synType, $validity, $LFName, $VVI, @citations);
sub encode_CONCORDANCE_FIELD_LFNAME {
  my ($self, $synType, $validity, $LFName, $VVI, @citations) = @_;

  #
  # check for ? or ! unblessed validity based on current VVI
  #

#2013_12_30 -- elevate ? to G status except for REVIEWER
  if ($validity eq '!' ) {

    #
    # 2012_02_10 -- make ADDON SHORT VALIDITY ! if reviewer
    #
    if ($synType eq 'reviewer' && $validity =~ /\?/ ) {
      $validity = '!';
    } else {
      $validity = '?';	# ? means global or not in current VVI
    }
  
    if ($VVI <= 0) {
      # do nothing further
    } else {
      #
      # maybe a citation from a headnote in this current VVI
      #
      foreach my $cit (@citations) {
	if ($cit =~ /^$VVI/) {
	  $validity = '!';
	  last;
	}
      }
    }
  }

  #
  # check for LFKey uniqueness
  #
  my $LFKey = &genLFKeyFromLFName($LFName);
  my $uniqueLFKey = qq{$synType;$LFKey};
  if (${$self->{'UNIQUE_LFKEYS'}->{$uniqueLFKey}}++ > 0) { 
    warn "DUPLICATE_LFKEY \[$uniqueLFKey\]\n";
    $validity = '!';
  };

  #my $LFNameField = qq{$synType $validity$LFName};
  my $LFNameField = sprintf("%s %s%-20s", $synType, $validity, $LFName);

  return $LFNameField;

}# end of encode_CONCORDANCE_FIELD_LFNAME();

#2011_12_21 -- CONCORDANCE THINGSYN FIELD

#my $rtsField = $self->encodeCONCORDANCERecogSynThingsField($synType, $LFName, @recogThingSyns);
sub encodeCONCORDANCERecogSynThingsField {
  my ($self, $synType, $LFName, @recogThingSyns) = @_;

  my %uniqueThingSyns = ();
  #
  # place the already-captured thingsyns into the unique hash
  #
  foreach my $thingSyn (@recogThingSyns) {
    $thingSyn =~ s/[<>]//g;
    $thingSyn = &trims($thingSyn);
    $uniqueThingSyns{$thingSyn} = 1 if $thingSyn;
  }

  #
  # ADD CANONICAL THINGSYN
  #
  my $literalThingSyn = &FFScanHelper::genThingSyn($LFName);
  $uniqueThingSyns{$literalThingSyn}++;
  
  
  # 2012_01_17 -- check for WLENS and ENSEMBLE for this before registering it
  # this is in encodeCONCORDANCERecogSynThingsField();
  if ($synType eq 'wlens' || $synType eq 'ensemble' ) {
    
    my $LFText = $LFName;
    $LFText =~ s/_$//;
     
    #
    # GENERATE STANDARD VARIANTS OF ENSEMBLE or WLENS 
    #
    my ($niceShort, $changedshort) = $self->abbreviateEnsembles($LFText);
    my ($theLFName, $theLFKey) = $self->genCanonicalEnsembleLFKey($niceShort);
    my ($niceLong, $changed) = $self->expandEnsembleAbbreviations($LFText);

    my $shortThingSyn = &FFScanHelper::genThingSyn($niceShort);
    my $longThingSyn = &FFScanHelper::genThingSyn($niceLong);

    ##warn "SHORTLONG: \[$niceShort\] \[$niceLong\]\n";
    $uniqueThingSyns{$shortThingSyn}++;
    $uniqueThingSyns{$longThingSyn}++;
    $uniqueThingSyns{$theLFKey}++;
  }

  my $rtsString = join (" ", (sort keys %uniqueThingSyns));
  my $rtsField = qq{> $rtsString};

  return $rtsField;

}# end of encodeCONCORDANCERecogSynThingsField();

#2011_12_21 -- CONCORDANCE SERNUM FIELDS
#my ($citField) = $self->encodeCONCORDANCECitField($numCitations, $MAX_CITATIONS, @citations);
sub encodeCONCORDANCECitField {
  my ($self, $numCitations, $max, @citations) = @_;
  my $citField = "";

  unless ($numCitations > 0) {
    #
    # BLANK or 0 passed arg means compute: the list is full
    # >0 means list may be truncated, thus unreliable
    #
    $numCitations = $#citations + 1;
  }

  my $dots = "";
  if ($numCitations > $max) {
    $#citations = $max -1;	# truncate
    $dots = "...";
  }
  my $s = join(" ", @citations);
  my $serNumString = "$s$dots";

  $citField = '# @' . $numCitations . '@' . $serNumString;

  return ($citField);

}# end of &encodeCONCORDANCECitField();

#my %uniqueThingSyns = helper->uniqueScalars("THINGSYNS", $basis, $thingSyn[,...]);
sub uniqueScalars {
  my ($self, $filterType, $basis, @additions) = @_;
  my %uniqueScalars = ();

  my $basisRef = ref($basis);
  my @nonUniqueList = ();

  #warn "FINNEGAN: STARTING WITH BASIS \[$basis\] ADDITIONS \[@additions\]\n";

  if ($basisRef) {
    if ($basisRef eq 'HASH') {
      #warn "FINNEGAN: ThingSyns BASIS IS HASH\n";
      my %hash = %$basis;
      foreach my $scalar(keys %hash) {
	push (@nonUniqueList, $scalar);
      }
    } elsif ($basisRef eq 'ARRAY') {
      @nonUniqueList = @$basis;
      #warn "FINNEGAN: ThingSyns BASIS IS ARRAY\n";
    } else {
      &comeToJesus( "UNEXPECTED \[$filterType\] BASIS IS \[$basisRef\]", @_);
    }
  } else {
    #
    # scalar, presumed string which may contain multiple scalars
    #
    my @scalars = split(/[ \t<>]+/, $basis);
    foreach my $scalar (@scalars) {
      push (@nonUniqueList, $scalar);
    }
    #warn "FINNEGAN: ThingSyns BASIS IS SCALAR\n";
  }
  #
  # ADDITIONS, each a presumed string which may contain multiple scalars
  #
  foreach my $string (@additions) {
    my @scalars = split(/[ <>]+/, $string);
    foreach my $scalar (@scalars) {
      push (@nonUniqueList, $scalar);
    }
  }


  #
  # make the unique hash
  #
  foreach my $scalar (@nonUniqueList) {
    if ($filterType eq "THINGSYNS") {
      $scalar =~ s/[<>]/ /g;	# possible > separating syns
    } elsif ($filterType eq "CITATIONS") {
      $scalar =~ s/\./ /g;	# possible dots after citations
    } else {
      &comeToJesus( "UNEXPECTED \[$filterType\] FILTER_TYPE IS \[$filterType\]", @_);
    }
    $scalar = &trims($scalar);
    $uniqueScalars{$scalar} = 1 if ($scalar =~ /\S/);
  }

  #Dx
  my $dxString = join("|", sort keys %uniqueScalars);
  #warn "FINNEGAN DX: \[$dxString\]\n";

  return %uniqueScalars;
  
}# end of &uniqueScalars();


#
# CONCORDANCE REC DECODE 
#

# sub decodeCONCORDANCERec
#my ($recType, $synType, $LFName, $validity, $uniqueThingSynsRef, $numCits, $uniqueCitationsRef, $LFKey, $modified) = $helper->decodeCONCORDANCERec($rec);
sub decodeCONCORDANCERec {
  my ($self, $rec) = @_;
  my ($recType, $synType, $LFName, $validity, $numCits, $LFKey, $modified) = ();

  my $recognitionThingSynsString = "";
  my $citString = "";
  my $checksumString = "";
  my %uniqueCitations = ();
  my %uniqueThingSyns = ();

  return undef unless ($rec =~ /\w/);

  if ($rec =~ /^#([a-z ]+)$/) {
    $recType = "TOPLINE";
    $synType = &trims($1);
    return ($recType, $synType);

  } elsif ($rec =~ /^#NEXT:\s*([a-z]+)/ ) {
    $recType = "SYNTYPELINE";
    $synType = $1;
    return ($recType, $synType);

  } elsif ($rec =~ /^([a-z]+)\s+([?=!])([^<>]+)(>[^#\%\@]*)(#\s*@(\d+)@)*\s*(\d[0-9 ])*/ ) {

    #ensemble =Orchestra Sinfonica di Torini della Radiotelevisione Italiana_ > orchestrasinfonicaditorinidellaradiotelevisioneitaliana  osinfonicaditorinidellartelevisioneitaliana  # @1@ 1862200 %17616 

    $recType = "ENTRY";
    $synType = &trims($1);
    $validity = $2;
    $LFName = &trims($3);
    $recognitionThingSynsString = &trims($4);
    $numCits = &trims($6);
    $citString = &trims($7);
  } else {
    warn "RETURNING EMPTY ON ODD CONCORDANCE RECORD \[$rec\]\n";
    return undef;
  }

  #warn "DECODING recType \[$recType\] synType \[$synType\] validity \[$validity\] LFName \[$LFName\] recognitionThingSynsString \[$recognitionThingSynsString\] numCits \[$numCits\] citString \[$citString\]\n";

  #
  # make the unique thingSyns hash
  #
  $recognitionThingSynsString =~ s/[<>]/ /g;
  %uniqueThingSyns = $self->uniqueScalars("THINGSYNS", $recognitionThingSynsString);

  #
  # make the unique citations hash
  #
  %uniqueCitations = $self->uniqueScalars("CITATIONS", $citString);

  #
  # generate the LFKey
  #
  $LFKey = &genLFKeyFromLFName($LFName);

  #
  # generate the MODIFIED flag
  #

  $modified = "1";
  #
  # modified unless there is a checksum string matching actual
  #
  if ($rec =~ /(.*)%(\d+)/) {
    my $ADDON_REC_TO_CHECK = trims($1);
    my $checksumString = $2;
    my $checksum = unpack ("%32C*", $ADDON_REC_TO_CHECK) % 65535;
    if ($checksum == $checksumString) {
      $modified = 0;
    }
  }

  return ($recType, $synType, $LFName, $validity, \%uniqueThingSyns, $numCits, \%uniqueCitations, $LFKey, $modified);
  
}# end of &FFScanHelper::decodeCONCORDANCERec();


#2012_01_11 -- writeCONCORDANCERecFromFFScanHelper($ADDONS_OUT);

#my ($rec) = $helper->encodeCONCORDANCERec($recType, $synType, $LFName, $validity, $recogThingSynsRef, $numCitations, $citationsRef[, $VVI]);

#$helper->writeCONCORDANCERecFromFFScanHelper($ADDONS_CONCORDANCE, $VVI);
sub writeCONCORDANCERecFromFFScanHelper {
  my ($self, $ADDONS_CONCORDANCE, $VVI) = @_;

  my $currentSerNum = "";

  my $placePrefix = "CONCORDANCE";
  my $place = "";

  #
  # GENERATE THE CONCORDANCE
  #

  $place = $placePrefix . "100";
  $self->log("NOTE", "...GENERATING ADDON_CONCORDANCE_FILE \[$ADDONS_CONCORDANCE\]", $currentSerNum, $place, @_ );

  open(ADDONS_CONCORDANCE, ">:utf8", $ADDONS_CONCORDANCE) or die "$0 FATAL ERROR: CANNOT OPEN ADDONS_CONCORDANCE FILE \[$ADDONS_CONCORDANCE\]: $!\n";

  #TRAVERSE THE ADDON_PROPS TREE

  #${$self->{REC2}->{$rec2}->{$rec1}}++;
  #
  # first, put out the errors due to thingSyn conflicts
  #
  foreach my $rec2 (sort keys %{$self->{REC2}} ) {
    my @rec1s = sort keys %{$self->{REC2}->{$rec2}};
    foreach my $rec1 (@rec1s) {
      $place = $placePrefix . "101";
      $self->log("WARN", "REC1: \[$rec1\]", $currentSerNum, $place, @_ );
      print ADDONS_CONCORDANCE "  REC1: $rec1\n";
    }
    $self->log("WARN", "REC2: \[$rec2\]", $currentSerNum, $place, @_ );
    print ADDONS_CONCORDANCE "REC2: $rec2\n";
  }

      

  $currentSerNum = "";

  my $topLine = $self->encodeCONCORDANCERec('TOPLINE'); 
  #2011_12_19 -- use common OUTREC from FFScanHelper
  print ADDONS_CONCORDANCE "$topLine\n";

  foreach my $synType (sort keys %LEGAL_SYNTYPES) {

    #2011_12_19 -- use common OUTREC from FFScanHelper
    my $synTypeLine = $self->encodeCONCORDANCERec('SYNTYPELINE', $synType); 
    print ADDONS_CONCORDANCE "$synTypeLine\n";
    $place = $placePrefix . "310";
    $self->log("IGNORE", "WRITING SYNTYPE ENTRIES: \[$synType\]", $currentSerNum, $place, @_ );

    my %uniqueThingSyns = ();
    next unless $synType;

    #
    # get all the ADDONLFNames for this synType
    # 

    my @LFNames = sort $self->getADDON_LFNames($synType);
    foreach my $LFName (@LFNames) {
      next unless $LFName;

      my $isUNChanged = $self->isUNChanged($synType, $LFName);
      if ($isUNChanged) {
	#warn "LF_NAME $synType, $LFName IS UNCHANGED \[$isUNChanged\]\n";
 	print ADDONS_CONCORDANCE "$isUNChanged\n";
 	next;
      }

      #
      # else gen another rec
      #

      my ($validity, @thingSyns) = $self->getADDONFromLFName($synType, $LFName);
      next unless $validity;
      next unless @thingSyns;

      my @citations = $self->getPOPUPsFromLFName($synType, $LFName);


      #
      # WRITE, using common OUTREC from FFScanHelper
      #
      my $entryLine = $self->encodeCONCORDANCERec('ENTRY', $synType, $LFName, $validity, \@thingSyns, "", \@citations, $VVI); 
     
      print ADDONS_CONCORDANCE "$entryLine\n";
  
    }# each ADDON ENTRY
  }# each synType
}# end of writeCONCORDANCERecFromFFScanHelper();

#my $changed = $self->isUNChanged($synType, $LFName);
sub isUNChanged {
  my ($self, $synType, $LFName) = @_;
  my $placePrefix = "IS_UNCHANGED";
  my $place = "";
	my $currentSerNum = "";

  my $isUNChanged = ${$self->{'ADDONS_IS_CHANGED'}->{$synType}->{$LFName}};
  if ($isUNChanged =~ /^$synType/) {
    return $isUNChanged;
  } elsif ($isUNChanged eq 'CHANGED' ) {
    return 0;
  } else {
	  $place = $placePrefix . "010";
		$self->log("ALARM", "CONFUSION CONCERNING STATE OF \[$synType\] \[$LFName\] \[$isUNChanged\]", $currentSerNum, $place, @_ );
  }

}# end of &isUNChanged();

#my ($canonicalLFName, $canonicalLFKey) = $helper->&genCanonicalEnsembleLFKey($looseLFName);
sub genCanonicalEnsembleLFKey {
  my ($self, $looseLFName) = @_;
  my ($canonicalLFName, $canonicalLFKey) = ();

  my $straightName = $looseLFName;
  $straightName =~ s/(.*)_(.*)/$2 $1/;
	$straightName = &trims($straightName);

  my ($abbreviatedString, $changed) = &abbreviateEnsembles($straightName);
  unless ($abbreviatedString) {
    $abbreviatedString = $straightName;
  }

  #2013_01_03 -- Fix the THE problem
#2013_12_25 -- change &amp and & to leave residue
  $abbreviatedString =~ s/^The //;
	#$abbreviatedString =~ s/&nbsp;/ /;
	#$abbreviatedString =~ s/&amp;/ and /;
	#$abbreviatedString =~ s/&/ and /;
  $abbreviatedString =~ s/ and / &amp; /;
  $abbreviatedString =~ s/& / &amp; /;

	#$abbreviatedString =~ s/(\b)O\s+and\s*Ch(\b)/$1_OCH_$2/i;
	#$abbreviatedString =~ s/(\b)Ch\s+and\s*O(\b)/$1_OCH_$2/i;
  $abbreviatedString =~ s/(\b)O\s+&amp;\s*Ch(\b)/$1_OCH_$2/i;
  $abbreviatedString =~ s/(\b)Ch\s+&amp;\s*O(\b)/$1_OCH_$2/i;

  $abbreviatedString =~ s/^\s*_OCH_ (of *)*(the)*\s*(.*)/$3 _OCH_/i;

  $abbreviatedString =~ s/_OCH_/O &amp; Ch/i;

	#2014_01_28 -- change next 4 to reflect end of line
  $abbreviatedString =~ s/ S O(\b)/ SO$1/;
  $abbreviatedString =~ s/ R O(\b)/ RO$1/;
  $abbreviatedString =~ s/ R SO(\b)/ RSO$1/;
  $abbreviatedString =~ s/ P O(\b)/ PO$1/;
 
  $abbreviatedString =~ s/'/’/g;

  $abbreviatedString =~ s/\s+/ /g;

  $canonicalLFName = &trims($abbreviatedString) . "_";
  $canonicalLFKey = $self->genLFKeyFromLFName($canonicalLFName);
  
  #warn "genCanonicalEnsembleLFKey IS RETURNING: $looseLFName -> $canonicalLFName $canonicalLFKey\n";

  
  return ($canonicalLFName, $canonicalLFKey);

}# end of &genCanonicalEnsembleLFKey();

#($canonicalLFName, $canonicalLFKey) = $helper->genCanonicalPeopleThingLFKey($looseLFName);
sub genCanonicalPeopleThingLFKey {
  my ($self, $looseLFName) = @_;

  my ($canonicalLFName, $canonicalLFKey) = ();

  #
  # expand this logic if we need more elegant LFKey behavior
  #

  $canonicalLFName = $looseLFName;

  $canonicalLFName =~ s/'/’/g;

  $canonicalLFKey = &FFScanHelper::genLFKeyFromLFName($canonicalLFName);

  return ($canonicalLFName, $canonicalLFKey);

}# end of &genCanonicalPeopleThingLFKey();

#2012_06_09 -- accomodate ASS_VARs!
#TUFFY

#my $newLine = &escapeVarious($perfString);
sub escapeVarious {
  my ($self, $perfString) = @_;
  my $newLine = "";

  my $placePrefix = "escapeVarious";
  my $place = "";
  my $currentSerNum = "";

	#2015_02_07 -- fix Anonymous 4 bug
	if ($perfString =~ /Anonymous/) {
		return ($perfString);
	}

  #2012_06_09 -- VAR fix
  #2013_06_21 -- fix CONDUCTED BY bug
  if ($perfString =~ /anonymous|other|others|uncredited|undocumented|unidentified|unknown|unnamed|unspecified|unstated|various/io) {	#}
  #if ($perfString =~ /anonymous|other|others|uncredited|undocumented|unidentified|unknown|unnamed|unspecified|unstated|various|soloists?|orchestras?|choruse?s?/io) {
    
    my @clauses = split(/\s*;\s*/, $perfString);
    my @doneClauses = ();
    foreach my $clause (@clauses) {
      my $firstWord = $clause;
      $firstWord =~ s/^\s+//;
      $firstWord =~ s/ +.*//;

      #2013_06_21 -- fix CONDUCTED BY bug
      if ($firstWord =~ /^(anonymous|other|others|uncredited|undocumented|unidentified|unknown|unnamed|unspecified|unstated|various)$/io ) {
	#if ($firstWord =~ /^(anonymous|other|others|uncredited|undocumented|unidentified|unknown|unnamed|unspecified|unstated|various|soloists?|orchestras?|choruse?s?)$/io ) {
	#while ($perfString =~ s%((various)[^\.;]*)\s*(;|$)+%<VAR>$2</VAR>$3%is ) { #}
	if ($clause =~ /conducted by/ || $clause =~ /directed by/ ) { 
	  $place = $placePrefix . "010";
	  $self->log("WARN", "VAR FIELD HAS CONDUCTED/DIRECTED BY: $clause", $currentSerNum, $place, @_ );
	}
	my $oldClause = "<VAR>$clause</VAR>";
	$clause = $self->escapeAssertions($oldClause, 'VAR');
	push (@doneClauses, $clause);
      } else {
	push (@doneClauses, $clause);
      }
	
    }
    $newLine = join("; ", @doneClauses);
  } else {
    $newLine = $perfString;
  }
  
  #if ($newLine =~ /Pople/) {
  #  warn "FFScanHelper_ESCAPE_VARIOUS: \[$newLine\]\n";
  #}
  return $newLine;
}# end of &escapeVarious();

#@bodyLines = $helper->unescapeVarious(@bodyLines);
sub unescapeVarious {
  my ($self, @bodyLines) = @_;
  #2012_06_09 -- VAR fix
  
  foreach my $bodyLine(@bodyLines) {
    $bodyLine = $self->unescapeAssertions($bodyLine, 'VAR');
    $bodyLine =~ s%<VAR>%<span class=VAR>%g;
    $bodyLine =~ s%</VAR>%</span>%g;
  }

  foreach my $bodyLine(@bodyLines) {
    $bodyLine = $self->unescapeAssertions($bodyLine, 'PAREN');
    $bodyLine =~ s%<PAREN>%(%g;
    $bodyLine =~ s%</PAREN>%)%g;
  }

  return @bodyLines;
}# end of &unescapeVarious();

#my $newLine = $helper->genConductorConstruct($perfString);
sub genConductorConstruct {
  my ($self, $perfString) = @_;
  
  #2012_06_09 -- VAR fix
  
  $perfString =~ s% conducting[,;]* %, conductor; %ig;
  $perfString =~ s% directing[,;]* %, director; %ig;
  $perfString =~ s% leading[,;]* %, leader; %ig;
  
  $perfString =~ s% conducting(\.)*%, conductor$1 %ig;
  $perfString =~ s% directing(\.)*%, director$1 %ig;
  $perfString =~ s% leading(\.)*%, leader$1 %ig;

  $perfString =~ s% conducts[,;] %, conductor; %ig;
  $perfString =~ s% directs[,;] %, director; %ig;
  $perfString =~ s% leads[,;] %, leader; %ig;
  
  $perfString =~ s% conducts(\.)*%, conductor$1 %ig;
  $perfString =~ s% directs(\.)*%, director$1 %ig;
  $perfString =~ s% leads(\.)*%, leader$1 %ig;
  
  $perfString =~ s% conductors?(\.)*%, conductor$1 %ig;
  $perfString =~ s% directors?(\.)*%, director$1 %ig;
  $perfString =~ s% leaders?(\.)*%, leader$1 %ig;

  $perfString =~ s% conductors?[,;] %, conductor; %ig;
  $perfString =~ s% directors?[,;] %, director; %ig;
  $perfString =~ s% leaders?[,;] %, leader; %ig;

  $perfString =~ s%(conductor|director|leader)s?\s;\s*the %$1; %ig;

  $perfString =~ s% piano and% piano, %ig;

  $perfString =~ s%, the %; %ig;
  $perfString =~ s% and the %; %ig;
  $perfString =~ s% and %, %ig;
  $perfString =~ s% with %; %ig;
  #$perfString =~ s% the % %ig;

  while ($perfString =~ /; *;/) {
    $perfString =~ s%; *;%; %;
  }
  while ($perfString =~ /, *,/) {
    $perfString =~ s%, *,%, %;
  }
  while ($perfString =~ /, *;/) {
    $perfString =~ s%, *;%; %;
  }
#2014_02_08 -- fix multiple CONDUCTORS
	#warn "CONDUCTOR_19 $perfString\n" if ($perfString =~ /Giuseppe Antonicelli/);

  return $perfString;
}# end of &genConductorConstruct();

#2013_08_25 -- implement SUBSTITUTIONS.editable

sub setUpSubstitutions {
  my ($self, $subFile) = @_;
  
open(SUBSTITUTIONS, "<:utf8", $subFile) or die "I CANNOT READ \[$subFile\]";
while (<SUBSTITUTIONS>) {
    $_ =~ s/#.*//;
    $_ =~ s/\n//;
    next unless ($_ =~ /\w/);
    my $bad = "";
    my $good = "";
    if ($_ =~ m/^([^|]+)\|([^|]+)$/) {
        $bad = $1;
        $good = $2;
        $SUBSTITUTIONS{$bad} = $good;
	#warn "GOOD LINE IN $subFile: BAD = \[$bad\] GOOD = \[$good\]\n";
    } else {
        die "FUNNY LINE IN $subFile: $_\n";
    }
}# end while substitutions
#warn "...READ SUBSTITUTIONS FILE \[$subFile\]\n";

close SUBSTITUTIONS;
}
#@newLines = &FFScanHelper::doSubstitutions(@newLines);
sub doSubstitutions {
	my (@newLines) = @_;

	foreach my $line (@newLines) {
		foreach my $pair (sort keys %SUBSTITUTIONS) {
			my $bad = $pair;
			my $good = $SUBSTITUTIONS{$pair};
			#warn "HELLO. BAD = \[$bad\] GOOD = \[$good\] $line\n";
			my $preLine = $line;
			if ($line =~ s|$bad|$good|g) {
				print "CORRECTION\n$preLine\n$line";
				#warn "CORRECTION\n$preLine\n$line";
			}
		}# end of foreach $pair
	}# end of foreach $line
	return (@newLines);
}# end of doSubstitutions();

#
#2014_01_06 -- support duplicate queueing, dequeing, and moving
#

#2014_01_10 -- put in local queues
#$self->&queueDuplicate($synType1, $val1, $LFName1, $synType2, $val2, $LFName2);
sub queueDuplicate {
	my	($self, $synType1, $val1, $LFName1, $synType2, $val2, $LFName2) = @_;
	my $rec = "$synType1\|$val1\|$LFName1\|$synType2\|$val2\|$LFName2";
	#warn "PUSHED ONTO DUPLICATE QUEUE: $rec\n";
  push (@{$self->{'ADDONS_DUPLICATE_QUEUE'}}, $rec);
	
	return;

}# end of &queueDuplicate();


#2014_01_10 -- put in local queues
#$self->queueBang($synType, $ADDONSShortValidity, $ADDONSLFName, $thingSyn, $serNum);
sub queueBang {
	my	($self, $synType1, $val1, $LFName1, $thingSyn, $serNum) = @_;
	if ($val1 eq "!") {
		my $rec = "$synType1\|$val1\|$LFName1\|$thingSyn\|$serNum";
		#warn "PUSHED ONTO BANG QUEUE: $rec\n";
		push (@{$self->{'ADDONS_BANG_QUEUE'}}, $rec);
	}
	
	return;

}# end of &queueBang();

#2014_01_10 -- put in local queues
#my @duplicates = $helper->fetchDuplicateQueue();
sub fetchDuplicateQueue {
  my ($self) = @_;
	return (@{$self->{'ADDONS_DUPLICATE_QUEUE'}});
}# end of &fetchDuplicateQueue();

#2014_01_10 -- put in local queues
#my @bangs = $helper->fetchBangQueue();
sub fetchBangQueue {
  my ($self) = @_;
	return (@{$self->{'ADDONS_BANG_QUEUE'}});
}# end of &fetchBangQueue();

#2014_01_10 -- put in local queues
#$self->queueCities($synType, $ADDONSShortValidity, $ADDONSLFName, $thingSyn, $serNum);
sub queueCities {
	my	($self, $synType1, $val1, $LFName1, $thingSyn, $serNum) = @_;
	if ($val1 eq "!") {
		my $rec = "$synType1\|$val1\|$LFName1\|$thingSyn\|$serNum";
		#warn "PUSHED ONTO BANG QUEUE: $rec\n";
		push (@{$self->{'ADDONS_BANG_QUEUE'}}, $rec);
	}
	
	return;
}# end of queueCities()


#2014_01_10 -- put in local queues
#my @bangs = $helper->fetchCitiesQueue();
sub fetchCitiesQueue {
  my ($self) = @_;
	return (@{$self->{'ADDONS_BANG_QUEUE'}});
}# end of &fetchCitiesQueue();

#2014_02_01 -- add sub PEEDecide
#my ($LFNameStraight, $LFNameFolded, $synTypesOutRef) =  $helper->PEEDecide($currentDocID, $currentPerformerText, $currentRoleTypeText, $currentRoleText);
sub PEEDecide {
	my ($self, $currentDocID, $currentPerformerText, $currentRoleTypeText, $currentRoleText) = @_;

  my $placePrefix = "PEE";
  my $place = "";
#2014_02_04 -- #pete -- UNCOMMENT THE FOLLOWING 5 LINES TO GET EXCEPTIONS
	#if ($currentPerformerText =~ /&[^a]/) {
	#	my $THINGSYNFlatName = &FFATLASSyntax::genTHINGSYNFlatName($currentPerformerText);
	#	$place = $placePrefix . "000";
	#	$self->log("ALARM", "REMOVING_&s: $currentDocID, \[$currentPerformerText\], $THINGSYNFlatName", $currentDocID, $place, @_ );
	#}
		

	$place = $placePrefix . "000";
	#$self->log("ALARM", "\nPEE_01: ENTRY: $currentDocID, $currentPerformerText, $currentRoleTypeText, $currentRoleText", $currentDocID, $place, @_ );

	my $nudeName = $currentPerformerText;
	$nudeName =~ s/([\W])/\\$1/g;
	#$nudeName =~ s/(.*)_(.*)/$2 $1_/;
	$nudeName =~ s/(.*)_(.*)/$2 $1/;
	$nudeName =~ s/\\([\W])/$1/g;
	
	$nudeName = &trims($nudeName);

	my @synTypesOut = ();
	my $LFNameStraight = "";
	my $LFNameFolded = "";

	foreach my $synType ('ensemble', 'wlens', 'wlperf') {
		my $LFName = $self->LFNameFromScratch($synType, $nudeName);
		$place = $placePrefix . "005";
		#$self->log("ALARM", "  PEE_01: LFNAME: $LFName", $currentDocID, $place, @_ );

		my ($validity, $LFKey, $LFName, $canonicalThingSyn, @recognitionThingSyns) = $self->ultraUltimateADDONFromText($synType, $LFName);

		$place = $placePrefix . "010";
		#$self->log("ALARM", "  PEE_02: ENTRY: $validity, $LFKey, $LFName, $canonicalThingSyn, \[@recognitionThingSyns\]", $currentDocID, $place, @_ );


		my @synTypesOfText = $self->getSynTypesOfText($currentPerformerText, 'wlens', 'wlperf', 'ensemble');

		$place = $placePrefix . "100";
		#$self->log("ALARM", "  PEE_03: SYNTYPES: \[@synTypesOfText\]", $currentDocID, $place, @_ );
		my ($synTypeOut, $LFKeyOut, $checkNameOut, $validityOut, $LFNameOut, $thingSynsOutRef, $serNumsOutRef) = $self->getPEEProperties($synType, $currentDocID, $validity, $LFKey, $LFName, $canonicalThingSyn, \@recognitionThingSyns, \@synTypesOfText);
		my @thingSynsOut = @$thingSynsOutRef;
		my @serNumsOut = @$serNumsOutRef;
		$place = $placePrefix . "200";
		#$self->log("ALARM", "PEEProperties RETURNED: $synType, $synTypeOut, $LFKeyOut, $checkNameOut, $validityOut, $LFNameOut, \[@thingSynsOut\], \[@serNumsOut\]", $currentDocID, $place, @_ );

		my $validityKey = ($validityOut) ? $validityOut : "0";
		my $synTypeKey = ($synTypeOut) ? $synTypeOut : $synType;
		my $outKey = "$synTypeKey$validityKey";
		push (@synTypesOut, $outKey);
		
		if ($synType eq "ensemble") {
			$LFNameStraight = $LFNameOut;
		} elsif ($synType eq "wlperf") {
			my $str = $checkNameOut;
			$str =~ s/_$//;
			$str =~ s/_/ /;
			$LFNameFolded = $self->LFNameFromScratch('performer', $str);
			$place = $placePrefix . "005";
			#$self->log("ALARM", "  PEE_01: LFNAME2: $LFName", $currentDocID, $place, @_ );
		}


	}# each of ensemble, performer

	$place = $placePrefix . "300";
	#$self->log("ALARM", "SYNTYPES: $currentPerformerText $currentRoleTypeText \[@synTypesOut\] \[$LFNameStraight\] \[$LFNameFolded\]", $currentDocID, $place, @_ );

  return ($LFNameStraight, $LFNameFolded, \@synTypesOut);
}# end of PEEDecide();

#2014_02_01 -- add sub PEEDecide
#($synTypeOut, $LFKeyOut, $checkNameOut, $validityOut, $LFNameOut, $thingSynsOutRef, $serNumsOutRef) = $self->getPEEProperties($synType, $currentDocID, $validity, $LFKey, $LFName, $canonicalThingSyn, \@recognitionThingSyns, \@synTypesOfText);
sub getPEEProperties {
	my ($self, $synType, $currentDocID, $validity1, $LFKey, $LFName, $canonicalThingSyn, $recognitionThingSynsRef, $synTypesOfTextRef) = @_;
	my @recognitionThingSyns = @$recognitionThingSynsRef;
	my @synTypesOfText = @$synTypesOfTextRef;

  my $placePrefix = "PEEPROPS";
  my $place = "";

	my ($synTypeOut, $LFKey, $checkName) = ();

	my ($validity, @thingSyns) = $self->getADDONFromLFName($synType, $LFName);
	#next unless $validity;
	return unless @thingSyns;

	my @serNums = $self->getPOPUPsFromLFName($synType, $LFName);
	unless ($synType eq "city") {
		return unless @serNums;
	}
	
	my $synTypeOut = $synType;
	return unless $LFName;
		
	$place = $placePrefix . "000";
	#$self->log("ALARM", "  PEE_04: $synType $LFName $validity \[@thingSyns\] \[@serNums\] ", $currentDocID, $place, @_ );

	my $checkName = $LFName;
	$checkName =~ s/([\W])/\\$1/g;
	$checkName =~ s/(.*)_(.*)/$2 $1_/;
	$checkName =~ s/\\([\W])/$1/g;
	
	$checkName = &trims($checkName);

	unless ($checkName) {
		$place = $placePrefix . "000";
		$self->log("DIE", "NO_CHECKNAME: ", $currentDocID, $place, @_ );
	}
	#
	# 2014_01_27 -- this is a checkName revision
	#
	my ($expandedString, $changed) = $self->expandEnsembleAbbreviations($checkName);
	my ($abbreviatedString, $changed2) = $self->abbreviateEnsembles($expandedString);
	
	my ($canonicalLFName1, $canonicalLFKey1) = $self->genCanonicalEnsembleLFKey($abbreviatedString);
	$checkName = $canonicalLFName1;
	
	#
	#
	#
	my $LFKey = $self->genLFKeyFromLFName($LFName);
	if ($synType =~ /(wlens|ensemble)/) {
		$LFName = $checkName;
		$LFKey = $canonicalLFKey1;
	} elsif ($synType =~ /wlperf/) {
		my $isEQ = ($abbreviatedString eq $expandedString)? "eq" : "ne";
		$place = $placePrefix . "000";
		#$self->log("ALARM", "  ABBREV_SHOWS: $synType $abbreviatedString $isEQ $expandedString", $currentDocID, $place, @_ );
		if ($abbreviatedString ne $expandedString) {
			$LFName = $checkName;
			$LFKey = $canonicalLFKey1;
			$synTypeOut = 'wlens';
		} else {
			#$self->log("ALARM", "  ANALYSIS_SHOWS: $synTypeOut, $LFKey, $checkName, $validity, $LFName", $currentDocID, $place, @_ );
		}
	}

	$place = $placePrefix . "000";
	#$self->log("ALARM", "PEEProperties RETURNING: $synTypeOut, $LFKey, $checkName, $validity, $LFName, \[@thingSyns\], \[@serNums\]", $currentDocID, $place, @_ );

	return ($synTypeOut, $LFKey, $checkName, $validity, $LFName, \@thingSyns, \@serNums);

}# end of getPEEProperties();


######################### THE HOLY LAND ######################

#
# the LOGGING routine
#


#&setWatchSerNums(@watchSerNums);
sub setWatchSerNums {
  my ($self, @watchSerNums) = @_;

  %{$self->{'WATCH_SERNUMS'}} = ();
  foreach my $serNum (@watchSerNums) {
    ${$self->{'WATCH_SERNUMS'}->{$serNum}}++;
  }
}# end of &setWatchSerNums();

#&log($level, $msg, $currentSerNum, $place, @_ );
sub log {
  my ($self, $level, $msg, $currentSerNum, $place, @callingArgs ) = @_;

  my %stackFileName = ();
  my %stackLine = ();
  my %stackSubroutine = ();
  my @topLevelARGS = ();

#2011_08_31 -- recognize FFLOGLEVEL environment variable
  my $FFLOGLEVEL = $ENV{FFLOGLEVEL};
  return undef if ($level eq 'NOTE' && $FFLOGLEVEL eq 'NONOTES');

  $msg = &trims($msg);

  if (%{$self->{'WATCH_SERNUMS'}} ) {
    my %watchSerNums = %{$self->{'WATCH_SERNUMS'}};
    if (%watchSerNums) {
      foreach my $serNum (sort keys %watchSerNums) {
	#warn "WATCHING SERNUM: $serNum\n";
      }
    }# if watching any serNums
  }

  #warn "LOGGING: level: \[$level\] place: \[$place\] msg: \[$msg\] callingArgs: \[@callingArgs\]\n";
  my $maxLevel = 50;

  for (my $i = 0; $i <= $maxLevel; $i++) {
    my ($package, $fileName, $line, $subroutine, $hasargs, $wantarray, $evaltext, $is_require, $hints, $bitmask) = caller($i);
 
    last unless $package ;
    #
    #warn "\[$i\]: \[$package, $fileName, $line, $subroutine\]\n";
    $stackFileName{$i} = $fileName;
    $stackLine{$i} = $line;
    $stackSubroutine{$i} = $subroutine;
 
    if ($i == 1 ) {
      #warn "\n  $msg\n\n";
      for (my $argi = 0; $argi <= $#callingArgs; $argi++ ) {
        my $arg = $callingArgs[$argi];
	#warn "  ARG $argi: \[$arg\]\n";
	push @topLevelARGS, $arg;
      }
    }
  }# each useful stack level

  #
  # summarize the STACK in a STACKSTRING
  #
  my $stackString = "";
  foreach my $stackLevel (reverse sort keys %stackFileName) {
    my $fileName = $stackFileName{$stackLevel};
    my $stackLine = $stackLine{$stackLevel};
    my $stackSubroutine = $stackSubroutine{$stackLevel};

    $stackString .= " " . $fileName;
    $stackString .= " " . $stackLine;
    $stackString .= " " . $stackSubroutine;
  }

  my $main = $0;
  my $shortMain = $main;
  $shortMain =~ s%.*/%%;

  $stackString =~ s/$main//g;
  $stackString =~ s/main::/-> /g;
  $stackString =~ s/FFScanHelper::log//g;
  $stackString =~ s/ +/ /g;
  $stackString .= " PLACE $place";
  $stackString .= "] ";

  $stackString = "\[" . $shortMain . $stackString;

  #warn "STACKSTRING \[$stackString\]\n";

  my $briefMsg = $msg;
  $briefMsg =~ s/dx=.*?\]//s;

  #
  # put on the designated media, if any, and die if requested
  #
  if (defined ${$self->{'WATCH_SERNUMS'}->{$currentSerNum}} ) {
    if (${$self->{'WATCH_SERNUMS'}->{$currentSerNum}} ) {
      warn "$currentSerNum WATCHING: $briefMsg $stackString\n";
      print "$currentSerNum WATCHING: $briefMsg $stackString\n";
       
      return "" unless ($level eq 'DIE');
    }
  }

  if ($level eq "IGNORE") {
    return;
  } elsif ($level eq "NOTE" ) {
    print "$currentSerNum NOTE: $briefMsg $stackString\n";
  } elsif ($level eq "NOTE_FULL" ) {
    print "$currentSerNum NOTE: $briefMsg $stackString ARGS \[@topLevelARGS\]\n";
  } elsif ($level eq "WARN" ) {
    print "$currentSerNum WARNING: $briefMsg $stackString\n";
    warn "\n$currentSerNum WARNING: $briefMsg $stackString\n";
  } elsif ($level eq "ALARM" ) {
    print "$currentSerNum ALARM: $briefMsg $stackString\n";
    warn "\n$currentSerNum ALARM: $briefMsg $stackString\n";
  } elsif ($level eq "FYI" ) {
    print "FYI: $briefMsg $stackString\n";
    warn "\nFYI: $briefMsg $stackString\n";
  } elsif ($level eq "WARN_FULL" ) {
    print "$currentSerNum WARNING: $briefMsg $stackString ARGS \[@topLevelARGS\]\n";
    warn "$currentSerNum WARNING: $briefMsg $stackString ARGS \[@topLevelARGS\]\n";
  } elsif ($level eq "DIE" ) {
    print "$currentSerNum DYING: $briefMsg $stackString ARGS \[@topLevelARGS\]\n";
    die "$currentSerNum DYING: $briefMsg $stackString ARGS \[@topLevelARGS\]\n";
  } else {
    die "BAD_LOG_LEVEL: \[$level\] TRYING TO LOG \[$stackString\]\n";
  }

  #die "\nLOGGING at level $level place $place \[$briefMsg\]. Sorry.\n";

}# end of log

#
# UTILITY ROUTINES
#

#my $SWVersion = $self->getSWVersion();
sub getSWVersion {
  my ($self) = @_;

  #2011_11_07 -- find SW_VERSION automagically from a SINGLE source

  my $SWVersion = "";
  if ($self->{SW_VERSION} ) {
    $SWVersion = $self->{SW_VERSION};
    #warn "SW_VERSION RETRIEVED IS \[$SWVersion\]\n";
  } else {
    #
    # find the SW_VERSION file in SCAN/foo/SW_VERSION
    #
    my $currentRealPath = realpath(".");
    my $SCAN_TOP = $currentRealPath;
    #warn "CURRENT DIR: $SCAN_TOP\n";
    #warn "CURRENT_REAL_PATH: $currentRealPath\n";
#2012_02_09 -- make FIND SW_VERSION ok for C's machine
    # 2013_01_24 -- find VERSION FILE if we are somewhere in /factory
    my $user = $ENV{'USER'};
    if ($SCAN_TOP =~ /SCAN/) {
      $SCAN_TOP =~ s%(/SCAN/[^/]+).*%$1%;	# SCAN/ACTIVE or SCAN/nnnn 
#2014_05_08 -- add www/perl/make_modx_db to SW_VERSION path
		} elsif ($SCAN_TOP =~ m%(.*/www/perl/make_modx_db)%) {
			$SCAN_TOP = "$1";
			#warn "SCAN TOP: $SCAN_TOP\n";
    } else {
      if ($user eq "celeste") {
	$SCAN_TOP =~ s%(/factory/[^/]+).*%$1%;	# CCS's machine
      } elsif ($user eq "jacqueline") {
	$SCAN_TOP =~ s%(/factory/[^/]+).*%$1%;	# Jacqueline Kharouf's machine
      } elsif ($user eq "peter") {
#2013_08_08 -- get the SW_VERSION seeking correct for PFSs new machine
	$SCAN_TOP =~ s%(/factory/[^/]+).*%$1%;	# PFS's machine
	#$SCAN_TOP =~ s%(/factory/).*%$1SCAN/ACTIVE%;
      }
    }
    my $versionFilePath = "$SCAN_TOP/SW_VERSION";
    warn "user $user versionFilePath: $versionFilePath\n";

    if (-f $versionFilePath) {
      $SWVersion = `cat $versionFilePath`;
      chop $SWVersion;
      $self->{SW_VERSION} = $SWVersion;
      #warn "CURRENT SW_VERSION IS \[$SWVersion\]\n";
    } else {
      die "FFScanHelper CANNOT FIND SW_VERSION\n";
    }
    warn "SW_VERSION IS \[$SWVersion\]\n";
  }

  return $SWVersion;
  
}# end of getSWVersion();

#$outText = &FFScanHelper::removeNullSpans($outText);
sub removeNullSpans {
  shift(@_) if (ref($_[0]) eq 'FFScanHelper' );      # STATIC even if called on instance`
  my ($t) = @_;
  #<span class=ARIAL></span>
  #die "O JUST FUCKME \[$t\]\n";
  #<span class=ARIAL></span>
  $t =~ s%<span class=[^<>]*></span>%%ig;

  return $t;

}# end of $removenullspans();

#my $t = &trims($t);
sub trims {
  my ($t) = @_;
  $t =~ s/^\s+//;
  $t =~ s/\s+$//;
  return $t;
}# end of &trims();

#my $t = &trimw($t);
sub trimw {
  my ($t) = @_;
  $t =~ s/^\w+//;
  $t =~ s/\w+$//;
  return $t;
}# end of &trimw();

#murmurToJesus( $msg, @_ );
sub murmurToJesus {
  my ( $msg, @callingargs ) = @_;

  my $maxlevel = 50;
  warn "\n\n";

  for (my $i = 1; $i <= $maxlevel; $i++) {
    my ($package, $filename, $line, $subroutine, $hasargs, $wantarray, $evaltext, $is_require, $hints, $bitmask) = caller($i);
 
    last unless $package ;
    warn "\[$i\]: \[$package, $filename, $line, $subroutine\]\n";
 
    if ($i == 1 ) {
      warn "\n  $msg\n\n";
      for (my $argi = 0; $argi <= $#callingargs; $argi++ ) {
        my $arg = $callingargs[$argi];
        warn "  arg $argi: \[$arg\]\n";
      }
    }
  }# each useful stack level

  my $briefmsg = $msg;
  $briefmsg =~ s/dx=.*?\]//s;

   warn "\nffscanhelper murmurred to jesus. \[$briefmsg\]. Good Luck!.\n";

}# end of &murmurToJesus();

#comeToJesus( $msg, @_ );
sub comeToJesus {
  my ( $msg, @callingargs ) = @_;

  my $maxlevel = 50;
  warn "\n\n";

  for (my $i = 1; $i <= $maxlevel; $i++) {
    my ($package, $filename, $line, $subroutine, $hasargs, $wantarray, $evaltext, $is_require, $hints, $bitmask) = caller($i);
 
    last unless $package ;
    warn "\[$i\]: \[$package, $filename, $line, $subroutine\]\n";
 
    if ($i == 1 ) {
      warn "\n  $msg\n\n";
      for (my $argi = 0; $argi <= $#callingargs; $argi++ ) {
        my $arg = $callingargs[$argi];
        warn "  arg $argi: \[$arg\]\n";
      }
    }
  }# each useful stack level

  my $briefmsg = $msg;
  $briefmsg =~ s/dx=.*?\]//s;

   die "\nffscanhelper was called to jesus. \[$briefmsg\]. sorry.\n";

}#end of &comeToJesus();

#####################################################################
#end of module
#####################################################################
1
