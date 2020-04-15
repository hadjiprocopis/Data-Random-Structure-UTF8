package Data::Random::Structure::UTF8;

use 5.006;
use strict;
use warnings;

our $VERSION='0.01';

use parent 'Data::Random::Structure';

use List::Util   qw( max );
use Unicode::UCD qw( charscripts charinfo charprop );
use Carp qw(croak);

sub	new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);
	return $self
}
sub	_init {
	my $self = shift;
	$self->SUPER::_init(@_);
	push @{$self->{_scalar_types}}, 'string-UTF8'
}
sub	random_char_UTF8 {
	# the crucial part borrowed from The Effective Perler:
	# https://www.effectiveperlprogramming.com/2018/08/find-the-new-emojis-in-perls-unicode-support/
#	my $achar;
#	for(my $trials=100;$trials-->0;){
#		$achar = chr(int(rand(0x10FFF+1)));
#		return $achar if $achar =~ /\p{Present_In: 8.0}/;
#	}

	# just greek and coptic no holes
	return chr(0x03B0+int(rand(0x03F0-0x03B0)));

	my $arand = rand();
	if( $arand < 0.2 ){
		return chr(0x03B0+int(rand(0x03F0-0x03B0)))
	} elsif( $arand < 0.4 ){
		return chr(0x0400+int(rand(0x040F-0x0400)))
	} elsif( $arand < 0.6 ){
		return chr(0x13A0+int(rand(0x13EF-0x13A0)))
	} elsif( $arand < 0.8 ){
		return chr(0x1200+int(rand(0x137F-0x1200)))
	}
	return chr(0xA980+int(rand(0xA9DF-0xA980)))
}
sub	random_chars_UTF8 {
	my %options = @_;
	my $minl = defined($options{'min'}) ? $options{'min'} : 6;
	my $maxl = defined($options{'max'}) ? $options{'max'} : 32;
	my $ret = "";
	for(1..($minl+int(rand($maxl-$minl)))){
		$ret .= random_char_UTF8()
	}
	return $ret;
}		
# override's parent's.
# first call parent's namesake and if it fails because it
# is decided to generate UTF8 something, it will default to
# this method which must deal with all the extenstions we introduced
# in our own _init()
# CAVEAT: it relies on parent croaking the message
#   "I don't know how to generate $type\n"
# if that chanegs (in parent) then we will no longer be able to deduce
# $type and have to change this program.
# if that happens please file a bug.
# unfortunately our parent class does not allow for input params...
sub	generate_scalar {
	my $self = shift;
	my $rc = eval { $self->SUPER::generate_scalar(@_) };
	if( $@ || ! defined($rc) ){
		if( $@ !~ /how to generate (.+?)\R/ ){
			warn "something changed in parent class and can not parse this message any more, please file a bug: '$@'";
			return scalar(random_chars_UTF8(min=>2,max=>2));
		}
		my $type = $1;
		if( $type eq 'string-UTF8' ){
			return scalar(random_chars_UTF8(min=>2,max=>2));
		} else {
			warn "child: I don't know how to generate $type, this is a bug, please file a bug and mention this: $@\n";
			# but don't die
			return scalar(random_chars_UTF8(min=>2,max=>2));
		}
	}
	return $rc
}
1;

=pod

=encoding utf8

=head1 NAME

Data::Random::Structure::UTF8 - The great new Data::Random::Structure::UTF8!

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

This module extends L<Data::Random::Structure> to add functionality
for producing random unicode strings:

=over 4

=item unicode scalars: e.g. C<"αβγ">,

=item mixed arrays: e.g. C<["αβγ", "123", "xyz"]>

=item hashtables with some/all keys and/or values as unicode: e.g.
C<{"αβγ" => "123", "xyz" => "αβγ"}>

=back

This is accomplised by adding an extra
type C<string-UTF8> (invisible to the user) and the
respective generator method. All these are invisible to the user
which will get the old functionality plus some (or maybe none
because this is a random process which does not eliminate non-unicode
strings, at the moment) unicode strings.

    use Data::Random::Structure::UTF8;

    my $randomiser = Data::Random::Structure::UTF8->new(
        max_depth => 5,
        max_elements => 20,
    );
    my $perl_var = $randomiser->generate() or die;
    print pp($perl_var);

    # which prints the usual escape mess of Dump and Dumper
