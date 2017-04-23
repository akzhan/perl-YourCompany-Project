package YourCompany::Model::Project;

use YourCompany::Perl::UTF8;

use YourCompany::DB;
use YourCompany::Plack::Error;

use parent qw( YourCompany::Model );

sub list( $self ) {
    return YourCompany::DB->txn_do(sub {
        return [
            YourCompany::DB->rs('Project')->all,
        ];
    });
}

sub single( $self, $id ) {
    # explicit transaction is unnecessary here, but for solid expirience
    return YourCompany::DB->txn_do(sub {
        $self->find_or_throw( $id );
    });
}

sub create( $self, $fields ) {
    delete $fields->{id}; # No id allowed on create
    return YourCompany::DB->txn_do(sub {
        my $project = YourCompany::DB->rs('Project')->create($fields);
        $project->refresh;

        return $project;
    });
}

sub update( $self, $id, $fields ) {
    return YourCompany::DB->txn_do(sub {
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
    return YourCompany::DB->txn_do(sub {
        my $project = $self->find_or_throw( $id );

        $project->delete;

        1;
    });
}

1;
