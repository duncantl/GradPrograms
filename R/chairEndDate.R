mkEndDate =
function(x)
{
    j = fromJSON(x)
    if(length(j$roles) == 0)
        return(NA)
    
    i = which(sapply(j$roles, function(x) x$code == "CHAIR" & !is.null(x$group) && !is.null(x$group$programType) && x$group$programType == "DESIGNATED_EMPHASIS"))

    if(length(i) == 0)
        NA
    else 
        data.frame(startDate = sapply(i, function(i) nullToNA(j$roles[[i]]$startDate)), endDate = sapply(i, function(i) nullToNA(j$roles[[i]]$endDate)), program = sapply(i, function(i) j$roles[[i]]$group$code))
}

nullToNA =
function(x)
{
    if(is.null(x))
        NA
    else
        x
}
