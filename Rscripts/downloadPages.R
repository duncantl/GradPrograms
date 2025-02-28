library(RCurl)
library(XML)



# We have this in ../R/programCodes.R
programNames = 
function(u = GSProgURL, dir)
{    
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
}

# progs is path to program e.g. /programs/gven with the name being the Human readable program name Viticulture and Enology
# progs2 is the mapping between human readable name and 4 letter program code, the latter being the names on the progs2 vector.


#progs = grep("^/programs/[a-z]{4}$", ll, value = TRUE)


