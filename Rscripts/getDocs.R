library(GradPrograms)

# getDegReqLink(, TRUE)
# getBylawsLink()


library(GradPrograms)

dir = "~/OGS/ScrapeWeb/GradPrograms/Aug_27_24/"

gprogs = list.files(dir, full = TRUE, pattern = "\\.html$")

degLinks = lapply(gprogs, getDegReqLink, TRUE)
names(degLinks) = tools::file_path_sans_ext(basename(gprogs))

bylawsLinks = lapply(gprogs, getBylawsLink)
names(bylawsLinks) = tools::file_path_sans_ext(basename(gprogs))



deDir = file.path(dir, "DECache")
des = list.files(deDir, full = TRUE, pattern = "\\.html")
names(des) = tools::file_path_sans_ext(basename(des))
deBylawsLinks = lapply(des, getBylawsLink)
deDegLinks = lapply(des, getDegReqLink, TRUE)



outDir = "Docs2"
if(!file.exists(outDir))
    dir.create(outDir)

dwld =
function(urls, prog, prefix, dir)
{
    dest = file.path(dir, sprintf("%s_%s_%s.pdf", prog, prefix, names(urls)))
    mapply(download.file, urls, dest)
}

st1 = mapply(dwld, degLinks, names(degLinks), "degreRequirements", MoreArgs = list(dir = outDir))

st2 = mapply(dwld, bylawsLinks, names(bylawsLinks), "bylaws", MoreArgs = list(dir = outDir))


st3 = mapply(dwld, deBylawsLinks, names(deBylawsLinks), "DEbylaws", MoreArgs = list(dir = outDir))
st4 = mapply(dwld, deDegLinks, names(deDegLinks), "DEDegRequirements", MoreArgs = list(dir = outDir))


# smba, smbb, ... have
#   "https://programs.gs.ucdavis.eduundefined"
# for bylaws.

# DEs.
# See GradPrograms/Rscripts/DEs.R



pdfs = list.files(outDir, recursive = TRUE, pattern = "\\.pdf$", full = TRUE)
length(pdfs)

xml = mapply(convertPDF2XML, pdfs, gsub("\\.pdf$", ".xml", pdfs))

library(ReadPDF)

docs = lapply(xml, readPDFXML)

# The following takes over a minute for isScanned, and 6 1/2 minutes for isScanned2
w1 = sapply(docs, isScanned)
w2 = sapply(docs, isScanned2)
print(table(w1, w2))

# w2 finds 5 scanned that w1 does not,
# Otherwise they agree and find 63 documents that both consider scanned
#
# The 5 they disagree on are
# gclr, gmcd, gphy and gdnu and  gdrb (DE) degree requirements

 # Docs/gclr_degreRequirements_2011.pdf  - not scanned
 # Docs/gcmd_degreRequirements_2010.pdf  - not scanned
 # Docs/gdnu_DEDegRequirements_2012.pdf  - not scanned
 # Docs/gdrb_DEDegRequirements_2015.pdf  - not scanned
 # Docs/gphy_degreRequirements_2005.pdf  - not scanned.


sc = pdfs[w1 & w2]

cvtDir = "ConvertedDocs2"
if(!file.exists(cvtDir))
   dir.create(cvtDir)

source("convertPDF.R")
out = file.path(cvtDir, basename(sc))

mapply(cvtPDF, sc, out)



############

library(Rtesseract)
sc.bb = lapply(sc, GetBoxes)
