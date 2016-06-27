# read raw pidstat log output and format suitable for load to postgresql/gpdb database
/^Linux/ {next}
/^$/ {next}
/^#/ {next}
{for (i=1;i<16;i++) printf $i "~"; for (i=16;i<=NF;i++) printf $i " "; print ""}
