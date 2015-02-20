# Load the shiny library
library(shiny)

# Load the data from a text file...
df <- read.table("thingstodoinwi.txt", sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Define function to display data in the dataset by category and city...
# ---------------------------------------------------------------
displaydf <- function(category, city) {
    df[df$Category == category & df$City == city,2:6]            
}


# Define server logic for random distribution application
shinyServer(function(input, output) {
    
    # Reactive expression to generate the search results whenever the 
    # selections of the dropDown boxs change.
    data <- reactive({  
         # DropDown box to select a category.
        selectInput("category", "Choose a category:", 
                    choices = unique(df$Category) )
        # DropDown box to select a city.
        selectInput("city", "Choose a city:", 
                    choices = unique(df$City) )
    })
    
    # Generate the results of the search to display in the "ui" Search Results tab.
    output$view <- renderTable({
        data()
        displaydf(input$category, input$city)
    })
    
    # Generate the documentation to display in the "ui" documentation tab.
    output$documentation <- renderUI({
    
        welcome =       '<p><h3>Welcome to our shiny application: 
                        <b>Things to do in Wisconsin!</b> </h3></p>'
            
        whattoexpect = '<p><h4><b> What to expect? </b></h4></p>'

        aboutapp =     '<p> In this application you can find pretty cool things to do <br/> 
                        in the state of Wisconsin, from museum to shopping and <br/>
                        even going out for a nice eating experience. <br/> 
                        So, please keep reading on and we will show you how <br/>
                        to get the most from this exciting website!</p>'
            
        howtouseit =    '<p><h4><b> How to use this application? </p></h4></b>'
        
        howtouseitdet = '<p>In the top-left corner of the application, you can choose <br/> 
                        the things you want to do in the state. There are two boxes <br/> 
                        to select <b> a) </b> Choose a category and <b> b) </b> Choose a city. <br/> 
                        Once you have made your selection, click the &quot<b><u> Click to search&quot </b></u> button <br/> 
                        and your results your show on the right side of the screen, under <br/> 
                        the <b><u>&quotSearch Results&quot</b></u> tab.</p>'
        
        download_results =    '<p><h4><b> How to download the results of your search? </p></h4></b>'
        # ----------------------------------------------------------------------
        
        download_results_det= '<p>When you are satisfied with your search, you can also download <br/>
                                  the results to a PDF or PNG file. <br/> <br/>
                                  <b>How?</b> Select either <u><b>PDF</b></u> or <u><b>PNG</b></u> from the option menu on the left <br/>
                                  and then click the <u><b>Download<b></u> button.
                               </p>'
        # ----------------------------------------------------------------------
        HTML(paste(welcome,
                   whattoexpect,
                   aboutapp, 
                   howtouseit,
                   howtouseitdet, 
                   download_results,
                   download_results_det,
                   sep = '<br/>'))
        
    })
      
    # Generate the contact information to display in the "ui" documentation tab.
    output$contactus <- renderUI({ 
    
        contactus_line1 =   '<p><h3></b>Things to do in Wisconsin </b></h3></p>'
        contactus_line2 =   '<p><h4> Contact us at: </h4></p>'
        contactus_line3 =   '<p><h5> <b>Location</b>: Milwaukee, WI <br/><br/>
                                     <b>Phone<b>: (800) 555-5555  </h5></p>'
        # ----------------------------------------------------------------------
        HTML(paste(contactus_line1,
                   contactus_line2,
                   contactus_line3, 
                   sep = '<br/>'))
        
    })

    # Display the images in the output gallery...
    output$gallery <- renderUI({ 
        
        img1 =  img(src="wisconsin_eatingout.jpg")  
        img2 =  img(src="wisconsin_museum.jpg")  
        img3 =  img(src="wisconsin_parks.jpg")   
        img4 =  img(src="wisconsin_sports.jpg")   
        img5 =  img(src="wisconsin_shopping.jpg")  
        img6 =  img(src="wisconsin_waterparks.jpg")  
        
        HTML(paste(img1, img2, 
                   img3, img4,
                   img5, img6,
                   sep = '<br/> <br/>'   ))
    
    })

    # Display the record count below the search results grid...
    output$obs <- renderText({ 
        # Determine number of records in dataset.
        obs = nrow (displaydf(input$category, input$city) )
        obs = paste("Number of records found for this selection: ", obs)
        HTML(obs) 
    })
     
    # Download the search results..
    # *** This feature is still under construction... ***
    # ...
    output$down <- downloadHandler(
                      filename = function(){
                          #things-to-do-in-wi.png OR
                          #things-to-do-in-wi.pdf
                         paste("things_to_do_in_wi", input$var3, sep=".")
                      },
                      content = function(file) {
                          if (input$var3 == "png")
                                png(file)
                          else
                               pdf(file)
                         data()
                         result = displaydf(input$category, input$city)
                         write.table(result, file, sep=';', dec=',', na='', row.names=F)
                          dev.off()
                      }
                  )
    
})
