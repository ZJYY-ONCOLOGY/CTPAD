# 加载R包 --------------------------------------------------------------------
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(shinyFeedback)
library(shinycssloaders)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyhelper)
library(shinyvalidate)
library(htmltools)
library(htmlwidgets)
library(slickR)
library(pdftools)
library(fresh)
library(waiter)
library(DT)
library(dplyr)
library(shinythemes)
library(ggrepel)
library(ComplexHeatmap)
library(circlize)
library(pheatmap)
library(grDevices)
library(enrichplot)
library(ggridges)
library(DOSE)
library(GseaVis)
library(ggraph)
library(tidyverse)
library(ggstatsplot)
library(ggplot2)
library(forcats)
library(ggstance)
library(ggnewscale)
library(stringr)
library(ggpubr)
library(jamba)
library(tidyr)
library(corrplot)
library(ggcorrplot)
library(emayili)
library(colourpicker)
library(dplyr)
library(Seurat)
library(patchwork)
#library(nycflights13)#spinner
options(scipen=999)

# #spinner----
# mycss <- "
#     .plot-container {
#       position: relative;
#     }
#     .loading-spinner {
#       position: absolute;
#       left: 50%;
#       top: 50%;
#       z-index: -1;
#       margin-top: -33px;  /* half of the spinner's height */
#       margin-left: -33px; /* half of the spinner's width */
#     }
#     "
# 环境变量 --------------------------------------------------------------------

data<-read.table("./data/data.txt")
geochoices<-data.frame(geo=data$names,GSE=rownames(data))
geolist <- as.list(geochoices$GSE)
names(geolist) <- geochoices$geo

scgeo<-c("GSE180885","GSE153760","GSE158432","GSE213849_AD")
scname<-c("Atopic dermatitis_GSE180885","Atopic dermatitis_GSE153760",
          "Atopic dermatitis_GSE158432","Atopic dermatitis_GSE213849_AD")
scchoices<-data.frame(scgeo,scname)
sclist<-as.list(scchoices$scgeo)
names(sclist)<-scchoices$scname

title<-read.table("./data/Group/group.txt",header=T,row.names=1)
annogeneset<-c("H: hallmark gene sets"="H",
               "CP: Canonical pathways"="CP",
               "GO: Gene Ontology gene sets"="GO")
immune_algorithm<-c("CIBERSORT",
                   "MCPcounter",
                   "quanTIseq",
                   "xCell",
                   "EPIC")
my36colors<-c("#5d8aa8","#cd9575","#915c83","#8db600","#e9d66b",
              "#b2beb5","#ff9966","#a52a2a","#a1caf1","#f4c2c2",
              "#98777b","#006a4e","#fad6a5","#002e63","#734f96",
              "#cd5b45","#8fbc8f","#e6e8fa","#ffdf00","#a50b5e",
              "#c3b091","#90ee90","#b19cd9","#979aaa","#673147",
              "#808000","#654321","#414a4c","#7D4F73FF","#FEC0A3FF",
              "#7F4B33FF","#A8ABACFF","#3A837DFF","#F79646FF","#C0504DFF",
              "#9B8357FF")

my40colors<-c("#253137","#455a64","#607d8b","#90a4ae",
              "#cfd8dc","#03579b","#0488d1","#03a9f4",
              "#4fc3f7","#b3e5fc","#19237e","#303f9f",
              "#3f51b5","#7986cb","#c5cae9","#4a198c",
              "#7b21a2","#9c27b0","#ba68c8","#e1bee7",
              "#88144f","#c21f5b","#e92663","#f06292",
              "#f8bbd0","#bf360c","#e64a18","#ff5722",
              "#ff8a65","#ffccbc","#f67f17","#fbc02c",
              "#ffec3a","#fff177","#fdf9c3","#33691d",
              "#689f38","#8bc34a","#aed581","#ddedc8")


create_theme(
  theme = "default",
  bs_vars_navbar(
    default_bg = "#d1efd3",
    default_color = "#2c7a2e",
    default_link_color = "black",
    default_link_active_color = "#30C696",
    default_link_active_bg = "#cbe4c7",
    default_link_hover_color = "#9DB71A",
    default_link_hover_bg = "#d5e4d3"
  ),
  bs_vars_global(
    body_bg = "white",
    link_color = "#6C6C6C",
    link_hover_color = "#30C696"
  ),
  bs_vars_wells(
    bg = "#E1E1E1"
    #border = ""
  ),
  bs_vars_tabs(
    border_color = "#d1efd3",
    link_hover_border_color = "#d1efd3",
    active_link_hover_bg = "#d1efd3",
    active_link_hover_color = "black",
    active_link_hover_border_color = "#d1efd3"
  ),
  bs_vars_font(
    size_base = "15px",
    size_large = "20px"),
  bs_vars_color(
    brand_primary = "#87B2C8",
    brand_success = "#EFBA87"
  ),
  output_file = "www/mytheme.css"
)

