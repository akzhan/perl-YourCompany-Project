=encoding utf-8

=head1 NAME

YourCompany::Perl::UTF8

=head1 DESCRIPTION

Common project rules.

Inspired by L<Modern::Perl> but should be extended our own way.

=head1 FEATURES

Features enabled by module usage: say, state, switch, unicode_strings, array_base.

=head1 POLICY

Sets 'c3' method resolution order.

Includes strict, warnings and utf8 pragmata.

=cut

package YourCompany::Perl::UTF8;

use 5.020_003;

use strict;
use warnings;

use mro     ();
use feature ();
use utf8    ();

# enable methods on filehandles; unnecessary when 5.14 autoloads them
use IO::File   ();
use IO::Handle ();

sub import {
    strict->import;
    warnings->import( FATAL => 'all' );
    feature->import(':5.20');
    feature->import('signatures');
    warnings->unimport('experimental::signatures');
    utf8->import;

    mro::set_mro( scalar caller(), 'c3' );
}

## no critic (Subroutines::ProhibitBuiltinHomonyms)
sub unimport {
    utf8->unimport;
    warnings->import('experimental::signatures');
    feature->unimport;
    warnings->unimport;
    strict->unimport;
}
## use critic

1;
