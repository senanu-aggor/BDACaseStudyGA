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
#
# You must have access to a Google Analytics account through your Gmail/Google account.
# 
# The website that you have access to must have more than 3 months of available data.
#
# If you do not have access, use the data in GACaseStudyData.csv 
#

# Clean the workspace
rm(list=ls())

# Install and load required packages

install.packages(c("plyr","dplyr","lattice","ggplot2","stringr"))
library(devtools)
install_github("Tatvic/RGoogleAnalytics")
invisible(lapply(c("plyr","dplyr","lattice","ggplot2","stringr","RGoogleAnalytics"), library, character.only=T))

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
query.list <- Init(start.date = start.date,
                   end.date = end.date,
                   dimensions = "ga:month, ga:pagePath, ga:sourceMedium, ga:userType, ga:deviceCategory",
                   metrics = "ga:entrances, ga:pageviews, ga:exits, ga:timeOnPage, ga:uniquePageviews, ga:pageLoadTime",
                   max.results = 10000,
                   table.id = table.id)           
ga.query <- QueryBuilder(query.list)
ga.data <- GetReportData(ga.query, token)
gadata <- ga.data

# CONTINUE HERE
# If you do not have access to GA, load the csv in the data folder into the variable ga.data
# ga.data <- read.csv("~/GACaseStudyData.csv")

# Make sure ga.data contains the data you want
gadata <- ga.data
str(gadata)

# Clean pagePath so everything after "?" is deleted. This is needed because
# Google Analytics will by default store things that in this case we do not care about
# and therefore we can clean/tidy the data further. 
# For more on the topic, read http://vita.had.co.nz/papers/tidy-data.pdf

gadata$pagePath <- gsub("\\?.*","",gadata$pagePath)

# Summarize rows

gadata <- ddply(gadata,
                .(month,pagePath,sourceMedium,userType,deviceCategory),
                summarise, 
                entrances=sum(entrances),pageviews=sum(pageviews),exits=sum(exits),
                timeOnPage=sum(timeOnPage),uniquePageviews=sum(uniquePageviews),
                pageLoadTime=sum(uniquePageviews))

# Now you have your data completely clean to analyze and visualize. Enjoy!


