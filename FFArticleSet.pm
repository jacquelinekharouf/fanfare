# ArticleSet.pm -- struct to store, organize and modify Fanfare document data
# 2006_04_05 -- restructured from FanfareDocument.pm to make a single
# 		instance capable of holding data for all articles in a single
# 		thingy.  All method calls changed to have serNum as first arg.
# 2006_10_15 -- move to perllib, rename FFArticleSet
#2006_10_18 -- add an html suffix to fid if there isn't one
# 2007_08_13 -- Allow reviewersig span type and Bf Para type
# 2008_08_10 -- tables are full citizens
# 2011_03_03 -- add method summary
# 2011_03_07 -- add 'SCAN_FILLER' as legal span purpose
# 2011_04_12 -- add 'SCAN_FILLER' as legal para purpose
#2012_05_18 -- add STET para and span 

#2012_08_30 -- add PARA PURPOSES for TABLE, DL, OL 
#2012_09_01 -- add BONUS
package FFArticleSet;

use Data::Dumper;
use Carp;

########################## METHOD SUMMARY ##########################
#grep "^sub " FFArticleSet.pm | sed -e "s/^/# /; s/ *[{}]//; "
# sub new
# sub addArticle
# sub allSerNums
# sub dump
# sub getSetMapped	# get or set a mapped value
# sub isValidSpanPurpose
# sub isValidParaPurpose
# sub _checkGetWhich
# sub _checkSetWhich
# sub _getVal
# sub _updateFinal
# sub fid
# sub allDatumElements
# sub parseSuccess
# sub articleType
# sub articleSubtype
# sub articleSortCode
# sub avPairFirstArticle
# sub avPairPrevArticle
# sub avPairNextArticle
# sub avPairLastArticle
# sub relatedArticleAVPairs
# sub articleTitle
# sub paraInventory
# sub author
# sub reviewTableLabel
# sub byline
# sub authorStatus
# sub beginsHeadnote
# sub endsHeadnote
# sub paraCharacteristics
# sub paraPurpose
# sub paraNums
# sub paraPurposes
# sub spanFont
# sub spanText
# sub spanPurpose
# sub pushSpanDatum
# sub spanData
# sub spanNums
# sub spanPurposes
# sub spanTexts
# sub spanFonts
# sub headnoteType
# sub headnoteParas
# sub headnoteOfPara
# sub headnoteNums

########################## METHOD SUMMARY ##########################

#GLOBALS FOR VALIDATION

my %validParaPurposes = (

  'ARTICLE_HEADING'	=> 1,	# Possibly article type, title and/or byline
  'ALBUM_TITLE'		=> 1,	# Album title in an otherwise COMPOSERS context
  'B'			=> 1,	# Body paragraph
  'BLANK'		=> 1,	# Contains only blank spans
  'BOLLY_HEADNOTE'	=> 1,	# Bollywood Review Headnote -- 2006_03_21
  'BOOK_HEADNOTE'	=> 1,	# Book Review Headnote
  'BYLINE'		=> 1,	# Author Byline
  'Br'			=> 1,	# Embedded Reviewer byline
  'CLIST_HEADNOTE'	=> 1,	# Secondary COMPOSER LIST Headnote
  'COL2_HEADNOTE'	=> 1,	# Optional CW Headnote following COL_HEADNOTE
  'COL_HEADNOTE'	=> 1,	# Collections Headnote
  'CPR_HEADNOTE'	=> 1,	# Standard Composer-Performer-Recording Headnote
  'EXTRAS_HEADNOTE'	=> 1,	# Optional Headnote beginning with EXTRAS char
  'FUNNY_B'		=> 1,	# has invalid spans
  'FUNNY_COL2_HEADNOTE'	=> 1,	# has invalid spans
  'FUNNY_COL_HEADNOTE'	=> 1,	# has invalid spans
  'FUNNY_CPR_HEADNOTE'	=> 1,	# has invalid spans
  'FUNNY_BOLLY_HEADNOTE'	=> 1,	# has invalid spans 2006_03_21
  'FUNNY_PROLOG'	=> 1,	# has invalid spans
  'FUNNY_WANT_PROLOG'	=> 1,	# Want list prolog that isn't ARIAL_0
  'PROLOG'		=> 1,	# Editorial notes, like Use This Headnote
  'SCAN_FILLER'		=> 1,	# 2011_04_12
#2012_05_18 -- add STET para and span 
  'STET_ARIAL'		=> 1,	# 2012_05_18
  'SELECTIONS_HEADNOTE'	=> 1,	# Secondary headnote for Arias from, etc.
  'SKIP'		=> 1,	# Skip this paragraph altogether
  'TABLE'		=> 1,	# 2008_08_10 -- tables are full citizens
  'UNKN'		=> 1,	# No purpose has been assigned
  'WLIST_HEADNOTE'	=> 1,	# Optional list of Works following CPR or COL
  'Bf'	=> 1,			# 2007_08_13 -- allow Bf Para Type
  'reviewersig'	=> 1,		# 2008_06_15 -- allow reviewersig Para Type
#2012_08_30 -- add PARA PURPOSES for TABLE, DL, OL 
  'BODY_TABLE_PARA'	=> 1,			# 
  'BODY_DL_PARA'	=> 1,			#
  'BODY_OL_PARA'	=> 1,			# 
#2012_09_01 -- add BONUS
  'BONUS'	=> 1,			# 



);

