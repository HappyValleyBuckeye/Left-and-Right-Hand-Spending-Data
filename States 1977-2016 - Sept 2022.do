set more off
capture log close
cd "/Users/LappyToppy/OneDrive - The Pennsylvania State University/Let Them Eat War/Final Data Sets"
*cd "C:\Users\dramey\Dropbox\Let Them Eat War\Final Data Sets\"

use "States.dta",clear
drop if year >2016

drop if state ==9|state ==44|state ==31

*merge 1:1 state place year using "Place Time.dta",gen(ptmerge)

drop if region ==.
drop region
do "Regioner.do"

tab region, gen(reg)
/*
tab year,gen(yar)
rename 	yar1	yar1970
rename 	yar2	yar1971
rename 	yar3	yar1972
rename 	yar4	yar1973
rename 	yar5	yar1974
rename 	yar6	yar1975
rename 	yar7	yar1976
rename 	yar8	yar1977
rename 	yar9	yar1978
rename 	yar10	yar1979
rename 	yar11	yar1980
rename 	yar12	yar1981
rename 	yar13	yar1982
rename 	yar14	yar1983
rename 	yar15	yar1984
rename 	yar16	yar1985
rename 	yar17	yar1986
rename 	yar18	yar1987
rename 	yar19	yar1988
rename 	yar20	yar1989
rename 	yar21	yar1990
rename 	yar22	yar1991
rename 	yar23	yar1992
rename 	yar24	yar1993
rename 	yar25	yar1994
rename 	yar26	yar1995
rename 	yar27	yar1996
rename 	yar28	yar1997
rename 	yar29	yar1998
rename 	yar30	yar1999
rename 	yar31	yar2000
rename 	yar32	yar2001
rename 	yar33	yar2002
rename 	yar34	yar2003
rename 	yar35	yar2004
rename 	yar36	yar2005
rename 	yar37	yar2006x
rename 	yar38	yar2007
rename 	yar39	yar2008
rename 	yar40	yar2009
rename 	yar41	yar2010
rename 	yar42	yar2011
rename 	yar43	yar2012
rename 	yar44	yar2013
rename 	yar45	yar2014
rename 	yar46	yar2015
rename 	yar47	yar2016
*/
tab state,gen(united)
drop if region ==.
gen ln_pop = ln(s_pop1)

gen s_pop3 = s_pop2 

gen s_pop = s_pop2



foreach var of varlist s_right* s_left* {
gen `var'_per = (`var'/s_pop3) * 100000 
gen ln_`var' = ln(`var'_per +1)

gen `var'_spend = (`var'/s_direct) * 100
gen ln_`var'_spend = ln(`var'_spend)
replace ln_`var'_spend = 0 if ln_`var'_spend ==.x
}

gen s_pps_lefthand1 = s_pps_welf1
gen s_pps_lefthand2 = s_pps_welf1 + s_pps_health
gen s_pps_righthand = s_pps_popo + s_pps_jail
gen s_sp_righthand = s_sp_popo + s_sp_jail






gen s_pcybm = 100*(s_ybm/s_pop1)
gen s_pcybf = 100*(s_ybf/s_pop1)

foreach var of varlist s_totgdp s_retwages s_manwages     {
replace `var' = 1000*(`var'/s_pop3)
}

gen s_retwag1 = 100*(s_retwag/s_totwag)
gen s_manwag1 = 100*(s_manwag/s_totwag)



foreach var of varlist s_males* s_females* s_humans* {
	gen s_pc_`var' = (`var'/s_pop2) *100
}

gen admin = 0
replace admin = 1 if ///
statename =="California" | ///
statename =="Colorado" | ///
statename =="Minnesota" | ///
statename =="New Jersey" | ///
statename =="New York" | ///
statename =="North Carolina" | ///
statename =="North Dakota" | ///
statename =="Ohio" | ///
statename =="Virginia" | ///
statename =="Wisconsin" 





 tab year,sum(s_pps_welf5)
tab year,sum(s_pps_righthand)


 
egen s_pclegdem = rowmean(s_pcsenatedem s_pchousedem)
gen s_pcleggop = 100-s_pclegdem
 





