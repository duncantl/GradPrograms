library(RCurl)
library(XML)
u = "https://grad.ucdavis.edu/policies"
tt = getURLContent(u)
doc = htmlParse(tt)

ll = xpathSApply(doc, "//h2[. = 'Policies Affecting:']/following-sibling::*[not(name() = 'h3' or name() = 'h4')]//a",
             function(x) structure(xmlGetAttr(x, "href"), names = xmlValue(x)))


hasExt = grepl('\\.[a-z]{1,5}$', ll)

ext = rep(".html", length(ll))
ext[hasExt] = gsub('.*(\\.[a-z]{1,5})$', "\\1", ll[hasExt])

files = file.path("PolicyDocs", paste0( gsub("[ /]", "_", names(ll)), ext))
mapply(download.file, ll, files)

all(file.exists(files))

pdfs = list.files("PolicyDocs", pattern = "\\.pdf$", full.name = TRUE)
length(pdfs) == sum(ext == ".pdf")
setdiff(basename(files[ext == ".pdf"]),  basename(pdfs))

# There is one duplicated name in files
files[duplicated(files)]
# [1] "PolicyDocs/Doctoral_Qualifying_Examinations.pdf"
# That's why we have 78 PDFs in files and only 77 in the PolicyDocs directory (and hence in `pdfs`)


# Create the XML files from the PDF
system("cd PolicyDocs; for f in *.pdf ; do echo "$f" ; pdftohtml -xml "$f" ; done")

ff = list.files("PolicyDocs", pattern = "\\.(xml|pdf)$")
g = split( ff, gsub("\\.(xml|pdf)$", "", ff))
w = sapply(g, length) != 2
stopifnot(!any(w))



xml = list.files("PolicyDocs", pattern = "\\.(xml|html)$", full.name = TRUE)
tmp = lapply(xml, function(x) {
    doc = htmlParse(x)
    xpathSApply(doc, "//text()[contains(lower-case(.), 'handbook')]", xmlValue)
})

names(tmp) = xml
tmp[ (sapply(tmp, length) > 0) ]

