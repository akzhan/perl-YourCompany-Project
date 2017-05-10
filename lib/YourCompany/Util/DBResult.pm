package YourCompany::Util::DBResult;

use YourCompany::Perl::UTF8;

use parent qw( DBIx::Class::Core );

__PACKAGE__->load_components( qw( +YourCompany::Util::JSONColumn +YourCompany::Util::BooleanColumn Core ) );

sub TO_JSON( $self ) {
    return +{
        $self->get_inflated_columns,
    };
}

sub refresh ( $self, $options = {} ) {
    $self->discard_changes;
}

1;
