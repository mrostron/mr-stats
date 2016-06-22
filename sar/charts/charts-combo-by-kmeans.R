#---------------
# setup for point-by-kmeans charts
#---------------
library(gridExtra)
library(ggplot2)
source("get-sar-data-raw.R")
con <- connect()
unlink(paste(gl_chart_output_dir,"charts-combo-by-kmeans",sep="/"), recursive=T)
dir.create(paste(gl_chart_output_dir,"charts-combo-by-kmeans",sep="/"))
fname <- function(name) { paste(gl_chart_output_dir, "charts-combo-by-kmeans", name, sep="/") }
#---------------
# print_combo_chart()
# print a combined scatterplot/histogram chart
# - input: data.frame: first column = x values, second column is y values
# - output: combination of:
#           - scatterplot of x-values vs y-values
#           - histogram of x-values
#           - histogram of y-values
#---------------
print_combo_chart <- function(data) {
# setup column names (originals used for labels, change to x/y to assist with plotting below)
  n  <- names(data)
  colnames(data) <- c("x","y")
# kmeans (kmeans by y-value)
  k  <- kmeans(data$y,centers=gl_kmeans_centers,iter.max=gl_kmeans_iterations,nstart=1)
  km <- as.factor(k$cluster)            # data points are classified by kmeans-center, used to color plot
  kc <- rev(order(k$centers))           # used to determine color order - kc is km-group in reverse order
# empty frame for right-hand-top corner
  empty <- ggplot()+geom_point(aes(1,1), colour="white") +
           theme(                              
             plot.background = element_blank(), 
             panel.grid.major = element_blank(), 
             panel.grid.minor = element_blank(), 
             panel.border = element_blank(), 
             panel.background = element_blank(),
             axis.title.x = element_blank(),
             axis.title.y = element_blank(),
             axis.text.x = element_blank(),
             axis.text.y = element_blank(),
             axis.ticks = element_blank()
           )
#scatterplot of data$x and data$y variables
  scatter <-    ggplot() +
                geom_point( data=data, aes(x=x,y=y, color=km)) +
                scale_color_manual( values = gl_kmeans_colors, breaks=kc, limits=kc ) +
                theme(legend.position = "none") +
                labs(x=n[1],y=n[2])
#                theme(legend.position=c(1,1),legend.justification=c(1,1)) 
#histogram of data$x - plot on top
  plot_top <-   ggplot() +
                geom_histogram( data=data, aes(x=x, fill=km, alpha=1.0)) +
                scale_fill_manual( values = gl_kmeans_colors, breaks=kc, limits=kc ) +
                theme(legend.position = "none") +
                labs(x=n[1])
#histogram of data$y - plot on the right
  plot_right <- ggplot() +
                geom_histogram( data=data, aes(x=y, fill=km, alpha=1.0 )) +
                coord_flip() +
                scale_fill_manual( values = gl_kmeans_colors, breaks=kc, limits=kc ) +
                theme(legend.position = "none") +
                labs(x=n[2])
#arrange the plots together, with appropriate height and width for each row and column
  grid.arrange( grobs=list( plot_top , empty , scatter , plot_right ) , ncol=2 , nrow=2 , widths=c(4, 1) , heights=c(1, 4))
}
#---------------
# main routine
# - query data
# - draw charts
#---------------
cpu_data  <- get_cpu_data(con)
mem_data  <- get_mem_data(con)
net_data  <- get_net_data(con)
rq_data   <- get_runq_data(con)
disk_data <- get_disk_data(con)
#---------------
png(file=fname("plistsz-over-ts.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
print_combo_chart( data.frame( ts=rq_data$ts, plistsz=rq_data$plistsz) )
dev.off()
#---------------
png(file=fname("runq-over-plistsz"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
print_combo_chart( data.frame( plistsz=rq_data$plistsz, runq=rq_data$runq) )
dev.off()
#---------------
png(file=fname("cpu-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
print_combo_chart( data.frame( plistsz=rq_data$plistsz, cpu_not_idle=cpu_data$not_idle ) )
dev.off()
#---------------
png(file=fname("mem-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
print_combo_chart( data.frame( plistsz=rq_data$plistsz, mem_used=mem_data$used ) )
dev.off()
#---------------
png(file=fname("disk-read-sectors-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
print_combo_chart( data.frame( plistsz=rq_data$plistsz, rd_sectors_sec=disk_data$rd_sectors_sec ) )
dev.off()
#---------------
png(file=fname("disk-write-sectors-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
print_combo_chart( data.frame( plistsz=rq_data$plistsz, wr_sectors_sec=disk_data$wr_sectors_sec ) )
dev.off()
#---------------
png(file=fname("disk-tps-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
print_combo_chart( data.frame( plistsz=rq_data$plistsz, tps=disk_data$tps ) )
dev.off()
#---------------
png(file=fname("net-send-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
print_combo_chart( data.frame( plistsz=rq_data$plistsz, net_pkts_sent=net_data$txpck_sec ) )
dev.off()
#---------------
png(file=fname("net-recv-over-plistsz.png"),width=gl_chart_size_width,height=gl_chart_size_height,units="px")
print_combo_chart( data.frame( plistsz=rq_data$plistsz, net_pkts_recv=net_data$rxpck_sec ) )
dev.off()
#---------------
disconnect(con)
#---------------
