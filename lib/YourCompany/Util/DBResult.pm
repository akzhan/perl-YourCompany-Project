package YourCompany::Util::DBResult;

use YourCompany::Perl::UTF8;

use parent qw( DBIx::Class::Core );

__PACKAGE__->load_components( qw( +YourCompany::Util::JSONColumn Core ) );

sub TO_JSON {
    my $self = shift;

    return +{
        $self->get_inflated_columns,
    };
}

1;