load("./updated_46_diseaselist_input.Rdata")

# 自定义函数 -------------------------------------------------------------------



# 火山图 ---------------------------------------------------------------------


my_volcano<-function(dataset,customize=T,
                     topgenes=NULL,customizegenes=NULL,
                     log2FC_cutoff,P.Value_cutoff,color1,color2){
  title<-read.table("./data/Group/group.txt",header=T,row.names=1)
  load(paste("./data/DEG/",dataset,"_deg.Rdata",sep = ""))
  
  #确定是上调还是下调，用于给图中点上色
  deg$threshold = factor(ifelse(deg$P.Value < P.Value_cutoff & abs(deg$logFC) >= log2FC_cutoff,
                                ifelse(deg$logFC >= log2FC_cutoff ,'Up','Down'),'Not Sig'),
                         levels=c('Up','Down','Not Sig'))
  deg$gene <- row.names(deg) #添加一列基因名，以便备注
  deg<-deg[order(deg$logFC),]
  
  if(customize == T){
    topgenes<-customizegenes
  }else{
    topgenes<-c(head(rownames(deg),n=topgenes),tail(rownames(deg),n=topgenes))
  }
  
  ggplot(deg,aes(x=logFC,y=-log10(P.Value),color=threshold))+
    geom_point(data = deg[deg$P.Value<P.Value_cutoff&abs(deg$logFC)>log2FC_cutoff,],size = 2.5)+
    geom_point(data = deg[deg$P.Value>P.Value_cutoff|abs(deg$logFC)<log2FC_cutoff,],size = 2.5)+
    scale_color_manual(values=c(color1,"#d2dae2",color2))+#确定点的颜色
    geom_text_repel(#添加关注的点的基因名
      data = deg[topgenes,],#data = deg[c(head(rownames(deg),n=topgenes),tail(rownames(deg),n=topgenes)),],
      aes(label = gene),
      size = 3.5,
      color = "black",
      #box.padding=unit(0.35, "lines"),
      # point.padding=unit(0.5, "lines"),
      segment.color = "black",#设置线段
      segment.size = 0.3,
      show.legend = FALSE,
      max.overlaps = 10
      )+
  # geom_text(
  #   data = deg[c(head(rownames(deg),n=topgenes),
  #          tail(rownames(deg),n=topgenes)),],
  #   aes(label = gene),
  #   size = 3.5,
  #   color = "black"
  #   )+
    xlab(bquote(~log[2]~'fold change'))+#修改x轴名称
    ylab(bquote(~-log[10]~'p-value'))+#修改y轴名称
    geom_vline(xintercept=c(-log2FC_cutoff,log2FC_cutoff),lty=3,col="black",lwd=0.5) +#添加横线|logFoldChange|>0.25
    geom_hline(yintercept = -log10(P.Value_cutoff),lty=3,col="black",lwd=0.5) +#添加竖线padj<0.05
    theme_classic(  # 主题设置，这个是无线条主题
      base_line_size = 0.7 # 坐标轴的粗细
    )+
    ggtitle(title[dataset,])+
    theme(axis.title.x = element_text(size = 18,
                                      color = "black",
                                      face = "plain"),
          axis.title.y = element_text(size = 18,
                                      color = "black",
                                      face = "plain",
                                      vjust = 1.9,
                                      hjust = 0.5,
                                      angle = 90),
          legend.title = element_blank(),
          legend.text = element_text(color="black", # 设置图例标签文字
                                     size = 12,
                                     face = "plain"),
          axis.text.x = element_text(size = 13,  # 修改X轴上字体大小，
                                     color = "black", # 颜色
                                     face = "plain", #  face取值：plain普通，bold加粗，italic斜体，bold.italic斜体加粗
                                     vjust = 0.5, # 位置
                                     hjust = 0.5,
                                     angle = 0), #角度
          axis.text.y = element_text(size = 13,
                                     color = "black",
                                     face = "plain",
                                     vjust = 0.5,
                                     hjust = 0.5,
                                     angle = 0) ,
          plot.title = element_text(size = 15,
                                    face = "bold",
                                    color = "black",
                                    hjust = 0.5),
          plot.margin=unit(rep(1,4),'lines')
    )
}


# 差异基因热图 ------------------------------------------------------------------

