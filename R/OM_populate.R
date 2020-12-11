
#' Populate UKPDS-OM2 worksheets
#'
#' Time required to populate sheet increases exponentially. Runtime for populating 1000 rows ~ 10s, 2000 rows ~ 50s, 3000 rows ~ 150s.
#' The recommended maximum number of patients to populate in each sheet is 3000.
#'
#' @param pathORI  Path to UKPDS-OM2 input workbook
#' @param pathEDIT Path to edited workbook
#' @param data     Data to populate with
#' @param sheet    Name of worksheet to populate
#' @param startrow Row to start population
#' @param startcol Column to start population
#' @param update.input Default set to FALSE. Set to TRUE if populating input data to update number of individuals in parameter sheet.
#'
#' @return Populated worksheet
#' @export
#'
#' @examples OM_populate(pathORI, pathEDIT, data, sheet = "Inputs", startrow = 17, startcol = 1, update.input = FALSE)

OM_populate <- function(pathORI, pathEDIT, data, sheet, startrow, startcol, update.input = FALSE){

  wb <- XLConnect::loadWorkbook(pathORI)

  XLConnect::writeWorksheet(wb, data, sheet = sheet, startRow = startrow, startCol = startcol, header = FALSE)

  if (update.input){
    XLConnect::writeWorksheet(wb, nrow(data) + 17 - 1, sheet = "Model Parameters", startRow = 4, startCol = 3, header = FALSE)
    XLConnect::setForceFormulaRecalculation(wb, sheet = "Model Parameters", TRUE)
  }

  XLConnect::saveWorkbook(wb, file = pathEDIT)

  gc()
}