my %validSpanPurposes = (

  'ALBUM_TITLE'		=> 1,	#
  'ARTICLE_TITLE'	=> 1,	#
  'ARTICLE_HEADING'	=> 1,	#
  'B'			=> 1,	#
  'BLANK'		=> 1,	#
  'BOOK_TITLE'		=> 1,	#
  'BOOK_AUTHOR'		=> 1,	#
  'BOOK_DATA'		=> 1,	#
  'BULLET_1'		=> 1,	#
  'BULLET_2'		=> 1,	#
  'BULLET_3'		=> 1,	#
  'BULLET_4'		=> 1,	#
  'BULLET_5'		=> 1,	#
  'BULLET_6'		=> 1,	#
  'BULLET_7'		=> 1,	#
  'BULLET_8'		=> 1,	#
  'BULLET_9'		=> 1,	#
  'BYLINE'		=> 1,	#
  'Br'			=> 1,	#
  'CLIST_TYPE'		=> 1,	# e.g.Music by,in a COMPOSER LIST
  'CLIST_FILLER'	=> 1,	# e.g. "and" in a COMPOSER LIST
  'COMPOSER'		=> 1,	# e.g. BACH
  'COMPOSER_CONT'	=> 1,	# e.g. (arr. Swineburg)
  'COMPOSER_SUPER'	=> 1,	# e.g. 2,3
  'EXTRAS'		=> 1,	#
  'EXTRAS_CONTENT'	=> 1,	#
  'FUNNY'		=> 1,	#
  'FUNNY_BOOK_SPAN'	=> 1,	# Unrecognized span in Book Review Headnote
  'FUNNY_COL2_SPAN'	=> 1,	#
  'FUNNY_COL_SPAN'	=> 1,	#
  'FUNNY_CPR_SPAN'	=> 1,	#
  'FUNNY_BOLLY_SPAN'	=> 1,	# 2006_03_21
  'PERFORMER'		=> 1,	#
  'PERF_SUPER'		=> 1,	#
  'PROLOG'		=> 1,	#
  'RECORDING'		=> 1,	#
  'REC_LEGAL'		=> 1,	#
  'REC_SUPER'		=> 1,	#
  'SELECTIONS_TYPE'	=> 1,	# Type of selections in a SELECTIONS_HEADNOTE
  'SCAN_FILLER'		=> 1,	# 2011_03_07
#2012_08_18 -- add STET para and span 
  'STET_ARIAL'		=> 1,	# 2012_08_18
  'STET_TIMES'		=> 1,	# 2012_08_18
  'STET'		=> 1,	# 2012_08_18
  'SKIP'		=> 1,	# ignore this span altogether
  'TABLE'		=> 1,	# 2008_08_10 -- tables are full citizens
  'UNKN'		=> 1,	# no purpose for this span has been adduced
  'VROLE'		=> 1,	#
  'WORK'		=> 1,	#
  'WORK_CONT'		=> 1,	#
  'WORK_SUPER'		=> 1,	#
  'reviewersig'		=> 1,	# 2007_08_13 -- Allow reviewersig span type

);