my_heatmap<-function(dataset,log2FC_cutoff,customize=T,
                     topgenes=NULL,customizegenes=NULL,
                     color1,color2){
load(paste("./data/DEG/",dataset,"_deg.Rdata",sep = ""))
load(paste("./data/Exp/",dataset,"_exp.Rdata",sep = ""))
group<-read.table(paste("./data/Group/",dataset,".txt",sep = ""),header=T,row.names=1)
grouptitle<-read.table("./data/Group/group.txt",header=T,row.names=1)

group1<-str_split(string = grouptitle[dataset,],pattern = " vs ")[[1]][1]
group2<-str_split(string = grouptitle[dataset,],pattern = " vs ")[[1]][2]

deg<-deg[order(deg$logFC),]

if (customize == T) {
  topgene <- customizegenes
}
else{
  topgene <- c(head(rownames(deg),n=as.numeric(topgenes)/2),
               tail(rownames(deg),n=as.numeric(topgenes)/2))
}

deg_topgene<-deg[topgene,]

deg_topgene$Status = factor(ifelse(abs(deg_topgene$logFC) >= log2FC_cutoff,
                                    ifelse(deg_topgene$logFC >= log2FC_cutoff ,'Up','Down'),'NS'),
                             levels=c('Up','Down','Not Sig'))


for(i in 1:nrow(deg_topgene)){
  deg_topgene[i,"P Value"]<-ifelse(deg_topgene[i,"P.Value"]<0.0001,"****",
                                    ifelse(deg_topgene[i,"P.Value"]<0.001,"***",
                                           ifelse(deg_topgene[i,"P.Value"]<0.01,"**",
                                                  ifelse(deg_topgene[i,"P.Value"]<0.05,"*",""))))
}

deg_topgene$genename<-str_c(rownames(deg_topgene),deg_topgene$`P Value`,sep = " ")
expmatrix<-2^(expmatrix)
htmatrix<-expmatrix[topgene,]


rownames(htmatrix)<-deg_topgene$genename
htmatrix<-as.matrix(htmatrix)

htmatrix = t(apply(htmatrix, 1, scale))
Htcolor<-c(color2, "white", color1)
  
Ht<-Heatmap(htmatrix, col = colorRamp2(c(-2, 0, 2), Htcolor),
            heatmap_legend_param = list(
              title = "expression (Z-score)"),
            top_annotation =HeatmapAnnotation(
              group=group$normgroup,
                #anno_block(gp = gpar(group$normgroup,fill=htcolor)),
             # col = structure(names = c("Island", "Shore", "Shelf", "OpenSea"), c("red", "blue", "green", "#CCCCCC")))
              # show_annotation_name = T,
              show_legend = F,
              col = list(group = c("experiment" = "#a0d0df", "control" = "#e2e283"))
              # cluster = anno_block(gp = gpar(fill = c("#a0d0df", "#e2e283")),
              #                      show_name = F)
            ),
            column_split = group$normgroup,
            show_column_names = F,
            column_title = NULL,
            left_annotation = rowAnnotation(
              Status=deg_topgene$Status,
              show_annotation_name = T,
              show_legend = F,
              col = list(Status = c("Up" = "#da8a67", "Down" = "#a1b873","Not Sig" = "#c9c0bb"))
            ))


lgd_group = Legend(labels = c(group1,group2),
                   title = "group",
                   legend_gp=gpar(fill=c("#a0d0df","#e2e283")))

lgd_status = Legend(labels = c('Up','Down','Not Sig'),
                    title = "status",
                    legend_gp=gpar(fill=c("#da8a67","#a1b873","#c9c0bb")))           
lgd_sig = Legend(pch = c("","","","",""), 
                 title = "P value",
                 type = "points", 
                 labels = c("<0.0001 ****","<0.001 ***","<0.01 **","<0.05 *"),
                 grid_width = unit(0.01, "mm"),
                 background ="white")

draw(Ht, heatmap_legend_list  = list(lgd_group,lgd_status,lgd_sig))
}


# GSEA富集分析点图 ----------------------------------------------------------


enrich_dotplot<-function(dataset,geneset=NULL){
  grouptitle<-read.table("./data/Group/group.txt",header=T,row.names=1)
  load(paste("./Enrichment/",dataset,"_GSEA.Rdata",sep = ""))
  gsea@result <- jamba::renameColumn(gsea@result,
                                     from="description",
                                     to="Description")
    dotplot(gsea,showCategory =geneset,
            title = paste("Dot plot for GSEA (",dataset,", ",grouptitle[dataset,],")",sep = ""),
            font.size = 10)+
      scale_color_continuous(low='#ff8080', high='#88c0fa')+
      theme(plot.title = element_text(hjust = 0.5,face = "bold",size=17))
  
}
# ridgeplot山脊图 ----------------------------------------------------------------


my_ridgeplot<-function(gsea,dataset){
  grouptitle<-read.table("./data/Group/group.txt",header=T,row.names=1)
  
  enrichplot::ridgeplot(gsea,showCategory = 15,core_enrichment = T)+
    ggplot2::scale_fill_gradient(low='#ff9999', high='#b8dafc')+
   ggplot2::ggtitle(paste("Ridgeline plot (",dataset,", ",grouptitle[dataset,],")",sep = ""))+
     ggplot2::theme(plot.title = element_text(hjust = 0.8,face = "bold",size=17),
     axis.text.x = element_text(size= 12),
     axis.text.y = element_text(size= 12))
}


