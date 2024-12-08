source("downloadPages.R")

byl = sapply(filenames, getBylawsLink)

bdir = gsub("-", "_", sprintf("BylawsCache_%s", Sys.Date()))
if(!file.exists(bdir))
    dir.create(bdir)

w = grepl("\\.eduundefined", byl)
bp = toupper(gsub("\\.html$", "",  basename(filenames[w])))


bfilenames = file.path( bdir, sprintf("%s.pdf", gsub("\\.html", "", basename(filenames))))
mapply(download.file, byl[!w], bfilenames[!w])

library(ReadPDF)

xml = gsub("\\.pdf", ".xml", bfilenames[!w])
invisible(mapply(convertPDF2XML, bfilenames[!w], xml))


docs = lapply(xml, xmlParse)

check =
function(doc)
{
    txt = xpathSApply(doc, "//text", xmlValue)
    any(grepl(" remove | removal |violation|violated|censure", txt))
}

ww = sapply(docs, check)

          
