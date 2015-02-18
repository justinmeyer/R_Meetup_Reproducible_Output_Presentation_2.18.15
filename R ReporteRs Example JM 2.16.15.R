# ReporteRs Example
# Justin Meyer
# 2/16/15

# This example is intended to show how to get started with the R ReporteRs
# package

# It is an expansion of the demo provided by the package author at
# https://github.com/davidgohel/ReporteRs

# You can have run additional examples with the three lines below
# They show what ReporteRs can do but aren't good at showing
# to create your own documents
# example(docx) # run a complete and detailed docx example
# example(pptx) # run a complete and detailed pptx example
# example(bsdoc) # run a complete and detailed html example

###############################
# Get ready to create Word docs
###############################

# Set working directory
# setwd("C:/Users/JM/Desktop/MadR Meetup Reproducible Reporting")

# Load the package
library(ReporteRs) # Needed to produce Microsoft Word Documents
library(ggplot2) # Needed to produce a chart later

# Check to make sure the computer has the required Java Runtime Environment (JRE) of 1.6 or higher
system("java -version")

###########################################
# Example 1, create a word doc with a table
###########################################

# This package can also produce .pptx and .html files

# Create an object called doc and 
# let R know it should be a Word document called "My Document"
doc = docx(title = 'My document')

# Add  a header
# Level indicates size of text and is like a html header with 1 being the largest
doc = addTitle(doc , 'Iris data table', level = 1)

# Add text with stylename "Normal" into doc 
doc = addParagraph(doc, value = "The following table shows the first 10 records in the iris dataset.", stylename = "Normal")

# Add a table containing the first 10 lines of iris data
doc = addFlexTable(doc, FlexTable(iris[1:10,]))

# Write the doc 
writeDoc(doc, file = "reporters_word_doc_example_1.docx")

########################
# Example 2, add a chart
########################

# Add a page break
doc = addPageBreak(doc)

# Add another header
doc = addTitle(doc, 'Petal Length and Sepal Length Chart', level = 1)

# Add text with stylename "Normal" into doc 
doc = addParagraph(doc, value = "The following chart shows petal length by sepal length and species.", stylename = "Normal")

# Add a ggplot2 chart
myggplot = qplot(Sepal.Length, Petal.Length, data = iris, color = Species, size = Petal.Width)
doc = addPlot(doc = doc , fun = print, x = myggplot)

# Write the doc 
writeDoc(doc, file = "reporters_word_doc_example_2.docx")

##########################
# Example 3, add a picture
##########################

# Add another page break
doc = addPageBreak(doc)

# Add yet another header
doc = addTitle(doc, 'A Picture', level = 1)

# Add more explanatory text, this time with style
# Style names come from: http://davidgohel.github.io/ReporteRs/word.html#UIDBX5YBLBNYJ
doc = addParagraph(doc, value = "This is some intense text.", stylename = "Citationintense")

# Add an image
doc = addImage(doc, "Assets/example_picture.jpg")

# Write the doc 
writeDoc(doc, file = "reporters_word_doc_example_3.docx")

#######################
# Example 4, add R code
#######################

# One more page break
doc = addPageBreak(doc)

# Add yet another title, this time at level 2
# Note that this automatically puts this section below the previous section in the outline,
# making it 3.1 underneath the picture section's 3.
doc = addTitle(doc , "R code is in this section.", level = 2)

# Add more explanatory text with a different style
doc = addParagraph(doc, value = "Here's some citation style text", stylename = "Citation")

# Add R code
doc = addRScript(doc, text = "ls()
x = rnorm(10)")

# Write the doc but save it to a folder within the working directory
writeDoc(doc, file = "reporters_word_doc_example_4.docx")

###########################################################
# Example 5, a loop to make multiple versions of the report
###########################################################

# Make a list of the versions you want
# This will make a report for each of the iris species
species_list <- unique(iris$Species)

# Loop
for (i in species_list) {
        temp <- subset(iris, iris$Species == i)
      
        # Create doc, a docx object
        doc = docx(title = 'My document')
        
        # Add the first 10 lines of iris data in a table
        doc = addTitle(doc , paste0(i, ' data table'), level = 1)
        
        # Add text with stylename "Normal" into doc 
        doc = addParagraph(doc, value = paste0("The following table shows the first 10 records in the ", i, " dataset."), stylename = "Normal")
        
        # Add a table
        doc = addFlexTable(doc, FlexTable(temp[1:10,]))
        
        # Add a page break
        doc = addPageBreak(doc)
        
        # Add another title
        doc = addTitle(doc, 'Petal Length and Sepal Length Chart', level = 1)
        
        # Add text with stylename "Normal" into doc 
        doc = addParagraph(doc, value = "The following chart shows petal length by sepal length and species.", stylename = "Normal")
        
        # Add a ggplot2 chart
        myggplot = qplot(Sepal.Length, Petal.Length, data = temp, color = Species, size = Petal.Width)
        doc = addPlot(doc = doc , fun = print, x = myggplot)
        
        # Write the doc 
        writeDoc(doc, file = paste0("reporters_word_doc_example_", i, ".docx"))
        
        rm(temp)
}

