package YourCompany::DBModel;

=encoding utf-8

=head1 NAME

YourCompany::DBModel

=head1 DESCRIPTION

Base L<YourCompany::DB> related L<YourCompany::Model> class.

=cut

use YourCompany::Perl::UTF8;

use parent 'YourCompany::Model';

use YourCompany::Plack::Error;
use YourCompany::DB;

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
        my $rs = $self->rs->search({
            'me.id' => $id,
        }, $attr);

        my $record = $attr->{prefetch} ? $rs->first : $rs->single;

        YourCompany::Plack::Error->not_found( $self->resultset_name. " not found: $id" )
            unless $record;

        return $record;
    });
}

1;