/*
foreach var of varlist pps_welf pps_health pps_popo pps_jail pps_righthand pps_lefthand pps_rightspend pps_leftspend1 {
tab year,sum(`var')
}

foreach var of varlist pps_leftspend1 pps_rightspend s_pcnhbl s_pcnhbl_sq s_pchisp s_pcpov s_pcfb s_unemp imprate1 cty_vcrime1 cty_pcrime1  s_totgdp1 manwages1 retwages1 rep_leg rep_gov citi6013 region ln_spend1 ln_pop  year {
drop if `var' ==.
}

*/

gen yaer = year-1972

gen yare2 = yaer^2



gen crimebill = year>1994
gen welfrfrm = year >1996
gen reforms = year >=1994

gen s_pcblack2 = s_pcblack^2
gen ln_pcblack = ln(s_pcblack)


 
 xtset state year
/*
foreach var of varlist ln_welf1 ln_righthand {
replace `var' = `var'[_n+1]
}
*/



gen styear = (state*100000)+year

alpha s_pcfb s_pchisp, s gen(s_hisimm)

  
egen s_pcblackstd = std(s_pcblack)
gen s_direct1 = 1000*(s_total/s_pop3)

gen s_left1pc = 1000*(s_left1/s_pop3)
gen s_right1pc = 1000*(s_right1/s_pop3)

foreach var of varlist  s_cash_assist_direct s_welf_cash_direct s_housing_direct ///
s_correct_direct s_police_direct {
	replace `var' = 1000*(`var'/s_pop3)
}



sort state year 

foreach var of varlist s_left1b s_left1 s_left1pc s_cash_assist_direct s_welf_cash_direct s_housing_direct ///
s_right1b s_right1 s_right1pc s_correct_direct s_police_direct s_direct1 {


bysort state: gen L`var' = f.`var'


replace `var' = L`var'
}

bysort state: gen s_blackchange = s_pcblack - l.s_pcblack

 replace s_avery1 = 0 if year<1996


capture log close


set more off

 gen year1 = year - 1976
 gen year2 = year1^2

 foreach var of varlist s_left1b s_right1b ///
s_pcblack s_blackchange  s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
  s_citi s_pcleggop  s_gopgov   s_gaprog  s_avery1  admin ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
  s_direct1   s_pop {

drop if `var' ==.
}



drop if s_left1b ==0
drop if s_right1b ==0

log using "State Descriptives 1976-2016.log", replace

 replace s_avery2 = 0 if year<1996
 gen year0 = year-1996

preserve


tab year,gen(yr) 




tab year,sum(s_left1pc) 
tab year,sum(s_left1b) 
tab year,sum(s_right1pc) 
tab year,sum(s_right1b) 
tab year,sum(s_direct1) 

tab statename

 

 sum ///
s_left1b s_left1pc s_cash_assist_direct s_welf_cash_direct s_housing_direct ///
s_right1b s_right1pc s_correct_direct s_police_direct /// 
 s_pcblack s_blackchange  s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
  s_citi s_pcleggop  s_gopgov   s_gaprog  s_avery1  admin ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
  s_direct1   s_pop if year <=2015
  
   sum ///
s_left1b s_left1pc s_cash_assist_direct s_welf_cash_direct s_housing_direct ///
s_right1b s_right1pc s_correct_direct s_police_direct /// 
 s_pcblack s_blackchange  s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
  s_citi s_pcleggop  s_gopgov   s_gaprog  s_avery1  admin ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
  s_direct1   s_pop if year <=1985
  
   sum ///
s_left1b s_left1pc s_cash_assist_direct s_welf_cash_direct s_housing_direct ///
s_right1b s_right1pc s_correct_direct s_police_direct /// 
 s_pcblack s_blackchange  s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
  s_citi s_pcleggop  s_gopgov   s_gaprog  s_avery1  admin ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
  s_direct1   s_pop if year >=1986 & year<= 1995
  
   sum ///
s_left1b s_left1pc s_cash_assist_direct s_welf_cash_direct s_housing_direct ///
s_right1b s_right1pc s_correct_direct s_police_direct /// 
 s_pcblack s_blackchange  s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
  s_citi s_pcleggop  s_gopgov   s_gaprog  s_avery1  admin ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
  s_direct1   s_pop if year >=1996 & year<= 2005
  
   sum ///
s_left1b s_left1pc s_cash_assist_direct s_welf_cash_direct s_housing_direct ///
s_right1b s_right1pc s_correct_direct s_police_direct /// 
 s_pcblack s_blackchange  s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
  s_citi s_pcleggop  s_gopgov   s_gaprog  s_avery1  admin ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
  s_direct1   s_pop if year >=2006 & year<= 2015


restore









replace s_pop = ln(s_pop)


foreach var of varlist s_vcrate  s_pcrate {
replace `var' = ln(`var' +1)
}


