# Dean/college
info = lapply(filenames[w], typeInfo)
names(info) = names(chairs)[w]

in2 = info[, c("dean", "code", "name")]

schoolMap = 
c(CAES = "College of Agriculture and Environmental Studies",
  CBS = "College of Biological Sciences", 
  CLS = "College of Letters and Science",
  COE = "College of Engineering",
  SOM = "School of Medicine", 
  SOE = "School of Education",
  GS = "Graduate School",
  SVM = "School of Veterinary Medicine", 
  SON = "School of Nursing")

in2$college = names(schoolMap)[ match(as.character(in2$dean), schoolMap) ]

o = structure(in2$college, names = tolower(in2$code))

# college, program/dept., chair first name, chair last name, email.



chairs = lapply(filenames, chair, asDataFrame = TRUE)
names(chairs) = gsub(".html$", "", basename(filenames))
w = sapply(chairs, is.data.frame)

# [1] "gpac" "gabg" "smba" "smbo" "gbax" "gepd" "wllm"

# gabg and gepd are missing; the others are GSM and Law school
if(FALSE) {
  chairs2 = do.call(rbind, chairs[w])
  n = sapply(chairs[w], nrow)
  chairs2$program = rep(names(chairs)[w], n)
}

ans = lapply(chairs[w], function(x) if(any(i <- grepl("Department", x$role))) x[i,] else x[1,])

ans$gplp = ans$gplp[2,]  # David Rizzo
n = sapply(ans, nrow)
table(n)

ans2 = do.call(rbind, ans)

m = match(rownames(ans2), tolower(in2$code))
ans2$department = in2$name[m]
ans2$college = in2$college[m]
i = gregexpr(" ", ans2$name)

els = strsplit(ans2$name, " +")
w = sapply(els, length) > 2
ans2$first = sapply(els, `[`, 1)
ans2$last = sapply(els, function(x) paste(x[-1], collapse = " "))



mm = read.csv(mostRecent("^List of Colleges"), stringsAsFactors = FALSE)
m2 = match(ans2$mail, mm[[5]])

ans3 = rbind(ans2[is.na(m2), ], ans2[!is.na(m2), ])
