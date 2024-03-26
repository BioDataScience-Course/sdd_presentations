first_sequence <- function(df){

  df %>.%
    arrange(., user, app, label, date) -> df

  df %>.%
    filter(., verb %in% c("answered", "submitted") & correct == TRUE) %>.%
    group_by(., app, label, user) %>.%
    slice_head(.) -> first_seq

  res <- left_join(
    df, select(first_seq, user, app, label, date_max=date),
    by = c("user", "app", "label"))

  res <- filter(res, date <= date_max)
  res

}


learnr_verb <- function(df){
  df %>.%
    group_by(., user, course, verb) %>.%
    summarise(., n = n()) %>.%
    ungroup(.) %>.%
    pivot_wider(., names_from = "verb",  values_from = "n") %>.%
    #drop_na(., course) %>.%
    replace_na(.,
      list(
        answered = 0, assisted = 0, evaluated = 0,
        executed = 0, reset = 0, revealed = 0, submitted = 0))
}

oid <- function(date, def.date= as.POSIXct("2000-01-01")) {
  # Replace missing dates by def.date
  date[is.na(date)] <- def.date
  n <- length(date)
  first_part <- format(as.hexmode(as.integer(date)), width = 8)
  second_part <- format(as.hexmode(as.integer(runif(n, 0, 1e9))), width = 10)
  third_part <- format(as.hexmode(1:n), width = 6)
  paste0(first_part, second_part, third_part)
}