foreach var of varlist s_totgdp s_retwages s_manwages     {
replace `var' = ln(`var')
}

set more off
capture log close

replace s_direct1 = ln(s_direct1)
log using "State Results 1976-2016.log", replace
*keep if admin ==0


preserve

foreach var of varlist ///
s_pcblack s_pcblack2 ///
 s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh  ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog     ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
    s_direct1  s_pop {
bysort state: egen C_`var' = mean(`var')
*replace `var' = `var'- C_`var'
}




tab year,gen(yr) 





foreach var of varlist s_left1b s_right1b ///
 s_pcblack s_blackchange  s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
  s_citi s_pcleggop  s_gopgov   s_gaprog  s_avery1  admin ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
  s_direct1   s_pop {

drop if `var' ==.


  }
 


*Full Model

  
  
reg s_left1b ///
 year1 year2  s_pcblack s_pcblack2 ///
 s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh  ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog   admin  ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
    s_direct1  s_pop  i.state 
  
*vif

estimates store e1


 reg  s_right1b   ///
 year1 year2  s_pcblack s_pcblack2 ///
 s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh  ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog   admin  ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
    s_direct1  s_pop  i.state 
  
*vif

  
  
estimates store e2


suest e1 e2,vce(r)


foreach var of varlist  ///
 year1  s_pcblack    s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh  ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog  admin  ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
    s_direct1   s_pop {
		sum `var'
test [e1_mean]`var'=[e2_mean]`var'
	}



  
  
*vif

  
  
reg s_left1b ///
 c.year1##(c.s_pcblack c.s_pcblack2)  c.year2##(c.s_pcblack c.s_pcblack2)   ///
 s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog  admin  ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
    s_direct1  s_pop  i.state 
  


estimates store e1


reg s_right1b  ///
 c.year1##(c.s_pcblack c.s_pcblack2)  c.year2##(c.s_pcblack c.s_pcblack2)   ///
 s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog   admin  ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
    s_direct1  s_pop  i.state 
  
*vif

  
  
estimates store e2


suest e1 e2,vce(r)

margins, predict(outcome(e1_mean)) at(year1==0 year2==0   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==10 year2==100   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==20 year2==400   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==30 year2==900   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   s_pcblack==30 s_pcblack2==900  )  atmeans asbal

margins, predict(outcome(e2_mean)) at(year1==0 year2==0   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==10 year2==100   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==20 year2==400   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==30 year2==900   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   s_pcblack==30 s_pcblack2==900  )  atmeans asbal
capture log close

/*
 
margins, predict(outcome(e1_mean)) at(year1==0   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==10   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10    s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==20   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==30   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==39   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==0   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==10   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10    s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==20   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==30   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==39   s_pcblack==0 s_pcblack2==0 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   s_pcblack==5 s_pcblack2==25 )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   s_pcblack==10 s_pcblack2==100  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   s_pcblack==15 s_pcblack2==225  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   s_pcblack==20 s_pcblack2==400  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   s_pcblack==25 s_pcblack2==625  )  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   s_pcblack==30 s_pcblack2==900  )  atmeans asbal 

/*






restore

 
*/





/*
reg s_left1b ///
 c.year1##c.s_blackchange s_pcblack c.    s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh  ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog admin  ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
    s_direct1   s_pop  i.state 
  


estimates store e1


reg s_right1b  ///
 c.year1##c.s_blackchange s_pcblack c.  s_pchisp  s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh  ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog admin  ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
    s_direct1   s_pop  i.state 
  


reg s_left1b ///
 c.year1##c.s_pchisp s_blackchange s_pcblack     s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh  ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog admin  ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
    s_direct1   s_pop  i.state 
  


estimates store e1


reg s_right1b  ///
 c.year1##c.s_pchisp s_blackchange s_pcblack     s_pcfb ///
    s_pcpov   s_pcurb s_pcfemhh  ///
   s_pc0024 s_pc65o ///
 s_pcunemp  s_retwages s_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog admin  ///
s_pcwelf s_imp ///
 s_vcrate  s_pcrate ///
    s_direct1   s_pop  i.state 
  





