set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(ll) LL
set val(mac) Mac/802_11
set val(ifq) Queue/DropTail/PriQueue
set val(ifqlen) 50
set val(ant) Antenna/OmniAntenna
set val(x) 500
set val(y) 500
set val(rp) AODV
set val(nn) 51
set val(stop) 100.0
set val(sc) "a3"
set val(cp) "a2"

set ns_ [new Simulator]
set tf [open 003.tr w]
$ns_ trace-all $tf
set nf [open 003.nam w]
$ns_ namtrace-all-wireless $nf $val(x) $val(y)

set prop [new $val(prop)]
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
set god_ [create-god $val(nn)]

$ns_ node-config -adhocRouting $val(rp)\
-llType $val(ll)\
-macType $val(mac)\
-channelType $val(chan)\
-propType $val(prop)\
-phyType $val(netif)\
-ifqLen $val(ifqlen)\
-ifqType $val(ifq)\
-antType $val(ant)\
-topoInstance $topo\
-routerTrace ON\
-macTrace ON\
-agentTrace ON


for { set i 0 } { $i < $val(nn) } { incr i } {
set node_($i) [$ns_ node]
$node_($i) random-motion 0
}


for { set i 0 } { $i<$val(nn) } { incr i } {
set xx [expr rand()*500]
set yy [expr rand()*500]
$node_($i) set X_ $xx
$node_($i) set Y_ $yy
}
for { set i 0 } { $i < $val(nn) } { incr i } {
$ns_ initial_node_pos $node_($i) 40
}
source $val(sc)
source $val(cp)
for { set i 0 } { $i < $val(nn) } { incr i } {
$ns_ at $val(stop) "$node_($i) reset";
}

$ns_ at $val(stop) "$ns_ halt";
$ns_ run
