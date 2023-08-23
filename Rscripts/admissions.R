ff = list.files("Cache_April19_2021", full = TRUE, pattern = "\\.html")
progs = gsub("\\.html", "", basename(ff))

adv = lapply(ff, function(f) try(person(f, "Academic Advisors", asDataFrame = TRUE)))
names(adv) = progs
adv = adv[- which(sapply(adv, is, 'try-error')) ]

w = which(sapply(adv, class) == "logical")
progs[w]

adv2 = adv[sapply(adv, is.data.frame)]

adm = lapply(adv2, function(x) x[grep("Admission", x$role), ])

gre = read.csv("~/Downloads/GRE.csv")


w2 = names(adm) %in% gre$Program[gre$GRE == 'N']

info = do.call(rbind, adm[!w2])
info$program = rep(names(adm[!w2]), sapply(adm[!w2], nrow))

write.csv(info, "AdmissionsChairs.csv", row.names = FALSE)


