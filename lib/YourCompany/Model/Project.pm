package YourCompany::Model::Project;

use YourCompany::Perl::UTF8;

use HTTP::Status qw( HTTP_NOT_FOUND );

use YourCompany::DB;
use YourCompany::Plack::Error;

use parent qw( YourCompany::Model );

sub list {
    return [
        YourCompany::DB->rs('Project')->all,
    ];
}

sub single {
    my ( $self, $id ) = @_;
    my $project = YourCompany::DB->rs('Project')->search({
        id => $id,
    })->single;

    YourCompany::Plack::Error->throw( HTTP_NOT_FOUND, "Project not found: $id" )
        unless $project;

    return $project;
}

1;
