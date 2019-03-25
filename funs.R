
getDocYears =
function(u, doc = htmlParse(u))
{
    bylaws = xpathSApply(doc, "//div[contains(@class, 'gs-program-bylaws') or contains(@class, 'gs-emphasis-bylaws')]//a", xmlValue)
    deg.req = xpathSApply(doc, "//div[contains(@class, 'gs-program-degree-req')]//a", xmlValue)
    data.frame(degreeRequirements = if(length(deg.req)) max(as.integer(deg.req)) else NA,
               bylaws = if(length(bylaws) == 0) NA else as.integer(bylaws))
}


getDEInfo =
function(u, doc = htmlParse(u))
{
  
}


chair =
function(u, doc = htmlParse(u))
{
    #  xpathSApply(doc, "//h3[contains(., 'Program Chair')]/following-sibling::div[1]//h3", xmlValue)
   person(doc = doc)
}

coordinator = 
function(u, doc = htmlParse(u))
{
  person(doc = doc, person = "Graduate Program Coordinator")
}

person =
function(u, doc = htmlParse(u), person = "Program Chair")
{
#    ans = xpathSApply(doc, sprintf("//h3[contains(., '%s')]/following-sibling::div[1]//h3", person), xmlValue)
    #    ans = getNodeSet(doc, sprintf("//h3[contains(., '%s')]/following-sibling::div[1]//h3", person))
    ans = getNodeSet(doc, sprintf("//h3[contains(., '%s')]/following-sibling::*", person))    

    i = which(sapply(ans, xmlName) == "h3")
    if(length(i))
        ans = ans[seq(1, length = i[1] - 1)]
    
    if(length(ans) == 0)
        structure(NA, names = NA)
    else
        structure(sapply(ans, function(x) xpathSApply(x, ".//h3", xmlValue)), names = gsub("^mailto:", "", sapply(ans, function(x) getNodeSet(x, ".//h3//a[starts-with(@href, 'mailto:')]/@href"))))
}


typeInfo =
function(u, doc = htmlParse(u))
{
    nn = getNodeSet(doc, "//div[./h3[contains(., 'Program Type')]]")
    if(length(nn) == 0) {
        warning("Cannot find 'Program Type' node")
        return(data.frame())
    }
    type = xpathSApply(nn[[1]], "./div[1]/div[1]", xmlValue)
    ii = lapply(c("program-lead-dean", "program-major-code"),
           function(i) {
             xpathSApply(nn[[1]], sprintf("./div[contains(@class, '%s')]/div[2]", i), xmlValue)
         })

    name = xpathSApply(doc, "//h1[contains(@class, 'page-title__title')]", xmlValue)
    data.frame(name = name, type = type, dean = ii[[1]], code = ii[[2]],
               chair = chair(doc = doc), coordinator = coordinator(doc = doc))
}
