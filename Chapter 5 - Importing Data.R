# CHAPTER 5 - IMPORTING DATA ----
# 5.1 Paths and the Working Directory----
filename <- "murders.csv"
dir <- system.file("extdata", package = "dslabs")
fullpath <- file.path(dir, filename)
file.copy(fullpath, "murders.csv") # it copies the file into the our working directory

library(tidyverse)
dat <- read_csv(filename)

dir <- system.file(package = "dslabs") # system.file provides the full path of the folder containing all the files and directories relevant to the package specified by the package argument
list.files(path = dir) # shows directories contained in dslabs

dir <- system.file(package = "dslabs")
filename %in% list.files(file.path(dir, "extdata"))

dir <- system.file("extdata", package = "dslabs") # system.file permits to provide subdirectory as first argument, so we can obtain the full path of the extdata directory like this
fullpath <- file.path(dir, filename) # file.path is used to combine directory names to produce the full path of the file we want to import

# 5.2 The read and readxl packages----
library(readr) # part of tidyverse

read_lines("murders.csv", n_max = 3) # allows to check first lines of a file

dat <- read_csv(filename) # import the csv file as a tibble
view(dat)

dat <- read_csv(fullpath) # note we can use the full path to import the same tibble

library(readxl) # provides functions to read-in Microsoft Excel formats. It can import Excel files and access the various sheets.

# 5.4 Downloading Files ----
url <- "https://raw.githubusercontent.com/rafalab/dslabs/master/inst/extdata/murders.csv"

dat <- read_csv(url) # I can import directly csv files from the web using read_csv

download.file(url, "murders.csv") # download.file is used to create a local copy of the file. Note that the second argument is the name, and is freely chosen

tmp_filename <- tempfile() # creates a random unique name for a file we are going to download
download.file(url, tmp_filename)
dat <- read_csv(tmp_filename)
file.remove(tmp_filename)

# 5.5 R-base importing functions ----
dat2 <- read.csv(filename)

class(dat2$abb)
class(dat2$region)

path <- system.file("extdata", package = "dslabs")
filename <- "murders.csv"
x <- scan(file.path(path, filename), sep = ",", what = "c") # alternative to read_lines
x[1:10]