#METHODS

sub new {
  my $class = shift;
  my $serNum;
  my $self =  {
	      };
  bless ($self, $class);
  return $self;
}

sub addArticle {
  my $self = shift;
  my $fid = shift;	# e.g. 123456.MAHLER_Sym-3.html
  my $serNum;
  #2006_10_18 -- add an html suffix to fid if there isn't one
  unless ($fid =~ /\.html$/) {
    $fid .= ".html";
  }
  if ($fid =~ /^(\d{6,7})\..*\.html$/) {
    $serNum = $1;
  } else {
    croak "ArticleSet->addArticle() FATAL ERROR: ARG MUST BE A FILE NAME OF FORM 123456.foo.html IS \[$fid\]\n";
  }

  $self->{'ALL_SERNUMS'}->{$serNum}++;
  croak "ArticleSet->addArticle() FATAL ERROR: ATTEMPT TO ADD DUPLICATE SERNUM \[$serNum\]\n" unless ($self->{'ALL_SERNUMS'}->{$serNum} == 1);

  $self->{'FID'}->{$serNum} = $fid;
  return $serNum;	# return the serNum
}

sub allSerNums {
  my $self = shift;
  return sort keys %{$self->{'ALL_SERNUMS'}};
}

sub dump {
  my $self = shift;
  return (Dumper($self));
}# end of dump()
sub getSetMapped {	# get or set a mapped value
  my $hash = shift;
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  my $caller = caller;
  if ($val) {	#SET
    if ($which =~ /^ORIG|AUTO|MAPPED^/) {
      $hash->{$which} = $val;
      _updateFinal($hash);	# make best resultant final
    } else {

      croak "$0 FATAL ERROR: ArticleSet $caller ARG0 MUST BE ORIG AUTO or MAPPED to SET \[$which\]\n";
    }
  } else {	#GET
    $which = "FINAL" unless $which;
    if ($which =~ /^ORIG|AUTO|MAPPED|FINAL$/) {
      $val = $hash->{$which};
    } else {
      croak "$0 FATAL ERROR: ArticleSet $caller ARG0 MUST BE ORIG AUTO MAPPED or FINAL to GET \[$which\]\n";
    }
  }
  return $val;
}

sub isValidSpanPurpose {
  my $self = shift;
  my $val = shift;
  return $validSpanPurposes{$val};
}# end of &isValidSpanPurpose();

sub isValidParaPurpose {
  my $self = shift;
  my $val = shift;
  return $validParaPurposes{$val};
}# end of &isValidParaPurpose();

#_checkGetWhich($which);
sub _checkGetWhich {
  my ($which) = @_;
  unless ($which =~ /^ORIG|AUTO|MAPPED|FINAL|STRING$/) {
    croak "$0 FATAL ERROR: ArticleSet->articleType() ARG0 MUST BE ORIG AUTO MAPPED FINAL OR STRING to GET \[$which\]\n";
  }
}# end of _checkGetWhich();

#_checkSetWhich($which);
sub _checkSetWhich {
  my ($which) = @_;

  unless ($which =~ /^ORIG|AUTO|MAPPED$/) {
    my $caller = caller;
    croak "$0 FATAL ERROR: ArticleSet $caller ARG0 MUST BE ORIG AUTO or MAPPED to SET \[$which\]\n";
  }
}# end of _checkSetWhich();


