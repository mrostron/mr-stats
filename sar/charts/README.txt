
--------------
Recommended Procedure
--------------
- pre-requisit
  - create postgresql database to contain data
  - collect/load sar statistics from your candidate host (ref db/README.txt)




--------------
Introduction
--------------

This directory contains a number of R chart-generating scripts.
The charts display system metrics in the following main groups:
- cpu
- memory
- disk
- network

Input data
- data is assumed to be sar-format tables in a postgresql database
- refer to the directory "db" for method of collecting/loading sar data

The type of display are
- dot plot of straight time-series of cluster-averages
- dot-plot of (actual value)/(expected load) (expected load:plistsz, actual value: depends on metric group )


Input
- The charts accept static input via a set of global variables.
  Data parameters are:
  - time range
  - host include/exlude
  - disk device include/exclude
  - network interface  include/exclude

Output
- The charts are static output in .png format
  location and size information can be configured globally.
  default output location will be /var/tmp

Other Analysis
- kmeans parameters can be configured globally








