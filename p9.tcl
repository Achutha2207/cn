set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(ifq) CMUPriQueue
set val(ll) LL
set val(ant) Antenna/OmniAntenna
set val(x) 700
set val(y) 700
set val(ifqlen) 50
set val(nn) 6
set val(stop) 60.0
set val(rp) DSR


set ns [new Simulator]
set tf [open 004.tr w]
$ns trace-all $tf
set nf [open 004.nam w]
$ns namtrace-all-wireless $nf $val(x) $val(y)
set prop [new $val(prop)]
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
set god_ [create-god $val(nn)]

$ns node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace ON


set n0 [$ns node]
$n0 random-motion 0
$n0 set X_ 150.0
$n0 set Y_ 300.0
$n0 set Z_ 0.0

set n1 [$ns node]
$n1 random-motion 0
$n1 set X_ 300.0
$n1 set Y_ 500.0
$n1 set Z_ 0.0

set n2 [$ns node]
$n2 random-motion 0
$n2 set X_ 500.0
$n2 set Y_ 500.0
$n2 set Z_ 0.0

set n3 [$ns node]
$n3 random-motion 0
$n3 set X_ 300.0
$n3 set Y_ 100.0
$n3 set Z_ 0.0

set n4 [$ns node]
$n4 random-motion 0
$n4 set X_ 500.0
$n4 set Y_ 100.0
$n4 set Z_ 0.0

set n5 [$ns node]
$n5 random-motion 0
$n5 set X_ 650.0
$n5 set Y_ 300.0
$n5 set Z_ 0.0



$ns initial_node_pos $n0 40
$ns initial_node_pos $n1 40
$ns initial_node_pos $n2 40
$ns initial_node_pos $n3 40
$ns initial_node_pos $n4 40
$ns initial_node_pos $n5 40



$ns at 1.0 "$n0 setdest 160.0 300.0 2.0"
$ns at 1.0 "$n1 setdest 310.0 150.0 2.0"
$ns at 1.0 "$n2 setdest 490.0 490.0 2.0"

$ns at 1.0 "$n3 setdest 300.0 120.0 2.0"
$ns at 1.0 "$n4 setdest 510.0 90.0 2.0"
$ns at 1.0 "$n5 setdest 640.0 290.0 2.0"
$ns at 4.0 "$n3 setdest 300.0 500.0 5.0"



set tcp0 [new Agent/TCP]
set sink0 [new Agent/TCPSink]
$ns attach-agent $n0 $tcp0
$ns attach-agent $n5 $sink0
$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 5.0 "$ftp0 start"
$ns at 60.0 "$ftp0 stop"


$ns at $val(stop) "$n0 reset";
$ns at $val(stop) "$n1 reset";
$ns at $val(stop) "$n2 reset";
$ns at $val(stop) "$n3 reset";
$ns at $val(stop) "$n4 reset";
$ns at $val(stop) "$n5 reset";


$ns at $val(stop) "finish"


proc finish {} {
global ns nf tf
$ns flush-trace
close $tf
close $nf
exec nam 004.nam &
exit 0
}

$ns run
