package FFChunkyIssues;
#2010_03_27 -- new
#2010_06_12 -- allow for WORK validity code text
#2010_06_13 -- sub registerChunkyXIDs {
#2010_06_22 -- add ATTRIBUTE ACCESSOR Methods
#2010_06_22 -- add sub writeIssueMetadataFile
#2010_06_24 -- carry over ATLAS span classes for downstream mapping
#2010_07_01 -- remove writes to no-longer-needed CHUNKY files
#2010_07_04 -- correct logic to select AZ_Release title
#2010_07_04 -- compute and stash SORT_ORDER attribute
#2010_07_04 -- ditch chunk attrs and supply FOONUM attrs
#2010_09_03 -- guard against articleTitle over 255 chars long

use 5.008008;	# I'm using 5.8.8 to develop this
use strict;
no strict 'refs';
use utf8;
use charnames qw/:full/;

my $CHUNK_GENERATOR_VERSION = 336;	# passed in issue header

# MODULES
use FFConstants;
use FFUTF;

################ METHOD INDEX #######################
#peter@astrophe:~/factory/COLLIDER/perllib> grep "^sub " FFChunkyIssues.pm | sed -e " s/^/# /; s/ *[{}]*$//; "
# sub new
# sub _checkArgs
# sub stash_AV_PAIR
# sub fetch_AV_PAIR
# sub fetch_SCALAR_ATTRS
# sub stash_ORDERED_LIST
# sub initialize_ORDERED_LIST
# sub push_ORDERED_LIST
# sub fetch_ORDERED_LIST
# sub format_ATTR_VAL_CHUNK
# sub initialize_ISSUE_CHUNK
# sub initialize_DEPARTMENT_CHUNK
# sub initialize_ARTICLE
# sub genArticleTitleToken
# sub setFFReleaseTitles
# sub genHeadnoteTitleFromLXCAssertions
# sub genArticleTitleFromLXC_Headnotes
# sub initialize_LXC_HEADNOTE
# sub extend_LXC_HEADNOTE
# sub log_LXC_HEADNOTE_FLAW
# sub log_LXC_HEADNOTE_ERROR
# sub fetch_HNIDs_OF_ARTICLE
# sub fetch_ASSERTIONS_OF_HNID
# sub unMAC
# sub initialize_LXC_ARTICLE_BODY
# sub initialize_LXC_ARTICLE_PARA
# sub add_LXC_ARTICLE_SPAN
# sub format_LXC_HEADNOTE_SPAN
# sub format_LXC_BODY_SPAN
# sub finalize_LXC_ARTICLE_PARA
# sub finalize_LXC_ARTICLE_BODY
# sub write_LXC_ARTICLE_BODY
# sub delete_LXC_ARTICLE_BODY
# sub fetchIssueAttrValsHash
# sub fetchDeptAttrValsHash
# sub fetchDeptNumsList
# sub fetchSerNumsList
# sub fetchArticleAttrValsHash
# sub writeIssueMetadataFile
# sub encodeLXC_HNID
# sub decodeLXC_HNID
# sub encodeLXC_DOCID
# sub decodeLXC_DOCID
# sub encode_ASIN_PROPERTY_EXPR
# sub registerChunkyXIDs
# sub trims
# sub trimW
# sub detag
# sub murmurToJesus
# sub comeToJesus
# sub BONEPILE {};
# sub write_HEADNOTE_CHUNKS_OF_ARTICLE
# sub write_AV_CHUNK
# sub writeChunkyIssue
################ METHOD INDEX #######################

#####################################################################
#GLOBALS -- GENERAL
#####################################################################
my %funnyLetters = ();
my %funnyWords = ();

my %departmentCodeByText = &FFConstants::departmentCodeByText();
my %departmentTextByCode = &FFConstants::departmentTextByCode();

my %mapParaTypes = (
  'ARIAL_0 ARTICLE_HEADING' => 'FFS_ARTICLE_HEADING',
  'ARIAL_0 BOOK_HEADNOTE' => 'FFS_BOOK_HEADNOTE',
  'ARIAL_0 CLIST_HEADNOTE' => 'FFS_CLIST_HEADNOTE',
  'ARIAL_0 EXTRAS_HEADNOTE' => 'FFS_EXTRAS_HEADNOTE',
  'ARIAL_0 PROLOG' => '_SKIP_',
  'ARIAL_0 SELECTIONS_HEADNOTE' => 'FFS_SELECTIONS_HEADNOTE',
  'ARIAL_0 WLIST_HEADNOTE' => 'FFS_WLIST_HEADNOTE',
  'ARIAL_1 EXTRAS_HEADNOTE' => 'FFS_EXTRAS_HEADNOTE',
  'ARIAL_2 COL_HEADNOTE' => 'FFS_COL_HEADNOTE',
  'ARIAL_2 EXTRAS_HEADNOTE' => 'FFS_EXTRAS_HEADNOTE',
  'BLACK_0 COL2_HEADNOTE' => 'FFS_COL2_HEADNOTE',
  'BLACK_0 EXTRAS_HEADNOTE' => 'FFS_EXTRAS_HEADNOTE',
  'BLACK_1 BOLLY_HEADNOTE' => 'FFS_BOLLY_HEADNOTE',
  'BLACK_1 EXTRAS_HEADNOTE' => 'FFS_EXTRAS_HEADNOTE',
  'BLACK_1 UNKN' => 'UNKN',
  'BLACK_2 CPR_HEADNOTE' => 'FFS_CPR_HEADNOTE',
  'BLACK_2 EXTRAS_HEADNOTE' => 'FFS_EXTRAS_HEADNOTE',
  'BLANK_0 BLANK' => 'BLANK',
  'BLANK_0 EXTRAS_HEADNOTE' => 'FFS_EXTRAS_HEADNOTE',
  'BLANK_0 SKIP' => '_SKIP_',
  'COURIER_0 PROLOG' => '_SKIP_',
  'COURIER PROLOG' => '_SKIP_',
  'reviewersig_0 Bf' => 'FFS_BODY',
  'SKIP SKIP' => '_SKIP_',
  'TABLE_0 B' => 'FFS_TABLE',
  'TIMES_0 B' => 'FFS_BODY',
  'TIMES_0 Bf' => 'FFS_BODY',
  'TIMES_0 Br' => 'FFS_BODY',
  'TIMES_0 EXTRAS_HEADNOTE' => 'FFS_EXTRAS_HEADNOTE',
  'TIMES_1 B' => 'FFS_BODY',
  'TIMES_1 Bf' => 'FFS_BODY',
  'TIMES_1 Br' => 'FFS_BODY',
  'TIMES_2 B' => 'FFS_BODY',
  'TIMES_2 Br' => 'FFS_BODY',
  'TIMES_4 Br' => 'FFS_BODY',
  'TIMES_6 B' => 'FFS_BODY',
  'TIMES_6 Br' => 'FFS_BODY',
  'TIMES_7 Br' => 'FFS_BODY',
);# mapParaTypes

my %mapSpanTypes = (
  'ALBUM_TITLE ARIAL' => 'bar',
  'ALBUM_TITLE ARIALb' => 'bar',
  'ALBUM_TITLE ARIALbi' => 'bar',
  'ALBUM_TITLE ARIALi' => 'bar',
  'ARTICLE_HEADING ARIALi' => 'bar',
  'ARTICLE_TITLE ARIAL' => 'bar',
  'ARTICLE_TITLE ARIALb' => 'bar',
  'ARTICLE_TITLE ARIALbi' => 'bar',
  'ARTICLE_TITLE ARIALi' => 'bar',
  'B ARIAL' => 'bar',
  'B ARIALb' => 'bar',
  'B ARIALbi' => 'bar',
  'B ARIALi' => 'bar',
  'B BULLET' => 'bar',
  'BLANK BLANK' => 'bar',
  'BOOK_DATA ARIAL' => 'bar',
  'BOOK_TITLE ARIALb' => 'bar',
  'BOOK_TITLE ARIALbi' => 'bar',
  'Br TIMESb' => 'bar',
  'B SHARP' => 'bar',
  'B SKIP' => 'bar',
  'B SUPER' => 'bar',
  'B TABLE' => 'bar',
  'B TIMES' => 'bar',
  'B TIMESbi' => 'bar',
  'B TIMESi' => 'bar',
  'BULLET_1 BULLET' => 'bar',
  'BULLET_2 BULLET' => 'bar',
  'BYLINE ARIAL' => 'bar',
  'BYLINE ARIALb' => 'bar',
  'BYLINE ARIALbi' => 'bar',
  'BYLINE ARIALi' => 'bar',
  'CLIST_FILLER ARIAL' => 'bar',
  'CLIST_FILLER SUPER' => 'bar',
  'CLIST_TYPE ARIAL' => 'bar',
  'COMPOSER BLACKb' => 'bar',
  'COMPOSER BLACKbi' => 'bar',
  'COMPOSER_CONT ARIAL' => 'bar',
  'COMPOSER_SUPER SUPER' => 'bar',
  'EXTRAS_CONTENT ARIAL' => 'bar',
  'EXTRAS_CONTENT ARIALb' => 'bar',
  'EXTRAS_CONTENT ARIALbi' => 'bar',
  'EXTRAS_CONTENT ARIALi' => 'bar',
  'EXTRAS_CONTENT BLACKb' => 'bar',
  'EXTRAS_CONTENT BLANK' => 'bar',
  'EXTRAS_CONTENT BULLET' => 'bar',
  'EXTRAS_CONTENT EXTRAS' => 'bar',
  'EXTRAS_CONTENT SUPER' => 'bar',
  'EXTRAS_CONTENT TIMES' => 'bar',
  'EXTRAS_CONTENT TIMESb' => 'bar',
  'EXTRAS EXTRAS' => 'bar',
  'HEADNOTE_LABEL ARIAL' => 'bar',	# added in CHUNKY: derived span
  'PERFORMER ARIAL' => 'bar',
  'PERF_SUPER SUPER' => 'bar',
  'PROLOG ARIAL' => 'bar',
  'PROLOG ARIALb' => 'bar',
  'PROLOG ARIALbi' => 'bar',
  'PROLOG ARIALi' => 'bar',
  'PROLOG COURIER' => 'bar',
  'PROLOG SUPER' => 'bar',
  'RECORDING ARIAL' => 'bar',
  'REC_SUPER SUPER' => 'bar',
  'reviewersig reviewersig' => 'bar',
  'SELECTIONS_TYPE ARIAL' => 'bar',
  'SELECTIONS_TYPE ARIALb' => 'bar',
  'SELECTIONS_TYPE ARIALbi' => 'bar',
  'SELECTIONS_TYPE ARIALi' => 'bar',
  'SKIP SKIP' => 'bar',
  'SKIP SKIPPED' => 'bar',
  'UNKN ARIAL' => 'bar',
  'UNKN ARIALb' => 'bar',
  'UNKN ARIALbi' => 'bar',
  'UNKN ARIALi' => 'bar',
  'UNKN BLACKb' => 'bar',
  'UNKN SKIPPED' => 'bar',
  'UNKN SUPER' => 'bar',
  'VROLE ARIALi' => 'bar',
  'WORK ARIALb' => 'bar',
  'WORK ARIALbi' => 'bar',
  'WORK ARIALi' => 'bar',
  'WORK ARIALw' => 'bar',
  'WORK_CONT ARIAL' => 'bar',
  'WORK_CONT ARIALi' => 'bar',
  'WORK SHARP' => 'bar',
  'WORK_SUPER SUPER' => 'bar',
); # mapSpanTypes


