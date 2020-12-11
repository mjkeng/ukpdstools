
#' Imports data on risk factors from UKPDS-OM2 worksheet
#'
#' @param path          Path to UKPDS-OM2 workbook
#' @param ncore         Number of nodes in cluster to use for parallel computating
#' @param baseline.only If TRUE, imports baseline characteristics from input sheet only
#'
#' @return Datasets containing risk factors over years imported from UKPDS-OM2
#' @export
#'
#' @examples OM_import_rf(path, ncore = parallel::detectCores() - 1, baseline.only = FALSE)

OM_import_rf <- function(path, ncore = 1, baseline.only = FALSE){

  col <- unlist(ukpds::ukpds_colnames$var) %>% as.character()

  df_baseline <- readxl::read_excel(path, sheet = "Inputs", skip = 15, col_names = col)

  if(baseline.only){
    return(df_baseline)
  } else{
    ukpds_sheet <- ukpdstools::ukpds_sheets[c(1:13),]

    sheetname <- readxl::excel_sheets(path)

    ukpds_sheet$locate <- sapply(ukpds_sheet$variable.sheet, function(x) {
      locate <- sheetname[match(paste0("Est ", x), sheetname)]
      return(locate)
    })

    if(ncore > 1){
      cl <- parallel::makeCluster(ncore)
      doParallel::registerDoParallel(cl)

      `%dopar%` <- foreach::`%dopar%`

      df_rf <- foreach::foreach(i = 1:nrow(ukpds_sheet), .combine = rbind, .packages = c("dplyr", "ukpdstools", "tidyr")) %dopar% {

        if(is.na(ukpds_sheet[i, "locate"])){
          temp <- ukpdstools::OM_import_indsheet(path, variable = ukpds_sheet[i, "var"])
        } else{
          temp <- ukpdstools::OM_import_indsheet(path, variable = ukpds_sheet[i, "var"], sheet = ukpds_sheet[i, "locate"])
        }

        temp %>%
          gather(var_yr, val, -id) %>%
          separate(var_yr, c("var", "yr"), by = "_") %>%
          spread(yr, val)
      }

      parallel::stopCluster(cl)

    }else{
      df_rf <- do.call(rbind, apply(ukpds_sheet, 1, function(x){

        if(is.na(x["locate"])){
          temp <- ukpdstools::OM_import_indsheet(path, variable = x["var"])
        } else{
          temp <- ukpdstools::OM_import_indsheet(path, variable = x["var"], sheet = x["locate"])
        }

        temp %>%
          gather(var_yr, val, -id) %>%
          separate(var_yr, c("var", "yr"), by = "_") %>%
          spread(yr, val)
      }))
    }

    df_rf_baseline <- df_baseline %>%
      gather(var, "yr00", -id) %>%
      filter(var %in% ukpds_sheet$var) %>%
      left_join(df_rf, by = c("id", "var")) %>%
      mutate(id = as.numeric(id)) %>%
      arrange(id)

    return(df_rf_baseline)
    }

}
