package ## no critic: Modules::RequireFilenameMatchesPackage
    # hide from PAUSE
    TableDataRole::Acme::CPANAuthors;

use 5.010001;
use strict;
use warnings;

use Role::Tiny;
with 'TableDataRole::Source::AOA';

around new => sub {
    require Acme::CPANAuthors;

    my $orig = shift;
    my ($self, %args) = @_;

    my $module = delete $args{module}
        or die "Please specify 'module' argument";
    $module =~ s/\AAcme::CPANAuthors:://;
    my $authors = Acme::CPANAuthors->new($module);

    my $aoa = [];
    my $column_names = [qw/
                              cpanid
                              name
                          /];
    for my $cpanid ($authors->id) {
        push @$aoa, [
            $cpanid,
            $authors->name($cpanid),
        ];
    }

    $orig->($self, %args, aoa => $aoa, column_names=>$column_names);
};

package TableData::Acme::CPANAuthors;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Acme::CPANAuthors';

# STATS

1;
# ABSTRACT: Authors listed in a Acme::CPANAuthors::* module

=head1 SYNOPSIS

Using from the CLI:

 % tabledata Acme/CPANAuthors=module,Indonesian


=head1 DESCRIPTION

A quick way to list the contents of an Acme::CPANAuthors::* module in table
fXSorm.

This table gets its data dynamically by querying L<Acme::CPANAuthors> (and the
specific authors module, e.g. L<Acme::CPANAuthors::Indonesian>).


=head1 METHODS

=head2 new

Usage:

 my $table = TableData::Acme::CPANAuthors->new(%args);
`
Known arguments:

=over

=item * module

Required.

=back


=head1 SEE ALSO

L<Acme::CPANAuthors>

L<acme-cpanauthors> from L<App::AcmeCPANAuthors>
