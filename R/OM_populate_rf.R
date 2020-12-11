
#' Populate UKPDS-OM2 risk factor sheets
#'
#' @param pathORI   Path to UKPDS-OM2 input workbook
#' @param pathEDIT  Path to edited workbook
#' @param sheet     Name of risk factor worksheet
#' @param data      Input data
#' @param method    Method of population (1 = Match subjects initial value, 2 = y=mx + c, 3 = Use UKPDS prediction formula )
#' @param overwrite Replace existing values? (Y = Overwrite current values in this sheet, N = Preserve the current value of cells, populating only empty ones)
#' @param tab_mc    Table of values for each group (m/c for continuous variables, Y/N for binary variables)
#'
#' @return Populated risk factor sheet
#' @export
#'
#' @examples OM_populate_rf(pathORI, pathEDIT, sheet = "Smoking Status", data, method = 3, overwrite = "N", tab_mc = NULL)


OM_populate_rf <- function(pathORI, pathEDIT, sheet, data = NULL, method = 3, overwrite = "N", tab_mc = NULL){

  wb <- XLConnect::loadWorkbook(pathORI)
  populate <- XLConnect::getSheets(wb)[3:15]

  if(!(sheet %in% populate)){stop(message("sheet name is invalid"))}

  header <- XLConnect::readWorksheet(wb, sheet = sheet, header = FALSE)[1:16, ]
  header[5,2] <- method  ##Method
  header[6,2] <- overwrite  ##Overwrite current value in sheet
  if(!is.null(tab_mc)){header[8,2:4] <- tab_mc}

  XLConnect::writeWorksheet(wb, header, sheet = sheet, header = FALSE)

  if(!is.null(data)){XLConnect::writeWorksheet(wb, data, sheet = sheet, startRow = 17, startCol = 1, header = FALSE)}

  XLConnect::saveWorkbook(wb, file = pathEDIT)
}
