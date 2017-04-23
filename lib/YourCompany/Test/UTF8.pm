package YourCompany::Test::UTF8;

use mro ();
use YourCompany::Perl::UTF8;

require Test::More;
require Test::Spec;
require Test::Exception;

my $builder = Test::More->builder;
binmode $builder->output,         ":encoding(UTF-8)";
binmode $builder->failure_output, ":encoding(UTF-8)";
binmode $builder->todo_output,    ":encoding(UTF-8)";

sub import( $class ) {
    my $callpkg = caller;

    YourCompany::Perl::UTF8->import;

    mro::set_mro( scalar caller(), 'c3' );

    ## no critic (BuiltinFunctions::ProhibitStringyEval)
    eval qq{
        package $callpkg;
        use parent 'Test::Spec';
        # allow Test::Spec usage errors to be reported via Carp
        our \@CARP_NOT = qw($callpkg);
    };
    ## use critic (BuiltinFunctions::ProhibitStringyEval)
    die $@ if $@; ## no critic (ErrorHandling::RequireCarping)
    Test::Spec::ExportProxy->export_to_level( 1, $callpkg );
    Test::Spec->export_to_level( 1, $callpkg );
    Test::Exception->export_to_level( 1, $callpkg );
}

1;
