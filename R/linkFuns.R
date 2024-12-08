mkDocLinkReport =
function(doc, exists, fixes)
{
#    lnks = gsub("\\)$", "", lnks)    
#    bad = lnks[ !exists[ lnks ] ]

    if(is.character(doc))
        doc = xmlParse(doc)

    nodes = getNodeSet(doc, "//ulink[starts-with(@url, 'http')]") # "//a[starts-with(@href, 'http')]")
    href0 = sapply(nodes, xmlGetAttr, "url")
    endParen = grepl("\\)$", href0)
    href = gsub("\\)$", "", href0)

    pageNums = as.integer(sapply(nodes, function(x) xmlGetAttr(xmlParent(x), "number")))


    ans = data.frame(pageNum = pageNums, url = href0, trailingParen = endParen)
#    browser()
    ans$newURL = fixes[ans$url]    
    if(any(endParen))
        ans$newURL[endParen] = unname( fixes[ href[endParen ] ] )
    
    ans = ans[href %in% names(exists)[!exists] | endParen,]

    
    ans
}
