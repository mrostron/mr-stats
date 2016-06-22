#---------------
# setup for point-by-kmeans charts
#---------------
library(plyr)
library(ggplot2)
source("get-sar-data-raw.R")
con <- connect()
unlink(paste(gl_chart_output_dir,"charts-heatmap-host-by-kmeans",sep="/"), recursive=T)
dir.create(paste(gl_chart_output_dir,"charts-heatmap-host-by-kmeans",sep="/"))
fname <- function(name) { paste(gl_chart_output_dir, "charts-heatmap-host-by-kmeans", name, sep="/") }
#---------------
# heatmap scaling factor
# - used to draw a heatmap of host/km-group membership
#   the heatmap fill-color is determined by "factor"
# - "factor" is proportion of time that host appears in a km grouping
# - input: data.frame named "data", contains km/host
#          this frame is counted by host and host/km
#          the factor is calculated as quotient of the two counts: (host-and-km-count)/(host-count)
# - return: list of host/km/factor
#---------------
km_scale <- function(data) {
  c1           <- count(data,.(host,km))
  c2           <- count(data,.(host))
  c3           <- join(c1,c2,by="host")
  colnames(c3) <- .(host,km,cnt1,cnt2)             # equiv to c("host","km","cnt1","cnt2")
  c4           <- transform(c3,factor=cnt1/cnt2)
  c4
}
#---------------
# runq
#---------------
rq <- function(con) {
  rq_data <- get_runq_data(con)
  km <- as.factor((kmeans(rq_data[,c("plistsz")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  ks <- km_scale(data.frame( host=rq_data$host, km ))
  print(ks)
  png( file=fname("plistsz-over-ts.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px" )
  print(
         ggplot() +
         geom_tile( data=ks, aes( x=km, y=host, fill=factor) ) +
         theme( panel.background=element_rect( fill="white", colour="white" ) ) +
         scale_fill_gradient( low="white", high="steelblue" )
  )
  dev.off()
  km <- as.factor((kmeans(rq_data[,c("runqsz")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  ks <- km_scale(data.frame( host=rq_data$host, km ))
  print(ks)
  png( file=fname("runq-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px" )
  print(
         ggplot() +
         geom_tile( data=ks, aes( x=km, y=host, fill=factor ) ) +
         theme( panel.background=element_rect( fill="white", colour="white" ) ) +
         scale_fill_gradient( low="white", high="steelblue" )
  )
  dev.off()
}
rq(con)
#---------------
# cpu
#---------------
cpu <- function(con) {
  cpu_data <- get_cpu_data(con)
  rq_data <- get_runq_data(con)
  km <- as.factor((kmeans(cpu_data[,c("not_idle")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  ks <- km_scale(data.frame( host=rq_data$host, km ))
  print(ks)
  png( file=fname("cpu-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height,units="px" )
  print(
         ggplot() +
         geom_tile( data=ks, aes( x=km, y=host, fill=factor ) ) +
         theme( panel.background=element_rect( fill="white", colour="white" ) ) +
         scale_fill_gradient( low="white", high="steelblue" )
  )
  dev.off()
}
cpu(con)
#---------------
# mem
#---------------
mem <- function(con) {
  mem_data <- get_mem_data(con)
  rq_data <- get_runq_data(con)
  km <- as.factor((kmeans(mem_data[,c("used")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  ks <- km_scale(data.frame( host=rq_data$host, km ))
  print(ks)
  png( file=fname("mem-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px" )
  print(
         ggplot() +
         geom_tile( data=ks, aes( x=km, y=host, fill=factor) ) +
         theme( panel.background=element_rect( fill="white", colour="white" ) ) +
         scale_fill_gradient( low="white", high="steelblue" )
  )
  dev.off()
}
mem(con)
#---------------
# disk
#---------------
disk <- function(con) {
  disk_data <- get_disk_data(con)
  rq_data <- get_runq_data(con)
  km <- as.factor((kmeans(disk_data[,c("rd_sectors_sec")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  ks <- km_scale(data.frame( host=rq_data$host, km ))
  png( file=fname("disk-read-sectors-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px" )
  print(
         ggplot() +
         geom_tile( data=ks , aes( x=km, y=host, fill=factor ) ) +
         theme( panel.background=element_rect( fill="white", colour="white" ) ) +
         scale_fill_gradient( low="white", high="steelblue" )
  )
  dev.off()
  km <- as.factor((kmeans(disk_data[,c("wr_sectors_sec")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  ks <- km_scale(data.frame( host=rq_data$host, km ))
  png( file=fname("disk-write-sectors-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px" )
  print(
         ggplot() +
         geom_tile( data=ks, aes( x=km, y=host, fill=factor ) ) +
         theme( panel.background=element_rect( fill="white", colour="white" ) ) +
         scale_fill_gradient( low="white", high="steelblue" )
  )
  dev.off()
  km <- as.factor((kmeans(disk_data[,c("tps")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  ks <- km_scale(data.frame( host=rq_data$host, km ))
  png( file=fname("disk-tps-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px" )
  print(
         ggplot() +
         geom_tile( data=ks, aes( x=km, y=host, fill=factor ) ) +
         theme( panel.background=element_rect( fill="white", colour="white" ) ) +
         scale_fill_gradient( low="white", high="steelblue" )
  )
  dev.off()
}
disk(con)
#---------------
# net
#---------------
net <- function(con) {
  net_data <- get_net_data(con)
  rq_data <- get_runq_data(con)
  km <- as.factor((kmeans(net_data[,c("txpck_sec")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  ks <- km_scale(data.frame( host=rq_data$host, km ))
  png( file=fname("net-send-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px" )
  print(
         ggplot() +
         geom_tile( data=ks, aes( x=km, y=host, fill=factor )) +
         theme( panel.background=element_rect( fill="white", colour="white" ) ) +
         scale_fill_gradient( low="white", high="steelblue" )
  )
  dev.off()
  km<-as.factor((kmeans(net_data[,c("rxpck_sec")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  ks <- km_scale(data.frame( host=rq_data$host, km ))
  png( file=fname("net-receive-over-plistsz.png"), width=gl_chart_size_width, height=gl_chart_size_height, units="px" )
  print(
         ggplot() +
         geom_tile( data=ks, aes( x=km, y=host, fill=factor )) +
         theme( panel.background=element_rect( fill="white", colour="white" ) ) +
         scale_fill_gradient( low="white", high="steelblue" )
  )
  dev.off()
}
net(con)
#---------------
disconnect(con)
#---------------
