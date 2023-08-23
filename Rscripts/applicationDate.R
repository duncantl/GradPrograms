#
dates = sapply(filenames, admissionDate)
names(dates) = filenames
dates = unlist(dates[!sapply(dates, is.null)])
progs = sapply(names(dates), progName)
degs = sapply(names(dates), degrees)
e = new.env(); source("../ListeningTour/funs.R", e)
degs2 = lapply(degs, e$cleanDegree)
degs2 = lapply(degs2, function(x) unique(trimws(gsub("Plan II?|Plan [ABC]", "", x))))
degs2 = lapply(degs2, function(x) grep("by exception", x, value = TRUE, invert = TRUE))

degs2 = lapply(degs2, function(x) gsub(" / ", "/", x))
#degs = sapply(degs, function(x) paste(e$cleanDegree(x), collapse = "; "))



el = strsplit(dates, "\\n")
a = sapply(el, `[[`, 1)



procDate =
function(x)
{
    a = strsplit(x, ":")[[1]]
    structure(trimws(a[2]), names = trimws(a[1]))
}


el2 = lapply(el, function(x) sapply(x, procDate, USE.NAMES = FALSE))

types = c("Priority", "General", "Space Available")
tt = as.data.frame(do.call(rbind, lapply(el2, function(x) x[types])))
names(tt) = types
tt$program = progs

ea = sapply(1:nrow(tt), function(i)  min( as.Date(unlist(tt[i,]), "%b %d, %Y"), na.rm = TRUE))
tt$earliest = structure(ea, class = "Date")  # as.Date(ea, "%b %d, %Y")
tt$degrees = sapply(degs2, paste, collapse = ", ")
tt$url = sprintf("https://grad.ucdavis.edu/programs/%s", gsub("\\.html", "", basename(rownames(tt2))))

tt2 = tt[order(tt$earliest),]
tt2[] = lapply(tt2, function(x) { x[is.na(x)]="" ; x })
#tt2$program = rownames(tt2)
tt2 = tt2[, c("program", "degrees", "Priority", "General", "Space Available", "url", "earliest")]

rownames(tt2) = NULL
writexl::write_xlsx(tt2, "ProgramApplicationDates1.xlsx")



if(FALSE) {
d = data.frame(#program = names(a),
          type = trimws(gsub(":.*", "", a)),
          date = as.Date(trimws(gsub(".*:", "", a)), "%b %d, %Y"))

w = d$date < Sys.Date()

d[w,]
}



