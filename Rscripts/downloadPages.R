library(RCurl)
library(XML)
u = "https://grad.ucdavis.edu/programs"
doc = htmlParse(getURLContent(u, followlocation = TRUE))

ll = getHTMLLinks(doc)

# program-tab--alphabetical
#lnodes = getNodeSet(doc, "//a[starts-with(@href, '/programs/')]")
#lnodes = getNodeSet(doc, "//div[contains(@class, 'program-tab--alphabetical')]//a[starts-with(@href, '/programs/')]")
lnodes = getNodeSet(doc, "//a[starts-with(@href, '/programs/')]")
#h = sapply(lnodes, xmlGetAttr, "href")
#w = grepl("^/programs/[a-z]{4}$", ll)
#lnodes = lnodes[w]

progs = structure(sapply(lnodes, xmlGetAttr, "href"), names = sapply(lnodes, xmlValue))

progs = progs[!duplicated(progs)]

progs2 = structure(sapply(lnodes, xmlValue), names = gsub("/programs/", "", sapply(lnodes, xmlGetAttr, "href")))

# progs is path to program e.g. /programs/gven with the name being the Human readable program name Viticulture and Enology
# progs2 is the mapping between human readable name and 4 letter program code, the latter being the names on the progs2 vector.


#progs = grep("^/programs/[a-z]{4}$", ll, value = TRUE)
u.progs = getRelativeURL(progs, u)


# Download the pages locally for each program.
dir = gsub("-", "_", sprintf("Cache_%s", Sys.Date()))
if(!file.exists(dir))
    dir.create(dir)
filenames = file.path( dir, sprintf("%s.html", basename(u.progs)))
names(filenames) = names(u.progs)
mapply(download.file, u.progs, filenames)

