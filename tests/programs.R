library(GradPrograms)

urls = programURLs()
u2 = programURLs(asDF = TRUE)
stopifnot(is.data.frame(u2))
stopifnot(nrow(u2) == length(urls))


p = programCodes()
stopifnot(all(nchar(p) == 4))
stopifnot(!is.null(names(p)))


dir = tempdir()
files = fetchProgramPages(dir = dir)

# After all the switching of functions
# the dean function now needs first argument to be a local file.

deans = sapply(files, dean)
stopifnot( all(deans != ""))

gpc = lapply(files, gpc)
stopifnot(all( sapply(gpc, nrow) > 0))

chair = lapply(files, chair)
stopifnot(all( sapply(chair, nrow) > 0))



# getDegRequirements - this assumes a URL. So fails. Not anymore.
# can add quiet = TRUE to avoid the output from download.file().
reqs = lapply(files, getDegRequirements)
stopifnot(all( sapply(reqs, length) > 0)) 
# message("SKIPPING getDegRequirements")

bylaws = sapply(files, getBylawsLink)
stopifnot( is.character(bylaws) && all(nchar(bylaws) > 20))

degLnk = sapply(files, getDegReqLink)
stopifnot( is.character(degLnk) && all(nchar(degLnk) > 20))


degrees = lapply(files, degrees)
# The MBA gives 0.
stopifnot( sum(sapply(degrees, length) > 0) > .9*length(files))

url = sapply(files, webSite)
stopifnot(all(nchar(url) > 0))
w = grepl("^https?:", url)
stopifnot(all(w))



reqDates = lapply(files, degReqDates)
stopifnot(all( sapply(reqDates, length) > 0))

bylawsDates = lapply(files, bylawsDates)
stopifnot(all( sapply(bylawsDates, length) > 0))


lcodes = toupper(gsub("\\.html", "", basename(files)))
codes = sapply(files, progCode)
stopifnot(all(lcodes == codes))

name = sapply(files, progName)
stopifnot(all(names(p) == name))

type = sapply(files, progType)
tt = table(type)
stopifnot(all(type %in% c("Departmentally-Based Graduate Program", "Interdisciplinary Graduate Group", "Professional Program")))
stopifnot(tt["Professional Program"] < .3 * length(type))

# url exists?

# rolesByEmail


# Check admit dates for all programs with some exceptions
# The professional
admitDates = lapply(files, admissionDate)
nd = sapply(admitDates, length) > 0
# Allow for some to be empty. All professional programs and Dramatic Art.
stopifnot( sum(nd) > .8 * length(nd) )
stopifnot( sum(nd[ type != "Professional Program"]) > .8 * length(nd) )

# Which programs have no application dates, grouped by program type.
# No obvious test.
split(names(p)[!nd],  type[!nd])
