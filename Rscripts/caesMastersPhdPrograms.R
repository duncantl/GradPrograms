library(GradPrograms)
library(XML)
dir = "~/OGS/START/GradGroupAnalysis/ProgPages_Feb27"
h = list.files(dir, full = TRUE)


ans = data.frame(college = sapply(hd, dean))
ans$name = sapply(h, progName)
ans$degree = sapply(degs, function(x) paste(sort(x), collapse = ", "))
ans$degree = gsub(" Plan [ABC]", "", ans$degree)
ans$urls = sapply(h, progWebsite)

caes = subset(ans, college == 'College of Agricultural and Environmental Sciences')

w = grepl("M\\.[SA].*Ph\\.D\\.", caes$degree) | grepl("Human Development", caes$name)

both = caes[w,]
i = grep("Human Development", both$name)

i2 = grep("Child Development", caes$name)
both[i, "degree"] = paste(caes$degree[i2], both$degree[i], sep = ", ")
both[i, "name"] = "Human and Child Development"

names(both) = c("College", "Program Name", "Program Web Site", "Degrees Offered")


