# Post-Election Reflection 
## November 17, 2020

Intro lines before this. 
In this blog, I will seek to provide a comprehensive reflection on my final prediction model. I will do this by first recapping such model and its main predictions. Then, I will touch on its inaccuracies, specifically highlighting the trends I found in such. Given such inaccuracies, I will propose two main hypotheses for why the model was inaccurate at times and propose quantitative tests that could test the validity of these hypotheses. Ultimatley, I will end by touching on how I might change my model if I were to do it again. 

**The Average Suppot Model and its Predictions**

My model, the average support model, consists of a linear regression between the popular vote share and average support for Democratic or Republican presidential candidates. The regression for the Democratic and Republican candidate average support models is based on national popular vote and average poll support data for presidential election candidates from 1968 to 2016. The formulas for each party's average support model are listed below:

* Democrat average support model: predicted popular vote share = 23.4186 + 0.5286 (average support)

* Republican average support model: predicted popular vote share = 12.5561 + 0.7829 (average support)

I used such models the derive the national and state-level two-party popular vote shares for each two-party candidate in the 2020 election, based on national and state-level average support data from the 2020 election cycle, respectively. Ultimatley, my average support models predicted that Trump would receive 47.9% of the two-party popular vote share, and Biden would receive 52.1%. Moreover, I predicted that Trump would attain 219 electoral votes, and Biden would attain 319 electoral votes. Below is the list of the states my models predicted that each candidate would win (and receive their electoral votes from):

Democrat states: DC, MA, RI, NY, VT, HI, MD, CA, CT, DE, WA, NJ, OR, IL, NM, VA, CO, ME, NH, MI, MN, PA, WI, NV, FL, AZ

Republican states: NC, IA, OH, GA, TX, AK, SC, IN, MT, MO, NE, KS, UT, SD, KY, TN, LA, AL, ND, WV, MS, ID, OK, AR, WY

Of course, such predictions did come with some uncertainty. For instance, the predictive interval for Trump's projected popular vote share was between 37.86% and 54.57%; the predictive interval for Biden's projected popular vote share fell between 43.39% and 57.15%. Moreover, I anticipated further uncertainty on the state-level, given variation between different states on their polls' frequency and quality. 
(could include something about bias here, or maybe remove this section entirely).


should I justify application to state? probs not, will roast it and mention it later on in hypothesis 1 (in my predictions, I assumed model could be applied to each state.....but did not account for bias...)


**Evaluating The Average Suppot Model's Accuracy**

Given the uncertainity in my model, I expected there to be some error. At a high level, my model performed relativley well for predicting the national election results, with the actual pv2p for Trump and Biden at X and Y being very close to the X and Y from my predictions. At a high level, my model also did not perform poorly when predicting the total electoral vote tally's for each candidate, with the values, X and Y, also very close to my predictions, X and Y. The graphs below summarize the distribution of state level pv2p errors (predicted - actual) for each candidate

Graph 1 and 2 (histograms)

Such indicate my model underestimated Trump and overestimated Biden across most of the states. This led to the RMSE for my state-by-state error to be X. As for which states my model was associated with particularly high error, look at the map below:

Map 

This map demonstrates that my model performed worse in some states, like X and Y, than others, like X and Y. Geographically, the spread of my state errors does seem to be varied, although there does seem to be a consolidation of errors in the midwest region. However, this could be a product of such states being blowout states as well, given that other areas, like DC or VT, don't fit this midwest pattern, while other midwest states, like X and Y, don't fit this either. 
Interestingly, the states my model performed the worst in did not seem to be the states I called wrong, like FL or Georgia, but rather the blow out states. 










