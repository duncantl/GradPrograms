degreesOffered =
function(majorCode = "gcsi",
         u = sprintf("https://grad.ucdavis.edu/programs/%s", tolower(majorCode)),
         txt = getURLContent(u), doc = htmlParse(txt))
{
  xpathSApply(doc, "//h3[. = 'Degrees Offered']/following-sibling::div[1]/div/div[contains(@class, 'field__item')]", xmlValue)
}


if(FALSE) {
    p = readRDS("Programs.rds")
    do = lapply(basename(p), degreesOffered)
    names(do) = basename(p)
    which(sapply(do, function(x) any(grepl("Integrated", x))))



dir = "Cache_April19_2021"
    #u = sprintf("Cache3/%s.html", basename(p))
u = list.files(dir, full = TRUE, pattern = "\\.html$")
library(XML)
degs = lapply(u, function(u) degreesOffered(doc = htmlParse(u)))
names(degs) = basename(p)

    # gare gbse gcsi geec gpol gsta 
}
