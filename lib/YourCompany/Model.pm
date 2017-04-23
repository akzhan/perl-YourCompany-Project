package YourCompany::Model;

use Mojo::Base 'MojoX::Model';
use YourCompany::Perl::UTF8;

use YourCompany::Plack::Error;

sub find_or_throw( $self, $id ) {
    my $entity_name = ( ref($self) =~ s/^.+:://r );

    return YourCompany::DB->txn_do(sub {
        my $instance = YourCompany::DB->rs($entity_name)->search({
            id => $id,
        })->single;

        YourCompany::Plack::Error->not_found( "$entity_name not found: $id" )
            unless $instance;

        return $instance;
    });
}

1;
