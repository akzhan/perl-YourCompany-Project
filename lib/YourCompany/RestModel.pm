package YourCompany::RestModel;

=encoding utf-8

=head1 NAME

YourCompany::RestModel

=head1 DESCRIPTION

L<YourCompany::Model> that responds to REST methods.

=cut

use Mojo::Base 'YourCompany::Model';
use YourCompany::Perl::UTF8;

use YourCompany::Plack::Error;
use YourCompany::DB;

has row => undef;

=head1 METHODS

=cut

sub finder( $self, $id) {
    $self->row( $self->find_or_throw($id) );
    return $self;
}

sub list( $self ) {
    return $self->txn_do(sub {
        return [
            $self->rs->all,
        ];
    });
}

sub single( $self ) {
    return $self->row;
}

sub create( $self, $fields ) {
    delete $fields->{id}; # No id allowed on create
    return $self->txn_do(sub {
        my $row = $self->rs->create($fields);
        $row->refresh;

        return $row;
    });
}

sub update( $self, $fields ) {
    my $id = $self->row->id;

    return $self->txn_do(sub {
        if ( exists($fields->{id}) && ( $fields->{id} != $id ) ) {
            YourCompany::Plack::Error->bad_request( "Model cannot change id from ". $fields->{id}. " to  $id" );
        }

        $self->row->update($fields);
        $self->row->refresh;

        return $self->row;
    });
}

sub delete( $self ) { ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    return $self->txn_do(sub {
        $self->row->delete;

        1;
    });
}

1;
