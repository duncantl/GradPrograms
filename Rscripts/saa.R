filenames = list.files("Cache_Mar18_2021", full = TRUE)
names(filenames) = gsub(".html$", "", basename(filenames))
saas = sapply(filenames, person, "Senior")
names(saas) = names(filenames)

table(saas)



# Census of students
gh = as.data.frame(readxl::read_excel(mostRecent("^gradhub-export")))

numStudents = table(gh$Major)
studentsBySAA = tapply(names(saas), saas, function(x) numStudents[toupper(x)])
sapply(studentsBySAA, sum)


# Students by degree
tt2 = table(gh$Major, gh$Degree)

studentsBySAAByDegree = tapply(names(saas), saas, function(x) { tmp = tt2[toupper(x), ]; tmp[, colSums(tmp) > 0]})

lapply(studentsBySAAByDegree, colSums)


sapply(studentsBySAAByDegree, function(x) sum(colSums(x)))
# Total number of students per SAA
#          Brad Wolf Rachel De Los Reyes        Sarah Mooney         Wallace Woods 
#               1525                1324                1362                  1366 



# Number of unique coordinators per SAA

coordinators = lapply(filenames, person, "Coordinator")
names(coordinators) = names(filenames)

coords = tapply(names(saas), saas, function(x) unique(unlist(coordinators[x])))
sapply(coords, length)

##################################################################

# Number of programs for each SAA

#          Brad Wolf Rachel De Los Reyes        Sarah Mooney         Wallace Woods 
#                 22                  27                  32                    12

# Number of coordinators

#          Brad Wolf Rachel De Los Reyes        Sarah Mooney       Wallace Woods 
#                 15                  17                  22                  12 


# Types of students by SAA
#`Brad Wolf`
# MA   MS  PHD 
#  2  352 1171 
#
#`Rachel De Los Reyes`
#MAS  MHS  MPH MPVM   MS  MSN  PHD 
# 18  130   29   19  182   60  886 
#
#`Sarah Mooney`
#CRED  EDD   MA  MFA   MS  PHD 
#   1   71  185   61   39 1005 
#
#`Wallace Woods`
# MAS MENGR    MS   PHD 
#  24    21   551   770 
