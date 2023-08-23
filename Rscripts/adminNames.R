
library(XML); library(RCurl)
source("funs.R")

ff = list.files("Cache6", full.names = TRUE)
prognames = toupper(gsub("\\.html", "", basename(ff)))
peop = lapply(ff, function(f) {doc = htmlParse(f); sapply(c("Program Chair", "Department Chair", "Department and Program Chair", "Graduate Program Coordinator"), function(p) person( person = p, doc = doc))})
names(peop) = prognames



tmp = lapply(ff, chair, asDataFrame = TRUE)
w = sapply(tmp, is.data.frame)
out  = prognames[!w]
# GBAX, SMBO, WLLM
tmp = tmp[w]
chairs = do.call(rbind, tmp)
chairs$program = rep(prognames[w], sapply(tmp, nrow))

tmp2 = lapply(ff[w], coordinator, asDataFrame = TRUE)
coords = do.call(rbind, tmp2)
coords$program = rep(prognames[w], sapply(tmp2, nrow))

admin = rbind(chairs, coords)
# Same as below with order()
# b = do.call(rbind, split(admin, admin$program))
admin = admin[order(admin$program),]


tmp = lapply(ff[w], typeInfo)
info = do.call(rbind, tmp)

m = match(admin$program, info$code)
stopifnot(!any(is.na(m)))

admin$programType = info$type[m]

stopifnot(all(tapply(admin$programType, admin$program, function(x) length(unique(x))) == 1))

admin$dean = info$dean[m]

admin$FirstName = gsub(" .*", "", admin$name)
admin$LastName = gsub("^[^ ]+ ", "", gsub(" - .*", "", admin$name))


degs = lapply(ff[w], getDegreesOffered)
names(degs) = prognames[w]

degrees = data.frame(degree = unlist(degs), program = rep(names(degs), sapply(degs, length)), stringsAsFactors = FALSE, row.names = NULL)


