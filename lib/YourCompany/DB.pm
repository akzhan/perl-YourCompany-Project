package YourCompany::DB;

use YourCompany::Perl::UTF8;

use YourCompany::Config ();

use parent 'DBIx::Class::Schema';

__PACKAGE__->load_classes();

my $schema = undef;
my $work_pid = 0;

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

sub rs {
    my $self = shift;
    return instance()->resultset(@_);
}

sub txn_do {
    my ( $self, $block, @args ) = @_;
    return instance()->storage->txn_do($block, @args);
}

sub dbh_do {
    my ( $self, $block, @args ) = @_;
    return instance()->storage->dbh_do($block, @args);
}

sub last_insert_id {
    my $self = shift;
    return instance()->storage->last_insert_id;
}

1;
