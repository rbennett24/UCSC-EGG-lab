############################
# EGG data analysis for 2019 Kaqchikel data
############################

############
# TO DO
############
# Facet by context and consonant identity


library(tidyr) # for data organization and manipulation
library(plyr)

library(ggplot2) # for plotting

# Colorblind friendly color palette
# http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
cbPalette <- c("#000000","#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
yelCol = cbPalette[6]
lightBlue = cbPalette[4]
orng  = cbPalette[3]

library(extrafont) # Try to make plots using the SILDoulos IPA font
font_import(prompt = F,pattern="DoulosSIL-R") # Import system fonts -- this can take awhile if you import them all.
# loadfonts(device = "win") # I think you only need to do this once so that R imports all the needed files to a place it can draw on them?
# windowsFonts() # This will just show you which fonts are available to R -- it may be a long list!


# Load the text file of laryngeal timing measurements.
computer <- "510fu"
#basedir<-paste0("C:\\Users\\",computer,"\\Dropbox\\Research\\Mayan\\Uspanteko\\Uspanteko_NSF_project\\Recordings\\")
basedir<-paste0("C:\\Users\\",computer,"\\Desktop\\Kaq_EGG_recordings\\")

# Load the text file of EGG traces
datafolder <- paste0(basedir,"\\Signal_processed\\EGG_extrema\\txt_measures\\")
setwd(datafolder)

# Directory for saving images
outdir<-paste0(basedir,"\\Plots\\") # Where will plots be saved?
if (dir.exists(outdir)){
  # do nothing
  } else {
  dir.create(outdir)
    }

# Need some special options to handle special characters <# '> in the input files 
Lx.timing<-read.table("glottal_timing.txt",header=T,comment.char = "",quote="\"")
Lx.traces<-read.table("EGG_traces.txt",header=T,comment.char = "",quote="\"")


###########################
# Add factors
###########################
levels(Lx.traces$seg)

Lx.traces$glot.type<-revalue(Lx.traces$seg,
                             c("p" = "Plain", "t" = "Plain", "k" = "Plain", "q" = "Plain",
                               "tz" = "Plain", "ch" = "Plain",
                               "b'" = "Glottalized", "t'" = "Glottalized", "k'" = "Glottalized", "q'" = "Glottalized",
                               "tz'" = "Glottalized", "ch'" = "Glottalized"))

Lx.timing$glot.type<-revalue(Lx.timing$seg,
                             c("p" = "Plain", "t" = "Plain", "k" = "Plain", "q" = "Plain",
                               "tz" = "Plain", "ch" = "Plain",
                               "b'" = "Glottalized", "t'" = "Glottalized", "k'" = "Glottalized", "q'" = "Glottalized",
                               "tz'" = "Glottalized", "ch'" = "Glottalized"))


###########################
# Plot EGG traces and signal landmark distributions in normalized time
###########################

########
# TO DO
# - Hide annotation from plain stop facet, or otherwise just subset data for two different plots rather than faceting.
# Probably: create a 2x2 data frame glot.type x label showing "glottalized" in one column and then text labels in the other column, then use geom_text instead of annotate to bring it in.
# https://stackoverflow.com/questions/11889625/annotating-text-on-individual-facet-in-ggplot2
# https://stackoverflow.com/questions/45214725/use-ggplots-annotate-only-within-one-facet
# https://buzzrbeeline.blog/2018/11/06/adding-different-annotation-to-each-facet-in-ggplot/
#
# - Facet by context and consonant identity too
# - decide on what landmarks you actually want to plot here.
# - remove outliers?

# Set a base plot for time-normalized EGG traces
Lx.trace.base<-ggplot(data=Lx.traces,
                      aes(x=stepPerc,y=Amp))+
                      #geom_line(color="grey65",alpha=0.45)+
                      geom_point(color="grey65",alpha=0.1)+
                      
                      theme_bw(base_size=24)+
                      
                      xlab("Normalized time")+
                      ylab("Amplitude")+
                      ggtitle("")


# Smooth the raw EGG signal
# http://statseducation.com/Introduction-to-R/modules/graphics/smoothing/
Lx.trace.loess<-Lx.trace.base+
                   geom_smooth(method="loess",span=0.1,lwd=4)
#                  geom_smooth(method="gam", formula = y ~s(x),span=0.25,lwd=4)


# Prepare some text for annotating facets
# You are doing this in such a way that only one facet will be annotated.
# To annotate both, use the "annotate" function instead.
relText<-data.frame(stepPerc=median(Lx.timing$RelTimeNorm,na.rm=T)-0.1,Amp=0.9,glot.type=factor("Glottalized",levels=levels(Lx.timing$glot.type)))

lxmaxText<-data.frame(stepPerc=median(Lx.timing$LxMaxTimeNorm,na.rm=T)-0.1,Amp=0.9,glot.type=factor("Glottalized",levels=levels(Lx.timing$glot.type)))


# Add distribution of stop releases
Lx.trace.rel<-Lx.trace.loess+
                    geom_density(data=Lx.timing,
                      inherit.aes = F,
                      aes(x=RelTimeNorm,y = ..scaled..),
                      fill=yelCol,alpha=0.25,color="black",lwd=1.25)+
                      
                      # For label font properties, see:
                      # http://www.cookbook-r.com/Graphs/Fonts/
                      geom_text(data=relText,label="Releases",
                                fontface="bold",size=5)
                      #annotate("text",x=median(Lx.timing$RelTimeNorm,na.rm=T)-0.1,y=0.9,
                      #         label="Releases",fontface="bold",size=5)


# Add disitribution of Lx maxima
Lx.trace.rel.max<-Lx.trace.rel+
                    geom_density(data=Lx.timing,
                       inherit.aes = F,
                       aes(x=LxMaxTimeNorm,y = ..scaled..),
                       fill=lightBlue,alpha=0.25,color="black",lty="dashed",lwd=1.25)+
                      
                       geom_text(data=lxmaxText,label="Lx maxima",
                                fontface="bold",size=5)
                       # annotate("text",x=median(Lx.timing$LxMaxTimeNorm,na.rm=T)-0.1,y=0.9,
                       #           label="EGG maxima",fontface="bold",size=5)


Lx.trace.rel.max

Lx.trace.rel.max.facet <- Lx.trace.rel.max+facet_wrap(.~glot.type)
Lx.trace.rel.max.facet

cairo_pdf(file=paste(outdir,"egg_trace_all.pdf",sep=""),
          width=14,height=8)

    print(Lx.trace.rel.max.facet)

dev.off()

###########################
# Plot distributions of lag values as combined violin + box plots.
###########################

########
# TO DO
# - remove outliers?
# - Facet by context and consonant identity

# Restructure input data so that different lag types are treated like factors
Lx.timing.short<-gather(data=Lx.timing,key="Lag.type",value="Lag",MinusSegStart:MinusClosureMid)
head(Lx.timing.short)

# Define a custom function for plotting number of observations in each condition.
# http://stackoverflow.com/questions/15660829/how-to-add-a-number-of-observations-per-group-and-use-group-mean-in-ggplot2-boxp
#
give.n <- function(x,ypos=min(Lx.timing.short$Lag,na.rm=T)-100){
  # Setting the value of y here affects the vertical positioning of the labels.
  data.frame(y = ypos, label = paste0("n=",length(x)))
}

# Rename lag types
Lx.timing.short$Lag.type<-revalue(Lx.timing.short$Lag.type,c("MinusClosureMid" = "Closure Midpoint",
                                                             "MinusRel" = "Release",
                                                              "MinusSegEnd" = "Stop offset",
                                                              "MinusSegStart" = "Stop onset"
                                                              ))

# Start base violin + box plot
lag.base<-ggplot(data=Lx.timing.short,
                 aes(y=Lag*1000,x=Lag.type,
                     fill=Lag.type,
                     color=Lag.type))+
                   
  xlab("Lag type")+
  ylab("Lag (ms)")+
  
  theme_bw(base_size=24)+
  theme(panel.grid.major.y = element_line(colour = "grey75"))+
  
  geom_violin(scale="width",width=.75,trim=T,
              show.legend=F
  )+
  
  # Set color palette
  scale_fill_manual(values=cbPalette)+
  scale_color_manual(values=cbPalette)+
    
  # Hide legends.
  guides(fill=FALSE,color=FALSE)+
  
  geom_boxplot(width=0.2,color="black",coef=0,outlier.colour = NA,fill="white")+
  stat_summary(fun.y="median",geom='point',size=6,pch=18)+
  stat_summary(fun.y="mean",fun.ymin="mean",fun.ymax="mean",
               geom="crossbar",width=0.75,lwd=.4,lty="solid",col="black")+
  
  stat_summary(fun.data = give.n, geom = "text", size=7,
               col="black",fontface="bold")+
  
  ggtitle("Lx maximum timing relative to:")

lag.base

cairo_pdf(file=paste(outdir,"lag_raw_all.pdf",sep=""),
          width=9.5,height=7.5)

    print(lag.base)

dev.off()


###################
# Convert values into relative standard deviations (RSDs) using dplyr
# (see e.g. Shaw et al. 2009)
Lx.timing.rsd <- ddply(Lx.timing.short, c("seg","segContext","Lag.type"), summarise,
                    N    = length(Lag),
                    mean = mean(Lag,rm.na=T),
                    sd   = sd(Lag,na.rm=T),
                    rsd   = 100 * sd / mean
)

Lx.timing.rsd


##############
# Before relying on RSD, check for correlation between SD and mean.
# Think about how exactly you want to visualize this, and how you want to facet by context and consonant identity
#
# Also: compute lmer using lag type as a predictor of lag, as in e.g. Shaw et al. 2009? They did ANOVA though, which might make more sense here.




###########################
# Plot distributions of Lx maxima as combined violin + box plots.
###########################

# Function for plotting number of observations
give.n <- function(x,ypos=0){
  # Setting the value of y here affects the vertical positioning of the labels.
  data.frame(y = ypos, label = paste0("n=",length(x)))
}

# Start base violin + box plot
lxmax.base<-ggplot(data=Lx.timing,
                 aes(y=LxMax,x=seg,
                     fill=seg,
                     color=seg))+
  
  xlab("Segment type")+
  ylab("Lx Maximum Value")+
  
  theme_bw(base_size=24)+
  theme(panel.grid.major.y = element_line(colour = "grey75"))+
  
  geom_violin(scale="width",width=.75,trim=T,
              show.legend=F
  )+
  
  # Set color palette
  scale_fill_manual(values=cbPalette)+
  scale_color_manual(values=cbPalette)+
  
  # Hide legends.
  guides(fill=FALSE,color=FALSE)+
  
  geom_boxplot(width=0.2,color="black",coef=0,outlier.colour = NA,fill="white")+
  stat_summary(fun.y="median",geom='point',size=6,pch=18)+
  stat_summary(fun.y="mean",fun.ymin="mean",fun.ymax="mean",
               geom="crossbar",width=0.75,lwd=.4,lty="solid",col="black")+
  
  stat_summary(fun.data = give.n, geom = "text", size=7,
               col="black",fontface="bold")+
  
  ggtitle("Distributions of Lx maxima across segment types")

lxmax.base

cairo_pdf(file=paste(outdir,"lxmax_x_seg.pdf",sep=""),
          width=11.5,height=7.5)

  print(lxmax.base)

dev.off()