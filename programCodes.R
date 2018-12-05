library(RCurl)
library(XML)
u = "https://grad.ucdavis.edu/programs"
doc = htmlParse(getURLContent(u))

ll = getHTMLLinks(doc)

# program-tab--alphabetical
#lnodes = getNodeSet(doc, "//a[starts-with(@href, '/programs/')]")
lnodes = getNodeSet(doc, "//div[contains(@class, 'program-tab--alphabetical')]//a[starts-with(@href, '/programs/')]")
h = sapply(lnodes, xmlGetAttr, "href")
w = grepl("^/programs/[a-z]{4}$", h)
lnodes = lnodes[w]
progs = structure(sapply(lnodes, xmlGetAttr, "href"), names = sapply(lnodes, xmlValue))

progs = progs[!duplicated(progs)]
#progs = grep("^/programs/[a-z]{4}$", ll, value = TRUE)
u.progs = getRelativeURL(progs, u)


# Download the pages locally for each program.
filenames = sprintf("Cache/%s.html", basename(u.progs))
names(filenames) = names(u.progs)
mapply(download.file, u.progs, filenames)

source("funs.R")

tmp = lapply(filenames, getDocYears)
info = do.call(rbind, tmp)


rownames(info)[is.na(info[[1]])]
rownames(info)[is.na(info[[2]])]






