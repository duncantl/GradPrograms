pi = readRDS("ProgramInfo.rds")
pi$dean[is.na(pi$dean)] = "Graduate School of Management"
w = pi$dean == "College of Agriculture and Environmental Studies"
caes = pi[w,]



############
stu = as.data.frame(read_excel("~/Downloads/gradhub-export-12.xls"))

table(as.character(caes$code) %in% unique(stu$Major))

stu.caes = subset(stu, Major %in% as.character(caes$code))

z = split(stu.caes, stu.caes$Major)





################
gh = readRDS("~/OGS/GradhubCode/Stats/GradhubProgramStats.rds")
all(caes$code %in% gh$major)
i = match(caes$code, gh$major)
gh.caes = gh[i, ]

