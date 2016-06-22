# ---------------------------
# this script queries sar tables and plots various stats
# - output is .png files in /var/tmp
# ---------------------------
library(ggplot2)
library(reshape2)
source("get-sar-data-cl-avg.R")
# ---------------------------
con<-connect()
unlink(paste(gl_chart_output_dir,"charts-area-cl-avg",sep="/"), recursive=T)
dir.create(paste(gl_chart_output_dir,"charts-area-cl-avg",sep="/"))
fname <- function(name) { paste(gl_chart_output_dir, "charts-area-cl-avg", name, sep="/") }
# ---------------------------
# runq
# - scatter plot of plistsz(x)/runq(y)
# ---------------------------
print("runq charts...")
runq <- function(con) {
  data  <- get_runq_data(con)
  chart <- ggplot() +
           geom_point(data=data, aes(x=plistsz, y=runqsz))
  png(file=fname("runq-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(chart)
  dev.off()
}
runq(con)
# ---------------------------
# mem
# - area-plot of time-mem, cluster-average, segments only
# ---------------------------
print("mem charts...")
mem <- function(con) {
  data     <- melt(
                   get_mem_data(con)
                 , id.vars=c("ts")
                 , measure.vars=c( "cach", "used", "buff", "free" )
                 , variable.name="type"
                 , value.name="val"
              )
  chart    <- ggplot() +
              geom_area( data=data, aes( x=ts, y=val, fill=type ) ) +
              scale_fill_manual( values=alpha( c("grey","yellow","orange","lightblue") ) ) +
              scale_y_continuous() +
              labs( title="Memory Utilization", x="Time", y="Memory (GB)" ) # +
#              scale_x_date( labels=date_format("%d-%b"), breaks = date_breaks("2 hours") ) +         # x-axis needs to be Date object - use as.Date()
#              theme(axis.text.x = element_text(angle=-45,vjust=0.5,size=10))                         # we can adjust x-axis labels eg alignment, size
  png(file=fname("mem-over-ts.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(chart)
  dev.off()
}
mem(con)
# ---------------------------
# cpu
# - area-plot of time-cpu%, cluster-avg, segments-only
# ---------------------------
print("cpu charts...")
cpu <- function(con) {
  data     <- melt(
                   get_cpu_data(con)
                 , id.vars=c("ts")
                 , measure.vars=c("usr","nice","sys","iowait","idle")
                 , variable.name="type", value.name="val"
              )
#
  chart    <- ggplot() +
              geom_area(data=data,aes(x=ts,y=val,fill=type)) +
              scale_fill_manual(values=alpha(c("grey","yellow","orange","red","lightblue"))) +
              scale_y_continuous() +
              labs(title="CPU Utilization\nCluster Avg", x="time", y="CPU (%)") #+
#              theme(axis.text.x = element_text(angle=60,vjust=0.5,size=10))
  png(file=fname("cpu-over-ts.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(chart)
  dev.off()
}
cpu(con)
# ---------------------------
# dsk
# - area chart of the disk tps read/write
# ---------------------------
print("dsk charts...")
dsk <- function(con) {
  data     <- get_disk_data(con)
  lng_data <- melt(
                   data
                 , id.vars=c("ts")
                 , measure.vars=c("rd_sectors_sec","wr_sectors_sec")
                 , variable.name="type"
                 , value.name="val"
              )
  chart    <- ggplot() +
              geom_area(data=lng_data, aes( x=ts, y=val, fill=type ) ) +
              scale_fill_manual( values=alpha( c("blue", "red") ) ) +
#              scale_y_continuous(limits=c(0,10000)) +
              labs(title="Disk Activity - Volume (Sectors/Sec)", x="time", y="sectors/sec")
  png(file=fname("disk-sectors-over-ts.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(chart)
  dev.off()
  chart    <- ggplot() +
              geom_line(data=data, aes( x=ts, y=tps) ) +
              scale_fill_manual( values=alpha( c("red") ) ) +
#              scale_y_continuous(limits=c(0,10000)) +
              labs(title="Disk Activity (TPS)", x="time", y="tps")
  png(file=fname("disk-tps-over-ts.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(chart)
  dev.off()
}
dsk(con)
# ---------------------------
# net
# - area chart of network packets sent/received
# ---------------------------
print("net charts...")
net <- function(con) {
  data     <- melt(
                   get_net_data(con)
                 , id.vars=c("ts")
                 , measure.vars=c("txpck_sec","rxpck_sec")
                 , variable.name="type"
                 , value.name="val"
              )
  chart    <- ggplot() +
              geom_area(data=data, aes( x=ts, y=val, fill=type) ) +
              scale_fill_manual(values=alpha(c("blue","red"))) +
#              scale_y_continuous(limits=c(0,gl_chart_size_width0)) +
              labs(title="N/W Activity", x="time", y="pkts('000s)")
  png(file=fname("net-pkts.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
  print(chart)
  dev.off()
}
net(con)
# ---------------------------
disconnect(con)
# ---------------------------

