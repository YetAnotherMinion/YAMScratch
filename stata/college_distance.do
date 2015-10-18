clear
cd "C:\Users\ShivaEbola\Documents\Stata"
use "CollegeDistance.dta"
regress yrsed dist female bytest tuition black hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80,r
di e(r2)
di e(r2_a)

//add a log linear regression model
gen ln_yrsed = ln(yrsed)
regress ln_yrsed dist female bytest tuition black hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80,r
di e(r2)
di e(r2_a)
//add a higher power distance term
gen dist2 = dist^2
regress yrsed dist dist2 female bytest tuition black hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80,r
di e(r2)
di e(r2_a)
//make an interaction term to capture both parents going to college
gen dad_and_mom = dadcoll*momcoll
regress yrsed dist dist2 female bytest tuition black hispanic incomehi ownhome dadcoll momcoll dad_and_mom cue80 stwmfg80,r
di e(r2)
di e(r2_a)

summarize yrsed dist dist2 female bytest tuition black hispanic incomehi ownhome dadcoll momcoll dad_and_mom cue80 stwmfg80
