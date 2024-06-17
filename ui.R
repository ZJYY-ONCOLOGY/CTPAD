# UI.R --------------------------------------------------------------------

shinyUI(
  div(
    # # Head linking to custom CSS tweaks and favicons
    tags$head(
      tags$link(
        rel   = "shortcut icon",
        type  = "image/x-icon",
        href  = "data:image/png;base64,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"
       # href  = "www/icon1.png"
      )
    ),
  
  tags$style(HTML("
        body > div > nav .nav.navbar-nav {
            float: right;
        }
        .navbar-nav > li > a {
            font-size: 12px;
            font-weight: bold;
        }
        ")),#        <!-- font-size: 14px; -->
  navbarPage(
    title=div(img(width="30", height="30",src="data:image/png;base64,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"
), strong("CTPAD")),
  theme = "mytheme.css", 
  fluid	=TRUE,
  footer = div(
    style="text-align:center",
    includeHTML("www/footer.html")
  ),
 
  
 # 1. Introduction -----------------------------------------------

  tabPanel("Introduction", 
           # waiterPreloader(
           #   html = tagList(
           #     spin_circle(),
           #     "Please wait ..."
           #     ),#设置加载图形样式和显示文字
           #   color = "#8598a9"),
           useShinyFeedback(),
           useShinyjs(),
           use_waiter(), 
           useShinydashboardPlus(),
           tags$head(
             tags$style(HTML("
    .slick-prev {
    left: -50px;
    }/*修改轮播图按钮的位置*/
    .slick-prev:before, .slick-next:before {
    font-size: 50px;
    }/*修改轮播图按钮的大小*/
    .shiny-download-link {
    color: white;
    background-color: #87B2C8;
    }/*修改downloadbutton样式*/
"))
           ),
           tags$h4("CTPAD (Comprehensive Transcriptomic Profiling in Allergic Diseases) is a tool for analyzing the expression data from ",
                   tags$a(href= "https://www.ncbi.nlm.nih.gov/geo/",
                          "GEO (Gene Expression Omnibus)",style="color:#5d8aa8;",target="_blank"),
                   "of allergic diseases using a standard processing pipeline. It provides multiple functional modules, such as expression analysis, enrichment analysis, immune infiltration and correlation analysis."
                   ),
           withSpinner(slickROutput("slick_output",width='90%',height='500px'),type=6),
             br(),
             shinydashboard::box(width = '100px',title = "Updates",
                                 "2023/07/19 Ver1.0.0 released.",
                                 status = "primary",
                                 solidHeader = TRUE),
fluidRow(column(12,
                class = "footer-container",
                HTML(#<div style="text-align: center;"><p>Copyright © 2023. All rights reserved.</p></div>
                  '<div style="text-align: center;"> 
                                <div style="text-align: center;"> 
                                <script type="text/javascript" src="//rf.revolvermaps.com/0/0/1.js?i=564gmkskr5p&amp;s=180&amp;m=8&amp;v=true&amp;r=false&amp;b=ffffff&amp;n=false&amp;c=ff0000" async="async"></script>
                                </div></div>')))

  
),

 # 2. Expression Analysis ---------------------------------------
 
 
  tabPanel(title = "Expression Analysis",
           useShinyFeedback(feedback = TRUE, toastr = TRUE),
           useShinyjs(),
           tabsetPanel(
             
      # 2.1 Volcano---------------------------------------------------------------------

             
             tabPanel(
               useShinyFeedback(feedback = TRUE, toastr = TRUE),
               useShinyjs(),
               title = "Volcano",
                      tags$head(
                        tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                      sidebarLayout(
                        sidebarPanel(
                          helper(
                          selectInput(
                            "dataset2_1",
                            "Select a GEO dataset",
                            choices=geolist,
                            selected = "Atopic dermatitis_GSE5667"
                          ),
                          colour = "#999177",
                          title = "Dataset option",
                          type = "markdown",
                          content = "dataset_expression"
                          ),
                          
                          materialSwitch(
                            inputId = "Customize2_1",
                            label = "Customize genes",
                            status = "info",
                            value = FALSE
                          ),
                          conditionalPanel(
                            condition = "input.Customize2_1 == false",
                            helper(
                              numericInput(
                                "markgeneN",
                                "Enter top 1~10 up- and downregulated DEGs to be marked",
                                value = 10, min = 1, max = 10
                              ),
                              colour = "#999177",
                              title = "Dataset option",
                              type = "markdown",
                              content = "markgene_expression"
                            ),
                          ),
                          conditionalPanel(
                            condition = "input.Customize2_1 == true",
                            selectizeInput(
                              "customize_genes2_1",
                              "Choose 1~20 gene symbol(s)",
                              choices = NULL,
                              multiple = T,
                              selected = NULL,
                              options = list(maxOptions = 30000,#增加可以显示的基因选项数量
                                             maxItems = 20)
                            )
                          ),
                          radioGroupButtons(
                            "p.value",
                            "Threshold of p value",
                            choices = c(0.0001, 0.001, 0.01,0.05,0.1),
                            selected = 0.05
                          ),
                          sliderInput(
                            "log2FC1",
                            "Threshold of log2(Fold Change)",
                            min=0.5,
                            max=5,
                            value=2,
                            step=0.1
                          ),
                          div(style="display:inline-block",
                          colourInput(inputId = "color1_2_1",
                                      label =  "Up color",
                                      value = "#ff9999",
                                      width = "150px",
                                      allowTransparent = F,
                                      returnName = TRUE,
                                      showColour='background',
                                      closeOnClick = TRUE)),
                          div(style="display:inline-block",
                          colourInput(inputId = "color2_2_1",
                                      label =  "Down color",
                                      value = "#b8dafc",
                                      width = "150px",
                                      allowTransparent = F,
                                      returnName = TRUE,
                                      showColour='background',
                                      closeOnClick = TRUE)),
                          br(),
                          actionButton(
                            "submit2_1",
                            "Submit",
                            icon=icon("circle-right",lib = "font-awesome")
                          )
                        ),
                        mainPanel(
                          column(7,
                                 dropdownButton(
                                   tags$h5("For RNA array data, log2(expression) ({limma} package) was used for analysis. For RNA high-throughput sequencing data, 'count' ({edgeR} package) or log2(tpm+1) ({limma} package) was used for analysis."),
                                   tags$h5("If the user changes the dataset, P Value, log2(Fold Change), and then clicks the submit button, the volcano plot changes accordingly and automatically."),
                                   tags$h5("UP: upregulated, Not Sig: not significant, DOWN: downregulated."),
                                   tags$h5("Plots can be downloaded in PDF format."),
                                   circle = F,
                                   label = "Description",
                                   status = "success",
                                   width = 400,
                                   icon = icon("align-left",lib = "font-awesome",verify_fa = FALSE))
                          ),
                          column(5,
                              downloadButton(
                                  "pdf2_1",
                                  "Download pdf",
                                  icon = icon("download",lib = "font-awesome",verify_fa = FALSE)
                                )
                            ),
                            
                            div(style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                                  withSpinner(
                                    plotOutput("volcanoPlot",inline=F,width ="100%",height = 500
                                               )
                                    ,type=6)
                            ))
                            )
                      ),

      # 2.2 Heatmap---------------------------------------------------------------------

             
             tabPanel(title = "Heatmap",
                      tags$head(
                        tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                      sidebarLayout(
                        sidebarPanel(
                          helper(
                          selectInput(
                            "dataset2_2",
                            "Select a GEO dataset",
                            choices=geolist,
                            selected = "Atopic dermatitis_GSE5667"
                          ),
                          colour = "#999177",
                          title = "Dataset option",
                          type = "markdown",
                          content = "dataset_expression"
                          ),
                          materialSwitch(
                            inputId = "Customize2_2",
                            label = "Customize genes",
                            status = "info",
                            value = FALSE
                          ),
                          conditionalPanel(
                            condition = "input.Customize2_2 == false",
                            helper(
                              radioGroupButtons(inputId = "topgenes",
                                         label = "The number of DEGs",
                                         choices = 
                                           c("Top 10 up- and downregulated DEGs"=20,
                                             "Top 5 up- and downregulated DEGs"=10),
                                         justified = TRUE,
                                         checkIcon = list(
                                           yes = icon("ok", 
                                                      lib = "glyphicon")),
                                         direction = "vertical"),
                            colour = "#999177",
                            title = "DEGs option",
                            type = "markdown",
                            content = "topgene_expression"
                            )
                          ),
                          conditionalPanel(
                            condition = "input.Customize2_2 == true",
                            selectizeInput(
                              "customize_genes2_2",
                              "Choose 3~20 gene symbols",
                              choices = NULL,
                              multiple = T,
                              selected = NULL,
                              options = list(maxOptions = 30000,#增加可以显示的基因选项数量
                                             maxItems = 20)
                            )
                          ),
                          sliderInput(
                            "log2FC2",
                            "Threshold of log2(Fold Change)",
                            min=0.5,
                            max=5,
                            value=2,
                            step=0.1
                          ),
                          div(style="display:inline-block",
                              colourInput(inputId = "color1_2_2",
                                          label =  "Up color",
                                          value = "#cf6c89",
                                          width = "150px",
                                          allowTransparent = F,
                                          returnName = TRUE,
                                          showColour='background',
                                          closeOnClick = TRUE)),
                          div(style="display:inline-block",
                              colourInput(inputId = "color2_2_2",
                                          label =  "Down color",
                                          value = "#6ccfb2",
                                          width = "150px",
                                          allowTransparent = F,
                                          returnName = TRUE,
                                          showColour='background',
                                          closeOnClick = TRUE)),
                          br(),
                          actionButton(
                            "submit2_2",
                            "Submit",
                            icon=icon("circle-right",lib = "font-awesome")
                          )
                        ),
                        mainPanel(
                          column(7,
                                 dropdownButton(
                                   tags$h5("For RNA array data, use log2(expression) ({limma} package) to analyze. For RNA high throughput sequencing data, use 'count' ({edgeR} package) or log2(tpm+1) ({limma} package) to analyze."),
                                   
                                   tags$h5("Users can choose the top 20/10 up and down differentially expressed genes or choose the gene symbols they are interested in."),
                                   tags$h5("Change dataset, gene numbers/gene symbols, log2(Fold Change) and then click the submit button, the heatmap plot changes accordingly and automatically."),
                                   
                                   tags$h5("UP: upregulated, Not Sig: not significant, DOWN: downregulated."),
                                   
                                   tags$h5("Plots can be downloaded in PDF format."),
                                   circle = F,
                                   label = "Description",
                                   status = "success",
                                   width = 400,
                                   icon = icon("align-left",lib = "font-awesome",verify_fa = FALSE))
                          ),
                            column(5,
                                   downloadButton(
                                     "pdf2_2",
                                     "Download pdf",
                                     icon = icon("download",lib = "font-awesome",verify_fa = FALSE)
                                   )),
                          div(style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                              withSpinner(
                                plotOutput("heatmapplot",inline=F,width ="100%",height = 500
                                          ),type=6)
                        ))
                      )),

      # 2.3 Table ---------------------------------------------------------------


             tabPanel(title = "Table",
                      sidebarLayout(
                        sidebarPanel(
                          helper(
                          selectInput(
                            "dataset2_3",
                            "Select a GEO dataset",
                            choices=geolist,
                            selected = "Atopic dermatitis_GSE5667"
                          ),
                          colour = "#999177",
                          title = "Dataset option",
                          type = "markdown",
                          content = "dataset_expression"
                        )
                        ),
                        mainPanel(
                          withSpinner(uiOutput('DEGList',style="auto")
                            #uiOutput('DEGList',style="auto")
                                      ,type=6),
                          downloadButton("download2_3","Download csv")
                        )
                      ))
           )
  ),

 # 3. Enrichment Analysis --------------------------------------------------

  navbarMenu(
    title = "Enrichment Analysis",


      # 3.1 GSEA ----------------------------------------------------------------

    
    tabPanel(title = "Gene Set Enrichment Analysis (GSEA)",
             useShinyFeedback(),
             useShinyjs(),
            
             tabsetPanel(

            # 3.1.1 Dot Plot-------------------------------------------------------------------

               
               tabPanel(title = "Dot Plot",
                          tags$head(
                          tags$style(type="text/css",
                                     '.shiny-output-error-validation{color: red;}')),
                        sidebarLayout(
                          sidebarPanel(
                            
                            helper(
                            selectInput(
                              "dataset3_2_1",
                              "Select a GEO dataset",
                              choices=geolist,
                              selected = "Atopic dermatitis_GSE5667"
                            ),colour = "#999177",
                            title = "Dataset option",
                            type = "markdown",
                            content = "dataset_GSEA"
                          ),
                            # selectInput(
                            #   "annotated3_2_1",
                            #   "Select annotated gene sets(MSigDB Collections)",
                            #   choices=annogeneset
                            # ),
                            # materialSwitch(
                            #   inputId = "Customize3",
                            #   label = "Customize gene sets",
                            #   status = "info",
                            #   value = FALSE
                            # ),
                          # tags$head(
                          #   tags$style(type="text/css",
                          #              '.myclass.shiny-bound-input{overflow-x: scroll;}')),
                          helper(
                          selectizeInput(
                                "customize_genesets_gsea",
                                "Choose 2~20 gene sets",
                                choices = NULL,
                                multiple = T,
                                selected = NULL,
                                options = list(maxOptions = 15000,#增加可以显示的基因选项数量
                                               maxItems = 20)
                              ),
                          colour = "#999177",
                          title = "Dataset option",
                          type = "markdown",
                          content = "geneset"),
                            
                            actionButton(
                              "submit3_2_1",
                              "Submit",
                              icon=icon("circle-right",lib = "font-awesome")
                            )
                          ),
                          mainPanel(
                            column(7,
                                   dropdownButton(
                                     tags$h5("The Enrichment Analysis module uses the clusterProfiler package to explore the functional characteristics of allergic disease data."),
                                     tags$h5("Annotated gene sets are from MSigDB (Molecular Signatures Database), including hallmark gene sets, canonical pathways and Gene Ontology gene sets."),
                                     tags$h5("Plots can be downloaded in PDF format."),
                                     circle = F,
                                     label = "Description",       
                                     status = "success",
                                     width = 400,
                                     icon = icon("align-left",lib = "font-awesome",verify_fa = FALSE))
                            ),
                              column(5,
                                     downloadButton(
                                "pdf3_2_1",
                                "Download pdf",
                                icon = icon("download",lib = "font-awesome",verify_fa = FALSE)
                              )),
                            div(style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                                withSpinner(
                                  plotOutput("dotplot2",inline=F,width ="100%",height = 500
                                              ),type=6)
                          ))
                        )
                         ),

            # 3.1.2 Ridgeline Plot-------------------------------------------------------------------

    
               tabPanel(title = "Ridgeline Plot",
                        tags$head(
                          tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                        sidebarLayout(
                          sidebarPanel(
                            helper(
                              selectInput(
                                "dataset3_2_2",
                                "Select a GEO dataset",
                                choices=geolist,
                                selected = "Atopic dermatitis_GSE5667"
                              ),colour = "#999177",
                              title = "Dataset option",
                              type = "markdown",
                              content = "dataset_GSEA"
                            ),
                            selectInput(
                              "annotated3_2_2",
                              "Select annotated gene sets (MSigDB Collections)",
                              choices=annogeneset
                            ),
                            
                            actionButton(
                              "submit3_2_2",
                              "Submit",
                              icon=icon("circle-right",lib = "font-awesome")
                            )
                          ),
                          mainPanel(
                            column(7,
                                   dropdownButton(
                                     tags$h5("The Enrichment Analysis module uses the clusterProfiler package to explore the functional characteristics of allergic disease data."),
                                     tags$h5("Annotated gene sets are from MSigDB (Molecular Signatures Database), including hallmark gene sets, canonical pathways and Gene Ontology gene sets."),
                                     tags$h5("Plots can be downloaded in PDF format."),
                                     circle = F,
                                     label = "Description",
                                     status = "success",
                                     width = 400,
                                     icon = icon("align-left",lib = "font-awesome",verify_fa = FALSE))
                            ),
                            column(5,
                                   downloadButton(
                              "pdf3_2_2",
                              "Download pdf",
                              icon = icon("download",lib = "font-awesome",verify_fa = FALSE)
                            )),
                            div(style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                                withSpinner(
                                  plotOutput("ridgeplot",inline=F,width ="100%",height = 720
                                            ),type=6)
                            )
                        )
                        )
                 ),

            # 3.1.3 GSEA plot-------------------------------------------------------------------

    
               tabPanel(title = "GSEA plot",
                        useShinyFeedback(),
                        useShinyjs(),
                        tags$head(
                          tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                        sidebarLayout(
                          sidebarPanel(
                            helper(
                              selectInput(
                                "dataset3_2_3",
                                "Select a GEO dataset",
                                choices=geolist,
                                selected = "Atopic dermatitis_GSE5667"
                              ),colour = "#999177",
                              title = "Dataset option",
                              type = "markdown",
                              content = "dataset_GSEA"
                            ),
                            selectInput(
                              "annotated3_2_3",
                              "Select annotated gene sets (MSigDB Collections)",
                              choices=annogeneset
                            ),
                            
                            selectizeInput(
                              "gseasets",
                              label="Select a gene set to plot",
                              choices=NULL,
                              multiple = F,
                              selected = NULL,
                              options = list(maxOptions = 15000)
                            ),
                            helper(
                            materialSwitch(
                              inputId = "topgene",
                              label = "Show top enrichment genes",
                              value = T,
                              status = "primary"
                            ),
                            colour = "#999177",
                            title = "Dataset option",
                            type = "markdown",
                            content = "gsea"
                            ),
                            conditionalPanel(
                              condition = "input.topgene == true",
                              numericInput(
                                "topgeneN",
                                "Enter 1~50 genes to be marked",
                                value = 25, min = 1, max = 50
                                )
                            ),
                            conditionalPanel(
                              condition = "input.topgene == false",
                              NULL
                            ),
                            
                            actionButton(
                              "submit3_2_3",
                              "Submit",
                              icon=icon("circle-right",lib = "font-awesome")
                            )
                          ),
                          mainPanel(
                            column(7,
                                   dropdownButton(
                                     tags$h5("Enrichment analysis uses {clusterProfiler} package to explore functional characteristics of genomics data."),
                                     tags$h5("Annotated gene sets are from MSigDB (Molecular Signatures Database), including hallmark gene sets, canonical pathways and Gene Ontology gene sets."),
                                     tags$h5("Plots can be downloaded in PDF format."),
                                     circle = F,
                                     label = "Description",
                                     status = "success",
                                     width = 400,
                                     icon = icon("align-left",lib = "font-awesome",verify_fa = FALSE))
                            ),
                            column(5,
                                   downloadButton(
                              "pdf3_2_3",
                              "Download pdf",
                              icon = icon("download",lib = "font-awesome",verify_fa = FALSE)
                            )),
                            div(style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                                withSpinner(
                                  plotOutput("gseaplot",inline=F,width ="100%",height = 500
                                             ),type=6)
                          )
                        ))
                        ),

            # 3.1.4 Table-------------------------------------------------------------------

    
               tabPanel(title = "Table",
                        tags$head(
                          tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                        sidebarLayout(
                          sidebarPanel(
                            helper(
                              selectInput(
                                "dataset3_2_4",
                                "Select a GEO dataset",
                                choices=geolist,
                                selected = "Atopic dermatitis_GSE5667"
                              ),colour = "#999177",
                              title = "Dataset option",
                              type = "markdown",
                              content = "dataset_GSEA"
                            ),
                            selectInput(
                              "annotated3_2_4",
                              "Select annotated gene sets (MSigDB Collections)",
                              choices=annogeneset
                            )
                          ),
                          mainPanel(
                            withSpinner(uiOutput('enrichlist2',style = "auto"),type=6),
                            downloadButton("download3_2_4","Download csv")
                          )
                        )
                        )
             )
      
    ),     

      # 3.2 ssGSEA --------------------------------------------------------------


    tabPanel(title = "Single-sample GSEA (ssGSEA)",
             
             useShinyFeedback(),
             useShinyjs(),
             tabsetPanel(

# 3.2.1 Heatmap -----------------------------------------------------------

               tabPanel(
                 title = "Heatmap",
             tags$head(
             tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
             sidebarLayout(
               sidebarPanel(
                 helper(
                   selectInput(
                     "dataset3_3_1",
                     "Select a GEO dataset",
                     choices=geolist,
                     selected = "Atopic dermatitis_GSE5667"
                   ),colour = "#999177",
                   title = "Dataset option",
                   type = "markdown",
                   content = "dataset_ssGSEA"
                 ),
                 helper(
                 selectizeInput(
                     "pathway3_3",
                     "Select 3~20 pathways for ssGSEA",
                     choices = NULL,
                     selected = NULL,
                     multiple = T,
                     options = list(maxOptions = 15000,#增加可以显示的基因选项数量
                                    maxItems = 20)
                   ),
                 colour = "#999177",
                 title = "Dataset option",
                 type = "markdown",
                 content = "geneset"),
                 div(style="display:inline-block",
                     colourInput(inputId = "color1_3_2_1",
                                 label =  "Up color",
                                 value = "#cf6c89",
                                 width = "150px",
                                 allowTransparent = F,
                                 returnName = TRUE,
                                 showColour='background',
                                 closeOnClick = TRUE)),
                 div(style="display:inline-block",
                     colourInput(inputId = "color2_3_2_1",
                                 label =  "Down color",
                                 value = "#6ccfb2",
                                 width = "150px",
                                 allowTransparent = F,
                                 returnName = TRUE,
                                 showColour='background',
                                 closeOnClick = TRUE)),
                 br(),
                 actionButton(
                   "submit3_3_1",
                   "Submit",
                   icon=icon("circle-right",lib = "font-awesome")
                 )
               ),
               mainPanel(
                 column(7,
                        dropdownButton(tags$h5("The Enrichment Analysis module uses the clusterProfiler package to explore the functional characteristics of allergic disease data."),
                                       tags$h5("Annotated gene sets are from MSigDB (Molecular Signatures Database), including hallmark gene sets, canonical pathways and Gene Ontology gene sets."),
                                       tags$h5("Wilcoxon p value: ****: <0.0001, ***: <0.001, **: <0.01, *: <0.05, Not Sig: >0.05."),
                                       tags$h5("Plots can be downloaded in PDF format."),
                                       circle = F,
                                       label = "Description",
                                       status = "success",
                                       width = 400,
                                       icon = icon("align-left",lib = "font-awesome",verify_fa = FALSE))
                 ),
                 column(5,
                        downloadButton(
                   "pdf3_3",
                   "Download pdf",
                   icon = icon("download",lib = "font-awesome",verify_fa = FALSE)
                 )),
                 div(style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                     withSpinner(
                       plotOutput("ssgseaheatmap",inline=F,width ="100%",height = 500
                                  ),type=6)
               ))

    )
    ),

# 3.2.2 Table --------------------------------------------------------------

    
    tabPanel(
      title = "Table",
      sidebarLayout(
        sidebarPanel(
          helper(
            selectInput(
              "dataset3_3_2",
              "Select a GEO dataset",
              choices=geolist,
              selected = "Atopic dermatitis_GSE5667"
            ),
            colour = "#999177",
            title = "Dataset option",
            type = "markdown",
            content = "dataset_expression"
          )
        ),
        mainPanel(
          withSpinner(DTOutput('ssgseaList'),type=6),
          downloadButton("download3_3","Download csv")
        )
      )
      
    )
    )
    )
),

 # 4. Immune Infiltration----------------------------------------------------------------------


    tabPanel(title = "Immune Infiltration",
             
             useShinyFeedback(),
             useShinyjs(),
             tabsetPanel(

      # 4.1 Stacked Bar Chart --------------------------------------------------------------------

               
              tabPanel(title = "Stacked Bar Chart",
                        tags$head(
                          tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                        sidebarLayout(
                          sidebarPanel(
                            helper(
                              selectInput(
                                "dataset4_1",
                                "Select a GEO dataset",
                                choices=geolist,
                                selected = "Atopic dermatitis_GSE5667"
                              ),colour = "#999177",
                              title = "Dataset option",
                              type = "markdown",
                              content = "dataset_immune"
                            ),
                            selectInput(
                              "algorithm1",
                              "Select an algorithm for immune infiltration analysis",
                              choices = immune_algorithm
                            ),
                            
                            actionButton(
                              "submit4_1",
                              "Submit",
                              icon=icon("circle-right",lib = "font-awesome")
                            )
                          ),
                          mainPanel(
                            column(8,
                                   dropdownButton(
                                     tags$h5("The Immune Infiltration module aims to show immune cell infiltration in allergic disease data."),
                                     tags$h5("The stacked bar chart is divided into two groups to show between-group differences."),
                                     tags$h5("Plots can be downloaded in PDF format."),
                                     circle = F,
                                     label = "Description",
                                     status = "success",
                                     width = 400,
                                     icon = icon("align-left",lib = "font-awesome",verify_fa = FALSE))
                            ),
                             column(4,
                                    downloadButton(
                               "pdf4_1",
                               "Download pdf",
                               icon = icon("download",lib = "font-awesome",verify_fa = FALSE)
                             )),
                            div(class='centered',style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                                withSpinner(
                                  plotOutput("stackbarplot",inline=F,width ="100%",height = 500
                                             ),type=6)
                          )
                        )
                        )
                        ),

      # 4.2 Heatmap---------------------------------------------------------------------

    
               tabPanel(title = "Heatmap",
                        tags$head(
                          tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                        sidebarLayout(
                          sidebarPanel(
                            helper(
                              selectInput(
                                "dataset4_2",
                                "Select a GEO dataset",
                                choices=geolist,
                                selected = "Atopic dermatitis_GSE5667"
                              ),colour = "#999177",
                              title = "Dataset option",
                              type = "markdown",
                              content = "dataset_immune"
                            ),
                            selectInput(
                              "algorithm2",
                              "Select an algorithm for immune infiltration analysis",
                              choices = immune_algorithm
                            ),
                            div(style="display:inline-block",
                                colourInput(inputId = "color1_4_2",
                                            label =  "High color",
                                            value = "#cf6c89",
                                            width = "150px",
                                            allowTransparent = F,
                                            returnName = TRUE,
                                            showColour='background',
                                            closeOnClick = TRUE)),
                            div(style="display:inline-block",
                                colourInput(inputId = "color2_4_2",
                                            label =  "Low color",
                                            value = "#6ccfb2",
                                            width = "150px",
                                            allowTransparent = F,
                                            returnName = TRUE,
                                            showColour='background',
                                            closeOnClick = TRUE)),
                            br(),
                            actionButton(
                              "submit4_2",
                              "Submit",
                              icon=icon("circle-right",lib = "font-awesome")
                            )
                          ),
                          mainPanel(
                            column(7,
                                   dropdownButton(
                                     tags$h5("The Immune infiltration module aims to show immune cell infiltration in allergic disease data."),
                                     tags$h5("Wilcoxon p value: ****: <0.0001, ***: <0.001, **: <0.01, *: <0.05, Not Sig: >0.05."),
                                     tags$h5("Plots can be downloaded in PDF format."),
                                     circle = F,
                                     label = "Description",
                                     status = "success",
                                     width = 400,
                                     icon = icon("align-left",lib = "font-awesome",verify_fa = FALSE))
                            ),
                            column(5,
                                   downloadButton(
                              "pdf4_2",
                              "Download pdf",
                              icon = icon("download",lib = "font-awesome",verify_fa = FALSE)
                            )),
                            div(style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                                withSpinner(
                                  plotOutput("immuneheatmap",inline=F,width ="100%",height = 500
                                            ),type=6)
                          )
                        ))
                        ),

      # 4.3 Box Plot---------------------------------------------------------------------


               tabPanel(title = "Box Plot",
                        tags$head(
                          tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                       sidebarLayout(
                         sidebarPanel(
                           helper(
                             selectInput(
                               "dataset4_3",
                               "Select a GEO dataset",
                               choices=geolist,
                               selected = "Atopic dermatitis_GSE5667"
                             ),colour = "#999177",
                             title = "Dataset option",
                             type = "markdown",
                             content = "dataset_immune"
                           ),
                           selectInput(
                             "algorithm3",
                             "Select an algorithm for immune infiltration analysis",
                             choices = immune_algorithm
                           ),
                           div(style="display:inline-block",
                               colourInput(inputId = "color1_4_3",
                                           label =  "Color1",
                                           value = "#006a4e",
                                           width = "150px",
                                           allowTransparent = F,
                                           returnName = TRUE,
                                           showColour='background',
                                           closeOnClick = TRUE)),
                           div(style="display:inline-block",
                               colourInput(inputId = "color2_4_3",
                                           label =  "Color2",
                                           value = "#a52a2a",
                                           width = "150px",
                                           allowTransparent = F,
                                           returnName = TRUE,
                                           showColour='background',
                                           closeOnClick = TRUE)),
                           br(),
                           actionButton(
                             "submit4_3",
                             "Submit",
                             icon=icon("circle-right",lib = "font-awesome",verify_fa = FALSE)
                           )
                         ),
                         mainPanel(
                           column(8,
                                  dropdownButton(tags$h5("The Immune infiltration module aims to show immune cell infiltration in allergic disease data."),
                                                 tags$h5("Wilcoxon p value: ****: <0.0001, ***: <0.001, **: <0.01, *: <0.05, Not Sig: >0.05."),
                                                 tags$h5("Plots can be downloaded in PDF format."),
                                                 circle = F,
                                                 label = "Description",
                                                 status = "success",
                                                 width = 400,
                                                 icon = icon("align-left",lib = "font-awesome",verify_fa = FALSE))
                           ),
                           column(4,
                                  downloadButton(
                             "pdf4_3",
                             "Download pdf",
                             icon = icon("download",lib = "font-awesome",verify_fa = FALSE)
                           )),
                           div(style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                               withSpinner(
                                 plotOutput("immuneboxplot",inline=F,width ="100%",height = 500
                                           ),type=6)
                         )
                       ))
                         ),

      # 4.4 Table ---------------------------------------------------------------

    
               tabPanel(title = "Table",
                        tags$head(
                          tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                        sidebarLayout(
                          sidebarPanel(
                            helper(
                              selectInput(
                                "dataset4_4",
                                "Select a GEO dataset",
                                choices=geolist,
                                selected = "Atopic dermatitis_GSE5667"
                              ),colour = "#999177",
                              title = "Dataset option",
                              type = "markdown",
                              content = "dataset_immune"
                            ),
                            selectInput(
                              "algorithm4",
                              "Select an algorithm for immune infiltration analysis",
                              choices = immune_algorithm
                            )
                          ),
                          mainPanel(
                            withSpinner(
                              DTOutput('immunelist'),type=6),
                            downloadButton("download4_4","Download csv")
                          )
                        )
                        )
    )
    ),

 # 5. Correlation Analysis -------------------------------------------------


   tabPanel(title = "Correlation Analysis",
            
            useShinyFeedback(),
            useShinyjs(),
               tabsetPanel(
                 # 5.1 Scatter diagram---------------------------------------------------------------------
                 
                 tabPanel(title = "Scatter diagram",
                          tags$head(
                            tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                          sidebarLayout(
                            sidebarPanel(
                              helper(
                                selectInput(
                                  "dataset5_1",
                                  "Select a GEO dataset",
                                  choices=geolist,
                                  selected = "Atopic dermatitis_GSE5667"
                                ),colour = "#999177",
                                title = "Dataset option",
                                type = "markdown",
                                content = "dataset_correlation"
                              ),
                              radioButtons(
                                "variable",
                                "Choose two variables to analysis",
                                choices = c("Gene & Gene"="gvg",
                                            "Gene & Pathway"="gvp",
                                            "Pathway & Pathway"="pvp")
                              ),
                              #disabled(
                              selectizeInput(
                                "X5_1_1",
                                "Select a gene symbol for X axis",
                                choices = NULL,
                                selected = NULL,
                                options = list(maxOptions = 30000)
                              ),
                              selectizeInput(
                                "Y5_1_1",
                                "Select a gene symbol for Y axis",
                                choices = NULL,
                                selected = NULL,
                                options = list(maxOptions = 30000)
                              ),
                              radioButtons(
                                "method5_1_1",
                                "Select a method for correlation",
                                choices = c("spearman","pearson"),
                                inline=TRUE#水平放置选项
                              ),
                              radioButtons(
                                "group1",
                                "Select a group for correlation",
                                choices = c("All","Atopic Dermatitis","Normal"),
                                inline=TRUE#水平放置选项
                                ),
                              conditionalPanel(
                                condition="input.group1=='All'",
                                div(style="display:inline-block",
                                    colourInput(inputId = "color1_5_1",
                                                label =  "Color1",
                                                value = "#ca85ca",
                                                width = "150px",
                                                allowTransparent = F,
                                                returnName = TRUE,
                                                showColour='background',
                                                closeOnClick = TRUE)),
                                div(style="display:inline-block",
                                    colourInput(inputId = "color2_5_1",
                                                label =  "Color2",
                                                value = "#85ca85",
                                                width = "150px",
                                                allowTransparent = F,
                                                returnName = TRUE,
                                                showColour='background',
                                                closeOnClick = TRUE)),
                                br()
                              ),
                              conditionalPanel(
                                condition = "input.group1!='All'",
                                
                                    colourInput(inputId = "color3_5_1",
                                                label =  "Color",
                                                value = "#ca85ca",
                                                width = "150px",
                                                allowTransparent = F,
                                                returnName = TRUE,
                                                showColour='background',
                                                closeOnClick = TRUE)
                              ),
                              
                              actionButton(
                                "submit5_1_1",
                                "Submit",
                                icon=icon("circle-right",lib = "font-awesome",verify_fa = FALSE)
                              )
                            ),
                            mainPanel(
                              column(7,
                                     dropdownButton(
                                       tags$h5("The scatter diagram shows the correlation between the two variables."),
                                       tags$h5("Users can choose the variables they are interested in."),
                                       tags$h5("Plots can be downloaded in PDF format."),
                                       circle = F,
                                       label = "Description",
                                       status = "success",
                                       width = 400,
                                       icon = icon("align-left",lib = "font-awesome",verify_fa = FALSE))
                              ),
                                column(5,
                                       downloadButton(
                                  "pdf5_1_1",
                                  "Download pdf",
                                  icon = icon("download",lib = "font-awesome",verify_fa = FALSE)
                                )),
                              div(style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                                  withSpinner(
                                    plotOutput("genevsgene",inline=F,width ="100%",height = 550),
                                    type=6
                              ))
                            )
                          )),


      # 5.2 Correlation heatmap---------------------------------------------------------------------


      tabPanel(title = "Correlation heatmap",
               sidebarLayout(sidebarPanel(
                              helper(
                                selectInput(
                                  "dataset5_2",
                                  "Select a GEO dataset",
                                  choices=geolist,
                                  selected = "Atopic dermatitis_GSE5667"
                                ),colour = "#999177",
                                title = "Dataset option",
                                type = "markdown",
                                content = "dataset_correlation"
                              ),
                              selectizeInput(
                                "genes5_2_1",
                                "Select 5~20 gene symbols for correlation analysis",
                                choices = NULL,
                                selected = NULL,
                                multiple = T,
                                options = list(maxOptions = 30000,#增加可以显示的基因选项数量
                                               maxItems = 20)
                              ),
                              radioButtons(
                                "method5_2_1",
                                "Select a method for correlation analysis",
                                choices = c("spearman","pearson")
                              ),
                              radioButtons(
                                "group2_1",
                                "Select a group for correlation analysis",
                                choices = c("All","AD","Normal")
                              ),
                              actionButton(
                                "submit5_2_1",
                                "Submit",
                                icon=icon("circle-right",lib = "font-awesome",verify_fa = FALSE)
                              )
                            ),
                            mainPanel(
                              column(7,
                                     dropdownButton(
                                       tags$h5("Correlation heatmap shows the correlation between multiple variables."),
                                       tags$h5("Users can choose the variables they are interested in."),
                                       tags$h5("Plots can be downloaded in PDF format."),
                                       tags$h5("p value: ***: <0.001, **: <0.01, *: <0.05."),
                                       circle = F,
                                       label = "Description",
                                       status = "success",
                                       width = 400,
                                       icon = icon("align-left",lib = "font-awesome",verify_fa = FALSE))
                              ),
                              column(5,
                                     downloadButton(
                                "pdf5_2_1",
                                "Download pdf",
                                icon = icon("download",lib = "font-awesome",verify_fa = FALSE)
                              )),
                              div(#style='display:block;width:400px;overflow-x: scroll;height:400px;overflow-y: scroll;',
                                  style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                                  withSpinner(
                                    plotOutput("corheatmap",inline=F,width ="100%",height = "500px"
                                               ),
                                    type=6
                              )
                            )
                          ))
                          )
               )
               
      ),
# 6. Single cell -----------------------------------------------------------------
# 6.1 clusterplot -----------------------------------------------------------------

tabPanel("scRNA-seq",
         tabsetPanel(
         tabPanel(
             title = "Cluster plot",
             tags$head(
               tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
             sidebarLayout(
               sidebarPanel(
                   selectInput(
                     "dataset6_1",
                     "Select a GEO dataset",
                     choices=sclist,
                     selected = "Atopic dermatitis_GSE180885"
                   ),
                   actionButton(
                     "submit6_1",
                     "Submit",
                     icon=icon("circle-right",lib = "font-awesome",verify_fa = FALSE)
                   )
           ),
           mainPanel(
             div(style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                 column(5,offset=1,
                        downloadButton(
                          "pdf6_1",
                          "Download pdf",
                          icon = icon("download",lib = "font-awesome",verify_fa = FALSE)
                        )),
                 withSpinner(
                   plotOutput("clusterPlot",inline=F,width ="100%",height = 500
                   ),type=6)
             )
           )
         )
         ),
         # 6.2 Feature plot-----------------------------------------------------------------
         
         tabPanel(
           title = "Feature plot",
           sidebarLayout(
             sidebarPanel(
               selectInput(
                 "dataset6_2",
                 "Select a GEO dataset",
                 choices=sclist,
                 selected = "Atopic dermatitis_GSE180885"
               ),
               radioButtons(
                 "featuretype",
                 "Choose variable",
                 choices = c("gene",
                             "pathway"),
                 selected = "gene"
               ),
               selectizeInput(
                 "feature6_2",
                 "Select 1~9 gene(s)",
                 choices = NULL,
                 selected = c("GOLT1A","PRSS38","RNF223","IGKV1-39","WDR63","RGPD8","CD1C","COL11A1","SAMD11"),
                 options = list(maxOptions = 30000),
                 multiple = T
               ),
               actionButton(
                 "submit6_2",
                 "Submit",
                 icon=icon("circle-right",lib = "font-awesome",verify_fa = FALSE)
               )
             ),
             mainPanel(
               #div(style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                   #wellPanel(
                   withSpinner(
                     plotOutput("featurePlot",inline=F,width ="100%",height = 500
                     )
                     ,type=6)#)
               #)
             )
           )
         ),
         # 6.3 Heatmap-----------------------------------------------------------------
         
         tabPanel(
           title = "Heatmap",
           sidebarLayout(
             sidebarPanel(
               selectInput(
                 "dataset6_3",
                 "Select a GEO dataset",
                 choices=sclist,
                 selected = "Atopic dermatitis_GSE180885"
               ),
               radioButtons(
                 "heatmaptype",
                 "Choose variable",
                 choices = c("gene",
                             "pathway"),
                 selected = "gene"
               ),
               selectizeInput(
                 "heatmap6_3",
                 "Select 2~15 gene(s)",
                 choices = c("GOLT1A","PRSS38","RNF223","IGKV1-39","WDR63","RGPD8","CD1C","COL11A1","SAMD11"),
                 selected = c("GOLT1A","PRSS38","RNF223","IGKV1-39","WDR63","RGPD8","CD1C","COL11A1","SAMD11"),
                 options = list(maxOptions = 30000),
                 multiple = T
               ),
               actionButton(
                 "submit6_3",
                 "Submit",
                 icon=icon("circle-right",lib = "font-awesome",verify_fa = FALSE)
               )
             ),
             mainPanel(
               div(style='display:block;width:90%;overflow-x: scroll;height:70%;overflow-y: scroll;',
                   withSpinner(
                     plotOutput("SCheatmap",inline=F,width ="100%",height = 500
                     )
                     ,type=6)
               )
             )
           )
         )
)
),
tabPanel(title = "Intergrated DataSets",
         sidebarLayout(
           sidebarPanel(
             helper(
               selectInput(
                 "Integrated_disease_input",
                 "Select allergic disease of interest",
                 choices=updated_46_diseaselist_input
               ),
               colour = "#999177",
               title = "Allergic disease option",
               type = "inline",
               content = "CTPAD includes 46 transcriptomic datasets related to 9 allergic diseases, sourced from the GEO database. The datasets cover two species: humans and mice."
             )
           ),
           mainPanel(
             fluidRow(
               column(12,
                      dropdownButton(
                        tags$h5("A differentially expressed gene (DEG) is defined as having a p-value less than 0.05 and an absolute |log2(FoldChange)| greater than 2."),
                        tags$h5("In each dataset's DEG analysis, a gene that is significantly up-regulated (disease vs. control) is assigned a value of 1. A gene that is significantly down-regulated (disease vs. control) is assigned a value of -1. If a gene is not significantly differentially expressed, it is assigned a value of 0."),
                        tags$h5("The first column, `Integrated DEG results score`, evaluates whether a gene is consistently differentially expressed across datasets. A higher positive score indicates greater confidence that a gene is up-regulated (disease vs. control), while a lower negative score indicates greater confidence that a gene is down-regulated (disease vs. control)."),
                        circle = F,
                        label = "Description",
                        status = "success",
                        width = 400,
                        icon = icon("align-left",lib = "font-awesome",verify_fa = FALSE))),
               column(12, withSpinner(dataTableOutput("Integrated_DT"),
                                      type=6)),
               column(12, downloadButton("Integrated_Download","Download csv"))
             )
           )
         )
),
# 7. Data -----------------------------------------------------------------

 
 tabPanel("Data",
          useShinyjs(),
          #column(1),
          column(11,
                 withSpinner(uiOutput('data_i'),type=6)),
          column(1)
          ),
# 8. About -----------------------------------------------------------------

tabPanel(title = "About",
         #shinyjs::inlineCSS(appCSS),
         useShinyjs(),
         #useSweetAlert("material-ui", ie = F),
#          tags$style(HTML(".footer-container {
# width: 100%; /*for nothing*/
# bottom: 0; /*for nothing*/
# left: 0; /*for nothing*/
# position: static;
# padding: 0;/*IMPORTANT! W/0
# PADDING*/
# background-color: #f8f8f8;
# }")),
# box(
#   title = "Contact Us", status = "primary", solidHeader = TRUE,
#   collapsible = TRUE),

tags$h3(strong("CONTACT US",style="color:#496f89;")),
tags$h5(c("If you need any further information about CTPAD,
          please feel free to contact us: "),
        strong("luopeng@smu.edu.cn (Peng Luo); 
               smuhuangwanqiao@i.smu.edu.cn (Wanqiao Huang);
               smuyanghong@i.smu.edu.cn (Hong Yang)"
               )),
tags$h5("Our lab has a long-standing interest in bioinformatics and biomedical research. We have previously developed several other Shiny web tools focusing on solving various scientific questions:"),
tags$h5(tags$a(href= "https://www.camoip.net/",
       "CAMOIP",style="color:#5d8aa8;",target="_blank"),": A Web Server for Comprehensive Analysis on Multi-omics of Immunotherapy in Pan-cancer. doi: ",
       tags$a(href= "https://doi.org/10.1093/bib/bbac129","10.1093/bib/bbac129",style="color:#5d8aa8;",target="_blank")),
tags$h5(tags$a(href= "https://smuonco.shinyapps.io/Onlinemeta/",
               "Onlinemeta",style="color:#5d8aa8;",target="_blank"),": A Web Server For Meta-Analysis Based On R-shiny. doi: ",
        tags$a(href= "https://doi.org/10.1101/2022.04.13.488126",
               "10.1101/2022.04.13.488126[preprint]",style="color:#5d8aa8;",target="_blank")),
tags$h5(tags$a(href= "https://smuonco.shinyapps.io/PanCanSurvPlot/",
               "PanCanSurvPlot",style="color:#5d8aa8;",target="_blank"),": A Large-scale Pan-cancer Survival Analysis Web Application. doi: ",
        tags$a(href= "https://doi.org/10.1101/2022.12.25.521884",
               "10.1101/2022.12.25.521884[preprint]",style="color:#5d8aa8;",target="_blank")),

br(),

tags$h3(strong("FAQ",style="color:#496f89;")),
tags$h5(strong("Why does the volcano map sometimes not show all the gene symbols that should be marked?")),
tags$h5("   The data points are so crowded that the algorithm in ggrepel package cannot find a solution to place all the gene labels."),
           tags$h5(strong("Abbreviations:")),
           tags$h5("GSE71822: HDM for house dust mite."),
           tags$h5("GSE148240: BioPM for biological particulate matter."),
           tags$h5("GSE13382 and GSE117898: OVA for ovalbumin."),
           
br(),

 tags$h3(strong("COMMENT BOX",style="color:#496f89;")),
           fluidRow(column(9,
                           tags$h5("Requests for new datasets/future functions/error reports/questions about CTPAD are all welcome. We truly appreciate your feedback!",style="color:#9c9c9c;"),
                textInput(inputId = "contact", label = "Name/Email (optional)", width = "60%"),
                textAreaInput(inputId = "comment", label = labelMandatory("Comment"), placeholder = "How can we improve this web? Enter your comment here.", width = "100%", height = "100px"),
                uiOutput("attachment"),
                actionButton("submit8", "Submit Comment", class = "btn-primary")
 ))
)
)
)
)

