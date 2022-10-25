






set more off
clear
clear mata
clear matrix
*set maxvar 32767
*set matsize 11000
*cd "C:\Users\dmr45\OneDrive - The Pennsylvania State University\Let Them Eat War\Final Data Sets\"
cd "/Users/LappyToppy/OneDrive - The Pennsylvania State University/Let Them Eat War/Final Data Sets"
capture log close
use "Counties.dta",clear
drop if year >2016
*drop if year <1976

drop if state==9|state==44|state==31

*merge 1:1 state place year using "Place Time.dta",gen(ptmerge)

*do "Regioner.do"

tab region, gen(reg)


gen s_pop3 = s_pop2 

gen s_pop = s_pop2/100000 



gen lnc_pop = ln(c_pop)
gen lns_pop = ln(s_pop1)

 

gen c_pop3 = c_pop/100000


 



 

gen admin = 0
replace admin = 1 if ///
statename=="California" | ///
statename=="Colorado" | ///
statename=="Minnesota" | ///
statename=="New Jersey" | ///
statename=="New York" | ///
statename=="North Carolina" | ///
statename=="North Dakota" | ///
statename=="Ohio" | ///
statename=="Virginia" | ///
statename=="Wisconsin" 






gen c_pps_lefthand1 = c_pps_welf1
gen c_pps_lefthand2 = c_pps_welf1 + c_pps_health
gen c_pps_righthand = c_pps2_popo + c_pps2_jail



egen s_pclegdem = rowmean(s_pcsenatedem s_pchousedem)
gen s_pcleggop = 100-s_pclegdem






foreach var of varlist s_totgdp s_retwages s_manwages      {
replace `var' = 1000*(`var'/s_pop1)
}

 
foreach var of varlist  c_retwages c_manwages     {
replace `var' = 1000*(`var'/c_pop)
}
 


gen crimebill = year>1994
gen welfrfrm = year >1996
gen reforms = year >=1994


egen s_averyz = std(s_avery1) 
 
 egen stcou = group(state county)
drop if stcou==.


by state county,sort: egen maxpop = max(c_pop)
*drop if maxpop<5000

sort state county year

xtset stcou year



foreach var of varlist ///
c_pcblack  c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp  {
by state county, sort: ipolate `var' year ,gen(i`var') epolate
replace `var' = i`var' if `var' >=.
replace `var' = 0 if `var'<=0
replace `var' = 100 if `var'>=100 & `var' <.



}

gen c_pcblack2 = c_pcblack^2


alpha c_pcfb c_pchisp, s gen(c_hisimm)

  
egen c_pcblackstd = std(c_pcblack)

gen s_direct1 = 1000*(s_direct/s_pop3)
gen c_direct1 = 1000*(c_total/c_pop)


gen c_left1pc = 1000*(c_left1/c_pop)
gen c_right1pc = 1000*(c_right1/c_pop)



foreach var of varlist c_cash_assist_direct c_welf_cash_direct c_housing_direct ///
c_correct_direct c_police_direct {
	replace `var' = 1000*(`var'/c_pop)
}

sort stcou year



foreach var of varlist  c_left1b c_left1pc c_cash_assist_direct c_welf_cash_direct c_housing_direct ///
c_right1b c_right1pc c_correct_direct c_police_direct c_direct1 {


bysort stcou: gen L`var' = f.`var'


replace `var' = L`var'
}


 

 replace s_avery1 = 0 if year<1996

bysort stcou: gen c_blackchange = c_pcblack - l.c_pcblack

 gen year1 = year - 1976
 gen year2 = year1^2
 
 
foreach var of varlist c_left1b c_right1b ///
c_pcblack c_blackchange c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
    s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3 {

drop if `var'==.
}
 
 
drop if year1==1972


drop if c_left1b ==0
drop if c_right1b ==0

preserve
capture log close 
log using "County Descriptives 1976-2016.log", replace


 

 

foreach var of varlist c_left1b c_right1b ///
c_pcblack c_blackchange c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
    s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3 {

drop if `var'==.
}
 
 
sort state county year




tab year,sum(c_left1pc) 
tab year,sum(c_left1b) 
tab year,sum(c_right1pc) 
tab year,sum(c_right1b) 

 sum ///
 c_left1b c_left1pc c_cash_assist_direct c_welf_cash_direct c_housing_direct ///
c_right1b c_right1pc c_correct_direct c_police_direct /// 
c_pcblack c_blackchange c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
    s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3 if year <=2015
 
  sum ///
 c_left1b c_left1pc c_cash_assist_direct c_welf_cash_direct c_housing_direct ///
c_right1b c_right1pc c_correct_direct c_police_direct /// 
c_pcblack c_blackchange c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
    s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3 if year <=1985
 
  sum ///
 c_left1b c_left1pc c_cash_assist_direct c_welf_cash_direct c_housing_direct ///
