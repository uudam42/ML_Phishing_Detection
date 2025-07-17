# R/import_csv.R

# Load required libraries
library(DBI)
library(RSQLite)

# Source the database connection function
# (expects database_connect.R in the R/ folder of the project root)
source("R/database_connect.R")

# Define file paths relative to the project root
csv_path <- "data/phishing_email.csv"
db_path  <- "data/phishing_email.sqlite"

# Read the CSV file into a data frame
emails <- read.csv(csv_path, stringsAsFactors = FALSE)
print(head(emails))

# Connect to (or create) the SQLite database
con <- connect_to_db(db_path)

# Write the emails data frame to the database table "emails"
# Overwrite the table if it already exists
dbWriteTable(con, "emails", emails, overwrite = TRUE)

# List tables in the database to confirm the write
print(dbListTables(con))

# Disconnect from the database
dbDisconnect(con)



