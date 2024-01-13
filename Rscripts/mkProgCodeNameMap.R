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

names(progs2) = toupper(names(progs2))

if(FALSE) {

     #XXX Escape and probably better fix the ' in Master's
    cmds = sprintf("INSERT INTO EFRM_PROGRAM_CODE_NAME_MAP (`PROGRAM_CODE`, `PROGRAM_NAME`) VALUES('%s', '%s');",
                   names(progs2), progs2)
    cat(cmds, sep = "\n")    
    
}