#####################################################################
#CONSTRUCTOR
#####################################################################

#require FFChunkyIssues;	# object to read, update and write a CHUNKY ISSUE
#$chunkyIssuesObject = FFChunkyIssues->new('BUILD', \*CHUNKY_ISSUE, \*BODYTEXT);
#$chunkyIssuesObject = FFChunkyIssues->new('BUILD', \*BODYTEXT);
#

sub new {
  my $class = shift;
  my $OP = shift;
  my $BODYTEXT_ISSUE_FILE_FH = shift;

  my $self =  {
		#'SCALAR' => "",
		'OP' => $OP,
		'BODYTEXT_ISSUE_FILE_FH' => $BODYTEXT_ISSUE_FILE_FH,

		#'LIST' => (),

		#'HASH' => {},
	      };

  bless ($self, $class);
  $self->_checkArgs();

  return $self;
}# end of new();

#####################################################################

#####################################################################
#METHODS
#####################################################################

#
# CHECK ARGUMENTS
#

sub _checkArgs {
  my $self = shift;
  if ($self->{OP} eq 'BUILD' ) {		# build up from scratch 
  } else {
    die "FFChunkyIssues GOT ILLEGAL OP \[$self->{OP}\]. LEGAL ARE: \[BUILD\]\n";
  }

}# end of _checkArgs

#########################
# LXC SELF HASH ACCESSORS
#########################

#$self->stash_AV_PAIR('DEPARTMENT', $LXC_DEPTNUM, 'NAME', $LXC_DEPARTMENT_NAME);
sub stash_AV_PAIR {
  my ($self, $HASH_NAME, $HASH_KEY, $attr, $val) = @_;

  ${$self->{$HASH_NAME}->{$HASH_KEY}->{$attr}} = $val;
  ${$self->{$HASH_NAME}->{$HASH_KEY}->{'UNIQUE_ATTRS'}->{$attr}}++;

}# end of &stash_AV_PAIR();

#my $val = $self->fetch_AV_PAIR('DEPARTMENT', $LXC_DEPTNUM, 'DEPTCODE');
sub fetch_AV_PAIR {
  my ($self, $HASH_NAME, $HASH_KEY, $attr) = @_;

  #warn "\nFETCHING AVPAIR... \[$HASH_NAME\} \{$HASH_KEY\] \{$attr\]\n";

  my $val = ${$self->{$HASH_NAME}->{$HASH_KEY}->{$attr}};

  return $val;

}# end of &fetch_AV_PAIR();

#my @attrs = $self->fetch_SCALAR_ATTRS('DEPARTMENT', $LXC_DEPTNUM);
sub fetch_SCALAR_ATTRS {
  my ($self, $HASH_NAME, $HASH_KEY) = @_;

  my @SCALAR_ATTRS = ();
  foreach my $attr (sort keys %{$self->{$HASH_NAME}->{$HASH_KEY}} ) {
    unless ($attr eq 'SCALAR_ATTRS') {
      my $refType = ref($self->{$HASH_NAME}->{$HASH_KEY}->{$attr});
      if ($refType eq 'SCALAR') {
	push(@SCALAR_ATTRS, $attr);
	#warn "A DESIRED $refType ATTR of $HASH_NAME, $HASH_KEY is \[$attr\]\n";
      } else {
	#warn "A $refType ATTR of $HASH_NAME, $HASH_KEY is \[$attr\]\n";
      }
    }
  }

  return @SCALAR_ATTRS;

}# end of &fetch_SCALAR_ATTRS();

#$self->stash_ORDERED_LIST('DEPARTMENT', $LXC_DEPTNUM, 'ORDERED_SPAN_LIST', @orderedSpanList);
sub stash_ORDERED_LIST {
  my ($self, $HASH_NAME, $HASH_KEY, $orderedListName, @orderedList) = @_;

  @{$self->{$HASH_NAME}->{$HASH_KEY}->{$orderedListName}} = @orderedList;

  return undef;

}# end of &stash_ORDERED_LIST();

#$chunkyIssuesObject->initialize_ORDERED_LIST('ARTICLE_METADATA', $LXC_SERNUM, 'ORDERED_SPAN_ATTRS', '_UNDEF_');

#$self->initialize_ORDERED_LIST('DEPARTMENT', $LXC_DEPTNUM, 'ORDERED_SPAN_LIST', $initialValue);
sub initialize_ORDERED_LIST {
  my ($self, $HASH_NAME, $HASH_KEY, $orderedListName, $initialValue) = @_;

  foreach my $attr (@{$self->{$HASH_NAME}->{$HASH_KEY}->{$orderedListName}} ) {
    $self->stash_AV_PAIR($HASH_NAME, $HASH_KEY, $attr, $initialValue);
  }

  return undef;

}# end of &initialize_ORDERED_LIST();

#$self->push_ORDERED_LIST{'DEPARTMENT', $LXC_DEPTNUM, 'LXC_SERNUMS_OF_INVOCATION', $LXC_SERNUM);
sub push_ORDERED_LIST {
  my ($self, $HASH_NAME, $HASH_KEY, $orderedListName, $elt) = @_;

  push(@{$self->{$HASH_NAME}->{$HASH_KEY}->{$orderedListName}}, $elt);

  return undef;

}# end of &push_ORDERED_LIST();

#my @attrs = $self->fetch_ORDERED_LIST('DEPARTMENT', $LXC_DEPTNUM, 'ORDERED_LIST_NAME');
sub fetch_ORDERED_LIST {
  my ($self, $HASH_NAME, $HASH_KEY, $orderedListName) = @_;

  my @orderedList = @{$self->{$HASH_NAME}->{$HASH_KEY}->{$orderedListName}};

  return @orderedList;

}# end of &fetch_ORDERED_LIST();

#my $issueChunk = $self->format_ATTR_VAL_CHUNK('ISSUE', $LXC_VII);
sub format_ATTR_VAL_CHUNK {
  my ($self, $HASH_NAME, $HASH_KEY)= @_;

  #
  # map hashes to FFIS span prefixes
  my %hashToField = (
    'ISSUE' => 'ISSUE',
    'DEPARTMENT' => 'DEPARTMENT',
    'ARTICLE_METADATA' => 'ARTICLE',
    'HEADNOTE' => 'HEADNOTE',
  );
  my $FIELD_NAME = $hashToField{$HASH_NAME};

  my $chunkHead = $self->fetch_AV_PAIR($HASH_NAME, $HASH_KEY, 'CHUNK_HEAD');
  my $chunkTail = $self->fetch_AV_PAIR($HASH_NAME, $HASH_KEY, 'CHUNK_TAIL');
  my @orderedSpanAttrs = $self->fetch_ORDERED_LIST($HASH_NAME, $HASH_KEY, 'ORDERED_SPAN_ATTRS');

  #
  # extract and format the ISSUE_CHUNK attr-val pairs
  #
  my @chunkMiddleSpans = ();

  foreach my $attr ( @orderedSpanAttrs) {
    my $val = $self->fetch_AV_PAIR($HASH_NAME, $HASH_KEY, $attr);
    my $span = qq{  <attr class='$FIELD_NAME\_$attr'>$val</attr>};
    push(@chunkMiddleSpans, $span);
  }

#  my $chunkTail = <<EOCT;
#</chunk>
#EOCT

  my $chunkMiddle = join("\n", @chunkMiddleSpans);
  my $AVChunk = qq{$chunkHead$chunkMiddle\n$chunkTail};

  return $AVChunk;

}# end of &format_ATTR_VAL_CHUNK(}[
#####################

#$chunkyIssuesObject->initialize_ISSUE_CHUNK($VVI, $RESPAN_AGENT, $RESPAN_VERSION);
sub initialize_ISSUE_CHUNK {
  my ($self, $VVI, $RESPAN_AGENT, $RESPAN_VERSION) = @_;

  my @orderedSpanAttrs = (
    'RESPAN_AGENT',
    'RESPAN_VERSION',

    #
    # version of this CHUNK GENERATOR
    #
    'SYNTAX_LEVEL',

    #
    # issue data from FFConstants
    #

    'ISSUE_STRING',
    'MONTHS_STRING',
    'YEAR_STRING',
    'SORTABLE',

    #
    # document source attributes from FFConstants
    #
    'SOURCE_PROVIDER',
    'DOC_GENERATOR',
    'HEADNOTE_VERSION_MAJOR',
    'HEADNOTE_VERSION_MINOR',
    'FOOTER_VERSION',
    'SIG_VERSION',
  ); # end of orderedSpanAttrs
  
  #
  # stash the ordered span list
  #
  $self->stash_ORDERED_LIST('ISSUE', $VVI, 'ORDERED_SPAN_ATTRS', @orderedSpanAttrs);
  ##my @orderedSpanAttrs = $self->fetch_ORDERED_LIST('ISSUE', $VVI, 'ORDERED_SPAN_ATTRS');
  
  #
  # stash the chunk head string
  #

  my $chunkHead = <<EOCH;
<chunk chunktype='ISSUE' vvi='$VVI'>
EOCH
  $self->stash_AV_PAIR('ISSUE', $VVI, 'CHUNK_HEAD', $chunkHead);
  
  #
  # stash the chunk tail string
  #

  #my $chunkTail = <<EOCH;
#</chunk>
#EOCH
  #$self->stash_AV_PAIR('ISSUE', $VVI, 'CHUNK_TAIL', $chunkTail);

  #
  # set the ATTRs
  #

  #
  # issue info from calling respan agent
  #

  $self->stash_AV_PAIR('ISSUE', $VVI, 'VVI', $VVI);
  $self->stash_AV_PAIR('ISSUE', $VVI, 'RESPAN_AGENT', $RESPAN_AGENT);
  $self->stash_AV_PAIR('ISSUE', $VVI, 'RESPAN_VERSION', $RESPAN_VERSION);

  ##my $VVI = $self->fetch_AV_PAIR('ISSUE', $VVI, 'VVI');
  ##my $RESPAN_AGENT = $self->fetch_AV_PAIR('ISSUE', $VVI, 'RESPAN_AGENT');
  ##my $RESPAN_VERSION = $self->fetch_AV_PAIR('ISSUE', $VVI, 'RESPAN_VERSION');

  #
  # version of this CHUNK GENERATOR
  #
  $self->stash_AV_PAIR('ISSUE', $VVI, 'SYNTAX_LEVEL', $CHUNK_GENERATOR_VERSION);

  #
  # issue data from FFConstants
  #
  my ($issueString, $months, $year, $sortable ) = &FFConstants::issueData($VVI);

  $self->stash_AV_PAIR('ISSUE', $VVI, 'ISSUE_STRING', $issueString);
  $self->stash_AV_PAIR('ISSUE', $VVI, 'MONTHS_STRING', $months);
  $self->stash_AV_PAIR('ISSUE', $VVI, 'YEAR_STRING', $year);
  $self->stash_AV_PAIR('ISSUE', $VVI, 'SORTABLE', $sortable);

  #
  # document source attributes from FFConstants
  #
  my ($sourceProvider, $docGenerator, $headnoteVersionMajor, $headnoteVersionMinor, $footerVersion, $sigVersion) = &FFConstants::docSourceAttributes($VVI);
  $self->stash_AV_PAIR('ISSUE', $VVI, 'SOURCE_PROVIDER', $sourceProvider);
  $self->stash_AV_PAIR('ISSUE', $VVI, 'DOC_GENERATOR', $docGenerator);
  $self->stash_AV_PAIR('ISSUE', $VVI, 'HEADNOTE_VERSION_MAJOR', $headnoteVersionMajor);
  $self->stash_AV_PAIR('ISSUE', $VVI, 'HEADNOTE_VERSION_MINOR', $headnoteVersionMinor);
  $self->stash_AV_PAIR('ISSUE', $VVI, 'FOOTER_VERSION', $footerVersion);
  $self->stash_AV_PAIR('ISSUE', $VVI, 'SIG_VERSION', $sigVersion);

  ##my @uniqueAttrs = $self->fetch_UNIQUE_ATTRS('ISSUE', $VVI);

  return undef;

}# end of &initialize_ISSUE_CHUNK();

