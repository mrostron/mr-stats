# ---------------------------

library(stringr)
set.seed(20)                   # constant random seed (kmeans)

# ---------------------------
# global variables
# - substituted into sql statements before execution
# ---------------------------

#gl_min_ts    <- "(current_date - 5)"
#gl_max_ts    <- "(current_date - 4)"
gl_min_ts    <- "'2016-06-05 13:00'"
gl_max_ts    <- "'2016-06-05 17:00'"
gl_host_incl <- "'sdw%'"
gl_host_excl <- "null"         # NB this is different from R NULL
gl_disk_incl <- "'dev8-0'"
gl_disk_excl <- "null"         # NB this is different from R NULL
gl_net_incl  <- "'eth0'"
gl_net_excl  <- "null"         # NB this is different from R NULL

# ---------------------------
# gl_subst()
# - substitute global variables into the input string
#   - embedded placeholders (:xxx) are replaced by global variables
# - placeholders are:
#   - ( :min_ts, :max_ts )
#   - ( :host_incl,:host_excl )
#   - ( :disk_incl,:disk_excl )
#   - ( :nic_incl,:nic_excl )
# - NB the variable must contain formatting information i.e. quotes, dashes, etc
#   the SQL statement will typically not quote or cast
#   i.e. quoting should be done within gl_subst or in the definition of the variable
# ---------------------------

library(stringr)
gl_subst <- function(s) {
  t <- str_replace_all( s, ":min_ts",    gl_min_ts )
  t <- str_replace_all( t, ":max_ts",    gl_max_ts )
  t <- str_replace_all( t, ":host_incl", gl_host_incl )
  t <- str_replace_all( t, ":host_excl", gl_host_excl )
  t <- str_replace_all( t, ":disk_incl", gl_disk_incl )
  t <- str_replace_all( t, ":disk_excl", gl_disk_excl )
  t <- str_replace_all( t, ":net_incl",  gl_net_incl )
  t <- str_replace_all( t, ":net_excl",  gl_net_excl )
  print(paste0("sql:",t))
  t
}

# ---------------------------
# chart
# - chart output base directory
# - chart size parameters
# ---------------------------

gl_chart_output_dir    <- "/var/tmp"
gl_chart_size_width    <- 800
gl_chart_size_height   <- 500

# ---------------------------
# kmeans
# - iterations
# - k-value ("centers")
# - colors (nb length of color vector should be equal to gl_kmeans_centers)
# ---------------------------

gl_kmeans_iterations <- 10
gl_kmeans_centers    <- 5
gl_kmeans_colors     <- c("red","pink","orange","green","blue") # color, from max-to-min (yvalue), length is #km-centers

