# R/feature_engineering.R

# Load libraries and connection function
library(DBI)
library(RSQLite)
source("R/database_connect.R")

# Connect to the database
db_path <- "data/phishing_email.sqlite"
con     <- connect_to_db(db_path)

# Extract features with a single SQL query
features <- dbGetQuery(con, "
  SELECT
    rowid AS id,
    LENGTH(text_combined) AS text_length,
    -- word count = spaces+1
    (LENGTH(text_combined) - LENGTH(REPLACE(text_combined, ' ', '')) + 1) AS word_count,
    -- flags/counts for common phishing indicators
    CASE WHEN text_combined LIKE '%xls%' THEN 1 ELSE 0 END AS has_xls,
    SUM(CASE WHEN text_combined LIKE '%http%' THEN 1 ELSE 0 END) AS http_count,
    CASE WHEN text_combined LIKE '%attachment%' THEN 1 ELSE 0 END AS has_attachment,
    -- preserve label for supervised learning
    label
  FROM emails
  GROUP BY rowid, text_combined, label;
")

# Inspect the first few rows
print(head(features))

# Write features back to disk for modeling
write.csv(features, "data/features.csv", row.names = FALSE)

# (Optional) also store features table in the database
dbWriteTable(con, "features", features, overwrite = TRUE)

# Close connection
dbDisconnect(con)
