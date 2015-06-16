# Data Analysis and Visualization with Google Analytics (GA)
#
# Big Data and Analytics for Business - INSEAD 2015
#
# Jesús Martín Calvo (15J)
#
# In this case study we will download data from GA using the
# GA Core Reporting API and then use it to create basic visualizations 
# and analysis on the user behavior in a website.
#
# What is an API: http://en.wikipedia.org/wiki/Application_programming_interface
# More on the GA Core Reporting API: https://developers.google.com/analytics/devguides/reporting/core/v3/
#
# We will use the following packages:
# RGoogleAnalytics: to connect with GA API and download the data
# dplyr: to manipulate the data
# lattice, ggplot2: to visualize the data
# stringr: to manipulate text
# Other packages will be used (knitr, shiny) as seen in class
#
#
# You must have access to a Google Analytics account through your Gmail/Google account.
# 
# The website that you have access to must have more than 3 months of available data.
#
# If you do not have access, use the data in data/GACaseStudyData.csv 
#

# Clean the workspace
rm(list=ls())

# Set up the working directory

local_directory <- getwd()

# Install and load required packages

source(paste(local_directory,"R/library.R", sep="/"))

# This is the name of the Report and Slides (in the doc directory) to generate 
report_file = "GAReport"

##############################
# Skip this part if you do not have access to Google Analytics (jump to CONTINUE HERE)

# In order to download data from GA API, you need to give access to your application
# 
# Step 1: Visit https://console.developers.google.com and log in with the Google Account 
# that you have access to GA
# Step 2: Create a project, click "APIs&auth" and then "APIs" and enable Analytics API
# Step 3: Click "Credentials", type RINSEAD in "Product name" and Save
# Step 4: Click "Credentials" and then "Create a new Client ID"
# Step 4: Select "Installed Application" and "Other" and click in "Create Client ID"
# Step 5: Run the following code with the information that is displayed in the fields {}:
 client.id <- "{copy paste your Client ID here}"
 client.secret <- "{copy paste your Client secret here}"
 token <- Auth(client.id,client.secret)
 ValidateToken(token)
# Give permissions to your application to access your GA data
# You must see in your RStudio console "Authentication complete."
# If you need help, type "?Auth" (no quotes) in the RStudio console
# 
# Now, we will download the data from GA Core Reporting API.
# First of all, you need to tell R which is the tableID that you want to use.
# Visit http://analytics.google.com, select the view where you want to take the data from
# and click on "Admin", then click on "View Settings"
# Run the following code with the View ID in the field {}
table.id <- "{copy paste your View ID here}"
# Now, we are ready to create the criteria for the data we want to download
# Run the following code adding the required information in the fields{}.
start.date  <-  "{Start date of the data}"
end.date  <-  "{End date of the data}"
# Make sure you have at least three months of data
# Now, run the following code

source(paste(local_directory,"R/GAQuery.R", sep="/"))

# CONTINUE HERE
# If you do not have access to GA, load the csv in the "data" folder into the variable gadata
if (!exists("gadata")) 
  gadata <- within(read.csv(paste(local_directory,"data/GACaseStudyData.csv", sep="/")),rm("X"))

# Make sure ga.data contains the data you want
#str(gadata)
#head(gadata)
# Now you have your data completely clean to analyze and visualize.

###########################
# Would you like to also start a web application on YOUR LOCAL COMPUTER once the report and slides are generated?
# Select start_webapp <- 1 ONLY if you run the case on your local computer
# NOTE: Running the web application on your LOCAL computer will open a new browser tab
# Otherwise, when running on a server the application will be automatically available
# through the ShinyApps directory

# 1: start application on LOCAL computer, 0: do not start it
# SELECT 0 if you are running the application on a server 
# (DEFAULT is 0). 
start_local_webapp <- 0


source(paste(local_directory,"R/runcode.R", sep = "/"))


if (start_local_webapp){
  
  # now run the app
  if (require(shiny) == FALSE) 
    install_libraries("shiny")
  runApp(paste(local_directory,"tools", sep="/"))  
}





  
  
  
  
  ############   Author notes   #############

client.id <- "972513462276-f9pvjl1huqnbh8lnl7qa9f06vcqmt878.apps.googleusercontent.com"
client.secret <- "3VQNCCEJKA4oBpWmeSZZMLbI"
token <- Auth(client.id,client.secret)
ValidateToken(token)
start.date = "2010-01-01"
end.date = "2014-12-31"
table.id = "ga:35315826"
query.list <- Init(start.date = start.date,
                   end.date = end.date,
                   dimensions = "ga:month, ga:pagePath, ga:sourceMedium, ga:userType, ga:deviceCategory",
                   metrics = "ga:entrances, ga:pageviews, ga:exits,ga:timeOnPage, ga:uniquePageviews, ga:pageLoadTime",
                   max.results = 10000,
                   table.id = "ga:35315826")           
ga.query <- QueryBuilder(query.list)
gadata <- GetReportData(ga.query, token)
gadata <- ga.data
ts <- gadata %>% group_by(month,pagePath,sourceMedium,userType,deviceCategory) %>% summarise_each(funs(sum))

gadata$pagePath <- gsub("\\?.*","",gadata$pagePath)


as <- tbl_df(as) 
as <-  group_by(gadata,month,pagePath,sourceMedium,userType,deviceCategory)

as
bs <- (summarise(as,
                 entrances=sum(entrances),pageviews=sum(pageviews),exits=sum(exits),timeOnPage=sum(timeOnPage),
                 uniquePageviews=sum(uniquePageviews),pageLoadTime=sum(pageLoadTime)))
bs <- as %>% group_by(month,pagePath,sourceMedium,userType,deviceCategory) %>% summarise_each(funs(sum))

as %>% group_by(pagePath,sourceMedium,userType,deviceCategory) %>%
  summarise(entrances=sum(entrances),pageviews=sum(pageviews),exits=sum(exits),timeOnPage=sum(timeOnPage),
            uniquePageviews=sum(uniquePageviews),pageLoadTime=sum(pageLoadTime))
summary(ss)
ss

