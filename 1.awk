
BEGIN {
tcp_count=0;
udo_count=0;
}{
if($1 == "-" && $5 == "tcp")
tcp_count++;
if($1 == "+" && $5 == "cbr")
udp_count++;
} END {
printf("TCP %d\n",tcp_count);
printf("UDP %d\n",udp_count);
}
