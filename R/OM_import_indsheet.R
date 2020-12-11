#' Imports data from UKPDS-OM2 worksheet
#'
#' @param path     Path to UKPDS-OM2 workbook
#' @param variable Variable to import (see variables in ukpdstools::ukpds_sheetnames)
#' @param sheet    Specify sheet name if different from those in ukpdstools::ukpds_sheetnames
#'
#' @return Imported data from UKPDS-OM2
#' @export
#'
#' @examples OM_import_indsheet(path, variable = "hdl")

OM_import_indsheet <- function(path, variable, sheet = NULL){

  temp <- ukpdstools::ukpds_sheets %>%
    filter(var == variable)
  var.type <- as.character(temp$var.type)

  if(is.null(sheet)){
    sheet <- as.character(temp$variable.sheet)
  }

  if(var.type == "input"){
    df_sheet <- readxl::read_excel(path, sheet = sheet, skip = 16, col_names = FALSE)
    names(df_sheet) <- c("id", paste(variable, paste0("yr", c(1:(length(names(df_sheet))-1)) %>% formatC(., width = 2, flag = "0")), sep = "_"))
  }

  if(var.type == "outcome"){
    names <- c("id",
               paste(variable, paste0("yr", c(1:70) %>% formatC(., width = 2, flag = "0")), "rate", sep = "/"),
               paste(variable, paste0("yr", c(1:70) %>% formatC(., width = 2, flag = "0")), "rate.lci", sep = "/"),
               paste(variable, paste0("yr", c(1:70) %>% formatC(., width = 2, flag = "0")), "rate.uci",sep = "/"),
               paste(variable, paste0("yr", c(1:70) %>% formatC(., width = 2, flag = "0")), "hist", sep = "/"),
               paste(variable, paste0("yr", c(1:70) %>% formatC(., width = 2, flag = "0")), "hist.lci", sep = "/"),
               paste(variable, paste0("yr", c(1:70) %>% formatC(., width = 2, flag = "0")), "hist.uci", sep = "/")
               )
    df_sheet <- readxl::read_excel(path, sheet = sheet, skip = 16, col_names = FALSE)
    names(df_sheet) <- names[1:ncol(df_sheet)]
    df_sheet <- df_sheet %>%
      gather(var, val, -id) %>%
      filter(!is.na(val) & val != "-") %>%
      spread(var, val)
  }

  return(df_sheet)
}
