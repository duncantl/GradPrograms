# reg3,
# reg3 = rbind(reg, reg2)
xxx = list(previous2, prev.csv2, man, man.old)
done.step1 = do.call(rbind, xxx)

done.step1$uuid = paste(done.step1$SID, done.step1$CRN)




ids2 = intersect(names(reg), names(prev))
both = rbind( reg[ids2], prev[ids2] )

w = is.na(both$SID) & is.na(both$CRN) & is.na(both$pdf)
both = both [ !w, ]

w = is.na(both$SID) 
both$pdf[w] %in% c(both$pdf[!w], IgnorePDFs)

both = both[!w,]

both$uid = mkUID(both)


split(both, both$uid)


oasis = getCurlHandle(followlocation = TRUE, cookie = readLines("oasis.cookie")[1])
oa = mapply(function(sid, crn, con) try(checkSU(sid, crn, con)), both$SID, both$CRN, MoreArgs = list(con = oasis))


e2 = grep("Error", oa)

i = grep("Cristiana", both$pdf)
both[i, c("SID", "CRN", "email", "Subject", "Course", "Section")] = c("915484630", "54263", "mblaismcpherson", "ANT", "210", "1")
both["Larson SU Grading Option signed.pdf", c("SID", "CRN", "email", "Subject", "Course", "Section")] = c("917858264", "55639", "cllarson", "BCB", "214", "1")


both = both[ - grep("Petition to Drop", both$SID), ]


both$uid = mkUID(both)

both$gradeOpt = oa


reg4 = both[both$gradeOpt %in% c("N", "X"),]
crs = split(reg4, reg4$uid)

dup = names(crs)[(sapply(crs, nrow)) > 1]

Open(file.path("PDF/Spring2020SUForm", reg4[reg4$uid %in% dup, "pdf"]), "skim")

reg4[ reg4$SID ==917818013 & reg4$CRN == 84845, "email"] = "jrvora"
reg4[ reg4$SID ==917818013 & reg4$CRN == 84845, "Subject"] = "ECS"
i  = reg4$SID ==917818013 & reg4$CRN == 84845 & reg4$Course == "289"
reg4 = reg4[!i,]


reg5 = reg4[!duplicated(reg4$uid), ]






