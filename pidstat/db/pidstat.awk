# read raw pidstat log output and format suitable for load to postgresql/gpdb database
# exclude "Linux" headers, #headers, empty lines
/^Linux/ {next}
/^$/     {next}
/^#/     {next}
NF < 16  {next}
# prepend fields: ( cluster, host, null placeholder for timestamp )
{
  printf c "~" h "~\\N~"
  for (i=1;i<16;i++) printf $i "~"
  for (i=16;i<=NF;i++) printf $i " "
  print ""
}
