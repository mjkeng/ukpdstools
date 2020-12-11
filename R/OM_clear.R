

#' Clears UKPDS-OM2 input sheets
#'
#' @param pathORI  Path to UKPDS-OM2 input workbook
#' @param pathEDIT Path to edited workbook
#'
#' @return Cleared UKPDS-OM2 input workbook
#' @export
#'
#' @examples OM_clear(pathORI, pathEDIT)


OM_clear <- function(pathORI, pathEDIT){

  wb <- XLConnect::loadWorkbook(pathORI)
  data <- XLConnect::readWorksheet(wb, sheet = "Inputs", header = FALSE)[1:16, ]
  XLConnect::clearSheet(wb, sheet = "Inputs")
  XLConnect::writeWorksheet(wb, data, sheet = "Inputs", header = FALSE)
  populate <- XLConnect::getSheets(wb)[3:15]

  for (x in populate){
    data <- XLConnect::readWorksheet(wb, sheet = x, header = FALSE)[1:16, ]
    XLConnect::clearSheet(wb, sheet = x)
    XLConnect::writeWorksheet(wb, data, sheet = x, header = FALSE)
  }

  XLConnect::saveWorkbook(wb, file = pathEDIT)
}
