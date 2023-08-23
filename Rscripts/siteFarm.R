library(RCurl)
library(XML)
url = "https://grad.sf.ucdavis.edu/graduate-programs"
url = "https://grad.ucdavis.edu/programs"


progs = htmlParse(getURLContent(url, followlocation = TRUE))
ll = getHTMLLinks(progs)
as = getNodeSet(progs, "//a[starts-with(@href, '/programs/')]")

prog.urls = structure(getRelativeURL(sapply(as, xmlGetAttr, "href"), url), names = sapply(as, xmlValue)) 

prog.code = basename(prog.urls)
prog.names = structure(names(prog.urls), names = prog.code)

dir = format(Sys.Date(), "%b_%d_%y")
if(!file.exists(dir))
    dir.create(dir)

mapply(download.file, prog.urls, file.path(dir, sprintf("%s.html", prog.code)))



ff = list.files(dir, full = TRUE)
source("funs.R")
ldean = structure(lapply(ff, leadDean), names = gsub("\\.html$", "", basename(ff)))


names(ff) = gsub("\\.html$", "", basename(ff))
byl = lapply(ff, bylawsDates)
deg = lapply(ff, degReqDates)

dates = data.frame(program = names(ff), bylaws = sapply(byl, max), degreeRequirements = sapply(deg, max))