# GSEA图 -------------------------------------------------------------------

mygseaplot<-function(gsea,id,dataset,topgene=T,genenum=25){
  
  if(topgene==T){
   
  gseaNb(object = gsea,
         geneSetID = id,#gsea@result$Description[1],
         newHtCol = c("blue","white", "red"),
         addPval = T,
         pvalX = 0.7,pvalY = 0.8,
         pCol = 'black',
         pHjust = 0,
         nesDigit = 3,
         pDigit = 3,
         addGene = T, #添加基因
         markTopgene = T,
         topGeneN = genenum, #标注前多少个gene
         geneCol = '#4d4d4d', #基因名标签颜色更改
         rmSegment = T #是否移除红线
         
  )}else{
    gseaNb(object = gsea,
             geneSetID = id,#gsea@result$Description[1],
             newHtCol = c("blue","white", "red"),
             addPval = T,
             pvalX = 0.7,pvalY = 0.8,
             pCol = 'black',
             pHjust = 0,
             nesDigit = 3,
             pDigit = 3
    )
  }
  

}



# ssGSEA热图 ----------------------------------------------------------------

myssgseaheatmap<-function(dataset,pathways=NULL,color1,color2){
  load(paste("./Enrichment/ssgsea/",dataset,"_ssgseamat.Rdata",sep = ""))
  load(paste("./Enrichment/ssgsea/",dataset,"_ssgseapvalue.Rdata",sep = ""))
  
  group<-read.table(paste("./data/Group/",dataset,".txt",sep = ""),header=T,row.names=1)
  grouptitle<-read.table("./data/Group/group.txt",header=T,row.names=1)
  
  group1<-str_split(string = grouptitle[dataset,],pattern = " vs ")[[1]][1]
  group2<-str_split(string = grouptitle[dataset,],pattern = " vs ")[[1]][2]
  
  #整理出行名和pvalue
  names(pvalues)<-rownames(ssgsea_mat)
  ssgsea_path<-as.data.frame(pathways)
  colnames(ssgsea_path)<-"name"
  ssgsea_path$pvalue<- pvalues[pathways]
  ssgsea_path$name<-str_replace(ssgsea_path$name, "(.{25})", "\\1\n")#先设置换行
  
  for(i in 1:nrow(ssgsea_path)){
    ssgsea_path[i,"name"]<-ifelse(nchar(ssgsea_path$name[i])>45,
                                        paste(substr((ssgsea_path$name[i]),1,45),"...",sep = ""),
                                     ssgsea_path$name[i])
  }#太长的字符串用省略号代替，也限制了最多两行字
  
  for(i in 1:nrow(ssgsea_path)){
    ssgsea_path[i,"pvalue"]<-ifelse(ssgsea_path[i,"pvalue"]<0.0001,"****",
                                     ifelse(ssgsea_path[i,"pvalue"]<0.001,"***",
                                            ifelse(ssgsea_path[i,"pvalue"]<0.01,"**",
                                                   ifelse(ssgsea_path[i,"pvalue"]<0.05,"*",""))))
  }
  
  ssgsea_path$name<-str_c(ssgsea_path$name,ssgsea_path$pvalue,sep = " ")
  
  htmatrix<-ssgsea_mat[pathways,]
  
  rownames(htmatrix)<-ssgsea_path$name
  htmatrix<-as.matrix(htmatrix)
  htmatrix<-t(apply(htmatrix, 1, scale))
  
  
  Ht<-Heatmap(htmatrix,
              col = colorRamp2(c(-2, 0, 2), c(color2, "white", color1)),
              heatmap_legend_param = list(title = "enrichment score (Z-score)",
                                          direction = "horizontal"),
              top_annotation =HeatmapAnnotation(
                group=group$normgroup,
                show_legend = F,
                col = list(group = c("experiment" = "#a0d0df", "control" = "#e2e283"))
              ),
              column_split = group$normgroup,
              show_column_names = F,
              column_title = NULL,
              row_names_gp = gpar(fontsize = 10),
              row_labels = ssgsea_path$name
  )
  lgd_group = Legend(labels = c(group1,group2),
                     title = "group",
                     legend_gp=gpar(fill=c("#a0d0df","#e2e283")))         
  lgd_sig = Legend(pch = c("","","","",""), 
                   title = "Wilcoxon, p value",
                   type = "points", 
                   labels = c("<0.0001 ****","<0.001 ***","<0.01 **","<0.05 *"),
                   grid_width = unit(0.01, "mm"),
                   background ="white"
                   #nrow = 1 设为水平排列
                   )
  draw(Ht, heatmap_legend_list = list(lgd_group,lgd_sig),
       heatmap_legend_side = "bottom", 
       annotation_legend_side = "bottom")
  
}

