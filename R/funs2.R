person =
function(u, field, doc = htmlParse(u), asDataFrame = FALSE)
{
    node = getNodeSet(doc, sprintf("//div[contains(@class, '%s')]", field))
    if(length(node) == 0)
        return(data.frame(name = NA, email = NA))
    
    name = xpathSApply(node[[1]], ".//div[@class = 'field__item']/p/text()[normalize-space(.) != ''][1]", xmlValue, trim = TRUE)
    name = name[name != '']
    email = unname( xpathSApply(node[[1]], ".//div[@class = 'field__item']//a[starts-with(@href, 'mailto:')]/@href") )
    data.frame(name = name, email = gsub("^mailto:", "", email))
}


coordinator =
function(u, person = "Program Chair", doc = htmlParse(u), asDataFrame = FALSE)
{
    tmp = person(u, 'field--name-field-grad-pro-coordinator', doc, asDataFrame)

    tmp[ !grepl("^\\([0-9]+\\)|^530-", tmp$name),]
}

chair = 
function(u, person = "Program Chair", doc = htmlParse(u), asDataFrame = FALSE)
{
    person(u, 'field--name-field-program-chair', doc, asDataFrame)
}



dean =
function(u, doc = htmlParse(u), asDataFrame = FALSE)
{
    xpathSApply(doc, "//div[contains(@class, 'field--name-field-lead-dean')]//div[@class='field__item']", xmlValue)
}

progType =
function(u, doc = htmlParse(u), asDataFrame = FALSE)
{
    xpathSApply(doc, "//div[contains(@class, 'field--name-field-degree-type')]//div[@class='field__item']", xmlValue)
}

degrees =
function(u, doc = htmlParse(u), asDataFrame = FALSE)
   trimws(unlist(strsplit(getFieldItems(u, 'field--name-field-degrees-offered', doc, asDataFrame), "\\n")))



getFieldItems =
function(u, field, doc = htmlParse(u), asDataFrame = FALSE)
{
    xp = sprintf("//div[contains(@class, '%s')]//div[@class='field__item']",   field)
    ans = xpathSApply(doc, xp, xmlValue)
    if(is.null(ans))
        ""
    else
        ans
}


progCode =
function(u, doc = htmlParse(u), asDataFrame = FALSE)
   getFieldItems(u, 'field--name-field-major-code', doc)


webSite =
function(u, doc = htmlParse(u), asDataFrame = FALSE)
{
    xp = "//div[contains(@class, 'gs-program-website')]/a/@href"
    unname(xpathSApply(doc, xp))
}


progName =
function(u, doc = htmlParse(u), asDataFrame = FALSE)
{
    xp = "//h1[@class = 'page-title']"
    unname(xpathSApply(doc, xp, xmlValue, trim = TRUE))
}





getDegReqLink =
function(doc, all = FALSE)    
{
    if(is.character(doc))
        doc = htmlParse(doc)
    
    nodes = getNodeSet(doc, "//div[contains(@class, 'field--name-field-degree-requirements')]//a")
    if(length(nodes) == 0)
       return( character() )

    ans = structure(sapply(nodes, xmlGetAttr, "href"), names = sapply(nodes, xmlValue))
    if(all)
        ans
    else
        ans[1]
}

getBylawsLink =
function(doc)
{
    if(is.character(doc))
        doc = htmlParse(doc)
    
    by = getNodeSet(doc, "//div[contains(@class, 'field--name-field-administrative-bylaws')]//a")
    if(length(by) == 0)
        return(NA)
    
    structure(xmlGetAttr(by[[1]], "href"), names = xmlValue(by[[1]]))
}
