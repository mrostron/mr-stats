#---------------
# setup for point-by-kmeans charts
#---------------
library(ggplot2)
source("get-sar-data-raw.R")
con <- connect()
unlink(paste(gl_chart_output_dir,"charts-point-by-kmeans",sep="/"), recursive=T)
dir.create(paste(gl_chart_output_dir,"charts-point-by-kmeans",sep="/"))
fname <- function(name) { paste(gl_chart_output_dir, "charts-point-by-kmeans", name, sep="/") }
#---------------
# runq
#---------------
rq <- function(con) {
  data <- get_runq_data(con)
  km<-as.factor((kmeans(data[,c("plistsz")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  png(file=fname("plistsz-over-ts.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(ggplot()+geom_point( data=data, aes( x=ts, y=plistsz, color=km )))
  dev.off()
  km<-as.factor((kmeans(data[,c("runqsz")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  png(file=fname("runq-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(ggplot()+geom_point(data=data,aes(x=plistsz,y=runqsz,color=km)))
  dev.off()
}
rq(con)
#---------------
# cpu
#---------------
cpu <- function(con) {
  cpu_data <- get_cpu_data(con)
  rq_data <- get_runq_data(con)
  data <- data.frame(rq_data$plistsz, (100-cpu_data$idle))
  colnames(data) <- c("plistsz","cpu_not_idle")
  km <- as.factor((kmeans(data[,c("cpu_not_idle")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  png(file=fname("cpu-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(ggplot()+geom_point(data=data,aes(x=plistsz,y=cpu_not_idle,color=km)))
  dev.off()
}
cpu(con)
#---------------
# mem
#---------------
mem <- function(con) {
  mem_data<-get_mem_data(con)
  rq_data<-get_runq_data(con)
  data<-data.frame( rq_data$plistsz, mem_data$used )
  colnames(data) <- c("plistsz","used")
  km<-as.factor((kmeans(data[,c("used")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  png(file=fname("mem-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(ggplot()+geom_point(data=data,aes(x=plistsz,y=used,color=km)))
  dev.off()
}
mem(con)
#---------------
# disk
#---------------
disk <- function(con) {
  disk_data<-get_disk_data(con)
  rq_data<-get_runq_data(con)
  data<-data.frame(rq_data$plistsz,disk_data$rd_sectors_sec,disk_data$wr_sectors_sec,disk_data$tps,disk_data$host)
  colnames(data) <- c("plistsz","rd_sectors_sec","wr_sectors_sec","tps","host")
  km<-as.factor((kmeans(data[,c("rd_sectors_sec")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  png(file=fname("disk-read-sectors-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(ggplot()+geom_point(data=data,aes(x=plistsz,y=rd_sectors_sec,color=km)))
  dev.off()
  km<-as.factor((kmeans(data[,c("wr_sectors_sec")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  png(file=fname("disk-write-sectors-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(ggplot()+geom_point(data=data,aes(x=plistsz,y=wr_sectors_sec,color=km)))
  dev.off()
  km<-as.factor((kmeans(data[,c("tps")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  png(file=fname("disk-tps-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(ggplot()+geom_point(data=data,aes(x=plistsz,y=tps,color=km)))
  dev.off()
}
disk(con)
#---------------
# net
#---------------
net <- function(con) {
  net_data<-get_net_data(con)
  rq_data<-get_runq_data(con)
  data<-data.frame(rq_data$plistsz,net_data$txpck_sec,net_data$rxpck_sec,rq_data$host)
  colnames(data) <- c("plistsz","txpck_sec","rxpck_sec","host")
  km<-as.factor((kmeans(data[,c("txpck_sec")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  png(file=fname("net-send-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(ggplot()+geom_point(data=data,aes(x=plistsz,y=txpck_sec,color=km)))
  dev.off()
  km<-as.factor((kmeans(data[,c("rxpck_sec")],centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1))$cluster)
  png(file=fname("net-receive-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(ggplot()+geom_point(data=data,aes(x=plistsz,y=rxpck_sec,color=km)))
  dev.off()
}
net(con)
#---------------
disconnect(con)
#---------------
