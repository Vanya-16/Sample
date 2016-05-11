set ns [new Simulator]
set nt [open out.tr w]
$ns trace-all $nt
set nf [open out.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n1 3Mb 5ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail
$ns duplex-link $n0 $n3 12Mb 15ms DropTail
$ns duplex-link $n3 $n2 1Mb 2ms DropTail

$ns cost $n0 $n1 1 
$ns cost $n1 $n2 2
$ns cost $n0 $n3 6
$ns cost $n3 $n2 4

set udp [new Agent/UDP]
$ns attach-agent $n0 $udp
set null [new Agent/Null]
$ns attach-agent $n2 $null
$ns connect $udp $null
$udp set fid_ 0
$ns color 0 blue

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

$ns rtproto DV 

$ns rtmodel-at 1.5 down $n1
$ns rtmodel-at 3.0 up $n1

$ns at 1.0 "$cbr start"
$ns at 3.5 "$cbr stop"
$ns at 4.0 "finish"

proc finish {} {
global ns nf nt
$ns flush-trace
#Close the NAM trace file
close $nf
close $nt
#Execute NAM on the trace file
exec nam out.nam &
exit 0
}

$ns run