# 免疫浸润堆叠图 -----------------------------------------------------------------

mystackplot<-function(immunedata){
  ggplot(immunedata,aes(sample,proportion,fill = celltype)) + 
  geom_bar(stat = "identity") +
  facet_grid(~group,scales = 'free_x',space = "free_x")+
  labs(fill = "Cell Type",x = "",y = "Estiamted Proportion") + 
  theme_bw() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position = "bottom",
        text=element_text(size=11)) + 
  scale_y_continuous(expand = c(0.01,0)) + scale_fill_manual(values = my40colors)
}

# 免疫浸润热图 ------------------------------------------------------------------

myimmuneheatmap<-function(dataset,algorithm,color1,color2){
  load(paste("./ImmuneInfiltration/",dataset,"_",algorithm,".Rdata",sep = ""))
  results<-as.data.frame(results)
  
  group<-read.table(paste("./data/Group/",dataset,".txt",sep = ""),header=T,row.names=1)
  grouptitle<-read.table("./data/Group/group.txt",header=T,row.names=1)
  
  group1<-str_split(string = grouptitle[dataset,],pattern = " vs ")[[1]][1]
  group2<-str_split(string = grouptitle[dataset,],pattern = " vs ")[[1]][2]
  
  results<-t(apply(results, 1, scale))
  #计算wilcoxon p
  pvalues<-sapply(1:nrow(results),function(i){
    data<-cbind.data.frame(results=as.numeric(t(results[i,])),group)
    p=wilcox.test(results~group,data,exact =F)$p.value
    return(p)
  })
  
  names(pvalues)<-rownames(results)
  results_name<-as.data.frame(rownames(results))
  colnames(results_name)<-"name"
  results_name$pvalue<- pvalues
  
  for(i in 1:nrow(results_name)){
    results_name[i,"pvalue"]<-ifelse(results_name[i,"pvalue"]<0.0001,"****",
                                    ifelse(results_name[i,"pvalue"]<0.001,"***",
                                           ifelse(results_name[i,"pvalue"]<0.01,"**",
                                                  ifelse(results_name[i,"pvalue"]<0.05,"*"," "))))
  }
  results_name$name<-str_c(results_name$name,results_name$pvalue,sep = " ")
  Htcolor<-c(color2,"white",color1)
  if(algorithm=="xCell"){
    Ht<-Heatmap(results, 
                col = colorRamp2(c(-2, 0, 2), Htcolor),
                heatmap_legend_param = list(title = "immune score (Z-score)",
                                            direction="horizontal"),
                top_annotation =HeatmapAnnotation(
                  group=group$normgroup,
                  show_legend = F,
                  col = list(group = c("experiment" = "#a0d0df", "control" = "#e2e283"))
                ),
                row_names_gp = gpar(fontsize = 8),
                row_labels = results_name$name,
                column_split = group$normgroup,
                show_column_names = F,
                column_title = NULL
    )
  }else{
  Ht<-Heatmap(results, 
          col = colorRamp2(c(-2, 0, 2), Htcolor),
          heatmap_legend_param = list(title = "immune score (Z-score)",
                                      direction="horizontal"),
          #heatmap_width = unit(14, "cm"), 
          #heatmap_height = unit(10, "cm"),
          top_annotation =HeatmapAnnotation(
            group=group$normgroup,
            show_legend = F,
            col = list(group = c("experiment" = "#a0d0df", "control" = "#e2e283"))
          ),
          row_names_gp = gpar(fontsize = 10),
          row_labels = results_name$name,
          column_split = group$normgroup,
          show_column_names = F,
          column_title = NULL
          )
  }
  lgd_group = Legend(labels = c(group1,group2),
                     title = "group",
                     legend_gp=gpar(fill=c("#a0d0df","#e2e283")))
  lgd_sig = Legend(pch = c("","","","",""), 
                   title = "Wilcoxon, p value",
                   type = "points", 
                   labels = c("<0.0001 ****","<0.001 ***","<0.01 **","<0.05 *"),
                   grid_width = unit(0.01, "mm"),
                   background ="white")
  draw(Ht, heatmap_legend_list = list(lgd_group,lgd_sig),
       heatmap_legend_side = "bottom", 
       annotation_legend_side = "bottom")
  
}



