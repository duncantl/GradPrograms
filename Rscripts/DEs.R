library(RCurl)
library(XML)
u = "https://grad.ucdavis.edu/programs/designated-emphases"
u = "https://grad.ucdavis.edu/designated-emphases"
doc = htmlParse(getURLContent(u))

ll = getNodeSet(doc, "//a[starts-with(@href, '/programs/designated-emphases/g')]")


h = structure(sapply(ll, xmlGetAttr, "href"), names = sapply(ll, xmlValue))
de.urls = getRelativeURL(h, u)

if(!file.exists("DECache"))
    dir.create("DECache")
filenames = sprintf("DECache/%s.html", basename(de.urls))
names(filenames) = names(de.urls)
mapply(download.file, de.urls, filenames)


docs = as.data.frame(t(sapply(filenames, getDocYears)), stringsAsFactors = FALSE)

docs$programCode = basename(de.urls)
docs$DE = rownames(docs)

co = lapply(filenames, coordinator)
ch = lapply(filenames, chair)
docs$chair = unlist(ch)
docs$e.chair = sapply(ch, names)
docs$coordinator = unlist(co)
docs$e.coordinator = sapply(co, names)

w = is.na(docs[,1]) | is.na(docs[,2])

miss = docs[w,]
z = is.na(miss$chair) & is.na(miss$coordinator)


template = paste(readLines("Email"), collapse = "\n")
mkEmail =
function(i) {
    docs = c("Degree Requirements"[is.na(miss[i, "degreeRequirements"])],
             "Bylaws"[is.na(miss[i, "bylaws"])])
    sprintf(template, paste(unlist(na.omit(c(miss[i, "e.chair"], miss[i, "e.coordinator"]))), collapse = ", "),
            paste(na.omit(unlist(miss[i, c("chair", "coordinator")])), collapse = " & "),
            miss$DE[i],
            paste(docs, collapse = " and\n"),
            if(length(docs) > 1) "them" else "it",
            miss$programCode[i]
            )
}

emails = sapply(1:nrow(miss), mkEmail)
