
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ukpds

This package consolidates functions to

  - Format UKPDS-OM2 input worksheets

  - Import results from UKPDS-OM2 worksheets

  - Sample baseline cohort (Future project?)

## Installation

`ukpds` can be installed from [GitLab](https://gitlab.ndph.ox.ac.uk)
with:

``` r
devtools::install_git('https://gitlab.ndph.ox.ac.uk/mkeng/ukpds.git', credentials = git2r::cred_user_pass("yourusername", getPass::getPass()))
## getPass() prompts you to enter your password - safer option than to have password stored in script
```

One of the dependencies in this package `RDCOMClient` is not globally
available on CRAN. If not already installed, run the following command:

``` r
install.packages("RDCOMClient", repos = "http://www.omegahat.net/R") 
```

It is recommended for additional memory to be allocated as running Excel
through `RDCOMClient` requires quite significant amount of memory space.
This can be done by running the code below **before** calling the
`ukpds` package.

``` r
options(java.parameters = "-Xmx8000m")
```

## Populating UKPDS-OM2 worksheets

  - `OM_clear` clears input sheets
  - `OM_populate` populates worksheets
  - `OM_populate_param` populates model parameters
  - `OM_populate_rf` manually populates risk factor sheets
  - `OM_runmacro_populate` automatically populates risk factor sheets
    with macro
  - `OM_check` checks that input data is within limits as specified in
    *ukpds\_limit*

## Importing from UKPDS-OM2 worksheets

  - `OM_import_indsheet` imports individual risk factor/outcome
    worksheet
  - `OM_import_rf` imports all risk factor worksheets, including
    baseline characteristics
  - `OM_import_outcomes` imports all outcomes worksheets

## Datasets

  - `ukpds_colnames` with order of input variables  
  - `ukpds_limit` with limits for input set within the model  
  - `ukpds_sheets` with names of risk factor worksheets and
    corresponding variable names

## Related publication

*Hayes, A. J., Leal, J., Gray, A. M., Holman, R. R., & Clarke, P. M.
(2013). UKPDS outcomes model 2: a new version of a model to simulate
lifetime health outcomes of patients with type 2 diabetes mellitus using
data from the 30 year United Kingdom Prospective Diabetes Study: UKPDS
82. Diabetologia, 56(9), 1925-1933.*

To download UKPDS Outcomes Model version 2 and for all licensing
queries, please visit [this
page](http://www.dtu.ox.ac.uk/outcomesmodel/).
