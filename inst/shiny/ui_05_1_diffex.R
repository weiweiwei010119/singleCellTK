shinyPanelDiffex <- fluidPage(
  tags$div(
    class = "container",
    h1("Differential Expression"),
    tags$a(href = "https://www.sctk.science/articles/tab05_differential-expression",
           "(help)", target = "_blank"),
    fluidRow(
      panel(
        style = "margin:2px;",
        h3("Method and Matrix"),
        p("For 'MAST', 'Limma' and 'ANOVA', log-transformed count matrix is preferred; for 'DESeq2', count matrix is preferred.",
          style = "color:grey;"),
        fluidRow(
          column(
            4,
            selectInput('deMethod', "Choose analysis method",
                        c('MAST', 'DESeq2', 'Limma', 'ANOVA'))
          ),
          column(
            4,
            uiOutput("deAssay")
            #selectInput("deAssay", "Select Assay:", currassays)
          )
        ),
        useShinyjs(),
        actionButton("deViewThresh", label = "View Thresholding"),
        shinyjs::hidden(
          wellPanel(
            id = "deThreshpanel",
            textOutput("deSanityWarnThresh"),
            uiOutput("deThreshPlotDiv"),
            #plotOutput("deThreshplot"),
            actionButton("deHideThresh", label = "Hide")
            )
          ),
        h3("Condition Setting"),
        p("Three approaches of setting provided for flexibility. ",
          style = "color:grey;"),
        radioButtons('deCondMethod', "Condition Selection:",
                     choiceNames = c("By annotations",
                                     "Manually select individual cells",
                                     "Manually enter cell IDs"),
                     choiceValues = c(1, 2, 3), inline = TRUE),
        fluidRow(
          column(width = 6,
                 textInput("deG1Name", "Name of Condition1", NULL,
                           placeholder = "Required")
          ),
          column(width = 6,
                 textInput("deG2Name", "Name of Condition2", NULL,
                           placeholder = "Required")
          )
        ),
        conditionalPanel(
          condition = "input.deCondMethod == 1",
          # Select by class UI ####
          panel(
            selectInput("deC1Class", "Choose Annotation Class:",
                        clusterChoice),
            fluidRow(
              column(width = 6,
                     uiOutput("deC1G1UI"),
                     uiOutput("deC1G1CellCheckUI"),
                     uiOutput("deC1G1NCell")
              ),
              column(width = 6,
                     uiOutput("deC1G2UI"),
                     uiOutput("deC1G2CellCheckUI"),
                     uiOutput("deC1G2NCell")
              )
            )
          )
        ),
        conditionalPanel(
          condition = "input.deCondMethod == 2",
          panel(
            tabsetPanel(
              tabPanel(
                "Condition 1",
                tagList(
                  selectInput(
                    'deC2G1Col',
                    "Columns to display",
                    clusterChoice, multiple = TRUE, width = '550px'
                  ),
                  DT::dataTableOutput("deC2G1Table"),
                  actionButton('deC2G1Table_addAll', "Add all filtered"),
                  actionButton('deC2G1Table_clear', "Clear selection"),
                )
              ),
              tabPanel(
                "Condition 2",
                tagList(
                  selectInput(
                    'deC2G2Col',
                    "Columns to display",
                    clusterChoice, multiple = TRUE, width = '550px'
                  ),
                  p("Leave unselected for all the others.",
                    style = 'color:grey;'),
                  DT::dataTableOutput("deC2G2Table"),
                  actionButton('deC2G2Table_addAll', "Add all filtered"),
                  actionButton('deC2G2Table_clear', "Clear selection"),
                )
              )
            ),
            h4("Summary", style = 'margin-top:10px'),
            uiOutput("deC2G1info"),
            uiOutput("deC2G2info")
          )
        ),
        conditionalPanel(
          condition = "input.deCondMethod == 3",
          # Direct enter name UI ####
          panel(
            fluidRow(
              column(width = 6,
                     h4("The Condition of Interests:"),
                     textAreaInput(
                       "deC3G1Cell", "Cell IDs:", height = '150px',
                       placeholder = "Enter cell IDs here, \none per line with no symbol separator."),
                     uiOutput("deC3G1NCell")
              ),
              column(width = 6,
                     h4("The Control Condition:"),
                     textAreaInput(
                       "deC3G2Cell", "Cell IDs:", height = '150px',
                       placeholder = "Leave this blank for all the others."),
                     uiOutput("deC3G2NCell")
              )
            )
          )
        ),
        h3("Parameters"),
        fluidRow(
          column(
            width = 3,
            numericInput("deFDRThresh", "Output FDR less than:",
                         min = 0.01, max = 1, step = 0.01, value = 0.05)
          ),
          column(
            width = 3,
            numericInput("deFCThresh",
                         "Output Log2FC Absolute value greater than:",
                         min = 0, step = 0.05, value = 1)
          ),
          column(
            width = 3,
            selectInput("deCovar", "Select Covariates",
                        clusterChoice, multiple = TRUE)
          ),
          column(
            width = 3,
            style = 'margin-top: 18px;',
            checkboxInput("dePosOnly", "Only up-regulated genes",
                          value = FALSE)
          )
        ),
        fluidRow(
          column(
            width = 3,
            textInput("deAnalysisName",
                      "Name of Differential Expression Analysis:",
                      placeholder = 'Required.')
          ),
          column(
            width = 2,
            style = 'margin-top: 25px;',
            withBusyIndicatorUI(actionButton("runDE", "Run"))
          )
        )
      )
    ),
    h3("Visualization"),
    p("For preview and result presentation.", style = "color:grey;"),
    fluidRow(
      uiOutput("deResSelUI"),
      tabsetPanel(
        tabPanel(
          "Heatmap",
          panel(
            sidebarLayout(
              sidebarPanel(
                checkboxInput('deHMDoLog', "Do log transformation", FALSE),
                checkboxInput('deHMPosOnly', "Only up-regulated",
                              value = FALSE),
                numericInput("deHMFC", "Aboslute log2FC value greater than:",
                             value = 1, min = 0, step = 0.05),
                numericInput("deHMFDR", "FDR value less than", value = 0.05,
                             max = 1, step = 0.01),
                selectInput("deHMcolData", "Additional cell annotation",
                            choices = clusterChoice, multiple = TRUE),
                selectInput("deHMrowData", "Additional feature annotation",
                            choices = featureChoice, multiple = TRUE),
                uiOutput('deHMSplitColUI'),
                uiOutput('deHMSplitRowUI'),
                withBusyIndicatorUI(actionButton('dePlotHM', 'Plot'))
              ),
              mainPanel(
                plotOutput("deHeatmap", height = "600px")
              )
            )
          )
        ),
        tabPanel("Results Table",
                 DT::dataTableOutput("deResult"),
                 downloadButton("deDownload", "Download Result Table")),
        tabPanel(
          "Violin Plot",
          panel(
            fluidRow(
              div(style="display: inline-block;vertical-align:center; width: 100px;margin-left:10px",
                  p('Plot the top')),
              div(style="display: inline-block;vertical-align:center; width: 60px;",
                  numericInput('deVioNRow', label = NULL, value = 6, min = 1)),
              div(style="display: inline-block;vertical-align:center; width: 12px;",
                  p('x')),
              div(style="display: inline-block;vertical-align:center; width: 60px;",
                  numericInput('deVioNCol', label = NULL, value = 6, min = 1)),
              div(style="display: inline-block;vertical-align:center; width: 10px;",
                  p('=')),
              div(style="display: inline-block;vertical-align:center; width: 30px;",
                  uiOutput('deVioTotalUI')),
              div(style="display: inline-block;vertical-align:center; width: 50px;",
                  p('genes'))
            ),
            fluidRow(
              column(
                width = 3,
                selectInput('deVioLabel', "Label features by",
                            c("Default ID", featureChoice))
              ),
              column(
                width = 2,
                style = 'margin-top: 23px;',
                withBusyIndicatorUI(actionButton('dePlotVio', 'Plot'))
              )
            )
          ),
          textOutput("deSanityWarnViolin"),
          plotOutput("deViolinPlot", height = "800px")
        ),
        tabPanel(
          "Linear Model",
          panel(
            fluidRow(
              div(style="display: inline-block;vertical-align:center; width: 100px;margin-left:10px",
                  p('Plot the top')),
              div(style="display: inline-block;vertical-align:center; width: 60px;",
                  numericInput('deRegNRow', label = NULL, value = 6, min = 1)),
              div(style="display: inline-block;vertical-align:center; width: 12px;",
                  p('x')),
              div(style="display: inline-block;vertical-align:center; width: 60px;",
                  numericInput('deRegNCol', label = NULL, value = 6, min = 1)),
              div(style="display: inline-block;vertical-align:center; width: 10px;",
                  p('=')),
              div(style="display: inline-block;vertical-align:center; width: 30px;",
                  uiOutput('deRegTotalUI')),
              div(style="display: inline-block;vertical-align:center; width: 50px;",
                  p('genes'))
            ),
            fluidRow(
              column(
                width = 3,
                selectInput('deRegLabel', "Label features by",
                            c("Default ID", featureChoice))
              ),
              column(
                width = 2,
                style = 'margin-top: 23px;',
                withBusyIndicatorUI(actionButton('dePlotReg', 'Plot'))
              )
            ),
          ),
          textOutput("deSanityWarnReg"),
          plotOutput("deRegPlot", height = "800px")
        )
      )
    )
  )
)

