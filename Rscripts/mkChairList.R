# see download.R
chairs = lapply(filenames, chair)
bad = sapply(chairs, function(x) is.na(x[1, "name"]))

d = data.frame(program = names(filenames),
           code = toupper(gsub("\\.html", "", basename(filenames))),
           chairName1 = sapply(chairs, function(x) x[1, "name"]),
           chairEmail1 = sapply(chairs, function(x) x[1, "email"]),
           chairName2 = "",
           chairEmail2 = "")

w = sapply(chairs, nrow) > 1
d$chairName2[w] = sapply(chairs[w], function(x) x[2, "name"])
d$chairEmail2[w] = sapply(chairs[w], function(x) x[2, "email"])

d2 = d[ order(is.na(d$chairName1)),]
