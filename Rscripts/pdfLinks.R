# In ~/OGS/ScrapeWeb/

source("~/OGS/ScrapeWeb/GradPrograms/R/funs2.R")
source("~/OGS/ScrapeWeb/GradPrograms/R/funs.R")

library(Rqpdf)
source("~/DSIProjects/Rqpdf/R/links.R")

library(XML)
library(ReadPDF)


pdfs = list.files(dir, full = TRUE)
lnks = lapply(pdfs, getHyperlinks)
names(lnks) = gsub("\\.pdf$", basename(pdfs))

tt = dsort(table(unlist(lnks)))
z = grepl("^https?:", names(tt))
us = lapply(names(tt)[z], parseURI)
h = sapply(us, `[[`, "server")


getURLs =
function(pdf)    
{
    doc = readPDFXML(pdf)
    xpathSApply(doc, "//text[contains(., 'http:') or contains(., 'https:')]", xmlValue, trim = TRUE)
}

u2 = lapply(pdfs, getURLs)
