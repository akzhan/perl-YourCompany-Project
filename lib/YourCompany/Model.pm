package YourCompany::Model;

=encoding utf-8

=head1 NAME

YourCompany::Model

=head1 DESCRIPTION

Base L<MojoX::Model> class.

=cut

use Mojo::Base 'MojoX::Model';
use YourCompany::Perl::UTF8;

use YourCompany::Plack::Error;
use YourCompany::DB;

=head1 METHODS

=head2 txn_do

    $model->txn_do(sub {
        # do in transaction block
    });

Shortcut for L<DBIx::Class::Schema/txn_do>.

=cut

sub txn_do( $, $block, @args ) {
    return YourCompany::DB->txn_do($block, @args);
}

=head2 rs

    $model->rs

Gets corresponding L<DBIx::Class::Schema/resultset>.

=cut

sub rs ( $self ) {
    my $entity_name = ( ref($self) =~ s/^.+:://r );

    return YourCompany::DB->rs($entity_name);
}

=head2 find_or_throw

    $model->find_or_throw( $id )

Gets record by $id or throw L<YourCompany::Plack::Error> C<not_found> error.

See also: L</rs>.

=cut

sub find_or_throw( $self, $id ) {
    my $entity_name = ( ref($self) =~ s/^.+:://r );

    return $self->txn_do(sub {
        my $record = $self->rs->search({
            'me.id' => $id,
        })->single;

        YourCompany::Plack::Error->not_found( "$entity_name not found: $id" )
            unless $record;

        return $record;
    });
}

1;
