set ns [new Simulator]
set tf [open tf2.tr w]
set nf [open nf2.nam w]
$ns trace-all $tf
$ns namtrace-all $nf
set cwind [open win2.tr w]
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
$ns duplex-link $n0 $n2 2Mb 2ms DropTail
$ns duplex-link $n1 $n2 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 0.4Mb 5ms DropTail
$ns duplex-link $n3 $n4 2Mb 2ms DropTail
$ns duplex-link $n3 $n5 2Mb 2ms DropTail
$ns queue-limit $n2 $n3 10
set tcp1 [new Agent/TCP]
set sink1 [new Agent/TCPSink]
set ftp1 [new Application/FTP]
$ns attach-agent $n0 $tcp1
$ns attach-agent $n5 $sink1
$ns connect $tcp1 $sink1
$ftp1 attach-agent $tcp1
$ns at 0.1 "$ftp1 start"

set tcp2 [new Agent/TCP]
set sink2 [new Agent/TCPSink]
set telnet1 [new Application/Telnet]
$ns attach-agent $n1 $tcp2
$ns attach-agent $n4 $sink2
$ns connect $tcp2 $sink2
$telnet1 attach-agent $tcp2
$ns at 1.1 "$telnet1 start"
$ns at 1.0 "$ftp1 stop"
#$ns at 4.0 "$telnet1 stop"
$ns at 2.0 "finish"
proc plotWindow {tcpsource file} {
global ns
set time 0.01
set now [$ns now]
set cwind [$tcpsource set cwnd_]
puts $file "$now $cwind"
$ns at [expr $now + $time] "plotWindow $tcpsource $file" 
}
$ns at 0.2 "plotWindow $tcp1 $cwind"
$ns at 0.5 "plotWindow $tcp2 $cwind"
proc finish {} {
global ns tf nf
$ns flush-trace
close $tf
close $nf
puts "Running nam..."
exec nam nf2.nam &
exec xgraph win2.tr &
exit 0 
}
$ns run

