package Dancer::Plugin::MPD;

use warnings;
use strict;
use Dancer::Plugin;
use Audio::MPD;

our $VERSION = '0.01';
my $mpd;

register mpd => sub {

    if ($mpd && $mpd->ping) {
        return $mpd;
    } else {
        return $mpd = _connect();
    }
};

sub _connect {

    my $conf = plugin_setting;

    # Only pass settings to Audio::MPD if they're specified in the config;
    # Audio::MPD does sensible things by default, so in the majority of cases
    # (MPD listening on localhost, on port 6600, with no password set), no
    # configuration will be needed at all.
    my %mpd_conf;
    for my $setting (qw(host port password)) {
        $mpd_conf{$setting} = $conf->{$setting} if exists $conf->{$setting};
    }

    # Audio::MPD's default conntype is 'once', which re-establishes a connection
    # for every request.  For performance, we probably want to re-use a
    # connection.
    $conf->{conntype} ||= 'reuse';

    return  Audio::MPD->new(\%mpd_conf);
}

   

register_plugin;

=head1 NAME

Dancer::Plugin::MPD - easy connection to MPD from Dancer apps

=head1 DESCRIPTION

Provides an easy way to connect to MPD (L<www.wusicpd.org>) from a L<Dancer>
app.  Handles obtaining the connection, making sure the connection is still
alive, and reconnecting if not.



=head1 SYNOPSIS

In your L<Dancer> app, calling the C<mpd> keyword will get you an MPD
connection.

    use Dancer::Plugin::MPD;
    my $current_song = mpd->current;
    mpd->next;


=head1 AUTHOR

David Precious, C<< <davidp at preshweb.co.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-dancer-plugin-mpd at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Dancer-Plugin-MPD>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Dancer::Plugin::MPD


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dancer-Plugin-MPD>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Dancer-Plugin-MPD>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Dancer-Plugin-MPD>

=item * Search CPAN

L<http://search.cpan.org/dist/Dancer-Plugin-MPD/>

=back



=head1 LICENSE AND COPYRIGHT

Copyright 2010 David Precious.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Dancer::Plugin::MPD
