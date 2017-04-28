package YourCompany::Model::Project;

=encoding utf-8

=head1 NAME

YourCompany::Model::Project

=cut

use YourCompany::Perl::UTF8;

use YourCompany::Plack::Error;

use parent qw( YourCompany::DBModel );

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
        $self->find_or_throw( $id );
    });
}

sub create( $self, $fields ) {
    delete $fields->{id}; # No id allowed on create
    return $self->txn_do(sub {
        my $project = $self->rs->create($fields);
        $project->refresh;

        return $project;
    });
}

sub update( $self, $id, $fields ) {
    return $self->txn_do(sub {
        if ( exists($fields->{id}) && ( $fields->{id} != $id ) ) {
            YourCompany::Plack::Error->bad_request( "Project cannot change id from ". $fields->{id}. " to  $id" );
        }

        my $project = $self->find_or_throw( $id );
        $project->update($fields);
        $project->refresh;

        return $project;
    });
}

sub delete( $self, $id ) { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    return $self->txn_do(sub {
        my $project = $self->find_or_throw( $id );

        $project->delete;

        1;
    });
}

1;
