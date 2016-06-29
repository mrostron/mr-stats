# read raw pidstat log output and format suitable for load to postgresql/gpdb database
# exclude "Linux" headers, #headers, empty lines
/^Linux/ {next}
/^$/     {next}
/^#/     {next}
# prepend fields: cluster, host, and a placeholder for timestamp
{
  printf c "~" h "~" "~"
  for (i=1;i<16;i++) printf $i "~"
  for (i=16;i<=NF;i++) printf $i " "
  print ""
}
