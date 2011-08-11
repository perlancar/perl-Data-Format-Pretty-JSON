package Data::Format::Pretty::CompactJSON;

use 5.010;
use strict;
use warnings;

use Data::Format::Pretty::JSON;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(format_pretty);

my $json = JSON->new->utf8->allow_nonref;

# VERSION

sub format_pretty {
    my ($data, $opts0) = @_;
    my %opts = $opts0 ? %$opts0 : ();
    $opts{pretty} = 0;
    Data::Format::Pretty::JSON::format_pretty($data, \%opts);
}

1;
# ABSTRACT: Pretty-print data structure as compact JSON
__END__

=head1 SYNOPSIS

 use Data::Format::Pretty::CompactJSON qw(format_pretty);
 print format_pretty($data);

Some example output:

=over 4

=item * format_pretty({a=>1, b=>2});

 {"a":1,"b":2}

=back


=head1 DESCRIPTION

This module is a shortcut for using L<Data::Format::Pretty::JSON> with options
C<pretty>=0.


=head1 FUNCTIONS

=head2 format_pretty($data, \%opts)

Return formatted data structure as JSON. See L<Data::Format::Pretty::JSON> for
details.


=head1 SEE ALSO

L<Data::Format::Pretty::JSON>

=cut

