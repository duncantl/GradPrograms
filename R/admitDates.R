# Potentially turn into a function.
if(FALSE) {
    ff = list.files("Cache5", full = TRUE)
    appdates = lapply(ff, admissionDate)
    names(appdates) = gsub("\\.html$", "", basename(ff))
    sa = lapply(appdates, function(x) x["Space Available"])
    sa = sa[!sapply(sa, is.na)]

    isFut = unlist(sa) > Sys.Date()
    names(sa)[isFut]
}
