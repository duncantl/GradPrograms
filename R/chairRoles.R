rolesByEmail = 
function(email, prm, auth = readLines("prm.auth")[1])
{
    z = prmQueryName(email, prm)
    v = getPRMByEmployeeId(z$records[[1]]$employeeId, auth, curl = prm)
}
