ff = list.files("Cache_April19_2021", full = TRUE, pattern = "\\.html")

progType = lapply(ff, typeInfo)
types = lapply(progType, function(x) x[1, "type"])
w = types == "Interdisciplinary Graduate Group"
docs = lapply(ff[w], htmlParse)

progName = sapply(docs, function(x) xpathSApply(x, "//head/title", xmlValue))
progName = trimws(gsub("\\|.*", "", progName))

names(docs) = progName

coordNames = sapply(docs, function(x) coordinator(doc = x))
w = sapply(coordNames, function(x) any(is.na(x)))


coordEmail = 
function(doc)
{
    ans = xpathSApply(doc, sprintf("//h3[contains(., '%s')] /following-sibling::div[1]//a[contains(@href, '@ucdavis.edu')]", "Graduate Program Coordinator"), xmlGetAttr, 'href')
    if(length(ans) == 0)
        return(NA)
    gsub("^mailto:", "", ans)
}

emails = sapply(docs, coordEmail)

emails["Applied Mathematics"] = "studentservices@math.ucdavis.edu"

c(Biophysics = "",
  "Clinical Research" = "",
  "Integrative Genetics and Genomics" = "")

d = data.frame(name = sapply(coordNames, paste, collapse = ", "),  email = emails, program = progName)
rownames(d) = NULL

