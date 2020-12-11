#' Check input data within limits
#'
#' @param data input data. Variables must be ordered in the same way as required in the UKPDS worksheet.
#'
#' @return Warnings if any input in data exceeds limits allowed by UKPDS model
#' @export
#'
#' @examples OM_check(data)


OM_check <- function(data){

  limit <- ukpdstools::ukpds_colnames %>%
    mutate(var = as.character(var)) %>%
    select(order, var) %>%
    left_join(ukpdstools::ukpds_limit, by = "var") %>%
    filter(!is.na(min))

  for (i in 1:nrow(limit)){
    colnum <- limit[i, "order"]
    if(!all(data[,colnum] >= limit[i, "min"]) | !all(data[,colnum] <= limit[i, "max"])){
      rowcheck <- paste(which(data[,colnum] < limit[i, "min"] | data[,colnum] > limit[i, "max"]), collapse = ", ")
      msg <- paste0("Check variable ", limit[i, "var"], " for patient id ", rowcheck)
      warning(msg)
    }
  }
}
