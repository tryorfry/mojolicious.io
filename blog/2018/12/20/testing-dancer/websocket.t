use Mojo::Base -strict;

use EV; # allows Mojo::IOLoop and AnyEvent to work together
use Test::More;
use Test::Mojo;

use Twiggy::Server;
use Plack::Util;

my $app = Plack::Util::load_psgi('bin/app.psgi');
my $twiggy = Twiggy::Server->new(
  host => '127.0.0.1',
  port => 8080,
);
$twiggy->register_service($app);

my $t = Test::Mojo->new;

$t->websocket_ok('ws://127.0.0.1:8080/ws')
  ->send_ok({json => {hello => 'Dancer'}})
  ->message_ok
  ->json_message_is({hello => 'browser!'})
  ->finish_ok;

done_testing;
