############################################
# Title: Script for Mock Report Automation #
# Author: Sam Long                         #
# Date: 2026-10-21                         #
############################################

## Purpose ##-------------------------------------------------------------------

# This script renders the mock report for Northeast EPI to HTML and then
# converts the HTML file to a PDF. It describes how data can be pre-loaded
# and variables/parameters can be preset. It also uses error handling to 
# prevent crashes when creating batches of reports.

## Packages ##------------------------------------------------------------------

# It's good practice to load packages first thing!

library(dplyr) # standard data manipulation and processing 
library(ggplot2) # standard plotting
library(glue) # string concatenation
library(pagedown) # for HTML -> PDF conversion
library(tryCatchLog) # error handling
library(futile.logger) # error logging
library(palmerpenguins) # mock data
library(readxl) # read in excel files

## Data Load ##-----------------------------------------------------------------

# Data can be pre-loaded in the environment and then accessed by the markdown
# when rendering to HTML. This can save LOTS of time when different versions
# of the same report are generated from the same dataset

# load penguin data
penguins <- palmerpenguins::penguins

## Parameters ##----------------------------------------------------------------

# names of people for whom to make the reports 
names <- c("Haley", "Bill", "Sam")

## Main ##----------------------------------------------------------------------

# Before rendering our markdown and printing it to PDF, we need to initialize
# the error handling framework. This ensure that the error handling functions
# have the correct instructions on what do when errors are encountered and how
# to log them.

# source code file name and line number tracking
options(keep.source = TRUE) 

# environment dump for post-mortem analysis if fatal errors occur
# helpful for diagnostics when an error occurs 
options("tryCatchLog.write.error.dump.file" = TRUE) 

# log errors into a file instead of console
flog.appender(appender.file(glue("{Sys.Date()}_report_app.log")))  

# Tiers of Err Messages: TRACE, DEBUG, INFO, WARN, ERROR, FATAL
# Warnings, Errors, and Fatal Errors are logged
flog.threshold(INFO)

# Use a for loop to make batches of reports!
# Iterate through names to make each report
for (i in names) {
  
  # Set my_name2 value
  my_name2 = i
  
  # error handling wrap function
  # error: defines behavior if error is encountered
  tryCatchLog(expr = {
    
    # render the html
    rmarkdown::render("mock_notebook_neepi_26.Rmd")
    
    # print to pdf
    chrome_print(input = "mock_notebook_neepi_26.html",
                 output = glue("{i}_mock_report.pdf"),
                 timeout = 60)
  },
  
  error = function(e){
    # will print in console
    message("* Caught an error on report for ", i)
    print(e)
  })
}





