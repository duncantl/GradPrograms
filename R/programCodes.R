GSProgURL = "https://grad.ucdavis.edu/programs"

programCodes = 
function(url = GSProgURL)
{
    txt = readLines(url)
    doc = htmlParse(txt)
    u = getHTMLLinks(doc)

    w = grepl("^/programs/[a-z]{4}$", u)
    u = u[w]

    codes = toupper(gsub("^/programs/", "", u))
}

programURLs = 
function(codes = programCodes(url), url = GSProgURL, asDF = FALSE)
{
    u = getRelativeURL(paste0("/programs/", tolower(codes)), url)
    if(!asDF)
        return(structure(u, names = names(codes)))

    data.frame(code = codes, name = names(codes), url = u, row.names = codes)
}


progWebsite =
function(u, doc = htmlParse(u))
{
    xpathSApply(doc, "//div[contains(@class, 'gs-program-website')]/a/@href")
}
