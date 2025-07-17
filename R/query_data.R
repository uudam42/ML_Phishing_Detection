# R/query_data.R

# Load necessary libraries and source the database connection function
library(DBI)
library(RSQLite)
source("R/database_connect.R")

# Define database path and establish connection
db_path <- "data/phishing_email.sqlite"
con     <- connect_to_db(db_path)

# 1) Query total number of emails and number of spam emails
total_count <- dbGetQuery(con, "
  SELECT 
    COUNT(*) AS total_emails,
    SUM(label) AS spam_emails
  FROM emails;
")
print(total_count)

# 2) Calculate the spam rate
total_count$spam_rate <- total_count$spam_emails / total_count$total_emails
print(total_count)

# 3) Count how many emails contain the keyword 'xls'
xls_count <- dbGetQuery(con, "
  SELECT 
    SUM(CASE WHEN text_combined LIKE '%xls%' THEN 1 ELSE 0 END) AS xls_count
  FROM emails;
")
print(xls_count)

# 4) Retrieve the first 10 spam email texts for review
top_spam <- dbGetQuery(con, "
  SELECT text_combined
  FROM emails
  WHERE label = 1
  LIMIT 10;
")
print(top_spam)

# Close the database connection
dbDisconnect(con)
