package Data::Format::Pretty::JSON;

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(format_pretty);

# VERSION

sub content_type { "application/json" }

sub format_pretty {
    my ($data, $opts) = @_;
    $opts //= {};

    state $json;
    my $pretty = $opts->{pretty} // 1;

    if ($pretty && ($opts->{color} // $ENV{COLOR} // (-t STDOUT))) {
        require JSON::Color;
        JSON::Color::encode_json($data, {pretty=>1, linum=>1}) . "\n";
    } else {
        if (!$json) {
            require JSON;
            $json = JSON->new->utf8->allow_nonref;
        }
        $json->pretty($pretty);
        $json->encode($data);
    }
}

1;
# ABSTRACT: Pretty-print data structure as JSON
__END__

=head1 SYNOPSIS

 use Data::Format::Pretty::JSON qw(format_pretty);
 print format_pretty($data);

Some example output:

=over 4

=item * format_pretty({a=>1, b=>2})

  {
      "a" : 1,
      "b" : 1,
  }

=item * format_pretty({a=>1, b=>2}, {pretty=>0});

 {"a":1,"b":2}

=back


=head1 DESCRIPTION

This module uses L<JSON> to encode data as JSON.


=for Pod::Coverage new

=head1 FUNCTIONS

=head2 format_pretty($data, \%opts)

Return formatted data structure as JSON. Options:

=over 4

=item * color => BOOL

Whether to enable coloring. The default is the enable only when running
interactively. Currently also enable line numbering.

=item * pretty => BOOL (default 1)

Whether to pretty-print JSON.

=back

=head2 content_type() => STR

Return C<application/json>.


=head1 ENVIRONMENT

=head2 COLOR => BOOL

Set C<color> option (if unset).


=head1 SEE ALSO

L<Data::Format::Pretty>

=cut
