package YourCompany::Model;

=encoding utf-8

=head1 NAME

YourCompany::Model

=head1 DESCRIPTION

Base L<MojoX::Model> class.

=cut

use YourCompany::Perl::UTF8;

use parent 'MojoX::Model';

use YourCompany::Plack::Error;
use YourCompany::DB;

has row => undef;

=head1 METHODS

=head2 resultset_name

    $model->resultset_name;

Returns associated resultset name.

Its last part of model class name by default.

=cut

sub resultset_name( $self ) {
    return ( ref($self) =~ s/^.+:://r );
}

=head2 txn_do

    $model->txn_do(sub {
        # do it in transaction block
    });

Shortcut for L<DBIx::Class::Schema/txn_do>.

=cut

sub txn_do( $, $block, @args ) {
    return YourCompany::DB->txn_do($block, @args);
}

=head2 rs

    $model->rs;

    $model->rs('ResultSet');

Gets corresponding or default L<DBIx::Class::Schema/resultset>.

See also L</resultset_name>.

=cut

sub rs ( $self, $resultset_name = undef ) {
    return YourCompany::DB->rs( $resultset_name // $self->resultset_name );
}

=head2 find_or_throw

    $model->find_or_throw( $id )

    $model->find_or_throw( $id, { prefetch => 'dependent' } )

Gets record by $id or throw L<YourCompany::Plack::Error> C<not_found> error.

See also: L</rs>.

=cut

sub find_or_throw( $self, $id, $attr = {} ) {
    return $self->txn_do(sub {
        my $record = $self->rs->search({
            'me.id' => $id,
        }, $attr)->single;

        YourCompany::Plack::Error->not_found( $self->resultset_name. " not found: $id" )
            unless $record;

        return $record;
    });
}

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