#$val = _getVal($self->{'ARTICLE_TYPE'}, $which;
sub _getVal {
  my ($hash, $which) = @_;
  my $val = "";
  if ($which eq "STRING") {	# if we are returning the mapping string
    $val = $hash->{"ORIG"};	# String begins with ORIG if any
    $val .= ">>" . $hash->{"AUTO"} if $hash->{"AUTO"};	# continues with >> AUTO if any
    $val .= "=>" . $hash->{"MAPPED"} if $hash->{"MAPPED"};	# continues with => MAPPED if any
  } else {
    $val = $hash->{$which};
  }
  return $val;
  
}# end of  _getVal();

sub _updateFinal {
  my ($hash) = shift;	# e.g. $self->{'ARTICLE_TYPE'}
  my $bestVal = "";
  if ($hash->{'MAPPED'}) {
    $hash->{'FINAL'} = $hash->{'MAPPED'};	# prefer a human-MAPPED value
    $hash->{'FINAL_SOURCE'} = 'MAPPED';
  } elsif ($hash->{'AUTO'}) {
    $hash->{'FINAL'} = $hash->{'AUTO'};	# next an AUTO value
    $hash->{'FINAL_SOURCE'} = 'AUTO';
  } elsif ($hash->{'ORIG'}) {
    $hash->{'FINAL'} = $hash->{'ORIG'};	# finally the ORIG value
    $hash->{'FINAL_SOURCE'} = 'ORIG';
  } else {
    my $caller = caller;
    croak "$0 FATAL ERROR: ArticleSet CANNOT UPDATE FINAL FOR \[$caller\]\n";
  }
}# end of _updateFinal()
    
#
# DOCUMENT PROPERTY ACCESSORS
#

sub fid {
  my $self = shift;	# NO SETTER: fid MUST BE SET AT addArticle()
  my $serNum = shift;
  return $self->{'FID'}->{$serNum};
}


#my @allDatumElements = $document->allDatumElements();
sub allDatumElements {
  my $self = shift;
  my $serNum = shift;

  return (@{$self->{'ALL_DATUM_ELEMENTS'}->{$serNum}});

}# end of allDatumElements();

# MAPABLE DOCUMENT PROPERTIES

sub parseSuccess {
  my $self = shift;
  my $serNum = shift;
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'PARSE_SUCCESS'}->{$serNum}->{$which} = $val;
    _updateFinal($self->{'PARSE_SUCCESS'}->{$serNum});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'PARSE_SUCCESS'}->{$serNum}, $which);
  }
  return $val;
}# end of parseSuccess();

sub articleType {
  my $self = shift;
  my $serNum = shift;
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'ARTICLE_TYPE'}->{$serNum}->{$which} = $val;
    _updateFinal($self->{'ARTICLE_TYPE'}->{$serNum});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'ARTICLE_TYPE'}->{$serNum}, $which);
  }
  return $val;
}# end of articleType();

#2006_03_22 -- add article subtype
sub articleSubtype {
  my $self = shift;
  my $serNum = shift;
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'ARTICLE_SUBTYPE'}->{$serNum}->{$which} = $val;
    _updateFinal($self->{'ARTICLE_SUBTYPE'}->{$serNum});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'ARTICLE_SUBTYPE'}->{$serNum}, $which);
  }
  return $val;
}# end of articleSubtype();

sub articleSortCode {
  my $self = shift;
  my $serNum = shift;
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'ARTICLE_SORT_CODE'}->{$serNum}->{$which} = $val;
    _updateFinal($self->{'ARTICLE_SORT_CODE'}->{$serNum});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'ARTICLE_SORT_CODE'}->{$serNum}, $which);
  }
  return $val;
}# end of articleSortCode();

sub avPairFirstArticle {
  my $self = shift;
  my $serNum = shift;
  my $avPair = shift;	# must be specified
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $serNum2 = shift;	# if specified, this is a SET and which must be provided

  if ($serNum2) {	#SET
    _checkSetWhich($which);
    $self->{'AVPAIR_FIRST_ARTICLE'}->{$serNum}->{$avPair}->{$which} = $serNum2;
    _updateFinal($self->{'AVPAIR_FIRST_ARTICLE'}->{$serNum}->{$avPair});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $serNum2 = _getVal($self->{'AVPAIR_FIRST_ARTICLE'}->{$serNum}->{$avPair}, $which);
  }
  return $serNum2;
}# end of avPairFirstArticle();

