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
function(codes = programCodes(url), url = GSProgURL)
{
    structure( getRelativeURL(paste0("/programs/", tolower(codes)), url),
               names = names(codes))
}
