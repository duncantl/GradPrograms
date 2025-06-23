# https://grad.ucdavis.edu/designated-emphases

deCodes = 
function()
{
    u = "https://grad.ucdavis.edu/designated-emphases"
    doc = htmlParse(readLines(u))
    a = getNodeSet(doc, "//a[contains(@href, '/designated-emphases/')]")
    
    h = sapply(a, xmlGetAttr, "href")
    structure(toupper(basename(h)), names = sapply(a, xmlValue))
}

