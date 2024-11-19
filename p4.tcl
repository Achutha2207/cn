set ns [new Simulator]
set tf [open 4.tr w]
$ns trace-all $tf
set nf [open 4.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]

$ns color 1 Blue

$n0 label "Server"
$n1 label "Client"

$ns duplex-link $n0 $n1 10Mb 22ms DropTail
$ns duplex-link-op $n0 $n1 orient right

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
$tcp set packetSize_ 1500
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$tcp set fid_ 1

proc finish {} {
global ns tf nf
$ns flush-trace
close $tf
close $nf
exec nam 4.nam &
exec awk -f p4transfer.awk 4.tr &
exec awk -f p4convert.awk 4.tr > convert.tr
exec xgraph convert.tr -geometry 800*400 -t
"Bytes_received_at_Client" -x "Time _in_secs" -y "Bytes_in_bps" &
}

$ns at 0.01 "$ftp start"
$ns at 15.0 "$ftp stop"
$ns at 15.1 "finish"
$ns run


