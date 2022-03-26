library(testthat)
library(ImagePlotting)

#Download datasets
options(timeout = max(15000, getOption("timeout")))
download.file("https://external-soa-downloads-p-1.s3.us-west-2.amazonaws.com/mu_brain_image_files.tar.gz",
              destfile = "testthat/testData/mu_brain_image_files.tar.gz")
download.file("https://external-soa-downloads-p-1.s3.us-west-2.amazonaws.com/mu_brain_workflow_and_counts_files.tar.gz",
              destfile = "testthat/testData/mu_brain_workflow_and_counts_files.tar.gz")

#untar only slide 4
untar("testthat/testData/mu_brain_image_files.tar.gz", files = "image_files/mu_brain_004.ome.tiff",
      exdir = "testthat/testData/")
untar("testthat/testData/mu_brain_workflow_and_counts_files.tar.gz",
      files = "workflow_and_count_files/workflow/readout_package/19July2021_MsWTA_20210804T2230/19July2021_MsWTA_20210804T2230_LabWorksheet.txt",
      exdir = "testthat/testData/")

#run tests
test_check("ImagePlotting")

#remove all the added files & folders
unlink("testthat/testData/mu_brain_image_files.tar.gz")
unlink("testthat/testData/image_files/mu_brain_004.ome.tiff", recursive = TRUE)
unlink("testthat/testData/mu_brain_workflow_and_counts_files.tar.gz")
unlink("testthat/testData/workflow_and_count_files/workflow/readout_package/19July2021_MsWTA_20210804T2230/19July2021_MsWTA_20210804T2230_LabWorksheet.txt",
       recursive = TRUE)

#https://www.tidyverse.org/blog/2019/01/vdiffr-0-3-0/