##########################
# MANAGE DEPARTMENT CHUNKS
##########################

#$chunkyIssuesObject->initialize_DEPARTMENT_CHUNK($VVI, $LXC_DEPTNUM, $LXC_DEPTCODE, $LXC_INVOCATION);
sub initialize_DEPARTMENT_CHUNK {
  my ($self, $VVI, $LXC_DEPTNUM, $LXC_DEPTCODE, $LXC_INVOCATION) = @_;

  #
  # store reference to this DEPTNUM as component of this VVI
  #
  $self->push_ORDERED_LIST('ISSUE', $VVI, 'LXC_DEPTNUMS', $LXC_DEPTNUM);

  my @orderedSpanAttrs = (
    'DEPTCODE',
    'NAME',
    'INVOCATION'
  );

  my $chunkHead = <<EOCH;
<chunk chunktype='DEPARTMENT' deptnum='$LXC_DEPTNUM'>
EOCH
  
  #
  # stash the ordered span list
  #
  $self->stash_ORDERED_LIST('DEPARTMENT', $LXC_DEPTNUM, 'ORDERED_SPAN_ATTRS', @orderedSpanAttrs);
  
#2010_07_04 -- ditch chunk attrs and supply FOONUM attrs
  #
  # stash the chunk head string
  #
  $self->stash_AV_PAIR('DEPARTMENT', $LXC_DEPTNUM, 'CHUNK_HEAD', $chunkHead);
  $self->stash_AV_PAIR('DEPARTMENT', $LXC_DEPTNUM, 'DEPTNUM', $LXC_DEPTNUM);
    
  #
  # stash the chunk tail string
  #

  #my $chunkTail = <<EOCH;
#</chunk>
#EOCH
  #$self->stash_AV_PAIR('DEPARTMENT', $LXC_DEPTNUM, 'CHUNK_TAIL', $chunkTail);

  #
  # get definitive department name
  #
  my $LXC_DEPARTMENT_NAME = $departmentTextByCode{$LXC_DEPTCODE};
  unless ($LXC_DEPARTMENT_NAME) {
    &comeToJesus( "CANNOT LOOK UP departmentTextByCode FOR LXC_DEPTCODE \[$LXC_DEPTCODE\]\n", @_ );
  }

  #
  # stash the proper department values
  #
  $self->stash_AV_PAIR('DEPARTMENT', $LXC_DEPTNUM, 'DEPTCODE', $LXC_DEPTCODE);
  $self->stash_AV_PAIR('DEPARTMENT', $LXC_DEPTNUM, 'NAME', $LXC_DEPARTMENT_NAME);
  $self->stash_AV_PAIR('DEPARTMENT', $LXC_DEPTNUM, 'INVOCATION', $LXC_INVOCATION);

}# end of &initialize_DEPARTMENT_CHUNK();

#######################
# MANAGE ARTICLE CHUNKS
#######################

#
# initialize ARTICLE_METADATA and ARTICLE_PARAS CHUNKS
#
#$chunkyIssuesObject->initialize_ARTICLE($VVI, $LXC_DEPTNUM, $LXC_SERNUM); 

sub initialize_ARTICLE {
  my ($self, $VVI, $LXC_DEPTNUM, $LXC_SERNUM) = @_;

  #
  # store reference to this DEPTNUM as component of this DEPTNUM
  #
  $self->push_ORDERED_LIST('DEPARTMENT', $LXC_DEPTNUM, 'LXC_SERNUMS', $LXC_SERNUM);

#2010_07_04 -- ditch chunk END attrs and supply FOONUM attrs
  #
  # stash the chunk head string
  #

  my $metadataChunkHead = <<EOMCH;
<chunk chunktype='ARTICLE_METADATA' sernum='$LXC_SERNUM'>
EOMCH
  $self->stash_AV_PAIR('ARTICLE_METADATA', $LXC_SERNUM, 'CHUNK_HEAD', $metadataChunkHead);
  
  #
  # ordered span list and attrs filled in from caller for now
  #

  #2010_07_04 -- compute and stash SORT_ORDER attribute
  if ($LXC_SERNUM =~ m/^(\d\d\d)(\d\d\d\d)$/ ) {
    my $vvi = $1;
    my $ascending = $2;
    my $invertedVVI = 1000 - $vvi;
    my $sortOrder = $invertedVVI . $ascending;
    $self->stash_AV_PAIR('ARTICLE_METADATA', $LXC_SERNUM, 'SORT_ORDER', $sortOrder);
  } else {
    &comeToJesus( "HOW COULD WE POSSIBLY FUCK UP THE SORT ORDER??? LXC_SERNUM \[$LXC_SERNUM\]", @_);
  }
    
  #
  # stash the chunk tail string
  #

  #my $chunkTail = <<EOCH;
#</chunk>
#EOCH
  #$self->stash_AV_PAIR('ARTICLE_METADATA', $LXC_SERNUM, 'CHUNK_TAIL', $chunkTail);

  return undef;

}# end of &initialize_ARTICLE();

##################### STATIC HELPERS (from prometheus respanAtlas.pl) #####

