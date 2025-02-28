fetchProgramPages =
    # Download the pages locally for each program.    
function(codes = programCodes(), progURLs = programURLs(codes, u),
         dir = gsub("-", "_", sprintf("GSProgPages_%s", Sys.Date())),
         u = GSProgURL)
{
    if(!file.exists(dir))
        dir.create(dir)

    filenames = file.path( dir, sprintf("%s.html", basename(progURLs)))
    names(filenames) = names(progURLs)

    mapply(download.file, progURLs, filenames)

    filenames
}
