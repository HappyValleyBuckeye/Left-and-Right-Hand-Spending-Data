set more off
capture log close
clear
clear mata
clear matrix
set matsize 800


cd "/Users/LappyToppy/OneDrive - The Pennsylvania State University/Let Them Eat War/Final Data Sets"

use "Places2.dta",clear
drop if year >2016
drop if state>56
drop if p_right2 ==.


drop if state ==9|state ==44|state ==31

*merge 1:1 state place year using "Place Time.dta",gen(ptmerge)

*do "Regioner.do"

*tab year,gen(yar)
 *rename 	yar1	yar1970
 *rename 	yar2	yar1971
 *rename 	yar3	yar1972
 *rename 	yar4	yar1973
 *rename 	yar5	yar1974
 *rename 	yar6	yar1975
 *rename 	yar7	yar1976
 *rename 	yar8	yar1977
 *rename 	yar9	yar1978
 *rename 	yar10	yar1979
 *rename 	yar11	yar1980
 *rename 	yar12	yar1981
 *rename 	yar13	yar1982
 *rename 	yar14	yar1983
 *rename 	yar15	yar1984
 *rename 	yar16	yar1985
 *rename 	yar17	yar1986
 *rename 	yar18	yar1987
 *rename 	yar19	yar1988
 *rename 	yar20	yar1989
 *rename 	yar21	yar1990
 *rename 	yar22	yar1991
 *rename 	yar23	yar1992
 *rename 	yar24	yar1993
 *rename 	yar25	yar1994
 *rename 	yar26	yar1995
 *rename 	yar27	yar1996
 *rename 	yar28	yar1997
 *rename 	yar29	yar1998
 *rename 	yar30	yar1999
 *rename 	yar31	yar2000
 *rename 	yar32	yar2001
 *rename 	yar33	yar2002
 *rename 	yar34	yar2003
 *rename 	yar35	yar2004
 *rename 	yar36	yar2005
 *rename 	yar37	yar2006
 *rename 	yar38	yar2007
 *rename 	yar39	yar2008
 *rename 	yar40	yar2009
 *rename 	yar41	yar2010
 *rename 	yar42	yar2011
 *rename 	yar43	yar2012
 *rename 	yar44	yar2013
 *rename 	yar45	yar2014
 *rename 	yar46	yar2015
 *rename 	yar47	yar2016

 




gen p_pop3 = p_pop1/100000
gen s_pop = s_pop1 
gen p_pop = p_pop1 


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




foreach var of varlist ///
p_pcblack  p_pchisp p_pcforbor ///
 p_pcpov  p_pcurb  p_pcfemhh ///
   p_pc0024 p_pc65o ///
c_pcunemp  {
by state county place, sort: ipolate `var' year ,gen(i`var') epolate
replace `var' = i`var' if `var' ==.
replace `var' = 0 if `var'<=0
replace `var' = 100 if `var'>=100 & `var' <.



}

gen  p_pcblack2 = p_pcblack^2

 
foreach var of varlist s_totgdp s_retwages s_manwages      {
replace `var' = 1000*(`var'/s_pop1)
}

 

 



 
 
 egen stcou = group(state county)
 egen stplace = group(state county place)
 
 drop if stplace ==.

 xtset stplace year
 
 set more off
 
egen s_pclegdem = rowmean(s_pcsenatedem s_pchousedem)
gen s_pcleggop = 100-s_pclegdem

alpha p_pcforbor p_pchisp, s gen(p_hisimm)

egen p_pcblackstd = std(p_pcblack)


gen s_direct1 = 1000*(s_direct/s_pop)
gen c_direct1 = 1000*(c_direct/c_pop)
gen p_direct1 = (p_total/p_pop)

gen p_left1pc = 1000*(p_left1/c_pop)
gen p_right1pc = 1000*(p_right1/c_pop)


 
foreach var of varlist  c_retwages c_manwages     {
replace `var' = 1000*(`var'/c_pop)
}
 

foreach var of varlist p_cash_assist_direct p_welf_cash_direct p_housing_direct ///
p_correct_direct p_police_direct {
	replace `var' = 1000*(`var'/p_pop)
}

sort stplace year

foreach var of varlist  p_left1b p_left1pc p_cash_assist_direct p_welf_cash_direct p_housing_direct ///
p_right1b p_right1pc p_correct_direct p_police_direct p_direct1 {


bysort stplace: gen L`var' = f.`var'


replace `var' = L`var'
}

 
 
