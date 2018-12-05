library(RCurl)
library(XML)
u = "https://grad.ucdavis.edu/programs/designated-emphases"
doc = htmlParse(getURLContent(u))

ll = getNodeSet(doc, "//a[starts-with(@href, '/programs/designated-emphases/g')]")

h = structure(sapply(ll, xmlGetAttr, "href"), names = sapply(ll, xmlValue))
de.urls = getRelativeURL(h, u)

filenames = sprintf("Cache/DE/%s.html", basename(de.urls))
names(filenames) = names(de.urls)
mapply(download.file, de.urls, filenames)




