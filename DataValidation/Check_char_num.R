    #  Misc. helper functions, primarily for data cleaning purposes
    #  Josh Nowak
    #  08/2016
################################################################################
    check_null <- function(x){
      #  A function to replace NULL with NA because of the odd behavior of NULL
      #  Takes a vector of any type
      #  Returns the vector with NULL replaced with NA
      
      x[is.null(x)] <- NA

    return(x)
    }
################################################################################
    check_empty <- function(x){
      #  A function to replace empty strings with NA
      #  Takes a vector of any type
      #  Returns the vector with empty strings replaced with NA

      out <- gsub("^$", NA, x)

    return(out)
    }
################################################################################
    check_missing <- function(x){
    
      x[is.na(x) | is.nan(x) | grepl("na", x, ignore.case = T)] <- NA
      
    return(x)
    }
################################################################################
    check_char <- function(x, extra = "[[:punct:]]"){
      #  A function to check character vectors, strip white space and remove
      #   punctuation and other special characters
      #  Takes a character vector and an optional regular expression, matching
      #   elements will be removed from the string
      #  Returns a character vector

      #  Replace NULL and empty strings
      out <- check_null(x)

      #  Force character
      out <- as.character(out)

      #  Remove NA like values
      out <- check_missing(out)

      #  Replace punctuation, blanks and spaces with nothing
      out <- gsub("[[:blank:]]|[[:space:]]", "", out)
      
      #  Remove punctuation if desired
      if(!is.null(extra)){
        out <- gsub(extra, "", out)
      }

      #  Trim white space from both ends of string
      out <- trimws(out, "both")

      #  Replace empty strings with NA
      out <- toupper(check_empty(out))

    return(out)
    }
################################################################################
    check_num <- function(x){
      #  A function to clean up generically numeric vectors, integers and double
      #  Takes a vector, character or numeric
      #  Returns, a numeric vector
      
      #  Replace NULL and empty strings
      out <- check_null(x)

      #  Force numeric silently
      out <- suppressWarnings(as.numeric(out))

      #  Greedily replace other missing values with NA
      out[!is.finite(out)] <- NA
      
    return(out)
    }