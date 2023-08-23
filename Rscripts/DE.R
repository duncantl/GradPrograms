library(RCurl)
library(XML)

u = "https://grad.ucdavis.edu/designated-emphases"
tt = getURLContent(u, followlocation = TRUE)
doc = htmlParse(tt)
# Get the human-readable names
tmp = getNodeSet(doc, "//a[contains(@href, 'designated-emphases/')]")
ll = structure(sapply(tmp, xmlGetAttr, "href"), names = sapply(tmp, xmlValue))
if(FALSE) {
  ll = getHTMLLinks(doc)
  de = grep("designated-emphases/[a-z]+$", ll, value = TRUE)
}
de.urls = getRelativeURL(de, u)
names(de.urls) = names(ll)

getYear =
function(u, doc = htmlParse(getURLContent(u)))
{    
     xpathSApply(doc, "//div[contains(@class, 'field--name-field-degree-requirements')]//a", xmlValue)
}

years = sapply(de.urls, getYear)

years1 = sapply(years, `[`, 1)

