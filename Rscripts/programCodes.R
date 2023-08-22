source("downloadPages.R")

#source("funs.R")
source("funs2.R")

tmp = lapply(filenames, getDocYears)
info = do.call(rbind, tmp)


rownames(info)[is.na(info[[1]])]
rownames(info)[is.na(info[[2]])]


if(FALSE) {
    dir = paste0("DegreeRequirements_", Sys.Date())
    if(!file.exists(dir))
        dir.create(dir)

    udegreqs = sapply(filenames, function(f) getDegReqLink(htmlParse(f)))
    w = sapply(udegreqs, length) > 0
    mapply(download.file, udegreqs[w], file.path(dir, gsub("html$", "pdf", basename(filenames)[w])))    
#    mapply(getDegRequirements, filenames, file.path(dir, gsub("html$", "pdf", basename(filenames))))
}


saveRDS(progs, file = "Programs.rds")




#
degs[(sapply(degs, function(x) any(grepl("Integrated", x))))]


# Get the admission details

tmp = lapply(filenames, function(u) getNodeSet(htmlParse(u), "//div[contains(@class, 'gs-program-admission-dtls')]"))
admissionDetails = lapply(filenames, function(u) getNodeSet(htmlParse(u), "//div[contains(@class, 'gs-program-admission-dtls')]"))
admissionDetails = admissionDetails[ sapply(admissionDetails, length) > 0 ]
