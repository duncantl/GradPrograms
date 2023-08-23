# Run first 4 lines of code in coordinators.R
# to define progs and info

source("funs.R")

ff = sprintf("Cache9/%s.html", gsub("/programs/", "", progs))
ff = list.files("Cache9", full.names = TRUE)
adv = lapply(ff, person, "Academic Advisors")


nadv = sapply(adv, length)
names(adv) = names(nadv) = gsub("\\.html", "", basename(ff))


advisorInfo = data.frame(name = unlist(adv), email = unlist(lapply(adv, names)), program = rep(names(adv), nadv), stringsAsFactors = FALSE)
saveRDS(advisorInfo, "AdvisorInfo.rds")


info$numAdvisors = NA
m = match(toupper(names(nadv)), info$major)
table(is.na(m))

setdiff(info$major, toupper(names(nadv)))
# [1] "GEAC" "GEDC" "GINP" "GICL" "WLAW" "MMED" "VMVM" NA    
setdiff(toupper(names(nadv)), info$major)
# [1] "GECW" "GNNP"


info[toupper(names(nadv)), "numAdvisors"] = nadv

info$studentAdvisorRatio = info$totalEnrollment/info$numAdvisors

# saveRDS(info, "~/OGS/GradhubCode/Stats/GradhubProgramStats.rds")

info[order(info$studentAdvisorRatio), c("name", "major", "masters", "phd", "totalEnrollment", "numAdvisors", "studentAdvisorRatio")]


subset(info, studentAdvisorRatio > 20)[c("name", "major", "masters", "phd", "totalEnrollment", "numAdvisors", "studentAdvisorRatio")]


# Professional schools
# Engineering
# PhD versus Masters

# Anthropology - probably one from each wing. Should be at least 2.
#


