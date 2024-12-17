# Setting the Default Parameters
set val(chan)   Channel/WirelessChannel
set val(prop)   Propagation/TwoRayGround
set val(netif)  Phy/WirelessPhy
set val(mac)    Mac/802_11
set val(ifq)    Queue/DropTail/PriQueue
set val(ll)     LL
set val(ant)    Antenna/OmniAntenna
set val(x)      500
set val(y)      400
set val(ifqlen) 50
set val(nn)     3
set val(stop)   60.0
set val(rp)     AODV

# Create simulator instance
set ns [new Simulator]
set tf [open 002.tr w]
$ns trace-all $tf
set nf [open 002.nam w]
$ns namtrace-all-wireless $nf $val(x) $val(y)

# Define topology and propagation model
set prop [new $val(prop)]
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

# Create general operations director (GOD)
create-god $val(nn)

# Node configuration
$ns node-config -adhocRouting $val(rp)\
                -llType $val(ll)\
                -macType $val(mac)\
                -ifqType $val(ifq)\
                -ifqLen $val(ifqlen)\
                -antType $val(ant)\
                -propType $val(prop)\
                -phyType $val(netif)\
                -channelType $val(chan)\
                -topoInstance $topo\
                -agentTrace ON\
                -routerTrace ON\
                -macTrace ON

# Creating nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns node]
    $node_($i) random-motion 0
}

# Initial positions of nodes
$node_(0) set x_ 5.0
$node_(0) set y_ 5.0
$node_(0) set z_ 0.0

$node_(1) set x_ 490.0
$node_(1) set y_ 285.0
$node_(1) set z_ 0.0

$node_(2) set x_ 150.0
$node_(2) set y_ 240.0
$node_(2) set z_ 0.0

for {set i 0} {$i < $val(nn)} {incr i} {
    $ns initial_node_pos $node_($i) 40
}

# Topology design and mobility
$ns at 0.0 "$node_(0) setdest 450.0 285.0 30.0"
$ns at 0.0 "$node_(1) setdest 200.0 285.0 30.0"
$ns at 0.0 "$node_(2) setdest 1.0 285.0 30.0"

$ns at 25.0 "$node_(0) setdest 300.0 285.0 10.0"
$ns at 25.0 "$node_(2) setdest 100.0 285.0 10.0"

$ns at 40.0 "$node_(0) setdest 490.0 285.0 5.0"
$ns at 40.0 "$node_(2) setdest 1.0 285.0 5.0"

# Generating traffic
set tcp0 [new Agent/TCP]
set sink0 [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp0
$ns attach-agent $node_(2) $sink0
$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 1.0 "$ftp0 start"

# Simulation termination
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at $val(stop) "$node_($i) reset"
}
$ns at $val(stop)"finish"


proc finish {} {
global ns tf nf
$ns flush-trace
close $nf
close $tf
exec nam 002.nam &
exit 0
}




$ns run
