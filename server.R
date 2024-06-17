# SERVER.R ----------------------------------------------------------------
shinyServer(
  function(input, output,session){
    
    #改变tabsetpanel的class,使不同的tab标题均匀排列于一行的空间
    shinyjs::addClass(class = "nav nav-tabs nav-justified", selector = '[class="nav nav-tabs"]')

# 1. 轮播图 ---------------------------------------------------------------------


    output$slick_output<-renderSlickR({
      
      imgs0 <- pdftools::pdf_convert("./www/carousel/workflow.pdf",format = 'png',verbose = FALSE)
      imgs1 <- pdftools::pdf_convert("./www/carousel/fig1.pdf",format = 'png',verbose = FALSE)
      imgs2 <- pdftools::pdf_convert("./www/carousel/fig2-1 (1).pdf",format = 'png',verbose = FALSE)
      imgs3 <- pdftools::pdf_convert("./www/carousel/fig2-1 (2).pdf",format = 'png',verbose = FALSE)
      imgs4 <- pdftools::pdf_convert("./www/carousel/fig3.pdf",format = 'png',verbose = FALSE)
      imgs5 <- pdftools::pdf_convert("./www/carousel/fig4.pdf",format = 'png',verbose = FALSE)
      slickR(c(imgs0,imgs1,imgs2,imgs3,imgs4,imgs5),height = 600,width = "100%") + 
        settings(dots = TRUE,autoplay = T,autoplaySpeed = 5000)
    })
    
 # 2. Expression Analysis ---------------------------------------------------
      # 2.1 volcano --------------------------------------------------------------

    observe_helpers(withMathJax = TRUE)#helper的server端控制
  
    observeEvent(list(input$dataset2_1,input$Customize2_1==T),{
      load(paste("./data/gene/",isolate(input$dataset2_1),"_gene.Rdata",sep = ""))
      
      updateSelectizeInput(
        session,
        inputId = "customize_genes2_1",
        choices = gene$`gene symbol`,
        selected = gene$`gene symbol`[1:5],
        server = T
      )
    })
    
    observeEvent(list(input$dataset2_1,input$customize_genes2_1), {
      if (length(input$customize_genes2_1) > 20) {
        showFeedbackDanger(
          inputId = "customize_genes2_1",
          text = "Warning, please choose 1~20 gene symbol(s)!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit2_1")
        #showToast('error', 'Danger if > 20 genes')
      } else if(length(input$customize_genes2_1) < 1){
        showFeedbackDanger(
          inputId = "customize_genes2_1",
          text = "Warning, please choose 1~20 gene symbol(s)!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit2_1")
        #showToast('error', 'Danger if < 3 genes')
      }
      else if(length(input$customize_genes2_1)>=1 && length(input$customize_genes2_1) <= 20){
        hideFeedback("customize_genes2_1")
        #showToast('success', 'Success!')
        shinyjs::enable("submit2_1")
      }
      
    })
    
  
    
    observeEvent(input$markgeneN, {
      if(is.na(input$markgeneN)){
        showFeedbackDanger(
          inputId = "markgeneN",
          text = "Please enter a number between 1~10",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit2_1")
      }else if (input$markgeneN > 10) {
        showFeedbackDanger(
          inputId = "markgeneN",
          text = "The value must between 1~10",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit2_1")
      } else if(input$markgeneN < 1){
        showFeedbackDanger(
          inputId = "markgeneN",
          text = "The value must between 1~10",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit2_1")
      }
      else if(input$markgeneN>=1 && input$markgeneN <= 10){
        hideFeedback("markgeneN")
        shinyjs::enable("submit2_1")
      }
    })
    
    
    volcano<-eventReactive(input$submit2_1,{
      if(input$Customize2_1==T){
    my_volcano(input$dataset2_1,
               log2FC_cutoff=as.numeric(input$log2FC1),
               P.Value_cutoff=as.numeric(input$p.value),
               customizegenes=isolate(input$customize_genes2_1),
               color1=input$color2_2_1,
               color2=input$color1_2_1)
      }else{
        my_volcano(input$dataset2_1,
                   customize=F,
                   log2FC_cutoff=as.numeric(input$log2FC1),
                   P.Value_cutoff=as.numeric(input$p.value),
                   topgenes=as.numeric(input$markgeneN),
                   color1=input$color2_2_1,
                   color2=input$color1_2_1)
      }
    })
    
    # observe({
    #   toggle(id = 'volcanoPlot', condition = FALSE)#隐藏
      
      output$volcanoPlot <- renderPlot({
        shiny::validate(need(input$submit2_1, ""))
        
        progress <- Progress$new(session, min=1, max=5)
        on.exit(progress$close())
        
        progress$set(message = 'Making volcano plot',
                     detail = 'This may take a while...')
        
        for (i in 1:5) {
          progress$set(value = i)
          Sys.sleep(0.5)
        }
        volcano()
      }, res = 96)
      

      # output$png2_1 <- downloadHandler(
      #     filename = function() {
      #       paste(input$dataset2_1, "_expression_volcano",".png", sep = "")
      #     },
      #     content = function(file) {
      #       ggsave(file, plot = volcano(), device = "png", width = 7, height = 6,bg ="white")
      #     }
      #   )
      output$pdf2_1 <- downloadHandler(
        filename = function() {
          paste(input$dataset2_1, "_expression_volcano",".pdf", sep = "")
        },
        content = function(file) {
          pdf(file,width = 7, height = 6,compress = F)#family参数导出pdf设置字体:family="Arial"
          plot(volcano())
          dev.off()
        }
      )
    
    

      # 2.2 heatmap -------------------------------------------------------------
      
    
      observeEvent(list(input$dataset2_2,input$Customize2_2==T),{
        load(paste("./data/gene/",isolate(input$dataset2_2),"_gene.Rdata",sep = ""))
        
        updateSelectizeInput(
          session,
          inputId = "customize_genes2_2",
          choices = gene$`gene symbol`,
          selected = gene$`gene symbol`[1:10],
          server = T
        )
      })
      
    observeEvent(list(input$dataset2_2,input$customize_genes2_2), {
      if (length(input$customize_genes2_2) > 20) {
        showFeedbackDanger(
          inputId = "customize_genes2_2",
          text = "Warning, the number of genes is more than 20!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit2_2")
        #showToast('error', 'Danger if > 20 genes')
      } else if(length(input$customize_genes2_2) < 3){
        showFeedbackDanger(
          inputId = "customize_genes2_2",
          text = "Warning, the number of genes is less than 3!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit2_2")
        #showToast('error', 'Danger if < 3 genes')
      }
      else if(length(input$customize_genes2_2)>=3 && length(input$customize_genes2_2) <= 20){
        hideFeedback("customize_genes2_2")
        #showToast('success', 'Success!')
        shinyjs::enable("submit2_2")
      }
      
    })
    
    heatmap<-eventReactive(input$submit2_2,{
      if(input$Customize2_2==T){
        my_heatmap(isolate(input$dataset2_2),
                   isolate(input$log2FC2),
                   customize=T,
                   customizegenes=isolate(input$customize_genes2_2),
                   color1=isolate(input$color1_2_2),
                   color2=isolate(input$color2_2_2))
      }else{
        my_heatmap(isolate(input$dataset2_2),
                   isolate(input$log2FC2),
                   customize=F,
                   topgenes=isolate(input$topgenes),
                   color1=isolate(input$color1_2_2),
                   color2=isolate(input$color2_2_2))
      }
      
    })
    
   
    
      output$heatmapplot=renderPlot({
        shiny::validate(need(input$submit2_2, ""))
        
        # dat <- data.frame(x = numeric(0), y = numeric(0))
        # 
        # withProgress(message = 'Making heatmap', value = 0, {
        #   n <- 10
        #   for (i in 1:n) {
        #     dat <- rbind(dat, data.frame(x = rnorm(1), y = rnorm(1)))
        #     incProgress(1/n, detail = paste("Doing part", i))
        #     Sys.sleep(0.1)
        #   }
        # })
        progress <- Progress$new(session, min=1, max=5)
        on.exit(progress$close())
        
        progress$set(message = 'Making heatmap',
                     detail = 'This may take a while...')
        
        for (i in 1:5) {
          progress$set(value = i)
          Sys.sleep(0.5)
        }
        
        heatmap()
        
      
      }, res = 96)

      
      output$pdf2_2 <- downloadHandler(
        filename = function() {
          paste(input$dataset2_1, "_expression_heatmap",".pdf", sep = "")
        },
        content = function(file) {
          pdf(file,width = 8,height = 5.5,compress = F)
         print(heatmap())
          dev.off()
        }
      )
      
      
      
      # 2.3 table ---------------------------------------------------------------
      
      
      
      deg2_3<-eventReactive(input$dataset2_3,{
        
        load(paste("./data/DEG/",input$dataset2_3,"_deg.Rdata",sep = ""))
        deg<-round(deg,5)
        deg[,4:5] <- format(deg[,4:5],scientific=T)
        deg
      })
        
    output$DEGList=renderUI({
         DT::datatable(deg2_3(),options = list(pageLength = 10))
    })
    
    output$download2_3 <- downloadHandler(
      filename = function() {
        paste(paste0(input$dataset2_3, "_gene"), ".csv", sep = "")
      },
      content <- function(file) {
        load(paste("./data/DEG/",input$dataset2_3,"_deg.Rdata",sep = ""))
        write.csv(
          round(deg,5),
          file)
      }
    )
    

 # 3. Enrichment Analysis --------------------------------------------------


   
      # 3.1 GSEA ----------------------------------------------------------------

            # 3.1.1 Dot Plot-------------------------------------------------------------------


    
    genesetlist_gsea<-eventReactive(input$dataset3_2_1,{
      load(paste("./Enrichment/genesetlist/",isolate(input$dataset3_2_1),
            "_GSEA_list.Rdata",sep = ""))
      genesetlist
    })
    
  
    
    
    observeEvent(input$dataset3_2_1,{
      #freezeReactiveValue(input, "customize_genesets_gsea")
      updateSelectizeInput(
        session = session,
        inputId = "customize_genesets_gsea",
        choices = genesetlist_gsea(),
        selected = genesetlist_gsea()[1:10],
        server = T
      )
    })
    
    observeEvent(input$customize_genesets_gsea, {
      if (length(input$customize_genesets_gsea) > 20) {
        showFeedbackDanger(
          inputId = "customize_genesets_gsea",
          text = "Warning, the number of gene sets is more than 20!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
          )
        shinyjs::disable("submit3_2_1")
        
      } else if(length(input$customize_genesets_gsea) < 2){
        showFeedbackDanger(
          inputId = "customize_genesets_gsea",
          text = "Warning, the number of gene sets is less than 2!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit3_2_1")
      }
      else if(length(input$customize_genesets_gsea)>=2 && length(input$customize_genesets_gsea) <= 20){
        hideFeedback("customize_genesets_gsea")
        shinyjs::enable("submit3_2_1")
      }
      
    })
  
    mydotplot2<-eventReactive(input$submit3_2_1,{
      
        enrich_dotplot(isolate(input$dataset3_2_1),
                         isolate(input$customize_genesets_gsea))
      
    })
    
    output$dotplot2 <- renderPlot({
      shiny::validate(need(input$submit3_2_1, ""))
      
      
      progress <- Progress$new(session, min=1, max=30)
      on.exit(progress$close())
      
      progress$set(message = 'Making dotplot',
                   detail = 'This may take a while...')
      
      for (i in 1:30) {
        progress$set(value = i)
        Sys.sleep(0.1)
      }
      mydotplot2()
      
      
      
    })
    
  
    
    output$pdf3_2_1 <- downloadHandler(
      filename = function() {
        paste(input$dataset3_2_1, "_GSEA_dotplot",".pdf",sep = "")
      },
      content <- function(file) {
          pdf(file,width = 10,height = 8,compress = F)
          print(mydotplot2())
          dev.off()
        }
      
    )

            # 3.1.2 Ridgeline Plot -----------------------------------------------------

    
    
    
    myridgeplot<-eventReactive(input$submit3_2_2,{
      load(paste("./Enrichment/",isolate(input$dataset3_2_2),"_",isolate(input$annotated3_2_2),"_GSEA.Rdata",sep = ""))
      
      my_ridgeplot(isolate(gsea),isolate(input$dataset3_2_2))
       # ridgeplot(isolate(gsea),showCategory = 15,core_enrichment = T)+     
       #   #scale_fill_gradient(low='#ff9999', high='#b8dafc')+
       #   ggtitle(paste("Ridgeline-plot (",isolate(input$dataset3_2_2),", ",grouptitle[isolate(input$dataset3_2_2),],")",sep = ""))+
       #   theme(plot.title = element_text(hjust = 0.8,face = "bold",size=17),
       #         axis.text.x = element_text(size= 12),
       #         axis.text.y = element_text(size= 12))
    })
    
    output$ridgeplot<-renderPlot({
      shiny::validate(need(input$submit3_2_2, ""))
      
      
      progress <- Progress$new(session, min=1, max=30)
      on.exit(progress$close())
      
      progress$set(message = 'Making ridgeline plot',
                   detail = 'This may take a while...')
      
      for (i in 1:30) {
        progress$set(value = i)
        Sys.sleep(0.1)
      }
      myridgeplot()
    }
    )
    
    
    output$pdf3_2_2 <- downloadHandler(
      filename = function() {
        paste(input$dataset3_2_2, "_GSEA_ridgelineplot",".pdf",sep = "")
      },
      content <- function(file) {
          pdf(file,width = 11,height = 12,compress = F)
          print(myridgeplot())
          dev.off()
        }
      
    )
    

            # 3.1.3 GSEA plot ---------------------------------------------------------

    
    
    gseasetid<-eventReactive(list(input$dataset3_2_3,input$annotated3_2_3),{
      
      load(paste("./Enrichment/",isolate(input$dataset3_2_3),"_",isolate(input$annotated3_2_3),"_GSEA.Rdata",sep = ""))
      gsea@result$Description
    })
    
    
    observeEvent(list(input$dataset3_2_3,input$annotated3_2_3),{
     # freezeReactiveValue(input, "gseasets")
      updateSelectizeInput(
        session = session,
        inputId = "gseasets",
        choices = isolate(gseasetid()),
        server = T
      )
    })
    
    observeEvent(input$gseasets,{
    if(input$gseasets==''){
      showFeedbackDanger(
        inputId = "gseasets",
        text = "Please choose a gene set!",
        color  =  "#d9534f" ,
        icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
      )
      shinyjs::disable("submit3_2_3")
    }else{
      hideFeedback("gseasets")
      shinyjs::enable("submit3_2_3")
    }
    })
    
    observeEvent(input$topgeneN, {
      if(is.na(input$topgeneN)){
        showFeedbackDanger(
          inputId = "topgeneN",
          text = "Please enter a number between 1~50",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit3_2_3")
      }else if (input$topgeneN > 50) {
        showFeedbackDanger(
          inputId = "topgeneN",
          text = "The value must between 1~50",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit3_2_3")
      } else if(input$topgeneN < 1){
        showFeedbackDanger(
          inputId = "topgeneN",
          text = "The value must between 1~50",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit3_2_3")
      }
      else if(input$topgeneN>=1 && input$topgeneN <= 50){
        hideFeedback("topgeneN")
        shinyjs::enable("submit3_2_3")
      }
    })
    
   mygsea<-eventReactive(input$submit3_2_3,{
     load(paste("./Enrichment/",isolate(input$dataset3_2_3),"_",isolate(input$annotated3_2_3),"_GSEA.Rdata",sep = ""))
     if(input$topgene==T){
       mygseaplot(gsea = isolate(gsea),
                  id = isolate(input$gseasets),
                  dataset = isolate(input$dataset3_2_3),
                  topgene=T,
                  genenum=isolate(input$topgeneN))
     }else{
       mygseaplot(gsea = isolate(gsea),
                  id = isolate(input$gseasets),
                  dataset = isolate(input$dataset3_2_3),
                  topgene=F)
     }
     
   })
   
    output$gseaplot<-renderPlot({
      shiny::validate(need(input$submit3_2_3, ""))
      
      progress <- Progress$new(session, min=1, max=100)
      on.exit(progress$close())
      
      progress$set(message = 'Making GSEA plot',
                   detail = 'This may take a while...')
      
      for (i in 1:100) {
        progress$set(value = i)
        Sys.sleep(0.1)
      }
      mygsea()
    })

 
        
    output$pdf3_2_3 <- downloadHandler(
      filename = function() {
        paste(input$dataset3_2_3, "_GSEA_plot",".pdf",sep = "")
      },
      content <- function(file) {
          pdf(file,width = 8,height = 6,compress = F)
          print(mygsea())
          dev.off()
        }
      
    )

            # 3.1.4 Table -------------------------------------------------------------

 
    output$enrichlist2=renderUI({
      
      load(paste("./Enrichment/",input$dataset3_2_4,"_",input$annotated3_2_4,"_GSEA.Rdata",sep = ""))
      
      rownames(gsea@result)<-NULL
      gsea@result[,(4:8)]<-round(gsea@result[,(4:8)],5)
      gsea@result[,6:8] <- format(gsea@result[,6:8],scientific=T)
      DT::datatable(gsea@result[,-2],extensions = 'Responsive',options = list(columnDefs = list(list(
        targets = 1,
        render = JS(
          "function(data, type, row, meta) {",
          "return type === 'display' && data.length > 35 ?",
          "'<span title=\"' + data + '\">' + data.substr(0, 35) + '...</span>' : data;",
          "}")
      )),pageLength = 10)
      )
      
    })
    
    
    output$download3_2_4 <- downloadHandler(
      filename = function() {
        paste(input$dataset3_2_4,"_",input$annotated3_2_4, "_GSEA.csv", sep = "")
      },
      content <- function(file) {
        load(paste("./Enrichment/",input$dataset3_2_4,"_",input$annotated3_2_4,"_GSEA.Rdata",sep = ""))
        rownames(gsea@result)<-NULL
        gsea@result[,(4:8)]<-round(gsea@result[,(4:8)],5)
        write.csv(
          gsea@result[,-2],
          file)
      }
    )

    
# 3.2 ssGSEA---------------------------------------------------------------------


# 3.2.1 Heatmap-------------------------------------------------------------------

   
    
    observeEvent(list(input$dataset3_3_1,input$Customize2==T),{
      #freezeReactiveValue(input,"pathway3_3")
      load(paste("./Enrichment/ssgsea/",isolate(input$dataset3_3_1),"_ssgseapathway.Rdata",sep = ""))
      
      updateSelectizeInput(
        session = session,
        inputId = "pathway3_3",
        choices = pathway$pathway,
        selected = pathway$pathway[1:10],
        server = T
      )
    })
    
    observeEvent(input$pathway3_3, {
      if (length(input$pathway3_3) > 20) {
        showFeedbackDanger(
          inputId = "pathway3_3",
          text = "Warning, the number of pathways is more than 20!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit3_3_1")
      } else if(length(input$pathway3_3) < 3){
        showFeedbackDanger(
          inputId = "pathway3_3",
          text = "Warning, the number of pathways is less than 3!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit3_3_1")
      }
      else if(length(input$pathway3_3)>=3 && length(input$pathway3_3) <= 20){
        hideFeedback("pathway3_3")
        shinyjs::enable("submit3_3_1")
      }
      
    })
    
    heatmap3_3_1<-eventReactive(input$submit3_3_1,{
      
        myssgseaheatmap(isolate(input$dataset3_3_1),
                        isolate(input$pathway3_3),
                        isolate(input$color1_3_2_1),
                        isolate(input$color2_3_2_1))
      
    })
    
    output$ssgseaheatmap=renderPlot({
      shiny::validate(need(input$submit3_3_1, ""))
      
      progress <- Progress$new(session, min=1, max=30)
      on.exit(progress$close())
      
      progress$set(message = 'Making heatmap',
                   detail = 'This may take a while...')
      
      for (i in 1:30) {
        progress$set(value = i)
        Sys.sleep(0.1)
      }
      
      
      heatmap3_3_1()
    })
    
    
  
    
    output$pdf3_3 <- downloadHandler(
      filename = function() {
        paste(input$dataset3_3_1, "_ssGSEA_heatmap",".pdf",sep = "")
      },
      content = function(file) {
        pdf(file,width = 12,height = 9,compress = F)
        print(heatmap3_3_1())
        dev.off()
      }
    )
    

# 3.2.2 Table -------------------------------------------------------------
    ssgsea_mat3.2.2<-eventReactive(input$dataset3_3_2,{
      
      load(paste("./Enrichment/ssgsea/",isolate(input$dataset3_3_2),"_ssgseamat.Rdata",sep = ""))
      
      ssgsea_mat<-round(ssgsea_mat,5)
      ssgsea_mat<-as.data.frame(ssgsea_mat)
      ssgsea_mat<-data.frame(pathway=row.names(ssgsea_mat),ssgsea_mat)
      rownames(ssgsea_mat)<-NULL
      ssgsea_mat
    })
    
    output$ssgseaList<-renderDT({
      DT::datatable(ssgsea_mat3.2.2(),options = list(columnDefs = list(list(
        targets = 1,
        render = JS(
          "function(data, type, row, meta) {",
          "return type === 'display' && data.length > 35 ?",
          "'<span title=\"' + data + '\">' + data.substr(0, 35) + '...</span>' : data;",
          "}")
      )),
      pageLength = 10,scrollX=T))
        })
        
    output$download3_3 <- downloadHandler(
      filename = function() {
        paste(input$dataset3_3_2,"_ssgsea_",input$ssgseatable, ".csv", sep = "")
      },
      content <- function(file) {
        load(paste("./Enrichment/ssgsea/",isolate(input$dataset3_3_2),"_ssgseamat.Rdata",sep = ""))
        write.csv(round(ssgsea_mat,5),file)
      }
    )
    
    
    
# 4. Immune Infiltration----------------------------------------------------------------------
 

# 4.1 Stacked Bar Chart---------------------------------------------------------------------

   
    immunedata1<-eventReactive(input$submit4_1,{
      load(paste("./ImmuneInfiltration/",isolate(input$dataset4_1),"_",isolate(input$algorithm1),".Rdata",sep = ""))
      results<-as.data.frame(results)
      results_prop<- apply(results, 2, function(x){x/sum(x)})
      results_prop<-as.data.frame(results_prop)
      results_prop$celltype<-rownames(results_prop)
      results_prop<-as.data.frame(results_prop)
      immunedata1 <- gather(results_prop,sample,proportion,1:ncol(results))
      
      immunedata1$proportion <- as.numeric(immunedata1$proportion)
      
      gl<-read.table(paste("./data/Group/",isolate(input$dataset4_1),".txt",sep = ""),
                     header=T,row.names=1)#读取分组
      group_list <- factor(gl$group)
      immunedata1$group<-rep(group_list,each=nrow(results))
      immunedata1<-as.data.frame(immunedata1)
      immunedata1
    })
    
    
    output$stackbarplot<-renderPlot({
      shiny::validate(need(input$submit4_1, ""))
      
      
      progress <- Progress$new(session, min=1, max=30)
      on.exit(progress$close())
      
      progress$set(message = 'Making stacked bar chart',
                   detail = 'This may take a while...')
      
      for (i in 1:30) {
        progress$set(value = i)
        Sys.sleep(0.1)
      }
      mystackplot(immunedata1())
      
    })
    
    
 
    
    output$pdf4_1 <- downloadHandler(
      filename = function() {
        paste(input$dataset4_1, "_", input$algorithm1,"_stackedbarplot",".pdf",sep = "")
      },
      content = function(file) {
        pdf(file,width = 14, height = 6,compress = F)
        plot(mystackplot(immunedata1()))
        dev.off()
      }
    )

# 4.2 Heatmap -------------------------------------------------------------

    
    heatmap4_2<-eventReactive(input$submit4_2,{
      myimmuneheatmap(isolate(input$dataset4_2),
                      isolate(input$algorithm2),
                      isolate(input$color1_4_2),
                      isolate(input$color2_4_2))
    })
    
    output$immuneheatmap<-renderPlot({
      shiny::validate(need(input$submit4_2, ""))
      
      
      progress <- Progress$new(session, min=1, max=30)
      on.exit(progress$close())
      
      progress$set(message = 'Making heatmap',
                   detail = 'This may take a while...')
      
      for (i in 1:30) {
        progress$set(value = i)
        Sys.sleep(0.1)
      }
      heatmap4_2()
    },res = 96)
    
    
 
    output$pdf4_2 <- downloadHandler(
      filename = function() {
        paste(input$dataset4_2, "_", input$algorithm2,"_heatmap",".pdf",sep = "")
      },
      content <- function(file) {
          pdf(file,width = 12,height = 9,compress = F)
          print(heatmap4_2())
          dev.off()
        
      }
    )
    

# 4.3 Box Plot---------------------------------------------------------------------


    
    output$immuneboxplot<-renderPlot({
      shiny::validate(need(input$submit4_3, ""))
      
      
      progress <- Progress$new(session, min=1, max=30)
      on.exit(progress$close())
      
      progress$set(message = 'Making box plot',
                   detail = 'This may take a while...')
      
      for (i in 1:30) {
        progress$set(value = i)
        Sys.sleep(0.1)
      }
      myimmuneboxplot(isolate(input$dataset4_3),isolate(input$algorithm3))
      
    })
    
   
    output$pdf4_3 <- downloadHandler(
      filename = function() {
        paste(input$dataset4_3, "_", input$algorithm3,"_boxplot",".pdf",sep = "")
      },
      content = function(file) {
        pdf(file,width = 11,height = 6,compress = F)
        plot(myimmuneboxplot(isolate(input$dataset4_3),isolate(input$algorithm3)))
        dev.off()
      }
    )
    

# 4.4 Table ---------------------------------------------------------------


    output$immunelist=renderDT({
      
      load(paste("./ImmuneInfiltration/",input$dataset4_4,"_",input$algorithm4,".Rdata",sep = ""))
      results<-t(results)
      DT::datatable(round(results,5),options = list(pageLength = 10,scrollX=T,scrollY=T),
                    caption = 'A table for the signature enrichment score of a list of immune cell-specific marker genes from gene expression profiles:')
      
    })
    
    
    output$download4_4 <- downloadHandler(
      filename = function() {
        paste(paste0(input$dataset4_4,"_",input$algorithm4), ".csv", sep = "")
      },
      content <- function(file) {
        load(paste("./ImmuneInfiltration/",input$dataset4_4,"_",input$algorithm4,".Rdata",sep = ""))
        results<-t(results)
        write.csv(
          round(results,5),
          file)
      }
    )
    

# 5 Correlation -----------------------------------------------------------


# 5.1 scattered diagram -----------------------------------------------------------------


    Group1<-eventReactive(input$dataset5_1,{

      group<-read.table("./data/Group/group.txt",header=T,row.names=1)
      str_split(string = group[isolate(input$dataset5_1),],pattern = " vs ")[[1]]
    })

    X5_1<-eventReactive(list(input$dataset5_1,
                             input$variable),{
      if(isolate(input$variable)=="pvp"){
      load(paste("./Enrichment/ssgsea/",isolate(input$dataset5_1),"_ssgseapathway.Rdata",sep=""))
      pathway$pathway
        }else{
        load(paste("./data/gene/",isolate(input$dataset5_1),"_gene.Rdata",sep = ""))
        gene$`gene symbol`
      }
    })

    Y5_1<-eventReactive(list(input$dataset5_1,
                             input$variable),{
      if(isolate(input$variable)=="gvg"){
      load(paste("./data/gene/",isolate(input$dataset5_1),"_gene.Rdata",sep = ""))
      gene$`gene symbol`
      }else{
        load(paste("./Enrichment/ssgsea/",isolate(input$dataset5_1),"_ssgseapathway.Rdata",sep=""))
        pathway$pathway
      }
    })

    Xlabel<-eventReactive(input$variable,{
      if(isolate(input$variable)=="pvp"){
        "Select a pathway for X axis"
      }else{
        "Select a gene symbol for X axis"
      }

    })

    Ylabel<-eventReactive(input$variable,{
      if(input$variable!="gvg"){
        "Select a pathway for Y axis"
      }else{
        "Select a gene symbol for Y axis"
      }

    })
    
    observeEvent(input$dataset5_1,{
     # freezeReactiveValue(input, "group1")
      updateRadioButtons(
        session = session,
        inputId = "group1",
        choices = c("All",Group1()),
        selected = "All",
        inline=TRUE
      )
    })
    
    observeEvent(list(input$dataset5_1,input$variable),{

      updateSelectizeInput(
        session = session,
        inputId = "X5_1_1",
        choices = X5_1(),
        selected = X5_1()[1],
        label = Xlabel(),
        server = T
      )
      updateSelectizeInput(
        session = session,
        inputId = "Y5_1_1",
        choices =  Y5_1(),
        selected = Y5_1()[2],
        label = Ylabel(),
        server = T
      )

    })

    observeEvent(list(input$X5_1_1,
                      input$Y5_1_1),{
       if(input$X5_1_1==''){
        showFeedbackDanger(
          inputId = "X5_1_1",
          text = "Please choose a variable!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit5_1_1")
       }else{
         hideFeedback("X5_1_1")
      }
         if(input$Y5_1_1==''){
        showFeedbackDanger(
          inputId = "Y5_1_1",
          text = "Please choose a variable!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit5_1_1")
         }else{
           hideFeedback("Y5_1_1")
      }
                        
         if(input$X5_1_1!=''&input$Y5_1_1!='') {
        hideFeedback("X5_1_1")
        hideFeedback("Y5_1_1")
        shinyjs::enable("submit5_1_1")
      }

    })
    scattergram<-eventReactive(input$submit5_1_1,{
      if(input$group1=='All'){
        myscattergram(dataset = isolate(input$dataset5_1),
                      x = isolate(input$X5_1_1),
                      y = isolate(input$Y5_1_1),
                      variable = isolate(input$variable),
                      cor_group = isolate(input$group1),
                      method = isolate(input$method5_1_1),
                      color1=isolate(input$color1_5_1),
                      color2=isolate(input$color2_5_1)
        )
      }else{
        myscattergram(dataset = isolate(input$dataset5_1),
                      x = isolate(input$X5_1_1),
                      y = isolate(input$Y5_1_1),
                      variable = isolate(input$variable),
                      cor_group = isolate(input$group1),
                      method = isolate(input$method5_1_1),
                      color3=isolate(input$color3_5_1)
        )
      }
    })
    
    output$genevsgene<-renderPlot({
      shiny::validate(need(input$submit5_1_1,""))
      
      
      progress <- Progress$new(session, min=1, max=20)
      on.exit(progress$close())
      
      progress$set(message = 'Making scattered diagram',
                   detail = 'This may take a while...')
      
      for (i in 1:20) {
        progress$set(value = i)
        Sys.sleep(0.1)
      }
      scattergram()
      
    })
     
  
  
    output$pdf5_1_1 <- downloadHandler(
      filename = function() {
        paste(input$dataset5_1, "_", 
              input$X5_1_1,"vs",input$Y5_1_1,
              "_scattergram_",input$method5_1_1,"_",input$group1,".pdf",sep = "")
      },
      content = function(file) {
        pdf(file,width = 7,height = 7,compress = F)#family参数导出pdf设置字体
        plot(scattergram())
        dev.off()
      }
    )

# 5.2 Heatmap-------------------------------------------------------------------

    Gene2_1<-eventReactive(input$dataset5_2,{
      load(paste("./data/gene/",isolate(input$dataset5_2),"_gene.Rdata",sep = ""))
      gene$`gene symbol`
    })
    
    Group2_1<-eventReactive(input$dataset5_2,{
      
      group<-read.table("./data/Group/group.txt",header=T,row.names=1)
      str_split(string = group[isolate(input$dataset5_2),],pattern = " vs ")[[1]]
    })
    
    observeEvent(input$dataset5_2,{
      updateSelectizeInput(
        session = session,
        inputId = "genes5_2_1",
        choices = isolate(Gene2_1()),
        selected = isolate(Gene2_1())[1:5],
        server = T
      )
      updateRadioButtons(
        session = session,
        inputId = "group2_1",
        choices = isolate(c("All",Group2_1())),
        selected = "All"
      )
    })
        
    
    observeEvent(list(input$dataset5_2,input$genes5_2_1), {
      if (length(input$genes5_2_1) < 5) {
        showFeedbackDanger(
          inputId = "genes5_2_1",
          text = "Warning, the number of genes is less than 5!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit5_2_1")
      } else if(length(input$genes5_2_1) > 20){
        showFeedbackDanger(
          inputId = "genes5_2_1",
          text = "Warning, the number of genes is more than 20!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit5_2_1")
      }
      else if(length(input$genes5_2_1)>=5 && length(input$genes5_2_1) <= 20){
        hideFeedback("genes5_2_1")
        shinyjs::enable("submit5_2_1")
      }
      
    })
    
    output$corheatmap<-renderPlot({
      shiny::validate(need(input$submit5_2_1,""))
      
      
      progress <- Progress$new(session, min=1, max=20)
      on.exit(progress$close())
      
      progress$set(message = 'Making heatmap',
                   detail = 'This may take a while...')
      
      for (i in 1:20) {
        progress$set(value = i)
        Sys.sleep(0.1)
      } 
      mycorbubble(isolate(input$dataset5_2),
                   isolate(input$genes5_2_1),
                   isolate(input$group2_1),
                   isolate(input$method5_2_1))
      
    })
    

    
    output$pdf5_2_1 <- downloadHandler(
      filename = function() {
        paste(input$dataset5_2, 
              "_genes_corheatmap_",input$method5_2_1,"_",input$group2_1,".pdf",sep = "")
      },
      content = function(file) {
        pdf(file,width = 11,height = 10,compress = F)
        mycorbubble(isolate(input$dataset5_2),
                          isolate(input$genes5_2_1),
                          isolate(input$group2_1),
                          isolate(input$method5_2_1))
        dev.off()
      }
    )
# 6. singlecell -----------------------------------------------------------------
    # 6.1 clusterplot -----------------------------------------------------------------
    
        output$clusterPlot<-renderPlot({
      shiny::validate(need(input$submit6_1,""))
      
      
      progress <- Progress$new(session, min=1, max=20)
      on.exit(progress$close())
      
      progress$set(message = 'Making cluster plot',
                   detail = 'This may take a while...')
      
      for (i in 1:20) {
        progress$set(value = i)
        Sys.sleep(0.1)
      } 
      load(paste("./scrna/data/",isolate(input$dataset6_1),".Rdata",sep = ""))
      DimPlot(pbmc, reduction = "umap", label = TRUE, pt.size = 0.5,label.size = 6) + NoLegend()
    })
    output$pdf6_1 <- downloadHandler(
      filename = function() {
        paste(input$dataset6_1, 
              "_singlecell_clusterplot_.pdf",sep = "")
      },
      content = function(file) {
        pdf(file,width = 10,height = 7,compress = F)#family参数导出pdf设置字体
        load(paste("./scrna/data/",isolate(input$dataset6_1),".Rdata",sep = ""))
        DimPlot(pbmc, reduction = "umap", label = TRUE, pt.size = 0.5,label.size = 6) + NoLegend()
        dev.off()
      }
    )
    
    
    # 6.2 featureplot -----------------------------------------------------------------
    
    
    
    flabel<-eventReactive(input$featuretype,{
      if(isolate(input$featuretype)=="pathway"){
        "Select 1~4 pathway(s)"
      }else{
        "Select 1~9 gene(s)"
      }

    })
    choice6_2<-eventReactive(list(input$dataset6_2,
                             input$featuretype),{
                               if(isolate(input$featuretype)=="gene"){
                                 marker_exp <- read.table(paste0("./scrna/table/",isolate(input$dataset6_2),"_heatmap_gene.txt"),
                                                          sep="\t",header=T)
                                 rownames(marker_exp)
                               }else{
                                 gsva_mat <- read.table(paste0("./scrna/table/",isolate(input$dataset6_2),"_heatmap_pathway.txt"),
                                                        sep="\t",header=T)
                                 rownames(gsva_mat)
                               }
                             })
    select6_2<-eventReactive(list(input$dataset6_2,
                                  input$featuretype),{
                                    if(isolate(input$featuretype)=="gene"){
                                      if(input$dataset6_2=="GSE180885"){
                                        c("GOLT1A","PRSS38","RNF223","IGKV1-39","WDR63","RGPD8","CD1C","COL11A1","SAMD11")
                                      }else if(input$dataset6_2=="GSE213849_AD"){
                                        c("PLEKHA7","TTLL10","TBC1D2","LGALSL","IGKC","STS","CCR1","HBA2","SOD3")
                                      }else if(input$dataset6_2=="GSE158432"){
                                        c("PEAK3","ADGRF4","HSD11B2","TRIM61","AQP10","SH2D6","FLT3","TRIM63","SGIP1")
                                      }else {#input$dataset6_2=="GSE153760"
                                        c("LINC02265","PLA2G2F","PLSCR2","TRIM54","RIIAD1","TUBB1","CLC","KLHL30","SHBG")
                                      }
                                    }else{
                                      if(input$dataset6_2=="GSE180885"){
                                        c("REACTOME-SEROTONIN-RECEPTORS",
                                            "REACTOME-SYNTHESIS-OF-PE",
                                            "REACTOME-DOPAMINE-RECEPTORS",
                                            "REACTOME-COMPLEMENT-CASCADE"
                                            # "KEGG-PROTEIN-EXPORT",
                                            # "REACTOME-SARS-COV-INFECTIONS",
                                            # "REACTOME-OPSINS",
                                            # "REACTOME-ACTIVATION-OF-C3-AND-C5",
                                            # "REACTOME-SIGNALING-BY-NOTCH1"
                                        )
                                      }else if(input$dataset6_2=="GSE213849_AD"){
                                        c("KEGG-NEUROTROPHIN-SIGNALING-PATHWAY",
                                          "REACTOME-INTERLEUKIN-7-SIGNALING",
                                          "REACTOME-GLUCURONIDATION",
                                          "KEGG-STEROID-HORMONE-BIOSYNTHESIS")
                                      }else if(input$dataset6_2=="GSE158432"){
                                        c("REACTOME-VASOPRESSIN-LIKE-RECEPTORS",
                                          "REACTOME-VASOPRESSIN-LIKE-RECEPTORS")
                                      }else {#input$dataset6_2=="GSE153760"
                                        c("REACTOME-REGULATION-OF-HSF1-MEDIATED-HEAT-SHOCK-RESPONSE",
                                          "KEGG-STEROID-HORMONE-BIOSYNTHESIS")
                                      }
                                    }
                                  }
    )
    observeEvent(list(input$dataset6_2,input$featuretype),{
      updateSelectizeInput(
        session = session,
        inputId = "feature6_2",
        choices = choice6_2(),
        selected = select6_2(),
        label = flabel(),
        server = T
      )
    }
    )
    # observeEvent(list(input$dataset6_2,input$featuretype),{
    #   if(isolate(input$featuretype)=="gene"){
    #     marker_exp<-read.table(paste("./scrna/table/",isolate(input$dataset6_2),"_heatmap_gene.txt",sep=""),
    #                            header = T,sep = "\t")
    #     scgenelist<-rownames(marker_exp)
    #     if (input$dataset6_2=="GSE180885"){
    #       updateSelectizeInput(session = session,
    #                            inputId = "feature6_2",
    #                            label = "Select 1~9 gene(s)",
    #                            choices = scgenelist,
    #                            selected = c("GOLT1A","PRSS38","RNF223","IGKV1-39","WDR63","RGPD8","CD1C","COL11A1","SAMD11"),
    #                            server = TRUE)
    #     }
    #     else if (input$dataset6_2=="GSE213849_AD"){
    #       updateSelectizeInput(session = session,
    #                            inputId = "feature6_2",
    #                            label = "Select 1~9 gene(s)",
    #                            choices = scgenelist,
    #                            selected = c("PLEKHA7","TTLL10","TBC1D2","LGALSL","IGKC","STS","CCR1","HBA2","SOD3"),
    #                            server = TRUE)
    #     }
    #     else if (input$dataset6_2=="GSE158432"){
    #       updateSelectizeInput(session = session,
    #                            inputId = "feature6_2",
    #                            label = "Select 1~9 gene(s)",
    #                            choices = scgenelist,
    #                            selected = c("PEAK3","ADGRF4","HSD11B2","TRIM61","AQP10","SH2D6","FLT3","TRIM63","SGIP1"),
    #                            server = TRUE)
    #     }
    #     else if (input$dataset6_2=="GSE153760"){
    #       updateSelectizeInput(session = session,
    #                            inputId = "feature6_2",
    #                            label = "Select 1~9 gene(s)",
    #                            choices = scgenelist,
    #                            selected = c("LINC02265","PLA2G2F","PLSCR2","TRIM54","RIIAD1","TUBB1","CLC","KLHL30","SHBG"),
    #                            server = TRUE)
    #     }
    #   }else{
    #     gsva_mat<-read.table(paste("./scrna/table/",isolate(input$dataset6_2),"_heatmap_pathway.txt",sep=""),
    #                          header = T,sep = "\t")
    #     scpathwaylist<-rownames(gsva_mat)
    #     if (input$dataset6_2=="GSE180885"){
    #       updateSelectizeInput(session = session,
    #                            inputId = "feature6_2",
    #                            label = "Select 1~9 pathway(s)",
    #                            choices = scpathwaylist,
    #                            selected = c("REACTOME-PHOSPHOLIPASE-C-MEDIATED-CASCADE-FGFR4",
    #                                         "REACTOME-SYNTHESIS-OF-PE"),
    #                            server = TRUE)
    #     }
    #     else if (input$dataset6_2=="GSE213849_AD"){
    #       updateSelectizeInput(session = session,
    #                            inputId = "feature6_2",
    #                            label = "Select 1~9 pathway(s)",
    #                            choices = scpathwaylist,
    #                            selected = c("KEGG-NEUROTROPHIN-SIGNALING-PATHWAY",
    #                                         "REACTOME-INTERLEUKIN-7-SIGNALING"),
    #                            server = TRUE)
    #     }
    #     else if (input$dataset6_2=="GSE158432"){
    #       updateSelectizeInput(session = session,
    #                            inputId = "feature6_2",                                                          label = "Select 2~15 pathway(s)",
    #                            label = "Select 1~9 pathway(s)",
    #                            choices = scpathwaylist,
    #                            selected = c("REACTOME-VASOPRESSIN-LIKE-RECEPTORS",
    #                                         "REACTOME-VASOPRESSIN-LIKE-RECEPTORS"),
    #                            server = TRUE)
    #     }
    #     else if (input$dataset6_2=="GSE153760"){
    #       updateSelectizeInput(session = session,
    #                            inputId = "feature6_2",
    #                            label = "Select 1~9 pathway(s)",
    #                            choices = scpathwaylist,
    #                            selected = c("REACTOME-REGULATION-OF-HSF1-MEDIATED-HEAT-SHOCK-RESPONSE",
    #                                         "KEGG-STEROID-HORMONE-BIOSYNTHESIS"),
    #                            server = TRUE)
    #     }
    #   }
    # })
    # 
    observeEvent(list(input$feature6_2,input$featuretype), {
      if(input$featuretype=="gene"){
      if (length(input$feature6_2) > 9) {
        showFeedbackDanger(
          inputId = "feature6_2",
          text = "Warning, the number of genes is more than 9!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit6_2")
        
      } else if(length(input$feature6_2) < 1){
        showFeedbackDanger(
          inputId = "feature6_2",
          text = "Warning, the number of genes is less than 1!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        shinyjs::disable("submit6_2")
      }
      else if(length(input$feature6_2)>=1 && length(input$feature6_2) <= 9){
        hideFeedback("feature6_2")
        shinyjs::enable("submit6_2")
      }
      }else{
        if (length(input$feature6_2) > 4) {
          showFeedbackDanger(
            inputId = "feature6_2",
            text = "Warning, the number of pathways is more than 4!",
            color  =  "#d9534f" ,
            icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
          )
          shinyjs::disable("submit6_2")
          
        } else if(length(input$feature6_2) < 1){
          showFeedbackDanger(
            inputId = "feature6_2",
            text = "Warning, the number of pathways is less than 1!",
            color  =  "#d9534f" ,
            icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
          )
          shinyjs::disable("submit6_2")
        }
        else if(length(input$feature6_2)>=1 && length(input$feature6_2) <= 4){
          hideFeedback("feature6_2")
          shinyjs::enable("submit6_2")
        }
      }
      
    })
    
    
    output$featurePlot<-renderPlot({
      shiny::validate(need(input$submit6_2,""))
      
      
      progress <- Progress$new(session, min=1, max=20)
      on.exit(progress$close())
      
      progress$set(message = 'Making feature plot',
                   detail = 'This may take a while...')
      
      for (i in 1:20) {
        progress$set(value = i)
        Sys.sleep(0.1)
      } 
      load(paste("./scrna/data/",isolate(input$dataset6_2),".Rdata",sep = ""))
      
      FeaturePlot(pbmc, features=isolate(input$feature6_2))
      
    } )
    # 6.3 heatmap -----------------------------------------------------------------
    
    # hlabel<-eventReactive(input$heatmaptype,{
    #   if(isolate(input$heatmaptype)=="pathway"){
    #     "Select 1~9 pathway(s)"
    #   }else{
    #     "Select 1~9 gene(s)"
    #   }
    #   
    # })
    #X6_3<-eventReactive
    observeEvent(list(input$dataset6_3,input$heatmaptype),{
                               if(isolate(input$heatmaptype)=="gene"){
                                 marker_exp<-read.table(paste("./scrna/table/",isolate(input$dataset6_3),"_heatmap_gene.txt",sep=""),
                                                        header = T,sep = "\t")
                                 scgenelist<-rownames(marker_exp)
                                 if (input$dataset6_3=="GSE180885"){
                                   updateSelectizeInput(session = session,
                                                        inputId = "heatmap6_3",
                                                        label = "Select 2~15 gene(s)",
                                                        choices = scgenelist,
                                                        selected = c("GOLT1A","PRSS38","RNF223","IGKV1-39","WDR63","RGPD8","CD1C","COL11A1","SAMD11"),
                                                        server = TRUE)
                                 }
                                 else if (input$dataset6_3=="GSE213849_AD"){
                                   updateSelectizeInput(session = session,
                                                        inputId = "heatmap6_3",
                                                        label = "Select 2~15 gene(s)",
                                                        choices = scgenelist,
                                                        selected = c("PLEKHA7","TTLL10","TBC1D2","LGALSL","IGKC","STS","CCR1","HBA2","SOD3"),
                                                        server = TRUE)
                                 }
                                 else if (input$dataset6_3=="GSE158432"){
                                   updateSelectizeInput(session = session,
                                                        inputId = "heatmap6_3",
                                                        label = "Select 2~15 gene(s)",
                                                        choices = scgenelist,
                                                        selected = c("PEAK3","ADGRF4","HSD11B2","TRIM61","AQP10","SH2D6","FLT3","TRIM63","SGIP1"),
                                                        server = TRUE)
                                 }
                                 else if (input$dataset6_3=="GSE153760"){
                                   updateSelectizeInput(session = session,
                                                        inputId = "heatmap6_3",
                                                        label = "Select 2~15 gene(s)",
                                                        choices = scgenelist,
                                                        selected = c("LINC02265","PLA2G2F","PLSCR2","TRIM54","RIIAD1","TUBB1","CLC","KLHL30","SHBG"),
                                                        server = TRUE)
                                 }
                               }else{
                                 gsva_mat<-read.table(paste("./scrna/table/",isolate(input$dataset6_3),"_heatmap_pathway.txt",sep=""),
                                                        header = T,sep = "\t")
                                 scpathwaylist<-rownames(gsva_mat)
                                 if (input$dataset6_3=="GSE180885"){
                                     updateSelectizeInput(session = session,
                                                          inputId = "heatmap6_3",
                                                          label = "Select 2~15 pathway(s)",
                                                          choices = scpathwaylist,
                                                          selected = c("REACTOME-SEROTONIN-RECEPTORS",
                                                                       "REACTOME-SYNTHESIS-OF-PE",
                                                                       "REACTOME-DOPAMINE-RECEPTORS",
                                                                       "REACTOME-COMPLEMENT-CASCADE",
                                                                       "KEGG-PROTEIN-EXPORT",
                                                                       "REACTOME-SARS-COV-INFECTIONS",
                                                                       "REACTOME-OPSINS",
                                                                       "REACTOME-ACTIVATION-OF-C3-AND-C5",
                                                                       "REACTOME-SIGNALING-BY-NOTCH1"
                                                          ),
                                                          server = TRUE)
                                   }
                                   else if (input$dataset6_3=="GSE213849_AD"){
                                     updateSelectizeInput(session = session,
                                                          inputId = "heatmap6_3",
                                                          label = "Select 2~15 pathway(s)",
                                                          choices = scpathwaylist,
                                                          selected = c("KEGG-NEUROTROPHIN-SIGNALING-PATHWAY",
                                                                       "REACTOME-FREE-FATTY-ACID-RECEPTORS",
                                                                       "REACTOME-INTERLEUKIN-7-SIGNALING",
                                                                       "REACTOME-METALLOPROTEASE-DUBS",
                                                                       "REACTOME-GLUCURONIDATION",
                                                                       "KEGG-FOLATE-BIOSYNTHESIS",
                                                                       "KEGG-STEROID-HORMONE-BIOSYNTHESIS",
                                                                       "REACTOME-GLUTATHIONE-CONJUGATION",
                                                                       "REACTOME-COMPLEMENT-CASCADE",
                                                                       "REACTOME-ECM-PROTEOGLYCANS"
                                                                       ),
                                                          server = TRUE)
                                   }
                                   else if (input$dataset6_3=="GSE158432"){
                                     updateSelectizeInput(session = session,
                                                          inputId = "heatmap6_3",     
                                                          label = "Select 2~15 pathway(s)",
                                                          choices = scpathwaylist,
                                                          selected = c("REACTOME-CARNITINE-METABOLISM",
                                                                       "KEGG-RETINOL-METABOLISM",
                                                                       "KEGG-BUTANOATE-METABOLISM",
                                                                       "KEGG-REGULATION-OF-AUTOPHAGY",
                                                                       "KEGG-OXIDATIVE-PHOSPHORYLATION",
                                                                       "KEGG-RIBOFLAVIN-METABOLISM",
                                                                       "REACTOME-DOPAMINE-RECEPTORS",
                                                                       "KEGG-GLYCEROLIPID-METABOLISM",
                                                                       "REACTOME-PI3K-AKT-ACTIVATION",
                                                                       "REACTOME-MELANIN-BIOSYNTHESIS"),
                                                          server = TRUE)
                                   }
                                   else if (input$dataset6_3=="GSE153760"){
                                     updateSelectizeInput(session = session,
                                                          inputId = "heatmap6_3",
                                                          label = "Select 2~15 pathway(s)",
                                                          choices = scpathwaylist,
                                                          selected = c("REACTOME-CHROMATIN-MODIFYING-ENZYMES",
                                                                      "REACTOME-KERATINIZATION",
                                                                      "HALLMARK-INFLAMMATORY-RESPONSE",
                                                                      "REACTOME-CD22-MEDIATED-BCR-REGULATION",
                                                                      "REACTOME-MELANIN-BIOSYNTHESIS",
                                                                      "HALLMARK-MITOTIC-SPINDLE",
                                                                      "REACTOME-CELLULAR-HEXOSE-TRANSPORT",
                                                                      "REACTOME-GLUCURONIDATION",
                                                                      "REACTOME-RHO-GTPASES-ACTIVATE-CIT",
                                                                      "REACTOME-TRNA-AMINOACYLATION"
                                                                      ),
                                                          server = TRUE)
                                   }
                               }
                             })
    # observeEvent(list(input$dataset6_3,input$heatmaptype),{
    #   
    #   updateSelectizeInput(
    #     session = session,
    #     inputId = "heatmap6_3",
    #     choices = X6_3(),
    #     selected = X6_3()[1:9],
    #     label = hlabel(),
    #     server = T
    #   )
    # }
    # )
    observeEvent(list(input$heatmaptype,input$heatmap6_3), {
      if (length(input$heatmap6_3) > 15) {
        if(isolate(input$heatmaptype)=="gene"){
          showFeedbackDanger(
            inputId = "heatmap6_3",
            text = "Warning, the number of genes is more than 15!",
            color  =  "#d9534f" ,
            icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
          )
        } else{
          showFeedbackDanger(
            inputId = "heatmap6_3",
            text = "Warning, the number of pathways is more than 15!",
            color  =  "#d9534f" ,
            icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
          )
        }
        
        shinyjs::disable("submit6_3")
        
      } else if(length(input$heatmap6_3) < 2){
        if(isolate(input$heatmaptype)=="gene"){
        showFeedbackDanger(
          inputId = "heatmap6_3",
          text = "Warning, the number of genes is less than 2!",
          color  =  "#d9534f" ,
          icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
        )
        } else{
          showFeedbackDanger(
            inputId = "heatmap6_3",
            text = "Warning, the number of pathways is less than 2!",
            color  =  "#d9534f" ,
            icon  =  shiny::icon ("exclamation-sign" ,  lib  =  "glyphicon")
          )
        }
        shinyjs::disable("submit6_3")
      }
      else if(length(input$heatmap6_3)>=2 && length(input$heatmap6_3) <= 15){
        hideFeedback("heatmap6_3")
        shinyjs::enable("submit6_3")
      }
    })
    
    matrix6_3<-eventReactive(list(input$dataset6_3,
                                    input$heatmaptype),{
      if(input$heatmaptype=="gene") {
      matrix<-read.table(paste("./scrna/table/",isolate(input$dataset6_3),"_heatmap_gene.txt",sep=""),
                         header = T,sep = "\t")
      matrix<-as.matrix(matrix)
    } else{
      matrix<-read.table(paste("./scrna/table/",isolate(input$dataset6_3),"_heatmap_pathway.txt",sep="")
                         ,header = T,sep = "\t")
      matrix<-as.matrix(matrix)
    }
                                    }
    )
    
    output$SCheatmap<-renderPlot({
      shiny::validate(need(input$submit6_3,""))
      
      
      progress <- Progress$new(session, min=1, max=20)
      on.exit(progress$close())
      
      progress$set(message = 'Making heatmap',
                   detail = 'This may take a while...')
      
      for (i in 1:20) {
        progress$set(value = i)
        Sys.sleep(0.1)
      } 
      
      Heatmap(matrix = matrix6_3()[isolate(input$heatmap6_3),],
              name = "z-score \nexpression  ", 
              col = colorRamp2(
                c(-2, 0, 2), 
                c("royalblue","white","firebrick3")
              ),
              row_names_max_width = max_text_width(
                rownames(matrix6_3()), 
                gp = gpar(fontsize = 12)),
              column_title = paste0("Heatmap of ",isolate(input$dataset6_3)), 
              column_title_gp = gpar(fontsize = 15, fontface = "bold"),
              rect_gp = gpar(col = "white", lwd = 0.2),
              cluster_rows = F,
              cluster_columns = F,
              column_names_side = "top",
              column_names_rot = 45,
              na_col = "white")
      
    } )
    
   
    
    
    
# 7. Data -----------------------------------------------------------------

    DataX <- reactive({ 
      data <- read.table("./data/data1.txt",header=T,row.names=1,fileEncoding = "UTF-8")
      data<-data[,-c(5,10:13)]
      data<-as.data.frame(data)
      data<-data%>%mutate(Species = as.factor(Species)) %>% 
        mutate(Disease = as.factor(Disease)) %>% 
        mutate(Tissue.type = as.factor(Tissue.type))%>% 
        mutate(Sequencing.type = as.factor(Sequencing.type))
      data
      })
    
      output$data_i<-renderUI({#用renderUI可以避免用extensions = Responsive时不同页面上显示列数不同的问题
        data<-DataX()
        
        #data<-dplyr::rename(data, Publication=url)
        DT::datatable(data,escape = FALSE,
                      filter = c("top"),
                      extensions = c('Buttons'), #,'Responsive'
                      options = list(
          dom = 'Bfrtip',
          buttons = 'csv',
          columnDefs = list(list(targets = c(7,8), searchable = FALSE),
                            list(
                              targets = c(7,8),
                              render = DT::JS(
                                "function(data, type, row, meta) {",
                                "return type === 'display' && data != null && data.length > 25 ?",
                                "'<span title=\"' + data + '\">' + data.substr(0, 25) + '...</span>' : data;",
                                "}")
                            )),
          initComplete = DT::JS(
            "function(settings, json) {",
            "$(this.api().table().header()).css({'background-color': '#8f8f8f', 'color': '#fff'});",
            "}")
          #columnDefs = list(list(visible=FALSE, targets=c(7,8)))#隐藏特定的列
        ))
      })
    # output$download6 <- downloadHandler(
    #   filename = "Dataset.csv",
    #   content <- function(file) {
    #     data<-DataX()
    #     data<-data[,c(1:5,8:9)]
    #     write.csv(data,file)
    #   }
    # )
    
#8.integrated data-----
      Integrated_disease_DTdata <- eventReactive(input$Integrated_disease_input,{
        load(paste0("./data/IntegratedDT/", gsub(" ", "_", input$Integrated_disease_input), ".Rdata"))
        as.data.frame(Integrated_summaryDT)
      })
      
      output$Integrated_DT <- renderDataTable({
        DT::datatable(Integrated_disease_DTdata(),
                      rownames = FALSE,
                      extensions = c("FixedColumns"),
                      selection = "none", #turn off row selection function otherwise u will select that row when clicking on the action button
                      options = list(pageLength = 10,
                                     scrollX = TRUE,
                                     # autoWidth = TRUE,
                                     fixedColumns = list(leftColumns = 3), #the first column is 1. 3 here means fix column after column 3.
                                     searchHighlight = TRUE,
                                     search = list(regex = FALSE, caseInsensitive = TRUE),
                                     columnDefs = list(list(className = 'dt-center', targets = "_all")))
        ) %>% 
          formatStyle(columns = seq(from = 4, to = ncol(Integrated_disease_DTdata())),
                      color = styleEqual(c(0, 1, -1), c('black', 'red', 'blue')))
      })
      
      output$Integrated_Download <- downloadHandler(
        filename = function() {
          paste0(input$Integrated_disease_input, "_Integrated_DEG_Summary", ".csv")
        },
        content <- function(file) {
          sep <- ","
          write.table(Integrated_disease_DTdata(), file, sep=sep, row.names = FALSE)
        }
      )
#      9. About -------
    
      output$attachment <- renderUI({
        fileInput("attach_pic", "Upload a PNG/JPGE File (optional)",
                  multiple = FALSE,
                  width = "100%",
                  placeholder = "You can attach the error report here.",
                  accept = c("image/png","image/jpeg"))
      })
      observe({
        shinyjs::toggleState(id ="submit8",
                             condition =(input$comment!=""))
      })
      # action to take when submit button is pressed
      observeEvent(input$submit8, {
        req(input$comment)
        smtp <- emayili::server(
          host = "smtp.163.com",
          port = 25,
          username = "shiny_luopeng@163.com",
          password = "LFZKTEZQQLXDTOGK"
        )
        email <- envelope() %>%
          from("shiny_luopeng@163.com") %>%
          to("shiny_luopeng@163.com")%>%
          subject(paste("CTPAD-SHINY FEEDBACK: ", input$contact))%>%
          emayili::html(
            tagList(p("CTPAD-SHINY FEEDBACK:"),
                    br(),
                    input$comment,
                    br(),
                    paste("from:",input$contact))
          )
        if(is.null(input$attach_pic)){
          email <- email
        }else{
          email <- email %>% attachment(input$attach_pic$datapath,
                                        name = input$attach_pic$name)
        }
        smtp(email)
        show_alert(
          title = "Success",
          text = "Thanks, your response was submitted successfully! We will get back to you as soon as possible.",
          type = "success"
        )
      })
      

    
  }
)