# 免疫浸润Boxplot-------------------------------------------------------------------------
myimmuneboxplot<-function(dataset,algorithm,color1,color2){
  load(paste("./ImmuneInfiltration/",dataset,"_",algorithm,".Rdata",sep = ""))
  results_prop<- apply(results, 2, function(x){x/sum(x)})
  results_prop<-as.data.frame(results_prop)
  results_prop$celltype<-rownames(results_prop)
  results_prop<-as.data.frame(results_prop)
  immunedata<- gather(results_prop,sample,proportion,1:ncol(results))

  
  immunedata$proportion <- as.numeric(immunedata$proportion)
  
  gl<-read.table(paste("./data/Group/",dataset,".txt",sep = ""),
                 header=T,row.names=1)
  group_list <- factor(gl$group)
  # group_list <- factor(group_list,levels = c("Normal","AD"),ordered = F)#对照组在前
  immunedata$group<-rep(group_list,each=nrow(results))
  
  ggplot(immunedata,aes(celltype,proportion,fill = group)) +
    geom_boxplot(outlier.shape = 21,color = "black") +
    theme_bw() +
    labs(x = "Cell Type", y = "Estimated Proportion") +
    theme(legend.position = "top") +
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.text.x = element_text(angle=80,vjust = 1,hjust = 1),
          text = element_text(size = 15))+
    scale_fill_manual(values = c(color1,color2))+#values = c("#006a4e","#a52a2a")
    stat_compare_means(aes(group = group,label = ..p.signif..),
                       symnum.args = list(cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, 1), symbols = c("****", "***", "**", "*", "ns")),
                       method = "wilcox.test"#kruskal.test
                       )
  
}


# 相关性散点图 ---------------------------------------------------------------------

myscattergram<-function(dataset,x=NULL,y=NULL,variable,cor_group,method,color1=NULL,color2=NULL,color3=NULL){
  
  load(paste("./data/Exp/",dataset,"_exp.Rdata",sep = ""))
  load(paste("./Enrichment/ssgsea/",dataset,"_ssgseamat.Rdata",sep = ""))
  group<-read.table(paste("./data/Group/",dataset,".txt",sep = ""),header=T,row.names=1)
  
  expmatrix<-as.data.frame(expmatrix)
  expmatrix<-2^(expmatrix)
  ssgsea_mat<-as.data.frame(ssgsea_mat)
  
  ifelse(variable=="gvp",
         cor_data<-rbind(expmatrix[x,],ssgsea_mat[y,]),
         ifelse(variable=="pvp",
                cor_data<-ssgsea_mat[c(x,y),],
                cor_data<-expmatrix[c(x,y),]))
  
  cor_data<-t(cor_data)
  cor_data<-as.data.frame(cor_data)
  cor_data$sample<-rownames(cor_data)
  cor_data$group<-group$group
  
  colnames(cor_data)[1]<-"X"
  colnames(cor_data)[2]<-"Y"
  
  if(cor_group=="All"){
    cor <- cor.test(cor_data[,1],cor_data[,2],method = "spearman") # 总的相关性分析
    r <- round(cor$estimate,2)
    P <- ifelse(cor$p.value < 0.001," < 0.001", paste0(" = ",round(cor$p.value,2))) 

    
    cor_plot<-ggplot(cor_data, aes(x = X, y = Y))+ 
      geom_point(aes(color = group, shape = group),size=2)+
      xlab(paste(x,
                 ifelse(variable=="pvp",
                        "(ssGSEA)","(expression)"),sep=""))+
      ylab(paste(y,
                 ifelse(variable=="gvg",
                        "(expression)","(ssGSEA)"),sep=""))+
      geom_smooth(aes(color = group ,fill = group), 
                  method = "lm",se = T, fullrange = T,level=0.2) +
      scale_shape_manual(values = c(17, 19))+
      geom_rug(aes(color = group),outside = T,sides = "tr",size = 1)+
      scale_color_manual(values =c(color1, color2))+#values =c("#ca85ca", "#85ca85")
      scale_fill_manual(values = c(color1, color2))+#values =c("#ca85ca", "#85ca85")
      theme_bw() +
      coord_cartesian(clip = "off") +#让数据顶格
      theme(panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            text = element_text(size = 10),
            plot.margin = margin(1, 1, 1, 1, "cm"),
            legend.position = "bottom",
            axis.title.x = element_text(size = 15,
                                        color = "black",
                                        face = "plain"),
            axis.title.y = element_text(size = 15,
                                        color = "black",
                                        face = "plain"),
            axis.text.x = element_text(size = 11,  
                                       color = "black", 
                                       face = "plain", 
                                       vjust = 0.5, 
                                       hjust = 0.5,
                                       angle = 0), 
            axis.text.y = element_text(size = 11,
                                       color = "black",
                                       face = "plain",
                                       vjust = 0.5,
                                       hjust = 0.5,
                                       angle = 0) ,
            legend.title = element_text(color="black", # 设置图例标签文字
                                        size = 12,
                                        face = "plain"),
            legend.text = element_text(color="black", # 设置图例标签文字
                                       size = 12,
                                       face = "plain")
      )
    
     x_range <- layer_scales(cor_plot)$x$range$range#计算坐标轴范围
     y_range <- layer_scales(cor_plot)$y$range$range
     
     cor_plot+annotate("text",
               x=x_range[[1]]+0.11*(diff(x_range)),
               y=y_range[[2]]+0.2*(diff(y_range)),
               label=bquote(~italic(R)~"="~.(r)~","~italic(p)~.(P)))+
      stat_cor(aes(color = group),
               method = method,
               label.y.npc = 0.95,p.accuracy = 0.001,
               show.legend=F)
  }else{
    
    cor_data<-dplyr::filter(cor_data,group==cor_group)
    
    ggplot(cor_data, aes(x = X, y = Y))+ 
      geom_point(color = "grey",size=2)+
      xlab(paste(x,
                 ifelse(variable=="pvp",
                        "(ssGSEA)","(expression)"),sep=""))+
      ylab(paste(y,
                 ifelse(variable=="gvg",
                        "(expression)","(ssGSEA)"),sep=""))+
      geom_smooth(color = "black",method = "lm",se = T, fullrange = T,level=0.2) +
      geom_rug(color = color3,outside = T,sides = "tr",size = 1)+#color = "#ca85ca"
      coord_cartesian(clip = "off") +#让数据顶格
      stat_cor(method = method,
               label.y.npc = 0.95,p.accuracy = 0.001,
               show.legend=F)+
      ggtitle(paste(dataset," (",cor_group,") ",method, ", p-value",sep = ""))+
      theme_bw() +
      theme(panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            text = element_text(size = 10),
            plot.margin = margin(1, 1, 1, 1, "cm"),
            plot.title = element_text(size = 12,
                                      color = "black",
                                      face = "bold",
                                      vjust = 6,#标题向上移动，避免遮挡密度条
                                      hjust = 0.5),#标题居中
            axis.title.x = element_text(size = 12,
                                        color = "black",
                                        face = "plain"),
            axis.title.y = element_text(size = 12,
                                        color = "black",
                                        face = "plain"),
            axis.text.x = element_text(size = 11,  
                                       color = "black", 
                                       face = "plain", 
                                       vjust = 0.5, 
                                       hjust = 0.5,
                                       angle = 0), 
            axis.text.y = element_text(size = 11,
                                       color = "black",
                                       face = "plain",
                                       vjust = 0.5,
                                       hjust = 0.5,
                                       angle = 0) 
      )
  }
  
  
  
}


