source("funs.R")
coords = lapply(sprintf("Cache2/%s.html", gsub("/programs/", "", progs)), coordinator)
names(coords) = gsub("(/programs/|html)", "", progs)

d = data.frame(person = unlist(coords), program = rep(names(coords), sapply(coords, length)), stringsAsFactors = FALSE)

tt = table(d$person)
names(tt) [ tt  > 1]

table(tt)

# What programs share a coordinator
share = unique(d$program[ d$person %in% names(tt)[tt > 1] ])
length(share)

progs2 = structure(names(progs), names = gsub("/programs/", "", progs))
progs2[share]

#share = sapply(coords, function(x) any(tt[x] > 1))
#table(share)
#names(share)[share]
#names(tt)


tmp = subset(d, program %in% share)
b = split(tmp, tmp$person)


info = readRDS("~/OGS/GradhubCode/Stats/GradhubProgramStats.rds")

i = match(d$program, tolower(info$major))
d[is.na(i),]
# Two have NA -
#  Nursing Science and Health-Care Leadership-Family Nurse Practitioner - gnnp
#  Creative Writing - gecw
# corresponding to programs not on gradhub.


# Need to divide by the number of coordinators.

numCoordinators = table(d$program)
b = tapply(d$program, d$person, function(x) sum( info$totalEnrollment[ match(x, tolower(info$major)) ]/ numCoordinators[x]))

summary(b)


coordinatorProgs = tapply(d$program, d$person, paste, collapse = ", ")
bb = data.frame(person = names(b), numStudents = b, programs = coordinatorProgs [ names(b) ])
bb[order(bb$numStudents),]


b2 = tapply(d$program, d$person, function(x) sum( info$phd[ match(x, tolower(info$major)) ]/ numCoordinators[x]))
bb2 = data.frame(person = names(b), numPhds = b2, programs = coordinatorProgs [ names(b) ])
bb2[order(bb2$numPhds),]