c_right1b c_right1pc c_correct_direct c_police_direct ///  
c_pcblack c_blackchange c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
    s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3 if year >=1986 & year<= 1995
 
  sum ///
 c_left1b c_left1pc c_cash_assist_direct c_welf_cash_direct c_housing_direct ///
c_right1b c_right1pc c_correct_direct c_police_direct ///  
c_pcblack c_blackchange c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
    s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3 if year >=1996 & year<= 2005
 
  sum ///
 c_left1b c_left1pc c_cash_assist_direct c_welf_cash_direct c_housing_direct ///
c_right1b c_right1pc c_correct_direct c_police_direct /// 
c_pcblack c_blackchange c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
    s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3 if year >=2006 & year<= 2015
 
 
 restore
 
 
 



capture log close 





replace c_pop3 = ln(c_pop)

foreach var of varlist c_vcrate c_pcrate {
replace `var' = ln(`var'+1)
}

foreach var of varlist  c_retwages c_manwages     {
replace `var' = ln(`var'+1)
}


replace c_direct1 = ln(c_direct1)

 
sort state county year




 log using "County Results 1976-2016.log", replace








preserve


 

 

foreach var of varlist c_left1b c_right1b ///
c_pcblack c_blackchange c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
    s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3 {

drop if `var'==.
}


foreach var of varlist ///
c_pcblack  c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog      ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3 {
bysort state: egen C_`var' = mean(`var')
*replace `var' = `var'- C_`var'
}


reg c_left1b ///
year1 year2 c_pcblack c_pcblack2   ///
   c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog   admin  ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3  i.state i.county
 
 

 


estimates store e1

reg c_right1b  ///
year1 year2 c_pcblack c_pcblack2   ///
   c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog   admin  ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3  i.state i.county
 
 
  
estimates store e2

suest e1 e2,vce(r) 

  
  
 foreach var of varlist year1 ///
year1 c_pcblack    c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog   admin  ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3 {
		sum `var'
test [e1_mean]`var'=[e2_mean]`var'
 }


reg c_left1b ///
c.year1##(c.c_pcblack c.c_pcblack2) c.year2##(c.c_pcblack c.c_pcblack2)    ///
    ///
   c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog   admin  ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3  i.state i.county

 


estimates store e1

reg c_right1b  ///
c.year1##(c.c_pcblack c.c_pcblack2) c.year2##(c.c_pcblack c.c_pcblack2)    ///
   c_pchisp c_pcfb ///
 c_pcpov  c_pcurb  c_pcfemhh ///
   c_pc0024 c_pc65o ///
c_pcunemp c_retwages c_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog   admin  ///
s_pcwelf s_imp ///
c_vcrate c_pcrate ///
 c_direct1 c_pop3  i.state i.county
 
 
 
 

 
 
estimates store e2

suest e1 e2,vce(r) 



margins, predict(outcome(e1_mean)) at(year1==0 year2==0   c_pcblack==0 c_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   c_pcblack==5 c_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   c_pcblack==10 c_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   c_pcblack==15 c_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   c_pcblack==20 c_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   c_pcblack==25 c_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   c_pcblack==30 c_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==10 year2==100   c_pcblack==0 c_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   c_pcblack==5 c_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   c_pcblack==10 c_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   c_pcblack==15 c_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   c_pcblack==20 c_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   c_pcblack==25 c_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   c_pcblack==30 c_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==20 year2==400   c_pcblack==0 c_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   c_pcblack==5 c_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   c_pcblack==10 c_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   c_pcblack==15 c_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   c_pcblack==20 c_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   c_pcblack==25 c_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   c_pcblack==30 c_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==30 year2==900   c_pcblack==0 c_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   c_pcblack==5 c_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   c_pcblack==10 c_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   c_pcblack==15 c_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   c_pcblack==20 c_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   c_pcblack==25 c_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   c_pcblack==30 c_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   c_pcblack==0 c_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   c_pcblack==5 c_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   c_pcblack==10 c_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   c_pcblack==15 c_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   c_pcblack==20 c_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   c_pcblack==25 c_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   c_pcblack==30 c_pcblack2==900  )  atmeans asbal

margins, predict(outcome(e2_mean)) at(year1==0 year2==0   c_pcblack==0 c_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   c_pcblack==5 c_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   c_pcblack==10 c_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   c_pcblack==15 c_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   c_pcblack==20 c_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   c_pcblack==25 c_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   c_pcblack==30 c_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==10 year2==100   c_pcblack==0 c_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   c_pcblack==5 c_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   c_pcblack==10 c_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   c_pcblack==15 c_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   c_pcblack==20 c_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   c_pcblack==25 c_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   c_pcblack==30 c_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==20 year2==400   c_pcblack==0 c_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   c_pcblack==5 c_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   c_pcblack==10 c_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   c_pcblack==15 c_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   c_pcblack==20 c_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   c_pcblack==25 c_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   c_pcblack==30 c_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==30 year2==900   c_pcblack==0 c_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   c_pcblack==5 c_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   c_pcblack==10 c_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   c_pcblack==15 c_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   c_pcblack==20 c_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   c_pcblack==25 c_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   c_pcblack==30 c_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   c_pcblack==0 c_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   c_pcblack==5 c_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   c_pcblack==10 c_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   c_pcblack==15 c_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   c_pcblack==20 c_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   c_pcblack==25 c_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   c_pcblack==30 c_pcblack2==900  )  atmeans asbal

