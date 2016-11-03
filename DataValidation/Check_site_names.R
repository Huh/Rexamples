    #  A function to check site names, this was written for a very specific 
    #   problem and was in no way meant to be general, but it does give some 
    #   ideas and patterns about how to go about check names, ID's and the like
    #  Josh Nowak
    #  11/2016
################################################################################
    check_site_nm <- function(x, punct = TRUE){
      #  A specific function to standardize site names and trim leading zeros in 
      #   names
      #  Takes a character vector of site names (e.g. "C50", "C05") and a 
      #   logical which determines whether punctuation should be stripped from
      #   the strings.
      #  Returns a character vector of the same length

      #  Trim whitespace
      tmp <- trimws(x, "both")

      #  If desired strip spaces and punctuation
      if(punct){
        tmp <- gsub("[[:punct:]]|[[:space:]]", "", tmp)
      }

      #  Extract leading letters, make all upper case
      char <- toupper(gsub("[0-9]*$", "", tmp))

      #  Extract trailing numbers, make numeric
      num <- as.numeric(gsub("^[A-z]*", "", tmp))

      #  Recombine letters and numbers
      out <- paste0(char, num)

      #  Check that NAs are actually NA
      out[is.na(char)|is.na(num)] <- NA

      #  Issue a warning if NA's were introduced by coercion
      x_na <- sum(is.na(x))
      out_na <- sum(is.na(out))
      if(out_na > x_na){
        warning("NA introduced by coercion")
      }

      #  Issue a warning if any of the names are less than two characters
      if(any(nchar(out) < 2)){
        warning("Some site names are shorter than 2 characters")
      }

    return(out)
    }