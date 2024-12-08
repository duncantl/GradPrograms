programCodes = 
function(url = "https://grad.ucdavis.edu/programs")
{
    txt = readLines(url)
    doc = htmlParse(txt)
    u = getHTMLLinks(doc)
    w = grepl("^/programs/[a-z]{4}$", u)

    u = u[w]
    getRelativeURL(u, url)
}
