#!/usr/bin/perl -w 
use strict;

use Data::Dumper;
use SGMonitor::Helpers::Linux_Process;





my $object=SGMonitor::Helpers::Linux_Process->new ( { 'cmdline' => 'echo hi' });


print(Dumper($object));
