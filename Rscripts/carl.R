
# See coordinators.R

# From the gradhub
g = read.csv("~/Downloads/CSV/Graduate Program Roles (2).csv", stringsAsFactors = FALSE)

g = subset(g, Is.Primary != "Backup")

ch = subset(g, Role == "Chair")

pcoord = subset(g, Role != "Chair")



setdiff(pcoord$Email, d$email)
setdiff(d$email, pcoord$Email)



# Can get the names of the people from PRM, but probably best to send it to the program emails
# rather than the personal emails.


# Probably only want to send this to one chair - not all chairs
# Actually probably just the coordinator and not bother/duplicate the chair


zz = split(chair.d, chair.d$program)
mw = sapply(zz, nrow) > 1
zz[mw]

c(d$email, chair$email)



split(d, d$email)




