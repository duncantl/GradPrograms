library(XML)
library(ReadPDF)

containsGRE = 
function(f, doc = readPDFXML(f))
{
    nodes = getNodeSet(doc, "//text[contains(., 'GRE')]")
    if(length(nodes) > 0)
        return(TRUE)

    all(sapply(c("Graduate", "Record", "Exam"), function(x) length(getNodeSet(doc, sprintf("//text[contains(., '%s')]", x))) > 0))
}

getGRENodes =
function(f, doc = readPDFXML(f))
{
    # Catches DEGREE
    ans =  getNodeSet(doc, "//text[contains(.,'GRE') or contains(.,'Record')]")
    names(ans) = sapply(ans, function(x) xmlGetAttr(xmlParent(x), "number"))
    ans
}

if(FALSE) {
x = list.files(pattern = "xml$")
hasGRE = sapply(x, containsGRE)
names(hasGRE) = gsub("\\.xml", "", basename(x))
table(hasGRE)
names(hasGRE)[!hasGRE]
}
