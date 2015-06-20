# Google Analytics Core Reporting API call
# This piece of code will query the API and return the data frame gadata

# Define parameters of the query
query.list <- Init(start.date = start.date,
                   end.date = end.date,
                   dimensions = "ga:year, ga:month, ga:pagePath, ga:source, ga:Medium, ga:userType, ga:deviceCategory",
                   metrics = "ga:entrances, ga:pageviews, ga:exits, ga:timeOnPage, ga:uniquePageviews,ga:users",
                   max.results = 10000,
                   table.id = table.id)           

# Build the API query
ga.query <- QueryBuilder(query.list)

# Request data to Core Reporting API
ga.data <- GetReportData(ga.query, token)

# Store in different variable
gadata <- ga.data

# Add YearMonth variable
# gadata$yearmonth <- paste(gadata$year,gadata$month,sep="")


# Clean pagePath so everything after "?" is deleted. This is needed because
# Google Analytics will by default store things that in this case we do not care about
# and therefore we can clean/tidy the data further. 
# For more on the topic, read http://vita.had.co.nz/papers/tidy-data.pdf
gadata$pagePath <- gsub("\\?.*","",gadata$pagePath)


# Summarize rows
gadata <- gadata %>% 
  group_by(yearmonth,year,month,pagePath,source,Medium,userType,deviceCategory) %>%
  summarise(entrances = sum(entrances),pageviews = sum(pageviews),exits = sum(exits),
            timeOnPage = sum(timeOnPage),uniquePageviews = sum(uniquePageviews),
            users = sum(users))


# Convert year and month in integers
gadata$month <- as.integer(gadata$month)
gadata$year <- as.integer(gadata$year)
# gadata$yearmonth <- as.integer(gadata$yearmonth)
