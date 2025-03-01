# This test runs the same code in programs.R but uses the program URLs rather than local files.
# This is slow as it ends up fetching each program page multiple times, e.g., for the dean and then for the gpc.
# And this is true of all the functions that read data from that page.
# So this is testing whether the code works with URLs but we would only use that approach in practice
# if dealing with an individual program. Otherwise, we would call fetchProgramPages() and work with the local copies.

library(GradPrograms)
e = parse("programs.R")

w = sapply(e, function(x) is.call(x) && is.name(x[[1]]) && as.character(x[[1]]) %in% c("=", "<-") && is.name(x[[2]]) && as.character(x[[2]]) == "files")

# Should only be one.
i = which(w)[1]

e[[i]] = quote(files <- programURLs())

eval(e, globalenv())
