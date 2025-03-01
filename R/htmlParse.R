htmlParse =
    #
    # This allows the other functions in this package to work with a local file or a URL and not
    # have to deal with these sources of content differently.
    #
    # if given a URL, i.e. a string starting with http, then download the content of that document.
    # Otherwise, just assume this is the name of a file or the content itself.
    #
function(u, ...)
{
    isURL = length(u) == 1 && grepl("^https?:", u)
    if(isURL)
        u = getURLContent(u, ...)

    XML::htmlParse(u)
}
