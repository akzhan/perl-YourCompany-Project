package YourCompany::Model::Project;

use YourCompany::Perl::UTF8;

use YourCompany::DB;
use YourCompany::Plack::Error;

use parent qw( YourCompany::Model );

sub list {
    return YourCompany::DB->txn_do(sub {
        return [
            YourCompany::DB->rs('Project')->all,
        ];
    });
}

sub single {
    my ( $self, $id ) = @_;
    return YourCompany::DB->txn_do(sub {
        my $project = YourCompany::DB->rs('Project')->search({
            id => $id,
        })->single;

        YourCompany::Plack::Error->throw( HTTP_NOT_FOUND, "Project not found: $id" )
            unless $project;

        return $project;
    });
}

sub create {
    my ( $self, $fields ) = @_;
    delete $fields->{id}; # No id allowed on create
    return YourCompany::DB->txn_do(sub {
        my $project = YourCompany::DB->rs('Project')->create($fields);
        $project->discard_changes;

        return $project;
    });
}

sub update {
    my ( $self, $id, $fields ) = @_;
    return YourCompany::DB->txn_do(sub {
        my $project = YourCompany::DB->rs('Project')->search({
            id => $id,
        })->single;

        YourCompany::Plack::Error->throw( HTTP_NOT_FOUND, "Project not found: $id" )
            unless $project;

        if ( exists($fields->{id}) && ( $fields->{id} != $id ) ) {
            YourCompany::Plack::Error->throw( HTTP_BAD_REQUEST, "Project cannot change id from ". $fields->{id}. " to  $id" )
                unless $project;
        }

        $project->update($fields);
        $project->discard_changes;

        return $project;
    });
}

sub delete { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    my ( $self, $id ) = @_;
    return YourCompany::DB->txn_do(sub {
        my $project = YourCompany::DB->rs('Project')->search({
            id => $id,
        })->single;

        YourCompany::Plack::Error->throw( HTTP_NOT_FOUND, "Project not found: $id" )
            unless $project;

        $project->delete;

        1;
    });
}

1;
