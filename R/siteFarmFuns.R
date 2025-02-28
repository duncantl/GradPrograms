degReqDates =    
function(f, doc = htmlParse(f))
{
  as.integer(xpathSApply(doc, "//div[contains(@class, 'field--name-field-degree-requirements')]//a", xmlValue))
}

bylawsDates =    
function(f, doc = htmlParse(f))
{
  as.integer(xpathSApply(doc, "//div[contains(@class, 'field--name-field-administrative-bylaws')]//a", xmlValue))
}