sub avPairPrevArticle {
  my $self = shift;
  my $serNum = shift;
  my $avPair = shift;	# must be specified
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $serNum2 = shift;	# if specified, this is a SET and which must be provided

  if ($serNum2) {	#SET
    _checkSetWhich($which);
    $self->{'AVPAIR_PREV_ARTICLE'}->{$serNum}->{$avPair}->{$which} = $serNum2;
    _updateFinal($self->{'AVPAIR_PREV_ARTICLE'}->{$serNum}->{$avPair});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $serNum2 = _getVal($self->{'AVPAIR_PREV_ARTICLE'}->{$serNum}->{$avPair}, $which);
  }
  return $serNum2;
}# end of avPairPrevArticle();

sub avPairNextArticle {
  my $self = shift;
  my $serNum = shift;
  my $avPair = shift;	# if specified, this is a SET and which must be provided
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $serNum2 = shift;	# if specified, this is a SET and which must be provided

  if ($serNum2) {	#SET
    _checkSetWhich($which);
    $self->{'AVPAIR_NEXT_ARTICLE'}->{$serNum}->{$avPair}->{$which} = $serNum2;
    _updateFinal($self->{'AVPAIR_NEXT_ARTICLE'}->{$serNum}->{$avPair});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $serNum2 = _getVal($self->{'AVPAIR_NEXT_ARTICLE'}->{$serNum}->{$avPair}, $which);
  }
  return $serNum2;
}# end of avPairNextArticle();

sub avPairLastArticle {
  my $self = shift;
  my $serNum = shift;
  my $avPair = shift;	# must be specified
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $serNum2 = shift;	# if specified, this is a SET and which must be provided

  if ($serNum2) {	#SET
    _checkSetWhich($which);
    $self->{'AVPAIR_LAST_ARTICLE'}->{$serNum}->{$avPair}->{$which} = $serNum2;
    _updateFinal($self->{'AVPAIR_LAST_ARTICLE'}->{$serNum}->{$avPair});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $serNum2 = _getVal($self->{'AVPAIR_LAST_ARTICLE'}->{$serNum}->{$avPair}, $which);
  }
  return $serNum2;
}# end of avPairLastArticle();

#my @relatedArticleAVPairs = $document->relatedArticleAVPairs();
sub relatedArticleAVPairs {
  my $self = shift;
  my $serNum = shift;
  my %unique = ();

  foreach my $avPair (keys %{$self->{'AVPAIR_FIRST_ARTICLE'}->{$serNum}}) {
    $unique{$avPair}++;
  }
  foreach my $avPair (keys %{$self->{'AVPAIR_PREV_ARTICLE'}->{$serNum}}) {
    $unique{$avPair}++;
  }
  foreach my $avPair (keys %{$self->{'AVPAIR_NEXT_ARTICLE'}->{$serNum}}) {
    $unique{$avPair}++;
  }
  foreach my $avPair (keys %{$self->{'AVPAIR_LAST_ARTICLE'}->{$serNum}}) {
    $unique{$avPair}++;
  }

  return (sort keys %unique);

}# end of relatedArticleAVPairs();

sub articleTitle {
  my $self = shift;
  my $serNum = shift;
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'ARTICLE_TITLE'}->{$serNum}->{$which} = $val;
    _updateFinal($self->{'ARTICLE_TITLE'}->{$serNum});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'ARTICLE_TITLE'}->{$serNum}, $which);
  }
  return $val;
}# end of articleTitle();

sub paraInventory {
  my $self = shift;
  my $serNum = shift;
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'PARA_INVENTORY'}->{$serNum}->{$which} = $val;
    _updateFinal($self->{'PARA_INVENTORY'}->{$serNum});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'PARA_INVENTORY'}->{$serNum}, $which);
  }
  return $val;
}# end of paraInventory();