bysort stplace: gen p_blackchange = p_pcblack - l.p_pcblack



 gen year1 = year - 1976
 gen year2 = year1^2
 
 replace s_avery1 = 0 if year<1996
 
  
foreach var of varlist p_left1b p_right1b ///
p_pcblack p_blackchange p_pchisp p_pcforbor ///
 p_pcfemhh p_pcpov  p_pcurb ///
   p_pc0024 p_pc65o ///
 p_pcunemp c_retwages c_manwages ///
    s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
p_vcrate p_pcrate ///
 p_direct1  p_pop3  {  

drop if `var' ==.
}


drop if p_left1b ==0
drop if p_right1b ==0

log using "Place Descriptives 1976-2016.log", replace
preserve



tab year,sum(p_left1pc) 
tab year,sum(p_left1b) 
tab year,sum(p_right1pc) 
tab year,sum(p_right1b) 
tab year,sum(p_direct1) 

tab year

 sum ///
p_left1b p_left1pc p_cash_assist_direct p_welf_cash_direct p_housing_direct ///
p_right1b p_right1pc p_correct_direct p_police_direct /// 
p_pcblack   p_pchisp p_pcforbor ///
 p_pcfemhh p_pcpov  p_pcurb ///
   p_pc0024 p_pc65o ///
 p_pcunemp c_retwages c_manwages ///
    s_citi s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
p_vcrate p_pcrate ///
 p_direct1  p_pop3  if year<=2015

 sum ///
p_left1b p_left1pc p_cash_assist_direct p_welf_cash_direct p_housing_direct ///
p_right1b p_right1pc p_correct_direct p_police_direct ///  
p_pcblack   p_pchisp p_pcforbor ///
 p_pcfemhh p_pcpov  p_pcurb ///
   p_pc0024 p_pc65o ///
 p_pcunemp c_retwages c_manwages ///
    s_citi s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
p_vcrate p_pcrate ///
 p_direct1  p_pop3 if year <=1985

  sum ///
p_left1b p_left1pc p_cash_assist_direct p_welf_cash_direct p_housing_direct ///
p_right1b p_right1pc p_correct_direct p_police_direct /// 
p_pcblack   p_pchisp p_pcforbor ///
 p_pcfemhh p_pcpov  p_pcurb ///
   p_pc0024 p_pc65o ///
 p_pcunemp c_retwages c_manwages ///
    s_citi s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
p_vcrate p_pcrate ///
 p_direct1  p_pop3  if year >=1986 & year<= 1995

 sum ///
p_left1b p_left1pc p_cash_assist_direct p_welf_cash_direct p_housing_direct ///
p_right1b p_right1pc p_correct_direct p_police_direct /// 
p_pcblack   p_pchisp p_pcforbor ///
 p_pcfemhh p_pcpov  p_pcurb ///
   p_pc0024 p_pc65o ///
 p_pcunemp c_retwages c_manwages ///
    s_citi s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
p_vcrate p_pcrate ///
 p_direct1  p_pop3 if year >=1996 & year<= 2005
 
 
 sum ///
p_left1b p_left1pc p_cash_assist_direct p_welf_cash_direct p_housing_direct ///
p_right1b p_right1pc p_correct_direct p_police_direct /// 
p_pcblack   p_pchisp p_pcforbor ///
 p_pcfemhh p_pcpov  p_pcurb ///
   p_pc0024 p_pc65o ///
 p_pcunemp c_retwages c_manwages ///
    s_citi s_pcleggop  s_gopgov   s_gaprog s_avery1 admin  ///
s_pcwelf s_imp ///
p_vcrate p_pcrate ///
 p_direct1  p_pop3   if year >=2006 & year<= 2015
 



restore

capture log close

replace p_direct1 = ln(p_direct1)


foreach var of varlist p_vcrate  p_pcrate {
	replace `var' = ln(`var' +1)
}

foreach var of varlist  c_retwages c_manwages     {
replace `var' = ln(`var'+1)
}
  
  
log using "Place Results 1976-2016.log", replace
	 

replace p_pop3 = ln(p_pop)
 



tab state,gen(st)
set more off




sort stplace year









set more off


preserve

foreach var of varlist ///
 p_blackchange p_pchisp p_pcforbor ///
 p_pcfemhh p_pcpov  p_pcurb ///
   p_pc0024 p_pc65o ///
 p_pcunemp c_retwages c_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog      ///
s_pcwelf s_imp ///
p_vcrate p_pcrate ///
 p_direct1  p_pop3  {
bysort stplace: egen C_`var' = mean(`var')
*replace `var' = `var'- C_`var'
}






