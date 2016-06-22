#---------------
library(ggplot2)
source("get-sar-data-raw.R")
con <- connect()
unlink(paste(gl_chart_output_dir,"charts-point-by-host",sep="/"), recursive=T)
dir.create(paste(gl_chart_output_dir,"charts-point-by-host",sep="/"))
fname <- function(name) { paste(gl_chart_output_dir, "charts-point-by-host", name, sep="/") }
#---------------
# runq
#---------------
rq <- function(con) {
  data<-get_runq_data(con)
  png( file=fname("plistsz-over-ts.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px")
  print( ggplot() + geom_line( data=data, aes( x=ts, y=plistsz, color=host )))
  dev.off()
  png( file=fname("runq-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px")
  print( ggplot() + geom_point( data=data, aes( x=plistsz, y=runqsz, color=host )))
  dev.off()
}
rq(con)
#---------------
# cpu
#---------------
cpu <- function(con) {
  cpu_data <- get_cpu_data(con)
  rq_data <- get_runq_data(con)
  data <- data.frame( cpu_data$ts, cpu_data$idle, rq_data$plistsz, rq_data$runqsz, rq_data$host )
  colnames(data) <- c("ts","idle","plistsz","runqsz","host")
  png( file= fname("cpu-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px")
  print( ggplot() + geom_point( data=data, aes( x=plistsz, y=(100-idle), color=host )))
  dev.off()
}
cpu(con)
#---------------
# mem
#---------------
mem<- function(con) {
  mem_data <- get_mem_data(con)
  rq_data <- get_runq_data(con)
  data<-data.frame( mem_data$host, rq_data$plistsz, mem_data$cach, mem_data$used, mem_data$free, mem_data$buff)
  colnames(data) <- c( "host", "plistsz", "cach", "used", "free", "buff" )
  png( file=fname("mem-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px")
  print( ggplot() + geom_point( data=data, aes( x=plistsz, y=used, color=host )))
  dev.off()
}
mem(con)
#---------------
# disk
#---------------
disk <- function(con) {
  disk_data<-get_disk_data(con)
  rq_data<-get_runq_data(con)
  data <- data.frame( rq_data$plistsz, disk_data$rd_sectors_sec, disk_data$wr_sectors_sec, disk_data$tps, disk_data$host )
  colnames(data) <- c( "plistsz", "rd_sectors_sec", "wr_sectors_sec", "tps", "host" )
  png( file=fname("disk-read-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px")
  print( ggplot() + geom_point( data=data, aes( x=plistsz, y=rd_sectors_sec, color=host )))
  dev.off()
  png( file=fname("disk-write-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px")
  print( ggplot() + geom_point( data=data, aes( x=plistsz, y=wr_sectors_sec, color=host )))
  dev.off()
}
disk(con)
#---------------
# net
#---------------
net <- function(con) {
  net_data<-get_net_data(con)
  rq_data<-get_runq_data(con)
  data<-data.frame( rq_data$plistsz, net_data$txpck_sec, net_data$rxpck_sec, rq_data$host )
  colnames(data) <- c( "plistsz", "txpck_sec", "rxpck_sec", "host" )
  png( file=fname("net-send-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px")
  print( ggplot() + geom_point( data=data, aes( x=plistsz, y=rxpck_sec, color=host )))
  dev.off()
  png(file=fname("net-receive-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px")
  print( ggplot() + geom_point( data=data, aes( x=plistsz, y=txpck_sec, color=host )))
  dev.off()
}
net(con)
#---------------
disconnect(con)
#---------------

