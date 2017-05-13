package YourCompany::App::Model::Todo;

=encoding utf-8

=head1 NAME

YourCompany::App::Model::Todo

=cut

use YourCompany::Perl::UTF8;

use YourCompany::Plack::Error;

use parent qw( YourCompany::App::DBModel );

sub list( $self ) {
    return $self->txn_do(sub {
        return [
            $self->rs->all,
        ];
    });
}

sub single( $self, $id ) {
    # explicit transaction is unnecessary here, but for solid expirience
    return $self->txn_do(sub {
        my $todo = $self->find_or_throw( $id );
        $todo;
    });
}

sub create( $self, $fields ) {
    delete $fields->{id}; # No id allowed on create
    return $self->txn_do(sub {
        my $todo = $self->rs->create($fields);
        $todo->refresh;

        $todo;
    });
}

sub update( $self, $id, $fields ) {
    return $self->txn_do(sub {
        if ( exists($fields->{id}) && ( $fields->{id} != $id ) ) {
            YourCompany::Plack::Error->bad_request( "Project cannot change id from ". $fields->{id}. " to  $id" );
        }

        my $todo = $self->find_or_throw( $id );
        $todo->update($fields);
        $todo->refresh;

        $todo;
    });
}

sub delete( $self, $id ) { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    return $self->txn_do(sub {
        my $todo = $self->find_or_throw( $id );

        $todo->delete;

        1;
    });
}

sub delete_all( $self ) {
    return $self->txn_do(sub {
        $self->rs->delete;

        1;
    });
}

1;
