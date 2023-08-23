# create the cache of program documents by running up to mapply(download.file) in programCodes.R

library(XML)
source("funs2.R")

dir = gsub("-", "_", sprintf("Cache_%s", Sys.Date()))
dir = mostRecent("^Cache_", ".")

ff = list.files(dir, full = TRUE)
degs = lapply(ff, degrees)
names(degs)  = gsub("\\.html", "", basename(ff))
degs

txt = sprintf('"%s",%s,%s', progs2[names(degs)], names(degs), sapply(degs, paste, collapse = ","))

cat("Program,Code,Degrees",
    txt, sep = "\n", file = "DegreesByProg.csv")
