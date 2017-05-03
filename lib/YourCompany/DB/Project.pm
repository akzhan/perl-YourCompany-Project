package YourCompany::DB::Project;

use YourCompany::Perl::UTF8;

=encoding utf8

=head1 NAME

YourCompany::DB::Project

=head1 DESCRIPTION

Represents C<projects> table.

=cut

use parent qw( YourCompany::Util::DBResult );

__PACKAGE__->table("projects");

=head1 COLUMNS

=head2 id

Identifier

=head2 title

Title

=cut

__PACKAGE__->add_columns(
    "id",
    {
        data_type         => "integer",
        is_auto_increment => 1,
        is_nullable       => 0,
        sequence          => "projects_sequence",
    },
    "title",
    { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

1;
