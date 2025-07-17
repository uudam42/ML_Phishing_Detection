# R/database_connect.R

# Load the DBI and RSQLite packages
library(DBI)
library(RSQLite)

# Returns a SQLite connection (creates the file if it doesn't exist)
connect_to_db <- function(db_path) {
  con <- dbConnect(RSQLite::SQLite(), dbname = db_path)
  return(con)
}

