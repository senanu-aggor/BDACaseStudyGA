# Google Analytics Core Reporting API call
# This piece of code will query the API and return the data frame gadata


query.list <- Init(start.date = start.date,
                   end.date = end.date,
                   dimensions = "ga:year, ga:month, ga:pagePath, ga:sourceMedium, ga:userType, ga:deviceCategory",
                   metrics = "ga:entrances, ga:pageviews, ga:exits, ga:timeOnPage, ga:uniquePageviews,ga:users",
                   max.results = 10000,
                   table.id = table.id)           
ga.query <- QueryBuilder(query.list)
ga.data <- GetReportData(ga.query, token)
ga.data$month <- as.integer(ga.data$month)
gadata <- ga.data