/*
  
margins, predict(outcome(e1_mean)) at(year1==0   c_pcblack==0 c_pcblack2==0 admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   c_pcblack==5 c_pcblack2==25 admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   c_pcblack==10 c_pcblack2==100  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   c_pcblack==15 c_pcblack2==225  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   c_pcblack==20 c_pcblack2==400  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   c_pcblack==25 c_pcblack2==625  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   c_pcblack==30 c_pcblack2==900  admin ==1)  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==10   c_pcblack==0 c_pcblack2==0 admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   c_pcblack==5 c_pcblack2==25 admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   c_pcblack==10 c_pcblack2==100  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10    c_pcblack==15 c_pcblack2==225  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   c_pcblack==20 c_pcblack2==400  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   c_pcblack==25 c_pcblack2==625  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   c_pcblack==30 c_pcblack2==900  admin ==1)  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==20   c_pcblack==0 c_pcblack2==0 admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   c_pcblack==5 c_pcblack2==25 admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   c_pcblack==10 c_pcblack2==100  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   c_pcblack==15 c_pcblack2==225  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   c_pcblack==20 c_pcblack2==400  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   c_pcblack==25 c_pcblack2==625  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   c_pcblack==30 c_pcblack2==900  admin ==1)  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==30   c_pcblack==0 c_pcblack2==0 admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   c_pcblack==5 c_pcblack2==25 admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   c_pcblack==10 c_pcblack2==100  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   c_pcblack==15 c_pcblack2==225  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   c_pcblack==20 c_pcblack2==400  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   c_pcblack==25 c_pcblack2==625  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   c_pcblack==30 c_pcblack2==900  admin ==1)  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==39   c_pcblack==0 c_pcblack2==0 admin ==1)  atmeans asbal  
margins, predict(outcome(e1_mean)) at(year1==39   c_pcblack==5 c_pcblack2==25 admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   c_pcblack==10 c_pcblack2==100  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   c_pcblack==15 c_pcblack2==225  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   c_pcblack==20 c_pcblack2==400  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   c_pcblack==25 c_pcblack2==625  admin ==1)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   c_pcblack==30 c_pcblack2==900  admin ==1)  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==0   c_pcblack==0 c_pcblack2==0 admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   c_pcblack==5 c_pcblack2==25 admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   c_pcblack==10 c_pcblack2==100  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   c_pcblack==15 c_pcblack2==225  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   c_pcblack==20 c_pcblack2==400  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   c_pcblack==25 c_pcblack2==625  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   c_pcblack==30 c_pcblack2==900  admin ==1)  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==10   c_pcblack==0 c_pcblack2==0 admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   c_pcblack==5 c_pcblack2==25 admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   c_pcblack==10 c_pcblack2==100  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   c_pcblack==15 c_pcblack2==225  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   c_pcblack==20 c_pcblack2==400  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   c_pcblack==25 c_pcblack2==625  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   c_pcblack==30 c_pcblack2==900  admin ==1)  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==20   c_pcblack==0 c_pcblack2==0 admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   c_pcblack==5 c_pcblack2==25 admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   c_pcblack==10 c_pcblack2==100  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   c_pcblack==15 c_pcblack2==225  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   c_pcblack==20 c_pcblack2==400  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   c_pcblack==25 c_pcblack2==625  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   c_pcblack==30 c_pcblack2==900  admin ==1)  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==30   c_pcblack==0 c_pcblack2==0 admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   c_pcblack==5 c_pcblack2==25 admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   c_pcblack==10 c_pcblack2==100  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   c_pcblack==15 c_pcblack2==225  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   c_pcblack==20 c_pcblack2==400  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   c_pcblack==25 c_pcblack2==625  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   c_pcblack==30 c_pcblack2==900  admin ==1)  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==39   c_pcblack==0 c_pcblack2==0 admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   c_pcblack==5 c_pcblack2==25 admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   c_pcblack==10 c_pcblack2==100  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   c_pcblack==15 c_pcblack2==225  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   c_pcblack==20 c_pcblack2==400  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   c_pcblack==25 c_pcblack2==625  admin ==1)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   c_pcblack==30 c_pcblack2==900  admin ==1)  atmeans asbal 



restore

*/

capture log close
