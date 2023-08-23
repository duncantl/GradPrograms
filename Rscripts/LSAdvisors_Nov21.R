source("funs.R")
source("advisorsPRM.R")
options(width = 200)

progs = readRDS("ProgramInfo2.rds")

lsProgs = as.character(progs$code[grepl("Letters and Science", progs$dean)])

ls.advisors = lapply(lsProgs, getAdvisors)
names(ls.advisors) = lsProgs

stu = readxl(mostRecent("^gradhub-export"))

tt = table(stu$Major, stu$Degree)

tt.ls = tt[lsProgs, ]
tt.ls = tt.ls[, colSums(tt.ls) != 0]

ls = as.data.frame(unclass(tt.ls))
ls$totalNumStudents = rowSums(tt.ls)
ls$numAdvisors = sapply(ls.advisors, nrow)[ rownames(ls) ]

ls$targetNumAdvisors = ceiling(ls$total/15)

ls$stuPerAdvisor = ls$total/ls$numAdvisors

ls[order(ls$stuPer, decreasing = TRUE), ]


ls[order(ls$stuPer, decreasing = TRUE), ]


#     MA MFA  MS PHD totalNumStudents numAdvisors targetNumAdvisors stuPerAdvisor
#GPSC  2   0   0 127              129           1                 9    129.000000
#GPOL  1   0   0  69               70           1                 5     70.000000
#GPHY  0   0   9 183              192           4                13     48.000000
#GANT  7   0   0  66               73           2                 5     36.500000
#GCOM  8   0   0  26               34           1                 3     34.000000
#GCHE  0   0   7 275              282          10                19     28.200000
#GSTA  0   0 118  53              171           8                12     21.375000
#GDES  0  21   0   0               21           1                 2     21.000000
#GCMN  3   0   0  37               40           2                 3     20.000000
#GPHI  7   0   0  33               40           2                 3     20.000000
#GENL  2   0   0  76               78           4                 6     19.500000
#GMUS  2   0   0  32               34           2                 3     17.000000
#GAHI 16   0   0   0               16           1                 2     16.000000
#GART  0  16   0   0               16           1                 2     16.000000
#----------------------
#GMAT  2   0   0  76               78           5                 6     15.600000
#GPFS  1   0   1  29               31           2                 3     15.500000
#GLIN  8   0   0  32               40           3                 3     13.333333
#GECW  0  26   0   0               26           2                 2     13.000000
#GSPA  9   0   0  43               52           4                 4     13.000000
#GECN  4   0   0  99              103           8                 7     12.875000
#GHIS  2   0   0  73               75           6                 5     12.500000
#GAPM  0   0   4  69               73           6                 5     12.166667
#GGER  2   0   0  10               12           1                 1     12.000000
#GREL  0   0   0  12               12           1                 1     12.000000
#GNAS  1   0   0  31               32           3                 3     10.666667
#GSOC  3   0   0  67               70           7                 5     10.000000
#GBST  0   0  22  22               44           6                 3      7.333333
#GDRA  0   7   0   0                7           1                 1      7.000000
#GFFS  4   0   0  10               14           2                 1      7.000000
#GCLT  0   0   0  41               41           6                 3      6.833333
#GGEL  0   0   1   7                8           3                 1      2.666667
#GPCH  0   0   6   0                6           3                 1      2.000000




#     MA MFA  MS PHD totalNumStudents numAdvisors targetNumAdvisors stuPerAdvisor
# GPSC  2   0   0 127              129           1                 9    129.000000
# GPOL  1   0   0  69               70           1                 5     70.000000
# GPHY  0   0   9 183              192           4                13     48.000000
# GANT  7   0   0  66               73           2                 5     36.500000
# GCOM  8   0   0  26               34           1                 3     34.000000
# GCHE  0   0   7 275              282          10                19     28.200000
# GSTA  0   0 118  53              171           8                12     21.375000
# GDES  0  21   0   0               21           1                 2     21.000000
# GCMN  3   0   0  37               40           2                 3     20.000000
# GPHI  7   0   0  33               40           2                 3     20.000000
# GENL  2   0   0  76               78           4                 6     19.500000
# GMUS  2   0   0  32               34           2                 3     17.000000
# GAHI 16   0   0   0               16           1                 2     16.000000
# GART  0  16   0   0               16           1                 2     16.000000
# ----------------------
# GMAT  2   0   0  76               78           5                 6     15.600000
# GPFS  1   0   1  29               31           2                 3     15.500000
# GLIN  8   0   0  32               40           3                 3     13.333333
# GECW  0  26   0   0               26           2                 2     13.000000
# GSPA  9   0   0  43               52           4                 4     13.000000
# GECN  4   0   0  99              103           8                 7     12.875000
# GHIS  2   0   0  73               75           6                 5     12.500000
# GAPM  0   0   4  69               73           6                 5     12.166667
# GGER  2   0   0  10               12           1                 1     12.000000
# GREL  0   0   0  12               12           1                 1     12.000000
# GNAS  1   0   0  31               32           3                 3     10.666667
# GSOC  3   0   0  67               70           7                 5     10.000000
# GBST  0   0  22  22               44           6                 3      7.333333
# GDRA  0   7   0   0                7           1                 1      7.000000
# GFFS  4   0   0  10               14           2                 1      7.000000
# GCLT  0   0   0  41               41           6                 3      6.833333
# GGEL  0   0   1   7                8           3                 1      2.666667
# GPCH  0   0   6   0                6           3                 1      2.000000

