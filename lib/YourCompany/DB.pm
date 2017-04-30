package YourCompany::DB;

=encoding utf-8

=head1 NAME

YourCompany::DB

=head1 DESCRIPTION

Application database schema.

=cut

use YourCompany::Perl::UTF8;

use YourCompany::Config;

use parent 'DBIx::Class::Schema';

__PACKAGE__->load_classes();

my $schema = undef;
my $work_pid = 0;

=head1 METHODS

=head2 instance

    YourCompany::DB->instance

Gets C<YourCompany::DB> default singleton instance.

=cut

sub instance {
    my $pid = $$;
    if ( $work_pid != $pid ) {
        $schema = undef;
        $work_pid = $pid;
    }
    my $host = YourCompany::Config->database->{host} // 'localhost';
    return $schema //= __PACKAGE__->connect(
        "dbi:Pg:dbname=". YourCompany::Config->database->{name}. ";host=$host",
        YourCompany::Config->database->{user},
        YourCompany::Config->database->{password},
        { pg_enable_utf8 => 1},
    );
}

=head2 rs

    YourCompany::DB->rs('Project')

Gets L<DBIx::Class::ResultSet> by specified name.

=cut

sub rs( $, @args ) {
    return instance()->resultset(@args);
}

=head2 txn_do

    my $res = YourCompany::DB->txn_do(sub {
        # it is in transaction
        my @args = @_;

        return 1;
    }, @args);

Executes $coderef with (optional) arguments @coderef_args atomically, returning its result (if any).
Equivalent to calling L<DBIx::Class::Storage/txn_do>.

=cut

sub txn_do( $, $block, @args ) {
    return instance()->storage->txn_do($block, @args);
}

=head2 dbh_do

Execute the given $subref or $method_name using the new exception-based connection management.

The first two arguments will be the storage object that dbh_do was called on and a database handle to use. Any additional arguments will be passed verbatim to the called subref as arguments 2 and onwards.

Using this (instead of $self->_dbh or $self->dbh) ensures correct exception handling and reconnection (or failover in future subclasses).

Your subref should have no side-effects outside of the database, as there is the potential for your subref to be partially double-executed if the database connection was stale/dysfunctional.

See also L<DBIx::Class::Storage::DBI/dbh_do>.

=cut

sub dbh_do( $, $block, @args ) {
    return instance()->storage->dbh_do($block, @args);
}

=head2 last_insert_id

Return the row id of the last insert.

See also L<DBIx::Class::Storage::DBI/last_insert_id>.

=cut

sub last_insert_id( $self ) {
    return instance()->storage->last_insert_id;
}

1;
