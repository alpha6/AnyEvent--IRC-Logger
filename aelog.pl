#!/usr/bin/env perl
use AnyEvent;
use AnyEvent::IRC::Client;
 
my $c = AnyEvent->condvar;
 
my $timer;
my $con = new AnyEvent::IRC::Client;
 
$con->reg_cb (connect => sub {
   my ($con, $err) = @_;
   if (defined $err) {
      warn "connect error: $err\n";
      return;
   }
});
$con->reg_cb ( registered => sub { print "I'm in!\n"; });
$con->reg_cb ( disconnect => sub { 
	print "I'm out!\n"; 
	$con->connect ("irc.perl.org", 6667, { nick => 'YetAnotherLogger'.$$ }); 
});
$con->send_srv(JOIN => '#ru.pm'); #подключаемся к каналу

$con->reg_cb(publicmsg => sub { #Получаем сообщения в канале
	my $data = pop;
	my $prefix = $data->{'prefix'};
	my ($nick) = split('!', $prefix);
    my $message = $data->{'params'}->[1];
    print "nick: $nick\ndata: $message\n";
  });

$con->connect ("irc.perl.org", 6667, { nick => 'YetAnotherLogger'.$$ });
$c->wait;
$con->disconnect;
