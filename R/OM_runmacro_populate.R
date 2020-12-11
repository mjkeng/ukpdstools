
#' Populate risk factors sheets
#'
#' @param path  Path to UKPDS-OM2 workbook to run macro
#' @param check If TRUE, check for errors and print path name to workbook if error exists
#'
#' @return Worksheets with populated risk factor trajectories
#' @export
#'
#' @examples OM_runmacro_populate(path, check = TRUE)

OM_runmacro_populate <- function(path, check = TRUE){

  require(RDCOMClient)

  xlApp <- RDCOMClient::COMCreate("Excel.Application", existing = FALSE)
  xlWbk <- xlApp$Workbooks()$Open(path)
  xlApp$Run("PopulateAllSheets")
  xlWbk$Save()
  temp <- xlWbk$Worksheets("Model Parameters")$Cells(63, "B")[["Value"]]
  xlWbk$Close()
  xlApp$Quit()

  xlWbk <- xlApp <- NULL
  rm(xlWbk, xlApp)
  gc()

  if (as.numeric(gsub("\\D", "", temp)) != 0 & check == TRUE) print(path)

}
