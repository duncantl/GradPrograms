library(GradPrograms)
#source("GradPrograms/Rscripts/downloadPages.R", verbose = TRUE)

deans = sapply(filenames, leadDean)
type = sapply(filenames, progType)
degs = lapply(filenames, degrees)

degs2 = sapply(degs, function(x) gsub(" Plan [A-C]", "", x))

degs3 = sapply(degs, paste, collapse = ", ")

code = gsub("\\.html", "", basename(filenames))

d = data.frame(program = names(degs3), code = code, dean = deans, type = type, degrees = degs3)

schools = c(`Graduate School of Management` = "GSM",
            `College of Agricultural and Environmental Sciences` = "CAES", 
            `College of Biological Sciences` = "CBS",
            `College of Letters and Science` = "CL&S", 
            `College of Engineering` = "COE",
            `School of Medicine` = "SOM",
            `School of Education` = "SOE", 
            `School of Veterinary Medicine` = "SVM",
            `Graduate School` = "GS", 
            `School of Law` = "LAW",
            `School of Nursing` = "SON")

d$school = schools[d$dean]

d = d[, c("program", "code", "school", "type", "dean", "degrees" )]

abbr = c("Departmentally-Based Graduate Program" = "Dept.Based Grad Program",
         "Interdisciplinary Graduate Group" = "Grad Group", 
         "Professional Program" = "Professional Program")

d$type = abbr[d$type]

#schools = unique(deans)


ty = split(d, d$type)
col = split(d, d$school)
z = c(all = list(d), ty, col)
writexl::write_xlsx(z, "~/GradProgramGroupInfo.xlsx")
