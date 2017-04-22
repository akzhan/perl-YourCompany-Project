package YourCompany::DB::Project;

use YourCompany::Perl::UTF8;

=encoding utf8

=head1 NAME

YourCompany::DB::Project

=head1 DESCRIPTION

проекты это наше все

=cut

use parent qw( YourCompany::Util::DBResult );

=head1 TABLE: C<projects>

=cut

__PACKAGE__->table("projects");

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