*Full Model


 

reg p_left1b ///
year1 year2  p_pcblack p_pcblack2  ///
 p_pchisp p_pcforbor ///
 p_pcpov  p_pcurb  p_pcfemhh ///
   p_pc0024 p_pc65o ///
p_pcunemp c_retwages c_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog   admin  ///
s_pcwelf s_imp ///
p_vcrate p_pcrate ///
 p_direct1  p_pop3    i.stplace   

 

*vif
 
 estimates store e1

 
reg p_right1b  ///
year1 year2  p_pcblack p_pcblack2  ///
 p_pchisp p_pcforbor ///
 p_pcpov  p_pcurb  p_pcfemhh ///
   p_pc0024 p_pc65o ///
p_pcunemp c_retwages c_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog   admin  ///
s_pcwelf s_imp ///
p_vcrate p_pcrate ///
 p_direct1  p_pop3    i.stplace  

 
*vif

   
estimates store e2


suest e1 e2,vce(r)



 
 foreach var of varlist year1 ///
year1   p_pcblack p_pcblack2  ///
 p_pchisp p_pcforbor ///
 p_pcfemhh p_pcpov  p_pcurb ///
   p_pc0024 p_pc65o ///
 p_pcunemp c_retwages c_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog   admin  ///
s_pcwelf s_imp ///
p_vcrate p_pcrate ///
 p_direct1  p_pop {
		sum `var'
test [e1_mean]`var'=[e2_mean]`var'
	}
	

	
 
reg p_left1b ///
c.year1##(c.p_pcblack c.p_pcblack2) c.year2##(c.p_pcblack c.p_pcblack2)  ///
 p_pchisp p_pcforbor ///
 p_pcpov  p_pcurb  p_pcfemhh ///
   p_pc0024 p_pc65o ///
p_pcunemp c_retwages c_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog   admin  ///
s_pcwelf s_imp ///
p_vcrate p_pcrate ///
 p_direct1  p_pop3    i.stplace  
 

*vif
 
 estimates store e1

 
reg p_right1b  ///
c.year1##(c.p_pcblack c.p_pcblack2) c.year2##(c.p_pcblack c.p_pcblack2)  ///
 p_pchisp p_pcforbor ///
 p_pcpov  p_pcurb  p_pcfemhh ///
   p_pc0024 p_pc65o ///
p_pcunemp c_retwages c_manwages ///
   s_citi s_pcleggop  s_gopgov   s_gaprog   admin  ///
s_pcwelf s_imp ///
p_vcrate p_pcrate ///
 p_direct1  p_pop3    i.stplace 
 

 
 estimates store e2


suest e1 e2,vce(r)


margins, predict(outcome(e1_mean)) at(year1==0 year2==0   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0 year2==0   p_pcblack==45 p_pcblack2==2025 )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==10 year2==100   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10 year2==100   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==20 year2==400   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400  p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20 year2==400  p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==30 year2==900   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30 year2==900   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   p_pcblack==0 p_pcblack2==0)  atmeans asbal  
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39 year2==1521   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==0 year2==0   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0 year2==0     p_pcblack==45 p_pcblack2==2025 )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==10 year2==100   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10 year2==100   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==20 year2==400   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20 year2==400   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==30 year2==900   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30 year2==900   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39 year2==1521   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

/*

margins, predict(outcome(e1_mean)) at(year1==0   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==0   p_pcblack==45 p_pcblack2==2025 )  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==10   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==10   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==20   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20  p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==20  p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==30   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==30   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e1_mean)) at(year1==39   p_pcblack==0 p_pcblack2==0)  atmeans asbal  
margins, predict(outcome(e1_mean)) at(year1==39   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e1_mean)) at(year1==39   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==0   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==0     p_pcblack==45 p_pcblack2==2025 )  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==10   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==10   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==20   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==20   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==30   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==30   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 

margins, predict(outcome(e2_mean)) at(year1==39   p_pcblack==0 p_pcblack2==0)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   p_pcblack==7.5 p_pcblack2==56.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   p_pcblack==15 p_pcblack2==225)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   p_pcblack==22.5 p_pcblack2==506.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   p_pcblack==30 p_pcblack2==900)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   p_pcblack==37.5 p_pcblack2==1406.25)  atmeans asbal 
margins, predict(outcome(e2_mean)) at(year1==39   p_pcblack==45 p_pcblack2==2025)  atmeans asbal 


restore

*/


capture log close
