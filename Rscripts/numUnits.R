#   source("downloadPages.R")

dir = "Cache_2022_06_11"
html = list.files(dir, full.names = TRUE)
names(html) = gsub(".html", "", basename(html))

source("funs2.R")

links = sapply(html, function(x) getDegReqLink(htmlParse(x))[1])

w = !is.na(links)

dir2 = sprintf("DegreeRequirements_%s", Sys.Date())
dir.create(dir2)

invisible(mapply(download.file, links[w], file.path(dir2, paste0(names(links)[w], ".pdf"))))

ff = list.files(dir2, full = TRUE)
mapply(function(p, x) system2("pdftohtml", c("-xml", shQuote(p), shQuote(x))),
         ff, gsub("\\.pdf$", ".xml", ff))

xml = list.files(dir2, pattern = "xml$", full.names = TRUE)
names(xml) = gsub("(\\.[0-9]+)?\\.xml", "", basename(xml))


doc = xmlParse(xml[[10]])