#my $articleTitleToken = &genArticleTitleToken($p);
sub genArticleTitleToken {
  my ($p) = @_;
  my $maxWords = 4;	# max words to return of para text
  my @wordList = ();

  my $selectionString = $p;
  $selectionString = &detag($selectionString);

  while (($#wordList+1) < $maxWords) {
    foreach my $spanText (split(/\s+/, $selectionString)) {
      $spanText =~ s/[^A-Za-z0-9_ ]//g;	# remove punctuation saving spaces
      next unless ($spanText =~ /\w/);
      $spanText = &FFUTF::toLatinSafe($spanText);
      my @words = split(/\s+/, $spanText);
      foreach my $word (@words) {
	if (($#wordList+1) < $maxWords) {
	  next if ($word =~ /^[a-z]/);	# skip lowercased words
	  next if ($word =~ /^(the|a|an|and)$/i);	# skip
	  next if ($word =~ /^(No|op|in)$/i);	# skip 
	  push(@wordList, $word);
	} else {
	  last;
	}
      }# each word in this span
    }# each span
    last;
  }# while we don't have max words yet

  my $titleToken = join(" ", @wordList);
  $titleToken =~ s/\s+/_/g;	# Words_will_be_underscore_joined
  $titleToken =~ s/_+/_/g;
  $titleToken =~ s/_+$//;
  $titleToken =~ s/^_+//;

  return $titleToken;
}# end of genArticleTitleToken();

#($DERIVED_ERRORS, $DERIVED_FLAWS) = $chunkyIssuesObject->setFFReleaseTitles($ATLAS_DOCID, $LXC_SERNUM, $LXC_DEPTCODE, $LXC_INVOCATION);
sub setFFReleaseTitles {
  my ($self, $ATLAS_DOCID, $LXC_SERNUM, $LXC_DEPTCODE, $LXC_INVOCATION) = @_;

  my $arFirstComposerLFName = "";
  my $arFirstPerformerLFName = "";
  my $arFirstLabel = "";

  my $DERIVED_ERRORS = 0;
  my $DERIVED_FLAWS = 0;

  #
  # first, iterate over the headnotes and discover/generate/set their titles
  #
  #@{$self->{'HEADNOTE_ASSERTIONS'}->{$LXC_SERNUM}->{$LXC_HNID}} = ();
  my @LXC_HNIDs = sort keys %{$self->{'HEADNOTE_ASSERTIONS'}->{$LXC_SERNUM}};
  my @hnReleaseTitles = ();
  foreach my $LXC_HNID (@LXC_HNIDs) {
    next if ($LXC_HNID =~ /_000$/ );	# skip HEADNOTE_0, unproductive for this
    my @hnAssertions = @{$self->{'HEADNOTE_ASSERTIONS'}->{$LXC_SERNUM}->{$LXC_HNID}};

    #
    # don't try to get headnote and article titles if 
    #   botched headnote syntax
    #   no assertions at all
    #
    next if (grep(/<attr class='HEADNOTE_ERROR'/, @hnAssertions) );

    #
    # discover/generate the headnote release title, and other goodies
    #
    my ($hnFirstComposerLFName, $hnFirstPerformerLFName, $hnReleaseTitle, $hnLabel) = $self->genHeadnoteTitleFromLXCAssertions($LXC_HNID, $LXC_SERNUM, $LXC_DEPTCODE, $LXC_INVOCATION, @hnAssertions);

    #warn "ChunkyIssues:VLOOB:910: $LXC_SERNUM \[$hnReleaseTitle\]\n";

    #
    # set the HEADNOTE RELEASE TITLE
    #
    
    my ($t) = (grep (/HEADNOTE_RELEASE_TITLE/, @hnAssertions) );
    unless ($t) {	# don't push it twice
      my $assertion = qq{<attr class='HEADNOTE_RELEASE_TITLE'>$hnReleaseTitle</attr>};
      push(@{$self->{'HEADNOTE_ASSERTIONS'}->{$LXC_SERNUM}->{$LXC_HNID}}, $assertion);
    }

    push (@hnReleaseTitles, $hnReleaseTitle);

    $arFirstComposerLFName = $hnFirstComposerLFName unless $arFirstComposerLFName;
    $arFirstPerformerLFName = $hnFirstPerformerLFName unless $arFirstPerformerLFName;
    $arFirstLabel = $hnLabel unless $arFirstLabel;
    
  }# each LXC_HNID

  #
  # discover/generate/set article title
  #
  my $articleTitle = $self->fetch_AV_PAIR('ARTICLE_METADATA', $LXC_SERNUM, 'TITLE');
  #2010_09_03 -- guard against articleTitle over 255 chars long
  my $articleTitleLength = length ($articleTitle);
  if ($articleTitleLength >= 255 ) {
    die "\nARTICLE_TITLE TOOO LONG_01 \[$articleTitleLength\] \[$articleTitle\]\n";
  }
  if (!$articleTitle || $articleTitle =~ /_UNDEF_/) {
    #warn "ChunkyIssues:VLOOB:01: $LXC_SERNUM\n";
    my $nicePerformerFL =  &FFATLASSyntax::niceNameFromLFName($arFirstPerformerLFName, 'FL');
    $articleTitle = $self->genArticleTitleFromLXC_Headnotes($LXC_SERNUM, $LXC_DEPTCODE, $LXC_INVOCATION, $nicePerformerFL, $arFirstLabel, @hnReleaseTitles);
    #2010_09_03 -- guard against articleTitle over 255 chars long
    my $articleTitleLength = length ($articleTitle);
    if ($articleTitleLength >= 255 ) {
      die "\nARTICLE_TITLE TOOO LONG_02 \[$articleTitleLength\] \[$articleTitle\]\n";
    }
    if ($articleTitle =~ /\d{7,}/ ) {
      #die "ChunkyIssues:VLOOB:02: $LXC_SERNUM \[$articleTitle\]\n";
    }


    #
    # set the ARTICLE TITLE
    #
    
    if ($articleTitle =~ /^:\s*on\s*$/ ) {
      my $last_LXC_HNID = $LXC_HNIDs[$#LXC_HNIDs]; 
      unless ($last_LXC_HNID) {
	my $LXC_PRIMARY_HEADNOTE_NUM = 0;
	$last_LXC_HNID = &FFChunkyIssues::encodeLXC_HNID($LXC_SERNUM, $LXC_PRIMARY_HEADNOTE_NUM);
      }
      #warn "\n\n\nFUCKING BASSOON! LAST_LXC_HNID: \[$last_LXC_HNID\]\n\n\n";

      #$chunkyIssuesObject->log_LXC_HEADNOTE_ERROR($LXC_HNID, $errorType, $errorText);
      $self->log_LXC_HEADNOTE_ERROR($last_LXC_HNID, "EMPTY_ARTICLE_TITLE", "NO firstPerformer and no LABEL returned" );
      $DERIVED_ERRORS++;
      return ($DERIVED_ERRORS, $DERIVED_FLAWS);
    } else {
      #2010_09_03 -- guard against articleTitle over 255 chars long
      my $articleTitleLength = length ($articleTitle);
      if ($articleTitleLength >= 255 ) {
	die "\nARTICLE_TITLE TOOO LONG_03 \[$articleTitleLength\] \[$articleTitle\]\n";
      }
      $self->stash_AV_PAIR('ARTICLE_METADATA', $LXC_SERNUM, 'TITLE', $articleTitle);
    }
  }# if article title wasn't stipulated in the map

  #
  # set the firsts
  #
  my $niceComposerLF = &FFATLASSyntax::niceNameFromLFName($arFirstComposerLFName, 'LF');
  my $nicePerformerLF = &FFATLASSyntax::niceNameFromLFName($arFirstPerformerLFName, 'LF');
  $self->stash_AV_PAIR('ARTICLE_METADATA', $LXC_SERNUM, 'FIRST_COMPOSER_ALPHA_FLATNAME', $niceComposerLF);
  $self->stash_AV_PAIR('ARTICLE_METADATA', $LXC_SERNUM, 'FIRST_PERFORMER_ALPHA_FLATNAME', $nicePerformerLF);

  return ($DERIVED_ERRORS, $DERIVED_FLAWS);

}# end of &setFFReleaseTitles();

#my ($hnFirstComposerLFName, $hnFirstPerformerLFName, $hnReleaseTitle, $hnLabel) = $self->genHeadnoteTitleFromLXCAssertions($LXC_HNID, $LXC_SERNUM, $LXC_DEPTCODE, $LXC_INVOCATION, @hnAssertions);
sub genHeadnoteTitleFromLXCAssertions {
  my ($self, $LXC_HNID, $LXC_SERNUM, $LXC_DEPTCODE, $LXC_INVOCATION, @hnAssertions) = @_;
  #
  # revised for fastATLAS data structures
  #

  my $DxIF = 0;
  #if ($LXC_HNID eq '2942980_001' ) {
  #  $DxIF = 1;
  #}
  my $currentHeadnoteID = "";
  my @composerList = ();
  my $firstComposerLFName = "";
  my @firstComposerWorks = ();
  my $firstPerformerLFName = "";

  my $label = "";
  my $releaseTitle = "";
  my $AZReleaseTitle = "";

  if ($LXC_DEPTCODE eq 'zz81' ) {	# BOLLY headnote
    $firstPerformerLFName = "SOUNDTRACK";
  }

  foreach my $assertion (@hnAssertions) {

    if ($assertion =~ m%<attr class='HEADNOTE_BOOK_TITLE'>(.*)\.*</attr>% ) {
      my $bookTitle = $1;
      return ("BOOK_REVIEW", $bookTitle, "");	# WE ARE DONE -- BOOK

    } elsif ($assertion =~ m%<attr class='HEADNOTE_CATALOG' .*lfname='(.*?)'% ) {
      next;	# DO NOT NEED
      
    } elsif ($assertion =~ m%<attr class='HEADNOTE_COMPOSER_CONT' .*lfname='(.*?)'% ) {
      next;	# DO NOT NEED

    } elsif ($assertion =~ m%<attr class='HEADNOTE_COMPOSER.*lfname='(.*?)'% ) {	#' # includes _NEW and _MAYBE
      my $LFName = $1;
      my $composer = &FFATLASSyntax::niceNameFromLFName($LFName, 'FL');
      push(@composerList, $composer);
      #warn "ChunkyIssues:VLOOB:710: $LXC_SERNUM COMPOSERLIST: \[@composerList\]\n";
      $firstComposerLFName = $LFName unless $firstComposerLFName;
      next;	# COMPOSER

    } elsif ($assertion =~ m%<attr class='HEADNOTE_ENSEMBLE.*lfname='(.*?)'% ) {
      my $LFName = $1;
      my $performer = &FFATLASSyntax::niceNameFromLFName($LFName, 'FL');
      $firstPerformerLFName = $LFName . " " unless ($firstPerformerLFName =~ /\w/);
      next;	# PERFORMER
      
    } elsif ($assertion =~ m%<attr class='HEADNOTE_INSTRUMENTALIST.*lfname='(.*?)'% ) {
      my $LFName = $1;
      my $performer = &FFATLASSyntax::niceNameFromLFName($LFName, 'FL');
      $firstPerformerLFName = $LFName . " " unless ($firstPerformerLFName =~ /\w/);
      next;	# PERFORMER

    } elsif ($assertion =~ m%<attr class='HEADNOTE_INSTRUMENT.*lfname='(.*?)'% ) {
      next;	# DO NOT NEED

    } elsif ($assertion =~ m%<attr class='HEADNOTE_LABEL.*lfname='(.*?)'% ) {
      my $LFName = $1;
      my $lab = &FFATLASSyntax::niceNameFromLFName($LFName, 'FL');
      $label = $lab unless $label;
      if ($DxIF) {
	warn "DxIF:label: $label $lab $LFName\n";
      }
      next;	# LABEL

    } elsif ($assertion =~ m%<attr class='HEADNOTE_LEADERMODE.*lfname='(.*?)'% ) {
      next;	# DO NOT NEED

    } elsif ($assertion =~ m%<attr class='HEADNOTE_LEADER.*lfname='(.*?)'% ) {
      my $LFName = $1;
      my $performer = &FFATLASSyntax::niceNameFromLFName($LFName, 'FL');
      $firstPerformerLFName = $LFName . " " unless ($firstPerformerLFName =~ /\w/);
      next;	# PERFORMER
      
    } elsif ($assertion =~ m%<attr class='HEADNOTE_PRPAIR'% ) {
      next;	# DO NOT NEED
      
    } elsif ($assertion =~ m%<attr class='HEADNOTE_RELEASE_TITLE'>(.*)</attr>% ) {
      my $rTitle = $1;
      $releaseTitle .= $rTitle . " ";
      next;	# FF RELEASE TITLE

    } elsif ($assertion =~ m%<attr class='HEADNOTE_SINGER.*lfname='(.*?)'% ) {	#'
      my $LFName = $1;
      my $performer = &FFATLASSyntax::niceNameFromLFName($LFName, 'FL');
      $firstPerformerLFName = $LFName . " " unless ($firstPerformerLFName =~ /\w/);
      next;	# PERFORMER

    } elsif ($assertion =~ m%<attr class='HEADNOTE_TYPE'% ) {
      next;	# DO NOT NEED

    } elsif ($assertion =~ m%<attr class='HEADNOTE_VROLE% ) {	#'
      next;	# DO NOT NEED

    } elsif ($assertion =~ m%<attr class='HEADNOTE_VOICE% ) {	#'
      next;	# DO NOT NEED
      
    } elsif ($assertion =~ m%<attr class='HEADNOTE_WLPERF.*lfname='(.*?)'% ) {	#'
      my $LFName = $1;
      my $performer = &FFATLASSyntax::niceNameFromLFName($LFName, 'FL');
      $firstPerformerLFName = $LFName . " " unless ($firstPerformerLFName =~ /\w/);
      next;	# PERFORMER

      #2010_06_12 -- allow for WORK validity code text
    } elsif ($assertion =~ m%<attr class='HEADNOTE_WORK[^\']*' .*lfname='(.*?)'% ) {
      my $LFName = $1;
      my $work = &FFATLASSyntax::niceNameFromWorkLFName($LFName, 'W');
      #warn "ChunkyIssues:VLOOB:720: $LXC_SERNUM COMPOSERLIST: \[@composerList\]\n";
      push (@firstComposerWorks, $work) if ($#composerList == 0);
      next;	# WORK

    } elsif ($assertion =~ m%<attr class='HEADNOTE_AZ_([^\']+)' .*>(.*)</attr>$% ) {
      my $azProp = $1;
      my $azVal = $2;	
      #2010_07_04 -- correct logic to select AZ_Release title
      if ($azProp eq 'TITLE') {

	#warn "ChunkyIssues:VLOOB:510: $LXC_SERNUM azProp: \[$azProp\] azVal: \[$azVal\]\n";
	
	#
	# try unMACing the title (unMACing everything will be hard);
	$azVal = $self->unMAC($azVal);
	$AZReleaseTitle = $azVal;
	#warn "ChunkyIssues:VLOOB:520: $LXC_SERNUM azProp: \[$azProp\] azVal: \[$azVal\]\n";
	
      }
    } else {
      &comeToJesus( "UNEXPECTED_ASSERTION FOUND SEEKING HEADNOTE TITLES \[$assertion\]\n", @_);
    }

  }# end loop over headnote assertions

  unless ($firstPerformerLFName =~ /\w/) {
    &comeToJesus( "HEADNOTE_TITLE_PROBLEM_PERFORMER: \[$LXC_SERNUM, $LXC_DEPTCODE, $LXC_INVOCATION\]\n", @_);
  }

  unless ($label =~ /\w/) {
    &comeToJesus( "HEADNOTE_TITLE_PROBLEM_LABEL: \[$LXC_SERNUM, $LXC_DEPTCODE, $LXC_INVOCATION\]\n", @_);
  }

  if ($releaseTitle =~ /\w/) {
    #warn "ChunkyIssues:VLOOB:610: $LXC_SERNUM releaseTitle: \[$releaseTitle\]\n";
    return ($firstComposerLFName, $firstPerformerLFName, $releaseTitle, $label);	# WE ARE DONE
  }

  if ($AZReleaseTitle =~ /\w/) {
    #warn "ChunkyIssues:VLOOB:620: $LXC_SERNUM AZReleaseTitle: \[$AZReleaseTitle\]\n";
    return ($firstComposerLFName, $firstPerformerLFName, $AZReleaseTitle, $label);	# WE ARE DONE
  }
      
  #
  # no explicit release title, so synthesize one 
  # according to number of composers present
  #

  #warn "ChunkyIssues:VLOOB:730: $LXC_SERNUM COMPOSERLIST: \[@composerList\]\n";
  #warn "ChunkyIssues:VLOOB:610: $LXC_SERNUM COMPOSERLIST: \[@composerList\]\n";
  if (@composerList) {	# if there were any composers at all

    my $numComposers = $#composerList + 1;
    if ($numComposers == 1) {	# if single composer
      my $soleComposer = $composerList[0];

      #truncate generic firstComposerWorks
      foreach my $work (@firstComposerWorks) {
	#$work =~ s/:.*//;	# lose everything from colon afterward
      }
      #make a worklist truncated on first space boundary after 40 char
      my $workText = join(" ", @firstComposerWorks);
      #warn "$currentHeadnoteID [$soleComposer] [$workText]\n";
      my $niceWorklist = $workText;
      #2008_06_11 -- fix bug in truncating release titles
      if ($niceWorklist =~ m/(.{30,}?[^ ]* )/) {	# restrict to 30 char
	$niceWorklist = $1;
	my $l = length($niceWorklist); 
	$niceWorklist .= "...";
	#warn "NICE WORK LIST \($l\): $niceWorklist\n";
      }
      $releaseTitle = "$soleComposer $niceWorklist";

    # more than 1 composer
    } else {

      #make a composer list truncated on first : boundary after 40 char
      my $compText = join(", ", @composerList);
      $compText =~ s/[:;]+//gs;
      my $niceComplist = $compText;
      #$niceComplist =~ s/^(.{40,40}.*?);/$1/;
      if ($niceComplist =~ m/(.{30,}?[^ ]* )/) {	# restrict to 30 char
	$niceComplist = $1;
	my $l = length($niceComplist); 
	$niceComplist .= "...";
	#warn "NICE COMP LIST \($l\): $niceComplist\n";
      }
      $releaseTitle = "$niceComplist";
    }
  } else {	# no composerworks hash
    &comeToJesus( "HEADNOTE_TITLE_PROBLEM_COMPOSER: \[$LXC_SERNUM, $LXC_DEPTCODE, $LXC_INVOCATION\]\n", @_);
  }# cases of numbers of composers and works


  return ($firstComposerLFName, $firstPerformerLFName, $releaseTitle, $label);	# WE ARE DONE

}# end of &genHeadnoteTitleFromLXCAssertions();

#my $articleTitle = $self->genArticleTitleFromLXC_Headnotes($LXC_SERNUM, $LXC_DEPTCODE, $LXC_INVOCATION, $arFirstPerformer, $arFirstLabel, @hnReleaseTitles);
sub genArticleTitleFromLXC_Headnotes {
  my ($self, $LXC_SERNUM, $LXC_DEPTCODE, $LXC_INVOCATION, $arFirstPerformer, $arFirstLabel, @hnReleaseTitles) = @_;

  my $firstReleaseTitle = $hnReleaseTitles[0];
  unless ($firstReleaseTitle =~ /\.\s*\.\s*\.\s*$/) {
    $firstReleaseTitle =&trimW($firstReleaseTitle);
    #2010_09_03 -- guard against articleTitle over 255 chars long
    my $interiorTitle = length ($firstReleaseTitle);
    if ($interiorTitle >= 100 ) {		# limit the title interior to 100 chars.
      my $firstReleaseTitleORIG = $firstReleaseTitle;
      $firstReleaseTitle = substr($firstReleaseTitle, 0, 100) . "...";
      print "\nCORRECTING FIRST_RELEASE_TITLE TOOO LONG_00 \[$interiorTitle\] \[$firstReleaseTitleORIG\] TO \[$firstReleaseTitle\]\n";
    }
  }

  #warn "ChunkyIssues:VLOOB:010: $LXC_SERNUM \[$firstReleaseTitle\]\n";

  if ($arFirstPerformer eq 'BOOK_REVIEW' ) {
    my $articleTitle = qq{BOOK REVIEW: $firstReleaseTitle on $arFirstLabel};
    return $articleTitle;
  }

  $arFirstPerformer = &trimW($arFirstPerformer);
  #warn "ChunkyIssues:VLOOB:011: $LXC_SERNUM \[$$arFirstPerformer\]\n";
  $arFirstLabel = &trimW($arFirstLabel);
  #warn "ChunkyIssues:VLOOB:012: $LXC_SERNUM \[$arFirstLabel\]\n";

  my $articleTitle = qq{$arFirstPerformer: $firstReleaseTitle on $arFirstLabel};
  return $articleTitle;

}# end of &genArticleTitleFromLXC_Headnotes();

#$chunkyIssuesObject->initialize_LXC_HEADNOTE($LXC_HNID, @assertions);
sub initialize_LXC_HEADNOTE {
  my ($self, $LXC_HNID, @assertions) = @_;

  my ($LXC_SERNUM, $phn) = &FFChunkyIssues::decodeLXC_HNID($LXC_HNID);

  #
  # store reference to this HEADNOTE as component of this ARTICLE
  #
  $self->push_ORDERED_LIST('ARTICLE_METADATA', $LXC_SERNUM, 'HNIDs', $LXC_HNID);

  #
  # initialize an ordered assertion queue
  #
  @{$self->{'HEADNOTE_ASSERTIONS'}->{$LXC_SERNUM}->{$LXC_HNID}} = ();

  #
  # Place any initial assertions in the assertion list for this hnid
  #
  foreach my $assertion (@assertions) {
    push(@{$self->{'HEADNOTE_ASSERTIONS'}->{$LXC_SERNUM}->{$LXC_HNID}}, $assertion);
  }

}# end of &initialize_LXC_HEADNOTE();

#$chunkyIssuesObject->extend_LXC_HEADNOTE($LXC_HNID, @assertions);
sub extend_LXC_HEADNOTE {
  my ($self, $LXC_HNID, @assertions) = @_;

  my ($LXC_SERNUM, $phn) = &FFChunkyIssues::decodeLXC_HNID($LXC_HNID);

  #
  # Place additional assertions in the assertion list for this hnid
  #
  foreach my $assertion (@assertions) {
    #
    # HACK!  retroactively frame attrs consistently
    # some day go fix Helper to do this in the first place
    #
    $assertion =~ s%<span%<attr%;
    $assertion =~ s%<expr%<attr%;
    $assertion =~ s%</span%</attr%;
    $assertion =~ s%</expr%</attr%;
    unless ($assertion =~ m%class='HEADNOTE_% ) {	#'
      $assertion =~ s%class='%class='HEADNOTE_%;
    }

    push(@{$self->{'HEADNOTE_ASSERTIONS'}->{$LXC_SERNUM}->{$LXC_HNID}}, $assertion);
  }

}# end of &extend_LXC_HEADNOTE();

#$chunkyIssuesObject->log_LXC_HEADNOTE_FLAW($LXC_HNID, $flawType, $flawText);
sub log_LXC_HEADNOTE_FLAW {
  my ($self, $LXC_HNID, $flawType, $flawText) = @_;
  my $errRec = qq{<attr class='HEADNOTE_FLAW' hnid='$LXC_HNID' type='$flawType'>$flawText</attr>};
  $self->extend_LXC_HEADNOTE($LXC_HNID, $errRec);

}# end of &log_LXC_HEADNOTE_FLAW();

#$chunkyIssuesObject->log_LXC_HEADNOTE_ERROR($LXC_HNID, $errorType, $errorText);
sub log_LXC_HEADNOTE_ERROR {
  my ($self, $LXC_HNID, $errorType, $errorText) = @_;
  my $errRec = qq{<attr class='HEADNOTE_ERROR' hnid='$LXC_HNID' type='$errorType'>$errorText</attr>};
  $self->extend_LXC_HEADNOTE($LXC_HNID, $errRec);

}# end of &log_LXC_HEADNOTE_ERROR();


#my @LXC_HNIDs = $chunkyIssuesObject->fetch_HNIDs_OF_ARTICLE($LXC_SERNUM);
sub fetch_HNIDs_OF_ARTICLE {
  my ($self, $LXC_SERNUM) = @_;

  return (sort keys %{$self->{'HEADNOTE_ASSERTIONS'}->{$LXC_SERNUM}});

}# end of &fetch_HNIDs_OF_ARTICLE();

#my @assertions = $chunkyIssuesObject->fetch_ASSERTIONS_OF_HNID($LXC_SERNUM, $LXC_HNID);
sub fetch_ASSERTIONS_OF_HNID {
  my ($self, $LXC_SERNUM, $LXC_HNID) = @_;

  return (@{$self->{'HEADNOTE_ASSERTIONS'}->{$LXC_SERNUM}->{$LXC_HNID}} );

}# end of &fetch_ASSERTIONS_OF_HNID();

#$AZReleaseTitle = $self->unMAC($azVal);
sub unMAC {
  my ($self, $azVal) = @_;

########################################################################
my $unMACDx = 0;	# analyze and warn if new AMAZON char errors
  			# small (<10s) performance penalty

			# sample dx output:
#CHUNKY_MACed: £¤¥¦ª«­¯°¶¸º¿ÕØãðôŽƒ…
#CHUNKY_MACed: AntoniÂ­n BÃ¶hnert; ChorusÃ¶ Delacôte EÃ¶tvÃ¶s GloriÃ¦ Guðmundsson GyÃ¶rgy HansjÃ¶rg I¿IV João Jérôme KÃ¶ln LlueÂ¯sa LluÃ¯sa Maria-João MatthÃ¤us-Passion MeÂºsica MÃ¶rbisch NaÃ¯ve Orchestra;YsaÃ¿e PÃªcheur RaÃºl RÃ¶schmann RÃ¸nning Saint-SaÃ«ns: Saint-SaÃƒÂ«ns: SchrÃ¶der SchÃ¤fer SchÃ¤fer; SchÃ¶ne SchÃ¸nwandt Sebastião StorgÃ¥rds SÃ£o São VerklÃ¤rte nÂ°5 Ãlvarez Ãlvarez;Albert Ãngel Ãdena; Ã…strand Õttl Õstrem Øystein Øyvind Žídek
########################################################################

  $azVal =~ s/\|/ /g;	# separate words delimited by ORbars
  ##############################################
  # MULTI-CHAR SUBSTITUTIONS
  ##############################################

  $azVal =~ s/Ã¹/ù/g;
  $azVal =~ s/Â±/ñ/g;
  $azVal =~ s/Ã±/ñ/g;
  $azVal =~ s/Ã©/é/g;
  $azVal =~ s/Ã¨/è/g;
  $azVal =~ s/Ã¼/ü/g;
  $azVal =~ s/Ã­/í/g;
  $azVal =~ s/Ã³/ó/g;
  $azVal =~ s/Ã¶/ö/g;
  $azVal =~ s/Ã¤/ä/g;
    $azVal =~ s/Ã/Á/g;
    $azVal =~ s/Ãª/ê/g;
    $azVal =~ s/Ã«/ë/g;
    $azVal =~ s/Ã¯/ï/g;
    $azVal =~ s/Â¯/ï/g;
    $azVal =~ s/Ãº/ú/g;
    $azVal =~ s/Âº/ú/g;	#??? Romainian, I think
    $azVal =~ s/Saint-SaÃƒÂ«ns/Saint-Saëns/g;
    $azVal =~ s/Ã/Ó/g;
    $azVal =~ s/AntoniÂ­n/Antonín/g;
    $azVal =~ s/Ã¦/æ/g;
    $azVal =~ s/Ã¥/å/g;
    $azVal =~ s/Ã…/Å/g;
    $azVal =~ s/Ã¸/ø/g;
    $azVal =~ s/Ã£/Ã/g;
    $azVal =~ s/nÂ°5/No. 5/g;	# 1-shot

    if ($azVal =~ m%^[ Óð¿ãØŽÕÕôÖÁÅ\%\=A-Za-z0-9\(\)\[\]\.,!:;·\/&'"#\$\*+?_\|~ ¡ÀÂÃÉÜßàáâäåæçèéêëìíîïñòóõöøùúûüýÿŒœ‘’-]*$%) { #'
      return $azVal;
    } else {
      if ( $unMACDx ) {
	my $residue = $azVal;
	$residue =~ s%[ Óð¿ãØŽÕÕôÖÁÅ\%\=A-Za-z0-9\(\)\[\]\.,!:\/&'";·#\$\*+?_\|~ ¡ÀÂÃÉÜßàáâäåæçèéêëìíîïñòóõöøùúûüýÿŒœ‘’-]%%g;	#'
	foreach my $letter (split(//, $residue) ) {
	  $funnyLetters{$letter}++;
	}

      my @words = split(/\s+/, $azVal);
      foreach my $word (@words) {
	unless ($word =~ m%^[ Óð¿ãØŽÕÕôÖÁÅ\%\=A-Za-z0-9\(\)\[\]\.,!:;·\/&'"#\$\*+?_\|~ ¡ÀÂÃÉÜßàáâäåæçèéêëìíîïñòóõöøùúûüýÿŒœ‘’-]*$%) { #'
	  $funnyWords{$word}++;
	}
      }
      my @oddLetters = (sort keys %funnyLetters );
      my $oddLetterString = join("", @oddLetters);
      warn "CHUNKY_MACed: $oddLetterString\n";
      print "CHUNKY_MACed: $oddLetterString\n";

      my @oddWords = (sort keys %funnyWords );
      my $oddWordString = join(" ", @oddWords);
      warn "CHUNKY_MACed: $oddWordString\n";
      print "CHUNKY_MACed: $oddWordString\n";

      die "HTTP\n" if ($oddWordString =~ /http/);
      my $unMACedVal = $azVal;

      return $unMACedVal;
    } else {
      return $azVal;
    }
  }# missed pattern
}# end of &unMAC();

#######################################################################
# BODYTEXT -- ARTICLE BODY ROUTINES
#######################################################################

  #BODYTEXT --  initialize_LXC_ARTICLE_BODY

#$chunkyIssuesObject->initialize_LXC_ARTICLE_BODY($LXC_SERNUM);
sub initialize_LXC_ARTICLE_BODY {
  my ($self, $LXC_SERNUM) = @_;
  %{$self->{'BODYTEXT'}->{$LXC_SERNUM}} = ();

  my $introHTML = qq{<!-- BEGIN_LXC_ARTICLE $LXC_SERNUM -->}; 
  ${$self->{'BODYTEXT'}->{$LXC_SERNUM}->{'INTRO_HTML'}} = "\n$introHTML\n";

  return undef;

}# end of &initialize_LXC_ARTICLE_BODY();

  #BODYTEXT --  initialize_LXC_ARTICLE_PARA

#$chunkyIssuesObject->initialize_LXC_ARTICLE_PARA($LXC_SERNUM, $LXC_PARA_NUM, $paraPurpose, $paraFont);
sub initialize_LXC_ARTICLE_PARA {
  my ($self, $LXC_SERNUM, $LXC_PARA_NUM, $paraPurpose, $paraFont) = @_;
  ${$self->{'BODYTEXT'}->{$LXC_SERNUM}->{'PARA_HTML'}->{$LXC_PARA_NUM}} = "";

  #warn "PARA: $LXC_SERNUM, $LXC_PARA_NUM, $paraPurpose, $paraFont\]\n";
  #my %mapParaTypes = (
  #  'ARIAL_0 ARTICLE_HEADING' => 'foo',

  my $paraType = qq{$paraFont $paraPurpose};
  my $paraClass = $mapParaTypes{$paraType};
  unless ($paraClass) {
    &comeToJesus( "CHUNKY SAYS A PARA MUST BE DEFINED FOR \[$paraFont\] \[$paraPurpose\]\n", @_ );
  }
  my $paraBeginTag = qq{<p class='$paraClass'>};
  ${$self->{'BODYTEXT'}->{$LXC_SERNUM}->{'PARA_HTML'}->{$LXC_PARA_NUM}} .= "$paraBeginTag";

  return undef;

}# end of &initialize_LXC_ARTICLE_PARA();

  #BODYTEXT --  add_LXC_ARTICLE_SPAN

#$chunkyIssuesObject->add_LXC_ARTICLE_SPAN($LXC_SERNUM, $LXC_PARA_NUM, $paraPurpose, $paraFont, $LXC_SPAN_NUM, $spanPurpose, $spanFont, $spanText);
sub add_LXC_ARTICLE_SPAN {
  my ($self, $LXC_SERNUM, $LXC_PARA_NUM, $paraPurpose, $paraFont, $LXC_SPAN_NUM, $spanPurpose, $spanFont, $spanText) = @_;

  #
  # make sure we have a span with content
  #
  return undef unless ($spanPurpose && $spanFont && $spanText);

  #warn "CHUNKY:ADDING_ARTICLE_SPAN: \[$LXC_SERNUM, $LXC_PARA_NUM, $paraPurpose, $paraFont, $LXC_SPAN_NUM, $spanPurpose, $spanFont, $spanText\]\n";

  #
  #  Consult available headnote attrs here if useful
  #

  #
  # Special for RECORDING -- split off specially classed LABEL span if poss.
  #
  if ($spanPurpose eq 'RECORDING' ) {
    my $LXC_HNID = &FFChunkyIssues::encodeLXC_HNID($LXC_SERNUM, $LXC_PARA_NUM);
    my @headnoteAssertions = $self->fetch_ASSERTIONS_OF_HNID($LXC_SERNUM, $LXC_HNID);
    foreach my $headnoteAssertion ( @headnoteAssertions ) {
      #warn "CHUNKY:AVAILABLE_HEADNOTE_ASSERTIONS: \[$headnoteAssertion\]\n";
      if ($headnoteAssertion =~ m%<attr class='HEADNOTE_LABEL' .*>(.*)</attr>%) {
	my $expectedLabelText = $1;
	if ($spanText =~ s/^(\s*$expectedLabelText)//) {
	  my $leadingLabelText = $1;
	  #warn "  CHUNKY:ADDING_LABEL_SPAN: \[$LXC_SERNUM, $LXC_PARA_NUM, $paraPurpose, $paraFont, $LXC_SPAN_NUM, $spanPurpose, $spanFont, $spanText, $leadingLabelText\]\n";
	  my $spanElement = $self->format_LXC_HEADNOTE_SPAN('HEADNOTE_LABEL','ARIAL', $leadingLabelText);

	  #
	  # add LABEL SPAN_ELEMENT TO BODYTEXT
	  #
	  ${$self->{'BODYTEXT'}->{$LXC_SERNUM}->{'PARA_HTML'}->{$LXC_PARA_NUM}} .= "$spanElement";
	  last;
	}# if LABEL text can be substituted
      }# if LABEL ASSERTION
    }# each ASSERTION for this headnote
  }# if adding RECORDING span

  #
  # choose a span formatting routine based on BODY or HEADNOTE
  #

  my $paraType = qq{$paraFont $paraPurpose};
  my $paraClass = $mapParaTypes{$paraType};
  unless ($paraClass) {
    &comeToJesus( "CHUNKY SAYS A PARA MUST BE DEFINED FOR \[$paraFont\] \[$paraPurpose\]\n", @_ );
  }
  #warn "CHUNKY:PARACLASS FOR SPAN FORMATTING IS \[$paraClass\]\n";

  my $spanElement = "";
  if ($paraClass =~ /BODY/i) {
    #warn "  CHUNKY:ADDING_BODY_SPAN: \[$LXC_SERNUM, $LXC_PARA_NUM, $paraPurpose, $LXC_SPAN_NUM, $spanPurpose, $spanFont, $spanText\]\n";
    $spanElement = $self->format_LXC_BODY_SPAN($spanPurpose, $spanFont, $spanText);
  } else {
    #warn "  CHUNKY:ADDING_HEADNOTE_SPAN: \[$LXC_SERNUM, $LXC_PARA_NUM, $paraPurpose, $paraFont, $LXC_SPAN_NUM, $spanPurpose, $spanFont, $spanText\]\n";
    $spanElement = $self->format_LXC_HEADNOTE_SPAN($spanPurpose, $spanFont, $spanText);
  }

  #
  # add SPAN_ELEMENT TO BODYTEXT
  #
  ${$self->{'BODYTEXT'}->{$LXC_SERNUM}->{'PARA_HTML'}->{$LXC_PARA_NUM}} .= "$spanElement";

  return undef;

}# end of &add_LXC_ARTICLE_SPAN();

#my $spanElement = $self->format_LXC_HEADNOTE_SPAN('HEADNOTE_LABEL', $text);
sub format_LXC_HEADNOTE_SPAN {
  my ($self, $spanPurpose, $spanFont, $text) = @_;

  #2010_06_24 -- carry over ATLAS span classes for downstream mapping
  my $spanType = qq{$spanPurpose $spanFont};
  #my $spanClass = $mapSpanTypes{$spanType};
  my $spanClass = "ffs_" . $spanType;
  $spanClass =~ s/ /_/g;
  $spanClass =~ tr/a-z /A-Z/;
  unless ($spanClass) {
    &comeToJesus( "CHUNKY SAYS A HEADNOTE SPAN MUST BE DEFINED FOR \[$spanFont\] \[$spanPurpose\]\n", @_ );
  }

  my $spanElement = qq{  <span class='$spanClass'>$text</span>\n};

  return $spanElement;

}# end of &format_LXC_HEADNOTE_SPAN();

#$spanElement = $self->format_LXC_BODY_SPAN($spanPurpose, $spanFont, $spanText);
sub format_LXC_BODY_SPAN {
  my ($self, $spanPurpose, $spanFont, $text) = @_;

  #2010_06_24 -- carry over ATLAS span classes for downstream mapping
  my $spanType = qq{$spanPurpose $spanFont};
  #my $spanClass = $mapSpanTypes{$spanType};
  #my $spanClass = $spanType;
  my $spanClass = "ffs_" . $spanType;
  $spanClass =~ s/ /_/g;
  $spanClass =~ tr/a-z /A-Z/;
  unless ($spanClass) {
    &comeToJesus( "CHUNKY SAYS A BODY SPAN MUST BE DEFINED FOR \[$spanFont\] \[$spanPurpose\]\n", @_ );
  }

  my $spanElement = qq{<span class='$spanClass'>$text</span>};

  return $spanElement;

}# end of &format_LXC_BODY_SPAN();

  #BODYTEXT --  finalize_LXC_ARTICLE_PARA

#$chunkyIssuesObject->finalize_LXC_ARTICLE_PARA($LXC_SERNUM, $LXC_PARA_NUM);
sub finalize_LXC_ARTICLE_PARA {
  my ($self, $LXC_SERNUM, $LXC_PARA_NUM) = @_;

  my $paraEndTag = qq{</p>};
  ${$self->{'BODYTEXT'}->{$LXC_SERNUM}->{'PARA_HTML'}->{$LXC_PARA_NUM}} .= "$paraEndTag\n";

  return undef;

}# end of &finalize_LXC_ARTICLE_PARA();

  #BODYTEXT --  finalize_LXC_ARTICLE_BODY

#$chunkyIssuesObject->finalize_LXC_ARTICLE_BODY($LXC_SERNUM);
sub finalize_LXC_ARTICLE_BODY {
  my ($self, $LXC_SERNUM) = @_;

  my $exitHTML = qq{<!-- END_LXC_ARTICLE $LXC_SERNUM -->}; 
  ${$self->{'BODYTEXT'}->{$LXC_SERNUM}->{'EXIT_HTML'}} .= "$exitHTML\n";

  return undef;

}# end of &finalize_LXC_ARTICLE_BODY();

  #BODYTEXT --  write_LXC_ARTICLE_BODY

#$chunkyIssuesObject->write_LXC_ARTICLE_BODY($LXC_SERNUM);
sub write_LXC_ARTICLE_BODY {
  my ($self, $LXC_SERNUM) = @_;
  
  my $FH = $self->{'BODYTEXT_ISSUE_FILE_FH'};

  #
  # write ARTICLE_INTRO 
  #
  my $introHTML = ${$self->{'BODYTEXT'}->{$LXC_SERNUM}->{'INTRO_HTML'}};
  print $FH "$introHTML\n";

  #
  # traverse the PARAS
  #
  foreach my $LXC_PARA_NUM (sort {$a <=> $b} keys %{$self->{'BODYTEXT'}->{$LXC_SERNUM}->{'PARA_HTML'}} ) {
    my $paraText = ${$self->{'BODYTEXT'}->{$LXC_SERNUM}->{'PARA_HTML'}->{$LXC_PARA_NUM}};
    print $FH "$paraText\n";

  }# each LXC_PARANUM

  #
  # write ARTICLE_EXIT 
  #
  my $exitHTML = ${$self->{'BODYTEXT'}->{$LXC_SERNUM}->{'EXIT_HTML'}};
  print $FH "$exitHTML\n";

  return undef;


}# end of &write_LXC_ARTICLE_BODY();

  #BODYTEXT --  delete_LXC_ARTICLE_BODY

#$chunkyIssuesObject->delete_LXC_ARTICLE_BODY($LXC_SERNUM);
sub delete_LXC_ARTICLE_BODY {
  my ($self, $LXC_SERNUM) = @_;
  %{$self->{'BODYTEXT'}->{$LXC_SERNUM}} = ();

  return undef;

}# end of &delete_LXC_ARTICLE_BODY();

#2010_06_22 -- add ATTRIBUTE ACCESSOR Methods

################## ATTRIBUTE ACCESSORS ###################

#my %issueAttrValsHash = $self->fetchIssueAttrValsHash($VVI);
sub fetchIssueAttrValsHash {
  my ($self, $VVI) = @_;

  my %returnHash = ();
  my @issueAttributes = $self->fetch_SCALAR_ATTRS('ISSUE', $VVI);
  foreach my $issueAttribute (@issueAttributes) {
    my $val = $self->fetch_AV_PAIR('ISSUE', $VVI, $issueAttribute);
    $returnHash{$issueAttribute} = $val;
  }# each ISSUE attribute

  return %returnHash;

}# end of &fetchIssueAttrValsHash();

#my %deptAttrValsHash = $self->fetchDeptAttrValsHash($VVI, $deptNum);
sub fetchDeptAttrValsHash {
  my ($self, $VVI, $deptNum) = @_;

  my %returnHash = ();
  my @deptAttributes = $self->fetch_SCALAR_ATTRS('DEPARTMENT', $deptNum);
  foreach my $deptAttribute (@deptAttributes) {
    my $val = $self->fetch_AV_PAIR('DEPARTMENT', $deptNum, $deptAttribute);
    $returnHash{$deptAttribute} = $val;
  }# each DEPARTMENT attribute

  return %returnHash;

}# end of &fetchDeptAttrValsHash();

#my @deptNumsList = $self->fetchDeptNumsList($VVI);
sub fetchDeptNumsList {
  my ($self, $VVI) = @_;

  my @deptNumsList = @{$self->{'ISSUE'}->{$VVI}->{'LXC_DEPTNUMS'}};
  #warn "ISSUE_DEPTNUMS_LIST IS \[@deptNumsList\]\n";

  return @deptNumsList;

}# end of &fetchDeptNumsList();

#my @serNumsList = $self->fetchSerNumsList($deptNum);
sub fetchSerNumsList {
  my ($self, $LXC_DEPTNUM) = @_;

  my @serNumsList = @{$self->{'DEPARTMENT'}->{$LXC_DEPTNUM}->{'LXC_SERNUMS'}};
  #warn "DEPTNUM_SERNUMS_LIST FOR DEPTNUM \[$LXC_DEPTNUM\] IS \[@serNumsList\]\n";

  return @serNumsList;

}# end of &fetchSerNumsList();

#my %articleAttrValsHash = $self->fetchArticleAttrValsHash($VVI, $deptNum, $serNum);
sub fetchArticleAttrValsHash {
  my ($self, $VVI, $deptNum, $serNum) = @_;

  my %returnHash = ();
  my @serAttributes = $self->fetch_SCALAR_ATTRS('ARTICLE_METADATA', $serNum);
  foreach my $serAttribute (@serAttributes) {
    my $val = $self->fetch_AV_PAIR('ARTICLE_METADATA', $serNum, $serAttribute);
    $returnHash{$serAttribute} = $val;
  }# each DEPARTMENT attribute

  return %returnHash;

}# end of &fetchArticleAttrValsHash();

#2010_06_22 -- add sub writeIssueMetadataFile
#$chunkyIssuesObject->writeIssueMetadataFile($VVI, \*ISSUE_ARTICLE_DATA);
sub writeIssueMetadataFile {
  my ($self, $VVI, $fh) = @_;

  #
  # COLLECT THE ISSUE SCALAR ATTRIBUTES 
  #

  #warn "\nISSUE ATTRIBUTES FOR ISSUE \[$VVI\] ARE:\n";
  my %issueAttrValsHash = $self->fetchIssueAttrValsHash($VVI);
  foreach my $issueAttr (sort keys %issueAttrValsHash ) {
    my $val = &trims($issueAttrValsHash{$issueAttr});
    print $fh "$VVI _ISSUE_ $issueAttr: $val\n";
  } # each ISSUE attr

  #
  # traverse the DEPARTMENTS of this ISSUE
  #

  my @deptNumsList = $self->fetchDeptNumsList($VVI);
  #warn "ISSUE_DEPTNUMS_LIST_2 IS \[@deptNumsList\]\n";
  foreach my $deptNum (@deptNumsList) {
    my %deptAttrValsHash = $self->fetchDeptAttrValsHash($VVI, $deptNum);
    foreach my $deptAttr (sort keys %deptAttrValsHash ) {
      my $val = &trims($deptAttrValsHash{$deptAttr});
      print $fh "$VVI $deptNum _DEPARTMENT_ $deptAttr: $val\n";
    } # each DEPT_attr

    #
    # traverse the ARTICLES of this DEPARTMENT
    #
    my @serNumsList = $self->fetchSerNumsList($deptNum);
    #warn "  DEPARTMENT \[$deptNum\] SERNUMS LIST IS \[@serNumsList\]\n";
    foreach my $serNum (@serNumsList) {
      my %articleAttrValsHash = $self->fetchArticleAttrValsHash($VVI, $deptNum, $serNum);
      foreach my $articleAttr (sort keys %articleAttrValsHash ) {
	my $val = &trims($articleAttrValsHash{$articleAttr});
	print $fh "$VVI $deptNum $serNum _ARTICLE_ $articleAttr: $val\n";
      } # each ARTICLE_attr

      #
      # traverse the HEADNOTES of this ARTICLE
      #
      my @HNIDsList = $self->fetch_HNIDs_OF_ARTICLE($serNum);
      #warn "  ARTICLE \[$serNum\] HEADNOTES LIST IS \[@HNIDsList\]\n";
      foreach my $HNID (@HNIDsList) {
	my @hnAssertionsList = $self->fetch_ASSERTIONS_OF_HNID($serNum, $HNID);
	foreach my $assertion (@hnAssertionsList ) {
	  my $val = &trims($assertion);
	  print $fh "$VVI $deptNum $serNum $HNID _HEADNOTE_ $val\n";
	} # each HEADNOTE_attr
	print $fh "$VVI $deptNum $serNum $HNID _HEADNOTE_ _END_\n";
      }# each HEADNOTE in this ARTICLE
      
      print $fh "$VVI $deptNum $serNum _ARTICLE_ _END_: _END_\n";

    } # each ARTICLE SERNUM in this DEPTNUM

    print $fh "$VVI $deptNum _DEPARTMENT_ _END_: _END_\n";

  }# each department invocation in VVI
  print $fh "$VVI _ISSUE_ _END_: _END_\n";

}# end of writeIssueMetadataFile();
##################### THE HOLY LAND ################
#
# UTILITY ROUTINES
#

#my $LXC_HNID = &FFChunkyIssues::encodeLXC_HNID($LXC_SERNUM, $LXC_PRIMARY_HEADNOTE_NUM);
sub encodeLXC_HNID {
  shift(@_) if (ref($_[0]) eq 'FFChunkyIssues' );       # STATIC even if called on instance
  my ($LXC_SERNUM, $LXC_PRIMARY_HEADNOTE_NUM) = @_;
  my $LXC_HNID = sprintf("%07i_%03i", $LXC_SERNUM, $LXC_PRIMARY_HEADNOTE_NUM);

  return $LXC_HNID;
  
}# end of &FFChunkyIssues::encodeLXC_HNID();

#my ($sn, $phn) = &FFChunkyIssues::decodeLXC_HNID($LXC_HNID);
sub decodeLXC_HNID {
  shift(@_) if (ref($_[0]) eq 'FFChunkyIssues' );       # STATIC even if called on instance
  my ($LXC_HNID) = @_;

  my ($sn, $phn) = split(/_0*/, $LXC_HNID);
  return ($sn, $phn);
  
}# end of &FFChunkyIssues::decodeLXC_HNID();


#my $LXC_DOCID = &FFChunkyIssues::encodeLXC_DOCID($LXC_SERNUM, $LXC_DEPTCODE, $LXC_TITLE_TOKEN);
sub encodeLXC_DOCID {
  shift(@_) if (ref($_[0]) eq 'FFChunkyIssues' );       # STATIC even if called on instance
  my ($LXC_SERNUM, $LXC_DEPTCODE, $LXC_TITLE_TOKEN) = @_;

  my $LXC_DOCID = qq{$LXC_SERNUM\.$LXC_DEPTCODE\_$LXC_TITLE_TOKEN};
  #warn "      LXC_SERNUM: \[$LXC_SERNUM\] LXC_DOCID: \[$LXC_DOCID\]\n";

  return ($LXC_DOCID);

}# end of encodeLXC_DOCID();

#my ($LXC_SERNUM, $LXC_DEPTCODE, $LXC_TITLE_TOKEN) = &FFChunkyIssues::decodeLXC_DOCID($LXC_DOCID);
sub decodeLXC_DOCID {
  shift(@_) if (ref($_[0]) eq 'FFChunkyIssues' );       # STATIC even if called on instance
  my ($LXC_DOCID) = @_;

  my ($LXC_SERNUM, $LXC_DEPTCODE, $LXC_TITLE_TOKEN) = ();
  if ($LXC_DOCID =~ /^(\d{7,7})\.([^_]+)_(.*)/ ) {
    $LXC_SERNUM = $1;
    $LXC_DEPTCODE = $2;
    $LXC_TITLE_TOKEN = $3;
  } else {
    die "FFChunkyIssues TRIED TO DECODE MALFORMED LXC_DOCID \[$LXC_DOCID\]\n";
  }
  
  return ($LXC_SERNUM, $LXC_DEPTCODE, $LXC_TITLE_TOKEN);

}# end of decodeLXC_DOCID();

#my $ASIN_PROPERTY_EXPR = $chunkyIssuesObject->encode_ASIN_PROPERTY_EXPR($bound_ASIN, $prop, $val);
sub encode_ASIN_PROPERTY_EXPR {
  my ($self, $bound_ASIN, $prop, $val) = @_;

  my $ASIN_PROPERTY_EXPR = qq{<attr class='HEADNOTE_AZ_$prop' asin='$bound_ASIN'>$val</attr>};

  return $ASIN_PROPERTY_EXPR;
  
}# end of &encode_ASIN_PROPERTY_EXPR();

#2010_06_13 -- sub registerChunkyXIDs {
#$chunkyIssuesObject->registerChunkyXIDs($helper);

sub registerChunkyXIDs {
  my ($self, $helper) = @_;
  
  #push(@{$self->{'HEADNOTE_ASSERTIONS'}->{$LXC_SERNUM}->{$LXC_HNID}}, $assertion);
  foreach my $LXC_SERNUM (sort keys %{$self->{'HEADNOTE_ASSERTIONS'}} ) {
    foreach my $LXC_HNID (sort keys %{$self->{'HEADNOTE_ASSERTIONS'}->{$LXC_SERNUM}} ) {
      my @assertions = @{$self->{'HEADNOTE_ASSERTIONS'}->{$LXC_SERNUM}->{$LXC_HNID}};
      foreach my $assertion (@assertions) {
	$helper->registerXIDReference($LXC_SERNUM, $LXC_HNID, $assertion);
      }# each assertion in headnote

    }# each headnote

  }#each ARTICLE

}# end of registerChunkyXIDs();

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

#t = detag($t);
sub detag {
  my ($t) = @_;
  $t =~ s%<.*?>%%gs;
  #$t =~ s%[:,]% %gs;	# ignore commas etc. which have space inserted
  $t =~ s%'%%gs;	# remove ' 
  $t =~ s%\s+% %gs;
  $t =~ s%^\s+%%gs;
  $t =~ s%\s+$%%gs;

  return $t;

}# end of &detag()

#murmurToJesus( $msg, @_ );
sub murmurToJesus {
  my ( $msg, @callingArgs ) = @_;

  my $maxLevel = 50;
  warn "\n\n";

  for (my $i = 1; $i <= $maxLevel; $i++) {
    my ($package, $filename, $line, $subroutine, $hasargs, $wantarray, $evaltext, $is_require, $hints, $bitmask) = caller($i);
 
    last unless $package ;
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
  $briefMsg =~ s/dx=.*?\]//s;

   warn "\nFFChunkyIssue murmured to Jesus. \[$briefMsg\]. Sorry.\n";
}

#comeToJesus( $msg, @_ );
sub comeToJesus {
  my ( $msg, @callingArgs ) = @_;

  my $maxLevel = 50;
  warn "\n\n";

  for (my $i = 1; $i <= $maxLevel; $i++) {
    my ($package, $filename, $line, $subroutine, $hasargs, $wantarray, $evaltext, $is_require, $hints, $bitmask) = caller($i);
 
    last unless $package ;
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
  $briefMsg =~ s/dx=.*?\]//s;

   die "\nFFChunkyIssue was called to Jesus. \[$briefMsg\]. Sorry.\n";
}

#####################################################################
#END OF MODULE
#####################################################################
1
__END__
sub BONEPILE {};

#$chunkyIssuesObject->write_HEADNOTE_CHUNKS_OF_ARTICLE($LXC_SERNUM);
sub write_HEADNOTE_CHUNKS_OF_ARTICLE {
  my ($self, $LXC_SERNUM) = @_;

  my $FH = $self->{'CHUNKY_ISSUE_FILE_FH'};
  #push(@{$self->{'HEADNOTE_ASSERTIONS'}->{$LXC_SERNUM}->{$LXC_HNID}}, $beginAssertion);
  
  foreach my $LXC_HNID ($self->fetch_HNIDs_OF_ARTICLE($LXC_SERNUM) ) {
    my $chunkHead = qq{<chunk chunktype='HEADNOTE' hnid='$LXC_HNID'>};
    my $chunkTail = qq{</chunk>};

    print $FH "$chunkHead\n";

    foreach my $assertion ($self->fetch_ASSERTIONS_OF_HNID($LXC_SERNUM, $LXC_HNID) ) {
      #warn "CHUNKY_ISSUES_OBJECT:WRITING RETRIEVED ASSERTION \[$assertion\]\n";
      print $FH "  $assertion\n";
    }
    print $FH "$chunkTail\n\n";
  }# each headnote
}# end of write_HEADNOTE_CHUNKS_OF_ARTICLE();
      
#$chunkyIssuesObject->write_AV_CHUNK('DEPARTMENT', $LXC_DEPTNUM); 
sub write_AV_CHUNK {
  my ($self, $CHUNK_NAME, $CHUNK_KEY) = @_; 

  my $avChunk = $self->format_ATTR_VAL_CHUNK($CHUNK_NAME, $CHUNK_KEY);

  #
  # write the av chunk
  #
  my $FH = $self->{'CHUNKY_ISSUE_FILE_FH'};
  print $FH "$avChunk\n";
}# end of &write_AV_CHUNK(); 

#####################
# MANAGE ISSUE CHUNKS

#
# write a chunky issue
#
#$chunkyIssuesObject->writeChunkyIssue($issue, $chunkyPath); 

sub writeChunkyIssue {
  my $self = shift;
  my $issue = shift;
  my $chunkyPath = shift;
  #open (CHUNKY_ISSUE, ">:utf8", $chunkyPath) or die "CANNOT WRITE chunkyPath \[$chunkyPath\]:$!\n";
  #warn "Writing CHUNKY ISSUE \[$issue\] IN \[$chunkyPath\] \n";

  #
  # write the issue chunk
  #
  my $issueChunk = ${$self->{'ISSUE_CHUNK_OF_ISSUE'}->{$issue}};
  print CHUNKY_ISSUE "$issueChunk\n";

  #
  # write each department chunk
  #

  #${$self->{'DEPARTMENT_INVOCATION_CHUNK'}->{$issue}->{$LXC_DEPTCODE}->{$invocation}} = $departmentChunk;
  foreach my $LXC_DEPTCODE (sort keys %{$self->{'DEPARTMENT_INVOCATION_CHUNK'}->{$issue}} ) {
    foreach my $invocation (sort keys %{$self->{'DEPARTMENT_INVOCATION_CHUNK'}->{$issue}->{$LXC_DEPTCODE}} ) {
      my $departmentChunk = ${$self->{'DEPARTMENT_INVOCATION_CHUNK'}->{$issue}->{$LXC_DEPTCODE}->{$invocation}};
      print CHUNKY_ISSUE "$departmentChunk\n";
    }# each invocation
  }# each department

  #close (CHUNKY_ISSUE);

}# end of writeChunkyIssue()
