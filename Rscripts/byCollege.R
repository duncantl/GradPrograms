source("funs.R")
ff = list.files("Cache7", full.names = TRUE)
info =  lapply(ff, typeInfo)
tmp = do.call(rbind, info)
stats = readRDS("../GradhubCode/Stats/GradhubProgramStats.rds")
i = match(as.character(tmp$code), stats$major)
tmp$phd = stats$phd[i]
tmp$masters = stats$masters[i]
tmp$totalEnrollment = stats$totalEnrollment[i]

z = by(tmp, tmp$code, function(x) x[1,])
z2 = do.call(rbind, z)
x = split(z2, list(z2$dean, z2$type))
x = x[sapply(x, nrow) > 0]


################

chairs = lapply(ff, chair, asDataFrame = TRUE)
names(chairs) =  gsub("\\.html", "", basename(ff))

# GSM and Law school give NA
chairs = chairs[!sapply(chairs, is.logical)]

m = match(toupper(names(chairs)), tmp$code)
tmp$chairNames = tmp$chairEmails = NA
tmp$chairNames[m] = sapply(chairs, function(x) paste(x$name[!grepl("Vice|Interim", x$role)], collapse = ","))
tmp$chairEmails[m] = sapply(chairs, function(x) paste(x$mail[!grepl("Vice|Interim", x$role)], collapse = ","))

saveRDS(tmp, "ProgramInfo2.rds")