# 相关性热图

# mycorheatmap<-function(dataset,genes,Group,method){
#   load(paste("./data/Exp/",dataset,"_exp.Rdata",sep = ""))
#   group<-read.table(paste("./data/Group/",dataset,".txt",sep=""),
#                     header=T,row.names=1)
#   
#   cor_data<-t(expmatrix[genes,])
#   
#   
#   if(Group=="All"){
#     NULL
#   }else{
#     cor_data<-as.data.frame(cor_data)
#     cor_data$group<-group$group
#     cor_data<-dplyr::filter(cor_data,group==Group)
#     cor_data<-cor_data[,-ncol(cor_data)]
#     cor_data<-as.matrix(cor_data)
#   }
#   
#   cor_result<-cor(cor_data,method = method)#改
#   cor_result<-as.data.frame(cor_result)
#   cor_result$geneX<-rownames(cor_result)
#   cor_result<-gather(cor_result, geneY, rvalue, 1:(ncol(cor_result)-1))#变成长数据
#   
#   cor_p<-cor.mtest(cor_data)
#   cor_p$pstar <- ifelse(cor_p$p < 0.05,
#                         ifelse(cor_p$p < 0.01,
#                                ifelse(cor_p$p < 0.001,"***","**"),"*"),"")
#   cor_p<-as.data.frame(cor_p$pstar)
#   cor_p$geneX<-rownames(cor_p)
#   cor_p<-gather(cor_p, geneY, pvalue, 1:(ncol(cor_p)-1))#变成长数据
#   
#   cordata<-cbind(cor_result,cor_p)[,-(4:5)]
#   cordata$geneX<-factor(cordata$geneX,levels = head(cordata$geneX,length(genes)))
#   cordata$geneY<-factor(cordata$geneY,levels = head(cordata$geneX,length(genes)))
#   
#   ggplot(cordata, aes(geneX, geneY)) + 
#     geom_tile(aes(fill = rvalue), colour = "white",size=1)+
#     scale_fill_gradient2(low = "#7926db",mid = "white",high = "#ff4d4d")+
#     geom_text(aes(label=pvalue),col ="black",size = 5)+
#     theme_minimal()+# 不要背景
#     theme(axis.title.x=element_blank(),#不要title
#           axis.ticks.x=element_blank(),#不要x轴
#           axis.title.y=element_blank(),#不要y轴
#           axis.text.x = element_text(size = 12,angle = 45, hjust = 1),# 调整x轴文字
#           axis.text.y = element_text(size = 12),
#           text = element_text(size = 12),
#           legend.title = element_text(color="black", # 设置图例标签文字
#                                       size = 12,
#                                       face = "plain"),
#           legend.text = element_text(color="black", # 设置图例标签文字
#                                      size = 12,
#                                      face = "plain")
#           )+
#     #调整legen
#     labs(fill =paste0("*   p < 0.05","\n","**  p < 0.01","\n","*** p < 0.001","\n",
#                       "Correlation","\n","(",method,")"))
# }


