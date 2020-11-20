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

Of course, such predictions did come with some uncertainty. For instance, the predictive interval for Trump's national projected popular vote share was between 37.86% and 54.57%; the predictive interval for Biden's national projected popular vote share was between 43.39% and 57.15%. Moreover, I anticipated further uncertainty on the state-level, given variation between different states on their polls' frequency and quality. 
(could include something about bias here, or maybe remove this section entirely).

should I justify application to state? probs not, will roast it and mention it later on in hypothesis 1 (in my predictions, I assumed model could be applied to each state.....but did not account for bias...)

**Evaluating The Average Suppot Model's Accuracy**

Overall, my model was quite accurate on the national level, with my model's predictions for Trump and Biden's two-party popular vote shares (47.9% and 52.1%, respectively) being extremely close to Trump and Biden's actual two-party popular vote shares (48% and 52%, respectively). My model also performed relatively well on the state level, although not to the same degree as my national level predictions. For instance, my model's predicted electoral vote tally for each candidate (219 and 319 for Trump and Biden, respectively) was not far off from the actual electoral vote tally for Trump and Biden (232 and 306, respectively). My model's incorrect prediction of a Trump win in Georgia, and a Biden win in Florida accounts for such deviation in electoral vote tally's. The graphs below summarize the distribution of the state-level two-party popular vote share errors for both candidates. 

Trump's State-Level Two-Party Popular Vote Error   |  Biden's State-Level Two-Party Popular Vote Error
:-------------------------:|:-------------------------:
![](Reflection4.png)|![](Reflection5.png)

These graphs illustrate that my average support model underestimated Trump's two-party popular vote share and overestimated Biden's two-party popular vote share in the majority of states. This led my model's state-level predictions to be associated with an RMSE value of 5.64. Of course, my model's prediction error varied between each state. The map below illustrates the absolute error margin of my model's predictions for Trump in each state:

| Abolsute Error Margin Map for the Average Support Model |
|:-:|
|![](Reflection1.png)|

This map demonstrates that the absolute error associated with my model's predictions varied significantly between different states, i.e., my model had a high prediction error margin in states like West Virginia and Wyoming but a low prediction error margin in states like Nevada and Arizona. Geographically, each region of the United States has some states with high prediction error margins, although there seems to be a consolidation of such states in the midwest. However, this could merely be a product of the midwest containing a high number of blowout states in the 2020 election, which my model seemed to perform the worst in. 

Trump's State-Level Two-Party Popular Vote Error   |  Biden's State-Level Two-Party Popular Vote Error
:-------------------------:|:-------------------------:
![](Reflection2.png)|![](Reflection3.png)

The graphs above display the ten states associated with the highest prediction error and actual win margin. Such gives credence to the notion that my model's prediction error was more prevalent in "blowout" states, given seven out of the ten states with the highest actual win margin were also the states with the highest prediction errors. In fact, the RMSE of the ten states with the highest actual win margin was 10.07; this is substantially higher than the RMSE across all the states (5.64). 

Overall, my model is relatively accurate. My model was most accurate in its national two-party popular vote predictions and less so in its state-by-state predictions, where prediction error varied between states; this variation was most pronounced when considering the high error associated with my mode's predictions for blowout states. 
(do I need this section? - probs not, already long enough, consider deleting)

**Hypotheses for the Average Support Model's Inaccuracies**

Although there might be several reasons why my model was inaccurate in certain states, I will mainly consider two hypotheses: my model's lack of accounting for specific state biases and the variation in poll quality between different states. Given such hypotheses, I will also propose quantitative tests that could evaluate the validity of each hypothesis. 

**Hypothesis #1**
My first hypothesis is that my model was inaccurate in individual states, given it did not account for their state-specific biases. As mentioned, I constructed the average support model based on a regression of historical popular vote and average poll support data on the national level. Thus, my model's application onto each state implicitly assumes the relationship between a candidate's popular vote and average support is the same on the state-level as the national level; however, this might not be the case. For instance, polls in a deeply red state, like Wyoming, could have historically underestimated the Republican candidate's actual vote share in presidential elections. Given my model does not factor such bias in, its predictions would then understate Trump's vote share in the region and lead to the error I observed in such a state. This type of state bias has some basis, given, as Nate Silver points out, that it is not uncommon for polls in historically blue or historically red states to underestimate the winning candidate's margin (https://fivethirtyeight.com/features/what-state-polls-can-tell-us-about-the-national-race/). Thus, it's clear to see how my first hypothesis could explain why my model was inaccurate in some states, particularly the blowout states I noted above. 

My proposed quantitative test for such hypothesis would be to run a regression between historical average support data and popular vote data for each of the states my model predicted fairly inaccurately. In a perfect world, such historical data for each of the states would be available, spanning many election cycles. If these state-specific regressions resulted in models with significantly different relationships between a candidate’s average support and popular vote share than my original model, such would be evidence for my first hypothesis. 





















