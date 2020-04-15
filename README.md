# NAME

Data::Random::Structure::UTF8 - The great new Data::Random::Structure::UTF8!

# VERSION

Version 0.01

# SYNOPSIS

This module extends [Data::Random::Structure](https://metacpan.org/pod/Data%3A%3ARandom%3A%3AStructure) to add functionality
for producing random unicode strings:

- unicode scalars: e.g. `"αβγ"`,
- mixed arrays: e.g. `["αβγ", "123", "xyz"]`
- hashtables with some/all keys and/or values as unicode: e.g.
`{"αβγ" =` "123", "xyz" => "αβγ"}>

This is accomplised by adding an extra
type `string-UTF8` (invisible to the user) and the
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

# METHODS

This is an object oriented module which has exactly the same API as
[Data::Random::Structure](https://metacpan.org/pod/Data%3A%3ARandom%3A%3AStructure).

## `new`

Constructor. See [Data::Random::Structure::new](https://metacpan.org/pod/Data%3A%3ARandom%3A%3AStructure%3A%3Anew) for the API. In short,
it takes 2 optional arguments, `max_depth` and `max_elements`.

# AUTHOR

Andreas Hadjiprocopis, `<bliako ta cpan.org / andreashad2 ta gmail.com>`

# BUGS

Please report any bugs or feature requests to `bug-data-random-structure-utf8 at rt.cpan.org`, or through
the web interface at [https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Random-Structure-UTF8](https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Random-Structure-UTF8).  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

# CAVEATS

There are 3 issues.

The first issue is that the unicode produced can make
[Data::Dump](https://metacpan.org/pod/Data%3A%3ADump) to complain with

    Operation "lc" returns its argument for UTF-16 surrogate U+DA4B at /usr/local/share/perl5/Data/Dump.pm line 302.

This, I have found, can be fixed with the following workaround (from [github user iafan](https://github.com/evernote/serge/commit/865402bbde42101345a5bee4cd0a855b9b76bdd7), thank you):

    # Suppress `Operation "lc" returns its argument for UTF-16 surrogate 0xNNNN` warning
    # for the `lc()` call below; use 'utf8' instead of a more appropriate 'surrogate' pragma
    # since the latter is not available in until Perl 5.14
    no warnings 'utf8';

The second issue is that this class inherits from [Data::Random::Structure](https://metacpan.org/pod/Data%3A%3ARandom%3A%3AStructure)
and relies on it complaining about not being able to handle certain types
which are our own extensions (the `string-UTF8` extension). We have
no way to know that except from catching its `croak`'ing and parsing it
with the following regex

    $@ !~ /how to generate (.+?)\R/

in order to extract the `type` which can not be handled
and handle it ourselves. So whenever the parent class ([Data::Random::Structure](https://metacpan.org/pod/Data%3A%3ARandom%3A%3AStructure))
changes its `croak` song, we will have to adopt this code
accordingly (in [Data::Random::Structure::UTF8::generate\_scalar](https://metacpan.org/pod/Data%3A%3ARandom%3A%3AStructure%3A%3AUTF8%3A%3Agenerate_scalar)).
For the moment, I have placed a catch-all, fall-back condition
to handle this but it will be called for all kind of types
and not only the types we have added.

So, this issue is not going to make the module die but may make it
to skew the random results in favour of unicode strings (which
is the fallback, default action when can't parse the type).

The third issue escapes me right now.

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Random::Structure::UTF8

You can also look for information at:

- RT: CPAN's request tracker (report bugs here)

    [https://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-Random-Structure-UTF8](https://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-Random-Structure-UTF8)

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/Data-Random-Structure-UTF8](http://annocpan.org/dist/Data-Random-Structure-UTF8)

- CPAN Ratings

    [https://cpanratings.perl.org/d/Data-Random-Structure-UTF8](https://cpanratings.perl.org/d/Data-Random-Structure-UTF8)

- Search CPAN

    [https://metacpan.org/release/Data-Random-Structure-UTF8](https://metacpan.org/release/Data-Random-Structure-UTF8)

# SEE ALSO

- [Data::Random::Structure](https://metacpan.org/pod/Data%3A%3ARandom%3A%3AStructure) 

# ACKNOWLEDGEMENTS

Mark Allen who created [Data::Random::Structure](https://metacpan.org/pod/Data%3A%3ARandom%3A%3AStructure) which is our parent class.

# DEDICATIONS AND HUGS

!Almaz!

# LICENSE AND COPYRIGHT

This software is Copyright (c) 2020 by Andreas Hadjiprocopis.

This is free software, licensed under:

    The Artistic License 2.0 (GPL Compatible)