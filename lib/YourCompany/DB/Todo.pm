package YourCompany::DB::Todo;

use YourCompany::Perl::UTF8;

=encoding utf8

=head1 NAME

YourCompany::DB::Todo

=head1 DESCRIPTION

Represents C<todos> table.

=cut

use parent qw( YourCompany::Util::DBResult );

__PACKAGE__->table("todos");

=head1 COLUMNS

=head2 id

Identifier

=head2 title

Title

=head2 completed

Is completed

=head2 order

Optional order.

=cut

__PACKAGE__->add_columns(
    "id",
    {
        data_type         => "integer",
        is_auto_increment => 1,
        is_nullable       => 0,
        sequence          => "todos_sequence",
    },
    "title",
    { data_type => "text", is_nullable => 0 },
    "completed",
    { data_type => "bool", is_nullable => 0, default => 0, bool => 1 },
    "order",
    { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

1;
