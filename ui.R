# Load the shiny library.
library(shiny)

# Load the data from a text file...
df <- read.table("thingstodoinwi.txt", sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Generate a webpage with a left sidebar panel and a main Panel to the right. 
shinyUI(pageWithSidebar(
    
    # Application title
    # HTML('<img src="wisconsin_map.jpg", height=150, width=150 />')
    headerPanel(title="Things to do in Wisconsin",
               ),
    
    # Create a sidebarPanel on the left side of the page.
    sidebarPanel(
    
        selectInput("category", "Choose a category:", 
                    choices = unique(df$Category)
                    ),
        br(),
        
        selectInput("city", "Choose a city:", 
                    choices = unique(df$City)
                    ),
        
        # The will refresh only after the submit button is clicked...
        submitButton("Click to search", icon("refresh"))
        ,br()
        
        #,helpText("Download the search results...")
                
        ,radioButtons(inputId = "var3", label="Select the file type to download the results", choices = list("png", "pdf"))
        
        # Insert to blank lines to separate the dropbox from the image.
        ,br(),br()
        
        # Show the wisconsin map image...
        ,img(src='wisconsin_map.jpg', align = "left", width=300, height=350)
        
        ), 
    
    
    # This is the main Panel. This is the area on the right that shows the
    # panel with all the options to selec from, such as Search results, Documentation, etc.
    mainPanel(
        # Create a tabPanel object...
        tabsetPanel(
            tabPanel("Search Results", tableOutput("view"), tableOutput("obs")
                                     ,downloadButton(outputId = "down", 
                                                    label="Download the results...")), 
            tabPanel("Documentation", htmlOutput("documentation")),
            tabPanel("Photo Gallery", htmlOutput("gallery")),
            tabPanel("Contact us", htmlOutput("contactus"))
                   )
         
         )
      )
    )