# Study of Religion - see email 4/13/2021  & 6/7/21  Flagg Miller. Were waiting on compliance check.
# Nuclear Science -  Robert Svoboda   email 12/11/2019. ends June 30, 2022.
# Biology of Vector-borne Diseases   11/4/2020    term = 2020-2023


# DEs that appear to have a 2022 end-of-term
# Biotechnology
# Human Rights
# Nuclear Science
# Computational Social Science


# See the first 17 lines DEs.R  to fetch the documents.
library(XML)
library(RJSONIO)
source("funs2.R")

filenames = list.files("DECache", pattern = "html$", full = TRUE)

chairs = do.call(rbind, lapply(filenames, chair))
if(length(names(filenames)) == 0)
    names(filenames) = sapply(filenames, function(f) xpathSApply(htmlParse(f), "//h1[starts-with(@class, 'page-title')]", xmlValue, trim = TRUE))
chairs$program = names(filenames)
chairs$progCode = toupper(gsub(".html$", "", basename(filenames)))



library(PRM)
source("~/OGS/GradhubCode/PRM/R/prm.R")
xauth = cookie("prm.auth")
con = mkPRMConnection(xauth, httpheader = c('Content-Type' = 'application/json'))

chair.emails = chairs[,2]

w = !is.na(chair.emails)
prm.info = lapply(chair.emails[w], function(email) try(prmQueryName2(email, con)))
names(prm.info) = chair.emails[w]

loginIds = sapply(prm.info, function(x) x$records[[1]]$loginId)
personPage = sprintf('https://prm.gs.ucdavis.edu/api/person/%s', loginIds)

json = lapply(personPage, function(u) { print(u); try(getURLContent(u, curl = con))})
names(json) = loginIds

source("chairEndDate.R")
end = lapply(json, mkEndDate)
end = do.call(rbind, end)

end[1:2] = lapply(end[1:2], function(x) as.Date(gsub("T.*", "", x), "%Y-%m-%d"))

m = match( chairs$progCode, end$program)
de = cbind(chairs, end[m,])


de[is.na(de$name) | is.na(de$endDate) | grepl("2022", de$endDate),]

#w2 = is.na(end[,2]) | grepl("2022", end[,2])
#end[w2,]


