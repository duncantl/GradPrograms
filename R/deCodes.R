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


gcertCodes = gaucCodes =
    function()
{
    u =  "https://grad.ucdavis.edu/graduate-academic-certificates"
    doc = htmlParse(readLines(u))
    li = getNodeSet(doc, "//ul[@class = 'list--accordion']/li")
    idx = seq(1, by = 2, length = length(li)/2)
    ti = sapply(li[idx], xmlValue)
    rx = "^([^(]+) \\((G[A-Z]+)\\)$"

    nms = gsub(rx, "\\1", ti)
    # nbsp
    nms = gsub("\ua0", '', nms)

    structure( gsub(rx, "\\2", ti), names = nms)
}
