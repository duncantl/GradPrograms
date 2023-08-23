library(ReadPDF)

getPara =
function(x, ncontext = 4)
{
    # This works if the text is all lines.
    # If changes fonts or broken up, need to use the bounding box
    # and order the phrases.
    # Also, the lines can be out of order.
  c(rev(rev(sapply(getSiblings(x, FALSE), xmlValue))[seq_len(ncontext)]),
     sapply(getSiblings(x), xmlValue)[seq_len(ncontext)][-1])
}


getPara2 =
function(x, ncontext = 4)
{
    bb = getBBox2(xmlParent(x))
    # group into lines
    # order within each line
    order(bb$top)
}
