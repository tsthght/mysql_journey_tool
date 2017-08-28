#!/usr/bin/perl
#sql_latency
#By tsthght

use strict;
use threads;
use DBI;
use Time::HiRes 'time';
use Getopt::Long;

my $version = "1.0";
my %opt = {
	"threads" => 0,
	"host" => "localhost",
	"port" => 3306,
	"user" => "",
	"pass" => "",
	"database" => "",
	"executeS" => "",
	"execute" => ""
};
GetOptions(\%opt,
	'threads=i',
	'host=s',
	'port=i',
	'user=s',
	'pass=s',
	'database=s',
	'executeS=s',
	'execute=s',
	'help'
) or die usage();

sub usage {
	print "\n".
		"  SQL_Latency $version\n".
		"  A perl script to test the latency usage of SQL queries in a certain amount of concurrent.\n".
		"  Options:\n".
		"    --threads <threads> Threads to use while doing test.\n".
		"    --host <hostname>   Connect to a remote host to perform tests(default:localhost).\n".
		"    --port <port>       Port to use for connection (default:3306).\n".
		"    --user <username>   Username to use for authentication.\n".
		"    --pass <password>   Password to use for authentication.\n".
		"    --database <dbname> Database to the test.\n".
		"    --executeS \"<sql>\"SQL string to do select work.\n".
		"    --execute \"<sql>\" SQL string to do insert|update|delete work.\n".
		"    --help              Print help message.\n".
		"\n";
	exit;
}
sub mysql_executeS {
	my $start = time;
	my $db = DBI->connect("DBI:mysql:database=$opt{'database'}:host=$opt{'host'}:port=$opt{'port'}",$opt{'user'},$opt{'pass'},{'RaiseError'=>1}) or die $db::errstr;
	my $select = $db->prepare($opt{'executeS'});
	printf("sql::%s\n", $opt{'executeS'});
	$select->execute() or die $db::errstr;
	$select->fetchall_arrayref;
	$select->finish();
	printf("executeS($_[0]) latency:%.5f second.\n", time - $start);
}
sub mysql_execute {
	my $start = time;
	my $db = DBI->connect("DBI:mysql:database=$opt{'database'}:host=$opt{'host'}:port=$opt{'port'}",$opt{'user'},$opt{'pass'},{'RaiseError'=>1}) or die     $db::errstr;
	my $rows = $db->do($opt{'execute'}) or die $db::errstr;
	printf("execute($_[0]) latency:%.5f second.\n", time - $start);
}
if(defined $opt{'help'} && $opt{'help'} == 1) {
	usage();
}else {
	print "create $opt{'threads'} threads\nwaiting for result ...\n";
	my @td;
	if($opt{'executeS'} ne "") {
		for(my $i=1; $i<=$opt{'threads'};$i++) {
			push (@td, threads->new(\&mysql_executeS, $i));
		}
	} elsif($opt{'execute'} ne "") {
		for(my $i=1; $i<=$opt{'threads'};$i++) {
			push (@td, threads->new(\&mysql_execute, $i));
		}
	} else {
		usage();
	}
	foreach(@td) {
		$_->join;
	}
	print "done.\n"
}
