d = read.csv("Units", fill = TRUE, skip = 2)
w = d[[1]] == ""
d[w,1] = NA
x = d[[4]]
d$phdMin = NA
d$phdMax = NA

omit = (x == "")
d[omit, 1]

nw = grepl("^[0-9]+$", x) | x == ""

d$phdMin[nw] = d$phdMax[nw] = as.integer(x[nw])

i = grepl("\\+$", d[[4]])
d$phdMin[i] = as.integer(gsub("\\+$", "", d[[4]][i]))

w = grepl("[/-]", x)
x = gsub("\\+$", "", x, fixed =TRUE)

d$phdMin[w] = as.integer(gsub("[-/].+", "", x[w]))
d$phdMax[w] = as.integer(gsub(".+[-/]", "", x[w]))


d[is.na(d$phdMin),]

d[,2] = as.integer(d[,2])
d[,3] = as.integer(d[,3])

d2 = d[ , c("program", "MS1", "MS2", "PHD", "phdMin", "phdMax", "Note")]

d2$PhdEqualFewer = FALSE
w = (!is.na(d2$MS1) & !is.na(d2$phdMin) & d2$MS1 >= d2$phdMin) | (!is.na(d2$MS2) & !is.na(d2$phdMin) & d2$MS2 >= d2$phdMin)
d2$PhdEqualFewer[w] = TRUE

table(w)
# 18 of the 

writexl::write_xlsx(d2, "DegreeUnits.xlsx")


