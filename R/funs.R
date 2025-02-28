getDEInfo =
function(u, doc = htmlParse(u))
{
  
}


# Repurposed this to call getDegReqLink rather than URL
# XXX enhance to allow all = TRUE and then put year on the name.
# Handle 2 in the same year.
getDegRequirements =    
function(u, to, doc = htmlParse(getURLContent(u)))
{
    dr = getDegReqLink(doc = doc)
    if(length(dr) < 1)
        return(NA)
    download.file(dr[1], to)
    dr[1]
}


# For SiteFarm format
admissionDate =
function(u, doc = htmlParse(u))
{
    v = xpathSApply(doc, "//div[contains(@class, 'field--name-field-admission-deadlines')]//div[@class = 'field__item']/text()", xmlValue)
    if(length(v) == 0)
        return(structure(numeric(), class = "Date"))

    v = trimws(v)
    els = strsplit(v, ": *")
    structure(as.Date(sapply(els, `[`, 2), "%b %d, %Y"),
              names = sapply(els, `[`, 1))
}


if(FALSE) {

    # For the old HTML page format


getDocYears =
function(u, doc = htmlParse(u))
{
    bylaws = xpathSApply(doc, "//div[contains(@class, 'gs-program-bylaws') or contains(@class, 'gs-emphasis-bylaws')]//a", xmlValue)
    deg.req = xpathSApply(doc, "//div[contains(@class, 'gs-program-degree-req')]//a", xmlValue)
    data.frame(degreeRequirements = if(length(deg.req)) max(as.integer(deg.req)) else NA,
               bylaws = if(length(bylaws) == 0) NA else as.integer(bylaws))
}

    
chair =
function(u, doc = htmlParse(u), ...)
{
    #  xpathSApply(doc, "//h3[contains(., 'Program Chair')]/following-sibling::div[1]//h3", xmlValue)
   person(doc = doc, ...)
}

coordinator = 
function(u, doc = htmlParse(u), ...)
{
  person(doc = doc, person = "Graduate Program Coordinator", ...)
}

person =
function(u, person = "Program Chair", doc = htmlParse(u), asDataFrame = FALSE)
{
#    ans = xpathSApply(doc, sprintf("//h3[contains(., '%s')]/following-sibling::div[1]//h3", person), xmlValue)
    #    ans = getNodeSet(doc, sprintf("//h3[contains(., '%s')]/following-sibling::div[1]//h3", person))
    ans = getNodeSet(doc, sprintf("//h3[contains(., '%s')]/following-sibling::*", person))    

    i = which(sapply(ans, xmlName) == "h3")
    if(length(i))
        ans = ans[seq(1, length = i[1] - 1)]
    
    if(length(ans) == 0)
        structure(NA, names = NA)
    else {

      tmp = structure(sapply(ans, function(x) xpathSApply(x, ".//h3", xmlValue)), names = gsub("^mailto:", "", sapply(ans, function(x) getNodeSet(x, ".//a[starts-with(@href, 'mailto:') and contains(@href, '@')]/@href"))))

      if(!asDataFrame)
          return(tmp)

      role = unlist(lapply(ans, function(x) xpathSApply(x, ".//b", xmlValue)))
      if(length(role) == 0)
          role = rep(person, length(tmp))
      data.frame(name = tmp, mail = names(tmp), role = role,
                 stringsAsFactors = FALSE, row.names = NULL)
    }
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
    data.frame(name = name, type = type, dean = if(length(ii[[1]])) ii[[1]] else NA, code = ii[[2]],
               chair = paste(chair(doc = doc), collapse = ", "),
               coordinator = paste(coordinator(doc = doc), collapse = ", "), row.names = NULL)
}


getDEPrograms =
function(u, doc = htmlParse(u))
{
  unname(gsub("/programs/", "", unlist(getNodeSet(doc, "//div[contains(@class, 'programs')]//a/@href"))))
}


getDegReqURL =
function(u, doc = htmlParse(getURLContent(u)))
{
    xpathSApply(doc, "//div[contains(@class, 'gs-program-degree-req')]//a/@href")
}

getDegreesOffered =
function(u, doc = htmlParse(u))
{
   trimws(xpathSApply(doc, "//h3[contains(., 'Degrees Offered')]/following-sibling::div[1]//div[starts-with(@class, 'field__item ')]", xmlValue))
}
    

    
} # if(FALSE)