sub author {
  my $self = shift;
  my $serNum = shift;
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'AUTHOR'}->{$serNum}->{$which} = $val;
    _updateFinal($self->{'AUTHOR'}->{$serNum});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'AUTHOR'}->{$serNum}, $which);
  }
  return $val;
}# end of author();

sub reviewTableLabel {
  my $self = shift;
  my $serNum = shift;
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'REVIEW_TABLE_LABEL'}->{$serNum}->{$which} = $val;
    _updateFinal($self->{'REVIEW_TABLE_LABEL'}->{$serNum});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'REVIEW_TABLE_LABEL'}->{$serNum}, $which);
  }
  return $val;
}# end of reviewTableLabel();

sub byline {
  my $self = shift;
  my $serNum = shift;
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'BYLINE'}->{$serNum}->{$which} = $val;
    _updateFinal($self->{'BYLINE'}->{$serNum});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'BYLINE'}->{$serNum}, $which);
  }
  return $val;
}# end of byline();

sub authorStatus {
  my $self = shift;
  my $serNum = shift;
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'AUTHOR_STATUS'}->{$serNum}->{$which} = $val;
    _updateFinal($self->{'AUTHOR_STATUS'}->{$serNum});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'AUTHOR_STATUS'}->{$serNum}, $which);
  }
  return $val;
}# end of authorStatus();
    

############################ PARAGRAPH ROUTINES ##########################

# PARA SCALAR METHODS


#
# declare that this paraNum is the first para of a headnote
#
sub beginsHeadnote {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;
  my $which = "ORIG";	# cannot override this;
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'PARA'}->{$serNum}->{$paraNum}->{'BEGINS_HEADNOTE'}->{$which} = $val;
    _updateFinal($self->{'PARA'}->{$serNum}->{$paraNum}->{'BEGINS_HEADNOTE'});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'PARA'}->{$serNum}->{$paraNum}->{'BEGINS_HEADNOTE'}, $which);
  }
  return $val;
}# end of beginsHeadnote();

#
# declare that this paraNum is the final para of the current headnote
#
sub endsHeadnote {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;	# 1 .. n
  my $which = "ORIG";	# cannot override this
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'PARA'}->{$serNum}->{$paraNum}->{'ENDS_HEADNOTE'}->{$which} = $val;
    _updateFinal($self->{'PARA'}->{$serNum}->{$paraNum}->{'ENDS_HEADNOTE'});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'PARA'}->{$serNum}->{$paraNum}->{'ENDS_HEADNOTE'}, $which);
  }
  return $val;
}# end of endsHeadnote();

sub paraCharacteristics {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;	# 1 .. n
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'PARA'}->{$serNum}->{$paraNum}->{'CHARACTERISTICS'}->{$which} = $val;
    _updateFinal($self->{'PARA'}->{$serNum}->{$paraNum}->{'CHARACTERISTICS'});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'PARA'}->{$serNum}->{$paraNum}->{'CHARACTERISTICS'}, $which);
  }
  return $val;
}# end of paraCharacteristics();

sub paraPurpose {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;	# 1 .. n
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    unless ($validParaPurposes{$val}) {
      my $s = $serNum;
      die "$0 FFArticleSet FATAL ERROR: INVALID PARA PURPOSE: \[$val\] IN $s\n";
    }
    #2008_08_10 -- tables
    #warn "Dx STORING PARA PURPOSE \[$paraNum\] \[$val\]\n" if ($serNum =~ /242151/ && $paraNum == 3);
    $self->{'PARA'}->{$serNum}->{$paraNum}->{'PURPOSE'}->{$which} = $val;
    _updateFinal($self->{'PARA'}->{$serNum}->{$paraNum}->{'PURPOSE'});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'PARA'}->{$serNum}->{$paraNum}->{'PURPOSE'}, $which);
  }
    #2008_08_10 -- tables
    #warn "Dx RETURNING PARA PURPOSE \[$paraNum\] \[$val\]\n" if ($serNum =~ /242151/ && $paraNum == 3);
  return $val;
}# end of paraPurpose();

