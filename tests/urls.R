library(GradPrograms)

urls = programURLs()

if(FALSE) {
    exp = ls("package:GradPrograms")
    omit = c("containsGRE", "fetchProgramPages", "getDegRequirements", "programCodes", "programURLs", "rolesByEmail")
    fnNames = setdiff(exp, omit)
}

fns = list(getDegReqLink, degrees, webSite, dean, gpc, chair, admissionDate,
           getBylawsLink, getDegReqLink, degReqDates, bylawsDates,
           progCode, progName, progType)
o = lapply(fns, function(fun) fun(urls[10]))

pdf1 = getDegRequirements(urls[10])
stopifnot(is.character(pdf1) && file.exists(pdf1))
if(require(Rqpdf)) {
    i = getInfo(pdf1)
    stopifnot(is.list(i) && all(c("Subject", "Title") %in% names(i)))
}


pdf2 = getDegRequirements(urls[10], NA)
stopifnot(is.raw(pdf2) && length(pdf2) > 1000)
if(require(Rqpdf)) {
    doc = qpdf(pdf2)
    stopifnot(is.list(i) && all(c("Subject", "Title") %in% names(i)))    
}


# This needs PRM and an active cookie
# e = rolesByEmail(urls[10])


