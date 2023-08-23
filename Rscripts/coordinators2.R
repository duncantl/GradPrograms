library(XML)
source("funs2.R")
#date = "Cache_2022_08_10"
# source("downloadPages.R")
date = sprintf("Cache_%s", gsub("-", "_", Sys.Date()))
p = list.files(date, full = TRUE)
coords = lapply(p, coordinator)
names(coords) = toupper(gsub("\\.html", "", basename(p)))

name = sapply(coords, `[[`, "name")

tmp = data.frame(name = unlist(name), program = rep(names(coords), sapply(coords,  nrow)))

ncByProg = table(tmp$program)

if(FALSE) {
    progNumStudents = readRDS("NumStudentsPerProgram_June2022.rds")
} else {

    x = mostRecent("^gradhub-export", "~/Downloads")
    d = readxl(x)
    progNumStudents = table(d$Major)
}


tmp$avgNumStudentsPerCoord = progNumStudents[tmp$program]/ncByProg[tmp$program]

coordNumStudents = tapply(tmp$avgNumStudentsPerCoord, tmp$name, sum, na.rm = TRUE)

#showCounts(coordNumStudents)

ans = data.frame(who = names(coordNumStudents),
                 totalNumStudents = coordNumStudents,
                 programs =  tapply(tmp$program, tmp$name, paste, collapse = ", "),
                 missingStudentNumbersFor = tapply(tmp$program, tmp$name, function(x) paste(x[!(x %in% names(progNumStudents))], collapse = ", ")))

z = ans[order(ans$totalNumStudents, decreasing = TRUE), ]

writexl::write_xlsx(z, sprintf("CoordinatorWorkload_%s.xlsx", gsub("-", "_", Sys.Date())))