# PARA LIST METHODS

sub paraNums {
  my $self = shift;
  my $serNum = shift;

  return (sort { $a <=> $b } keys %{$self->{'PARA'}->{$serNum}});
}# end of paraNums();

sub paraPurposes {
  my $self = shift;
  my $serNum = shift;

  my @paraNums = $self->paraNums($serNum);
  my @purposes = ();

  foreach my $paraNum (@paraNums) {
    my $purpose = $self->paraPurpose($serNum, $paraNum);
    $purpose = "UNKN_" . $self->paraCharacteristics($serNum, $paraNum) unless $purpose;
    push (@purposes, $purpose);
  }

  return (@purposes);
}# end of paraPurposes()

################################ SPAN ROUTINES ####################
    

sub spanFont {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;	# 1 .. n
  my $spanNum = shift;	# 1 .. n
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'PARA'}->{$serNum}->{$paraNum}->{'SPAN'}->{$spanNum}->{'FONT'}->{$which} = $val;
    _updateFinal($self->{'PARA'}->{$serNum}->{$paraNum}->{'SPAN'}->{$spanNum}->{'FONT'});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'PARA'}->{$serNum}->{$paraNum}->{'SPAN'}->{$spanNum}->{'FONT'}, $which);
  }
  return $val;
}# end of spanFont();

sub spanText {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;	# 1 .. n
  my $spanNum = shift;	# 1 .. n
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'PARA'}->{$serNum}->{$paraNum}->{'SPAN'}->{$spanNum}->{'TEXT'}->{$which} = $val;
    _updateFinal($self->{'PARA'}->{$serNum}->{$paraNum}->{'SPAN'}->{$spanNum}->{'TEXT'});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'PARA'}->{$serNum}->{$paraNum}->{'SPAN'}->{$spanNum}->{'TEXT'}, $which);
  }
  return $val;
}# end of spanText();

sub spanPurpose {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;	# 1 .. n
  my $spanNum = shift;	# 1 .. n
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    unless ($validSpanPurposes{$val}) {
      my $s = $serNum;
      die "$0 FATAL ERROR: INVALID SPAN PURPOSE: \[$val\] IN $s\n";
    }
    $self->{'PARA'}->{$serNum}->{$paraNum}->{'SPAN'}->{$spanNum}->{'PURPOSE'}->{$which} = $val;
    _updateFinal($self->{'PARA'}->{$serNum}->{$paraNum}->{'SPAN'}->{$spanNum}->{'PURPOSE'});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = $self->{'PARA'}->{$serNum}->{$paraNum}->{'SPAN'}->{$spanNum}->{'PURPOSE'}->{$which};
    $val = _getVal($self->{'PARA'}->{$serNum}->{$paraNum}->{'SPAN'}->{$spanNum}->{'PURPOSE'}, $which);
  }
  return $val;
}# end of spanPurpose();


#pushSpanDatum($paraNum, $spanNum, "$attr:$val");
sub pushSpanDatum {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;	# 1 .. n
  my $spanNum = shift;	# 1 .. n
  my $val = shift;	# this is ALWAYS a SET which must be provided

  if ($val) {	#SET
    push(@{$self->{'PARA'}->{$serNum}->{$paraNum}->{'SPAN'}->{$spanNum}->{'DATA'}}, $val);
    push(@{$self->{'ALL_DATUM_ELEMENTS'}->{$serNum}}, $val);

  } else {	#GET
    die "$0 FATAL ERROR: INVALID CALL TO pushSpanDatum(); MUST SPECIFY AVPAIR AS VALUE IN $s\n";
  }
}# end of pushSpanDatum();


#@avPairs = spanData($paraNum, $spanNum");
sub spanData {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;	# 1 .. n
  my $spanNum = shift;	# 1 .. n

  return(@{$self->{'PARA'}->{$serNum}->{$paraNum}->{'SPAN'}->{$spanNum}->{'DATA'}});
  
}# end of spanData();

