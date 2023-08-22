library(XML)
source("funs.R")
progs = readRDS("Programs.rds")
  # Read the number of students for each program  - various categories for students.
info = readRDS("~/OGS/GradhubCode/Stats/GradhubProgramStats.rds")



coords = lapply(sprintf("Cache_April19_2021/%s.html", gsub("/programs/", "", progs)), coordinator)
names(coords) = gsub("(/programs/|html)", "", progs)

# data frame with a row for each coordinator.
# If a coordinator serves two programs, there are two rows.
d = data.frame(person = unlist(coords), program = rep(names(coords), sapply(coords, length)), email = unlist(lapply(coords, names)), stringsAsFactors = FALSE)

p2 = gsub("/programs/", "", progs)
i = match(d$program, p2)
d$programName = names(progs)[i]


# Which coordinator serve more than one program.
tt = table(d$person)
names(tt) [ tt  > 1]

# How many coordinators serve 1, 2, 3, 4,  5  programs.
table(tt)

# What programs share a coordinator with any  other program.
share = unique(d$program[ d$person %in% names(tt)[tt > 1] ])
length(share)

# Get the human readable name of the programs.
progs2 = structure(names(progs), names = gsub("/programs/", "", progs))
progs2[share]

#share = sapply(coords, function(x) any(tt[x] > 1))
#table(share)
#names(share)[share]
#names(tt)


# For the programs which share a coordinator, look at
# this by coordinator/.
tmp = subset(d, program %in% share)
b = split(tmp, tmp$person)

# So, e.g., Victoria Dye serves gach and gptx.




i = match(d$program, tolower(info$major))
d[is.na(i),]
# Two have NA -
#  Nursing Science and Health-Care Leadership-Family Nurse Practitioner - gnnp
#  Creative Writing - gecw
# corresponding to programs not on gradhub.



# Number of coordinators in each program
# 89 programs have 1, 8 programs have 2
# This does not speak  at all to what % of an FTE they are employed.
numCoordinators = table(d$program)

# For each coordinator, find out how many students they serve on average.
b = tapply(d$program, d$person, function(x) sum( info$totalEnrollment[ match(x, tolower(info$major)) ]/ numCoordinators[x]))
summary(b)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#   3.00   42.00   65.00   80.82  103.50  244.00       2 


# For each coordinator, show the number of students (on average) they support
# and the combination of programs they serve.
coordinatorProgs = tapply(d$program, d$person, paste, collapse = ", ")
bb = data.frame(person = names(b), numStudents = b, programs = coordinatorProgs [ names(b) ])
bb[order(bb$numStudents),]


b2 = tapply(d$program, d$person, function(x) sum( info$phd[ match(x, tolower(info$major)) ]/ numCoordinators[x]))
bb2 = data.frame(person = names(b), numPhds = b2, programs = coordinatorProgs [ names(b) ])
bb2[order(bb2$numPhds),]







chair = lapply(sprintf("Cache2/%s.html", gsub("/programs/", "", progs)), person, "Program Chair")
names(chair) = gsub("(/programs/|html)", "", progs)
chair.d = data.frame(person = unlist(chair), program = rep(names(chair), sapply(chair, length)), email = unlist(lapply(chair, names)), stringsAsFactors = FALSE)
