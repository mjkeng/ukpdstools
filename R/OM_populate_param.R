#' Populate UKPDS-OM2 parameters
#'
#' @param pathORI  Path to UKPDS-OM2 input workbook
#' @param pathEDIT Path to edited workbook
#' @param nprocess No. of processes to use
#' @param nloops   No. of loops (for stochastic uncertainty)
#' @param nboot    No. of bootstraps (for parameter uncertainty)
#' @param nyears   No. of years simulated
#' @param seeds    Random no. seed (1 - 100)
#' @param dc_qaly  Discount rate for QALY/LE
#' @param dc_cost  Discount rate for costs
#'
#' @return Populated parameters sheet
#' @export
#'
#' @examples OM_populate_param(pathORI, pathEDIT, nprocess = 10, nloops = 10000, nboot = 0, nyears = 70, seeds = c(1:10))


OM_populate_param <- function(pathORI, pathEDIT, nprocess = 10, nloops = 10000, nboot = 0, nyears = 70, seeds = c(1:10), dc_qaly = 0.035, dc_cost = 0.035){

  wb <- XLConnect::loadWorkbook(pathORI)

  XLConnect::writeWorksheet(wb, nprocess, sheet = "Model Parameters", startRow = 9, startCol = 2, header = FALSE)
  XLConnect::writeWorksheet(wb, nloops, sheet = "Model Parameters", startRow = 5, startCol = 2, header = FALSE)
  XLConnect::writeWorksheet(wb, nboot, sheet = "Model Parameters", startRow = 6, startCol = 2, header = FALSE)
  XLConnect::writeWorksheet(wb, nyears, sheet = "Model Parameters", startRow = 7, startCol = 2, header = FALSE)

  # Seeds
  if(length(seeds) == 1){seeds <- data.frame(t(rep(seeds, 10)))}
  if(length(seeds) > 1){seeds <- data.frame(t(seeds))}

  XLConnect::writeWorksheet(wb, seeds, sheet = "Model Parameters", startRow = 11, startCol = 3, header = FALSE)

  # Discount rate
  XLConnect::writeWorksheet(wb, dc_qaly, sheet = "Model Parameters", startRow = 15, startCol = 2, header = FALSE)
  XLConnect::writeWorksheet(wb, dc_qaly, sheet = "Model Parameters", startRow = 15, startCol = 4, header = FALSE)
  XLConnect::writeWorksheet(wb, dc_cost, sheet = "Model Parameters", startRow = 16, startCol = 2, header = FALSE)
  XLConnect::writeWorksheet(wb, dc_cost, sheet = "Model Parameters", startRow = 16, startCol = 4, header = FALSE)

  XLConnect::saveWorkbook(wb, file = pathEDIT)
}
