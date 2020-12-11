#' Imports data on outcomes from UKPDS-OM2 worksheet
#'
#' @param path  Path to UKPDS-OM2 workbook
#' @param ncore Number of nodes in cluster to use for parallel computating
#'
#' @return Datasets containing outcomes (probability of individuals developing each endpoint in each year) over years imported from UKPDS-OM2
#' @export
#'
#' @examples OM_import_outcomes(path, ncore = parallel::detectCores() - 1)

OM_import_outcomes <- function(path, ncore = 1){

  sheet <- ukpdstools::ukpds_sheets[c(14:24),"var"] %>%
    unlist() %>%
    as.character()

  if(ncore > 1){
    cl <- parallel::makeCluster(ncore)
    doParallel::registerDoParallel(cl)

    `%dopar%` <- foreach::`%dopar%`

    df_out <- foreach::foreach(i = sheet, .combine = rbind, .packages = c("dplyr", "ukpdstools", "tidyr")) %dopar% {
      ukpdstools::OM_import_indsheet(path, variable = i) %>%
        gather(var_yr, val, -id) %>%
        separate(var_yr, c("var", "yr", "outcome.type"), sep = "/") %>%
        spread(yr, val)
    }

    parallel::stopCluster(cl)

  }else{
    df_out <- do.call(rbind, lapply(sheet, function(i){
      ukpdstools::OM_import_indsheet(path, variable = i) %>%
        gather(var_yr, val, -id) %>%
        separate(var_yr, c("var", "yr", "outcome.type"), sep = "/") %>%
        spread(yr, val)
    }))
  }

  df_out <- df_out %>%
    mutate(id = as.numeric(id)) %>%
    arrange(id)

  return(df_out)

}