[
  "\x{7D5A}\x{4EC1}\x{6AE}\x{1F9A}\x{190}\x{72D9}\x{2EE2}\x{4C54}\x{ED71}\x{8161}\x{161E}",
  "\x{E6E2}\x{75A4}\x{194B}\x{678D}\x{B522}\x{B06F}\x{FFAA}\x{10733}\x{C35F}\x{8B77}\x{FF25}\x{14C8}\x{843A}\x{E2EE}\x{10360}\x{C108}\x{3E55}",
  329076,
  0.255759160148987,
  "RZY}A+3Q%`J/Oonu7xEHV)z-<",
  1,
  "\x{A847}\x{6E7E}\x{47A5}\x{7D6}\x{F6C1}\x{7315}\x{7B94}\x{AD5B}\x{F87C}\x{7FCB}\x{1FEB}\x{D1EA}\x{6B65}\x{10635}\x{1287}\x{5466}\x{F66E}\x{F501}\x{5D8B}\x{FA87}\x{3E03}\x{9279}",
  "\x{FBEE}\x{66C9}\x{5880}\x{F861}\x{B0FB}\x{18BF}\x{1B8}\x{EFD9}\x{3448}\x{F39C}9\x{85AF}\x{97D3}\x{A2D1}\x{61C}\x{BC54}\x{3012}\x{963F}\x{EA46}\x{B0C7}\x{CF89}\x{8C3F}\x{1062F}\x{50D7}\x{F6AB}\x{8261}",
  150763,
  0.995195566715751,
  540387,
  "n^h%KIOdtl?v8(bCXkPNjx74R",
  0.659785029547361,
  "\x{54AA}\x{F0DE}\x{35F7}\x{CEF3}\x{E3BE}\x{2AEE}",
  0.0238308786033095,
  59973,
  [
    "TEb97qJt",
    1,
    "_ow|J\@~=6%*N;52?W3Y\$S1",
    0.931256396568543,
    0.466393020781872,
    0.400670775469877,
    "\x{EABE}\x{22E8}\x{F8C7}\x{2E99}\x{3A55}\x{F3A2}\x{C5BA}",
    0.113700689106214,
    "1-M&B/",
    "\x{82D0}\x{7AB0}\x{9BDC}\x{3A08}\x{F236}\x{DBC2}\x{2093}\x{1608}\x{A16F}\x{A2D2}\x{4FE8}\x{2780}\x{8625}\x{11A1}\x{2F8}\x{92FA}\x{B10D}\x{EF1C}\x{1008C}\x{C5FE}\x{48D7}\x{A081}\x{B8B5}\x{5F88}\x{16F6}\x{F44E}\x{EB52}\x{3CE4}\x{3780}\x{6AB6}\x{59F5}",
    0.941029056924428,
    0.27890646290453,
    "\x{3EFA}\x{5C5A}\x{EF74}\x{FB2F}\x{A663}\x{9E55}\x{2AAA}\x{CC77}\x{5C41}",
    "\\Rz.U<\"yD,qMu~lN",
    305433,
    "A#W&V\"",
    1,
  ],

=head1 METHODS

This is an object oriented module which has exactly the same API as
L<Data::Random::Structure>.

=head2 C<new>

Constructor. See L<Data::Random::Structure::new> for the API. In short,
it takes 2 optional arguments, C<max_depth> and C<max_elements>.

=head1 AUTHOR

Andreas Hadjiprocopis, C<< <bliako ta cpan.org / andreashad2 ta gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-data-random-structure-utf8 at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Random-Structure-UTF8>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 CAVEATS

There are 3 issues.

The first issue is that the unicode produced can make
L<Data::Dump> to complain with

   Operation "lc" returns its argument for UTF-16 surrogate U+DA4B at /usr/local/share/perl5/Data/Dump.pm line 302.

This, I have found, can be fixed with the following workaround (from L<github user iafan|https://github.com/evernote/serge/commit/865402bbde42101345a5bee4cd0a855b9b76bdd7>, thank you):

    # Suppress `Operation "lc" returns its argument for UTF-16 surrogate 0xNNNN` warning
    # for the `lc()` call below; use 'utf8' instead of a more appropriate 'surrogate' pragma
    # since the latter is not available in until Perl 5.14
    no warnings 'utf8';

The second issue is that this class inherits from L<Data::Random::Structure>
and relies on it complaining about not being able to handle certain types
which are our own extensions (the C<string-UTF8> extension). We have
no way to know that except from catching its C<croak>'ing and parsing it
with the following regex

   $@ !~ /how to generate (.+?)\R/

in order to extract the C<type> which can not be handled
and handle it ourselves. So whenever the parent class (L<Data::Random::Structure>)
changes its C<croak> song, we will have to adopt this code
accordingly (in L<Data::Random::Structure::UTF8::generate_scalar>).
For the moment, I have placed a catch-all, fall-back condition
to handle this but it will be called for all kind of types
and not only the types we have added.

So, this issue is not going to make the module die but may make it
to skew the random results in favour of unicode strings (which
is the fallback, default action when can't parse the type).

The third issue escapes me right now.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Random::Structure::UTF8


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-Random-Structure-UTF8>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Data-Random-Structure-UTF8>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Data-Random-Structure-UTF8>

=item * Search CPAN

L<https://metacpan.org/release/Data-Random-Structure-UTF8>

=back

=head1 SEE ALSO

=over 4

=item L<Data::Random::Structure> 

=back

=head1 ACKNOWLEDGEMENTS

Mark Allen who created L<Data::Random::Structure> which is our parent class.

=head1 DEDICATIONS AND HUGS

!Almaz!

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2020 by Andreas Hadjiprocopis.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