# 相关性气泡图 ------------------------------------------------------------------

mycorbubble<-function(dataset,genes,Group,method){
  
  load(paste("./data/Exp/",dataset,"_exp.Rdata",sep = ""))
  group<-read.table(paste("./data/Group/",dataset,".txt",sep=""),
                    header=T,row.names=1)
  expmatrix<-2^(expmatrix)
  cor_data<-t(expmatrix[genes,])
  
  if(Group=="All"){
    NULL
  }else{
    cor_data<-as.data.frame(cor_data)
    cor_data$group<-group$group
    cor_data<-dplyr::filter(cor_data,group==Group)
    cor_data<-cor_data[,-ncol(cor_data)]
    cor_data<-as.matrix(cor_data)
  }
  
  
  env.cor <- round(cor(cor_data, method = method),2)
  diag(env.cor)<-0#对角线值为0
  env.p <-round(cor_pmat(cor_data,method = method),2)
  diag(env.p)<-1
  
  if(length(genes)<10){
  corrplot(corr =env.cor, p.mat = env.p,
           title=paste(dataset,"(",Group,") ",method, ", p-values",sep = ""),
           mar=c(0,0,2,0),#为了标题在合适位置mar=c(0,0,1,0)
           method = "square",type = "upper",
           tl.pos="lt",tl.srt = 45,#坐标轴文字
           insig="label_sig",
           sig.level = c(.001, .01, .05),
           pch.cex = 1,diag=T,
           tl.cex=1.2, tl.col="black",
           col = COL2("PRGn")
             #colorRampPalette(colors = c('#80fcfe', '#ff80fc'))(10)
  ) # 用*作为显著性标签，sig.level参数表示0.05用*表示。0.01用**。0.001用***。pch.cex = 0.8,用于设置显著性标签的字符大小。
  corrplot(corr = env.cor,type="lower",
           add=TRUE,method="number",
           tl.pos = "n",cl.pos = "n",diag=F,col = "black",number.cex = 1) 
  
  }else if(length(genes)>=10 &&length(genes)<=15){
    corrplot(corr =env.cor, p.mat = env.p,
             title=paste(dataset,"(",Group,") ",method, ", p-values",sep = ""),
             mar=c(0,0,1,0),#为了标题在合适位置mar=c(0,0,1,0),
             method = "square",type = "upper",
             tl.pos="lt",tl.srt = 45,#坐标轴文字
             insig="label_sig",
             sig.level = c(.001, .01, .05),
             pch.cex = 0.8,diag=T,
             tl.cex=1, tl.col="black",
             col = COL2("PRGn")
             #colorRampPalette(colors = c('#80fcfe', '#ff80fc'))(10)
    ) # 用*作为显著性标签，sig.level参数表示0.05用*表示。0.01用**。0.001用***。pch.cex = 0.8,用于设置显著性标签的字符大小。
    corrplot(corr = env.cor,type="lower",
             add=TRUE,method="number",
             tl.pos = "n",cl.pos = "n",diag=F,col = "black",number.cex = 0.9) 

  }else{
    corrplot(corr =env.cor, p.mat = env.p,
             title=paste(dataset," (",Group,") ",method, ", p-value",sep = ""),
             mar=c(0,0,1,0),#为了标题在合适位置
             method = "square",type = "upper",
             tl.pos="lt",tl.srt = 45,#坐标轴文字
             insig="label_sig",
             sig.level = c(.001, .01, .05),
             pch.cex = 0.8,diag=T,
             tl.cex=0.9, tl.col="black",
             col = COL2("PRGn")
             #colorRampPalette(colors = c('#80fcfe', '#ff80fc'))(10)
    ) # 用*作为显著性标签，sig.level参数表示0.05用*表示。0.01用**。0.001用***。pch.cex = 0.8,用于设置显著性标签的字符大小。
    corrplot(corr = env.cor,type="lower",
             add=TRUE,method="number",
             tl.pos = "n",cl.pos = "n",diag=F,col = "black",number.cex = 0.8) 
    
  }
  }

# comment box ---------------
#实现红⾊星号提⽰必选项:
labelMandatory <- function(label) {
tagList(
  label,
  span("*", class = "mandatory_star")
)
}
appCSS <- ".mandatory_star { color: red; }"