#SPAN LIST METHODS

sub spanNums {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;

  return (sort { $a <=> $b } keys %{$self->{'PARA'}->{$serNum}->{$paraNum}->{'SPAN'}});
}# end of paraNums();

sub spanPurposes {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;

  my @spanNums = $self->spanNums($serNum, $paraNum);
  my @purposes = ();

  foreach my $spanNum (@spanNums) {
    my $purpose = $self->spanPurpose($serNum, $paraNum, $spanNum);
    $purpose = "UNKN_" . $self->spanFont($serNum, $paraNum, $spanNum) unless $purpose;
    push (@purposes, $purpose);
  }

  return (@purposes);
}# end of spanPurposes()

sub spanTexts {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;

  my @spanNums = $self->spanNums($serNum, $paraNum);
  my @texts = ();

  foreach my $spanNum (@spanNums) {
    my $text = $self->spanText($serNum, $paraNum, $spanNum);
    push (@texts, $text);
  }

  return (@texts);
}# end of spanTexts()

sub spanFonts {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;

  my @spanNums = $self->spanNums($serNum, $paraNum);
  my @fonts = ();

  foreach my $spanNum (@spanNums) {
    my $font = $self->spanFont($serNum, $paraNum, $spanNum);
    push (@fonts, $font);
  }

  return (@fonts);
}# end of spanFonts()

####################### HEADNOTE METHODS ################################

#
# declare that this headnote has a type
# OPTIONAL -- currently only used by monoMap for the type Period Instruments
#
sub headnoteType {
  my $self = shift;
  my $serNum = shift;
  my $headnoteNum = shift;	# 1 .. n
  my $which = shift;	# ORIG, AUTO, MAPPED, or FINAL* if specified
  my $val = shift;	# if specified, this is a SET and which must be provided

  if ($val) {	#SET
    _checkSetWhich($which);
    $self->{'HEADNOTE'}->{$serNum}->{$headnoteNum}->{'TYPE'}->{$which} = $val;
    _updateFinal($self->{'HEADNOTE'}->{$serNum}->{$headnoteNum}->{'TYPE'});	# make best resultant final
  } else {	#GET
    $which = "FINAL" unless $which;
    _checkGetWhich($which);
    $val = _getVal($self->{'HEADNOTE'}->{$serNum}->{$headnoteNum}->{'TYPE'}, $which);
  }
  return $val;
}# end of headnoteType();


#
# declare that this paraNum is a constituent para of the current headnote
#
#&headnoteParas($headnoteNum[, $paraNum])
sub headnoteParas {
  my ($self, $serNum, $headnoteNum, $paraNum) = @_;
  if ($paraNum) {	# add para
    push (@{$self->{'PARAS_OF_HEADNOTE'}->{$serNum}->{$headnoteNum}}, $paraNum);
    $self->{'HEADNOTE_OF_PARA'}->{$serNum}->{$paraNum} = $headnoteNum;
  } else {		# return the list of paras constituting this headnote
    return (@{$self->{'PARAS_OF_HEADNOTE'}->{$serNum}->{$headnoteNum}});
  }
}# end of &headnoteParas();

#
# returns headnote of which this headnote is a constituent, if any
#
#my $headnoteNum = $document->headnoteOfPara($paraNum);
sub headnoteOfPara {
  my $self = shift;
  my $serNum = shift;
  my $paraNum = shift;

  return ($self->{'HEADNOTE_OF_PARA'}->{$serNum}->{$paraNum});

}# end of &headnoteOfPara();

#
# returns all headnote numbers declared in this article
#
#my @headnoteNums = $document->headnoteNums();
sub headnoteNums {
  my $self = shift;
  my $serNum = shift;

  return keys %{$self->{'PARAS_OF_HEADNOTE'}->{$serNum}};

}# end of &headnoteNums();


####################### END OF MODULE ###################################
1
