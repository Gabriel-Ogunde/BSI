
************==DATA: DHS, 2018 BIRTH RECODE==*************

use "C:\Users\USER\Desktop\NDHS DATA 2018\NG_2018_DHS_02172020_1656_137126\NGBR7ADT\NGBR7AFL.DTA"

numlabel, add
set more off

*******Derivation and recoding of variables*******
gen weight=v005/1000000
recode v212 (min/17 = 1 "<18") (18/max=2 ">=18"), gen(age_at_first_birth) 
recode v149 (0=0 "No education") (1/2=1 "Primary education") (3/4=2 "Secondary education") (5=3 "Tertiary education"), gen(education)
recode v501 (0=0 "Never in union") (1=1 "Married") (2=2 "Living with partner") (3/5=3 "Widowed/Divorced/Separated"), gen(marital_status) 
recode v130 (1 2 = 1 "Christian") (3=2 "Islam") (4 96=3 "Others"), gen(religion) 
recode v131 (2=1 "Fulani") (3=2 "Hausa") (6=3 "Igbo") (8=4 "Kanuri/beriberi") (10=5 "Yoruba") (1 4 5 7 9 96 98=6 "Others"), gen(ethnicity) 
recode v201 (1/5=1 "<=5") (6/max=2 ">5"), gen(parity) 
recode v218 (0/3=1 "<4 children") (4/7=2 "4-7 children") (8/max=3 ">7 children"), gen(no_living_children)
recode v364 (1 2 =1 "Yes") (3 4=2 "No"), gen(contraceptive_use) 
recode v602 (2=1 "Undecided") (1=2 "Have another") (3=3 "No more") (4 5=4 "Others"), gen(fert_pref) 
recode v613 (0/2=1 "0-2 children") (3/5=2 "3-5 children") (6/max=3 "6+ children"), gen(ideal_no_children) 
recode v604 (0=0 "<12 months") (1=1 "1 year") (2=2 "2 years") (3=3 "3 years") (4/6=4 "4+ years") (7 8=5 "Others"), gen(BSI)
gen child_dead = v206+v207
recode child_dead (0=0 "No") (1/max=1 "Yes"), gen(child_mortality)
recode BSI (0/1=1 "Short BSI") (2/3=2 "Optimal BSI") (4=3 "Long BSI") (5=.), gen(BSI_R)
recode v511 (min/17=1 "<18 years") (18/max=2 ">=18 years"), gen(age_first_cohabitation)
gen fp_message=0
replace fp_message=1 if v384a==1 | v384b==1 | v384c==1 | v384d==1


******TABLE 1: Distribution of socio-demographic and fertility characteristics***********
summarize v012 //mean age and standard deviation of respondent
tab v013 [iw=weight] //group age of respondent
summarize v212 //mean age of respondent at first birth 
tab age_at_first_birth [iw=weight]
tab education [iw=weight]
tab marital_status [iw=weight]
tab religion [iw=weight]
tab v102 [iw=weight] //domicile of respondent
tab ethnicity [iw=weight]
tab v716 [iw=weight] //occupation of respondent
summarize v201 //mean parity
tab parity [iw=weight] 
tab no_living_children [iw=weight]
tab contraceptive_use [iw=weight] 
tab child_mortality [iw=weight]
tab fert_pref [iw=weight]
tab ideal_no_children [iw=weight] 
tab m10 [iw=weight] //wanted last pregnancy
tab v190 [iw=weight] //Wealth Index of respondent
tab BSI [iw=weight]

*******North East*******
******Model I (Second model) *********
gsem (ib2.bsi_r <- i.age_grp i.age_first_cohabitation i.age_at_first_birth i.marital_status i.religion i.ethnicity i.education i.child_mortality i.occupation i.v714 i.v102 i.v190) if v024==2, mlogit
estat eform

*****Model II (Third model)****
gsem (ib2.bsi_r <- i.parity i.fp_message i.v632 i.ideal_no_children i.sexual_actv i.v624) if v024==2, mlogit
estat eform

****** Model III (Fourth model)*****
gsem (ib2.bsi_r <- i.age_grp i.v102 i.v190 i.fp_message i.ideal_no_children i.sexual_actv) if v024==2, mlogit
estat eform