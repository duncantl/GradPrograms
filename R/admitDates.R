# For the old page format, before SiteFarm.
# XXX Remove this file from git.
# 
appDates =
function(f, doc = htmlParse(f))
{
    z = getNodeSet(doc, "//h3[. = 'Application Deadlines']/following-sibling::div")
    if(length(z) == 0)
        return(as.Date(character()))
    
    d = sapply(z, function(n) xpathSApply(n, ".//div[contains(@class, 'field__item even')]", xmlValue))
    d = as.Date(d, "%b %d, %Y")
    names(d) = gsub(":.*", "", sapply(z, function(n) xpathSApply(n, ".//div[contains(@class, 'field__label')]", xmlValue)))
    
    d
}


if(FALSE) {
    ff = list.files("Cache5", full = TRUE)
    appdates = lapply(ff, appDates)
    names(appdates) = gsub("\\.html$", "", basename(ff))
    sa = lapply(appdates, function(x) x["Space Available"])
    sa = sa[!sapply(sa, is.na)]

    isFut = unlist(sa) > Sys.Date()
    names(sa)[isFut]
}
