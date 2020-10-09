# Polls and Probabilistic Models
## Oct 9, 2020

Throughout previous blogs, I have relied on linear regression models to derive election results. Although such has helped me analyze the relationships between variables like average poll support and popular vote shares, the outcome of a linear regression model can be any value in a continuous range; thus, some predictions (i.e., popular vote share) could be outside the 0-100% range. This clearly reduces the practicality of some of the linear regression results. Therefore this week, I will explore 2020 predictions through probabilistic models, like a binomial logistic regression, limiting election outcomes to a finite draw of voters from a given population (i.e., the voting-eligible population). I will base such probabilistic models on the average poll support for each of the major party candidates in 2020, first considering the entire country and then focusing on the key battleground states in the 2020 election. 

**The 2020 Map**

|Incumbency Status vs. Two-Party Popular Vote Share (1948-2016) |
|:-:|
|![](Prob1.png)|

This map demonstrates the 2020 win margins for the Democratic candidate, Joe Biden, relative to the Republican candidate Donald Trump. The win margin is derived from the predicted distribution of draws (10,000 draws) from the population (i.e the voting-eligible population) in each state, with the draw probability for Biden and Trump based on their average support. The main takeaways are:

* **Biden is favored.** From the data available, the probabilistic map of win margins demonstrates that Biden is favored relative to Trump in terms of attaining a greater vote share in 2020. This is evident given the magnitude of Biden's win margins and the states in which Biden's win margins are positive relative to Trump. This takeaway falls in line with models from previous weeks, which demonstrated Biden would have a greater vote share than Trump based on Biden's greater average poll support.

* **Limited data.** As one can see from the map, there are states with missing win margins. This is due to the limited or missing data available for some states, which hinders one's ability to draw more substantive takeaways from the United States' win margins map. Given these limitations, it is necessary to conduct further analysis using probabilistic models; however, focusing only on the key battleground states of the 2020 election.

**Swing States 2020**

Given an analysis of the win margins for every state does not give that insightful of answers, given missing data and limited data, an analysis focusing on each swing state will likely yeild more substantitve takewaways. By focusing on these individual states, we can reduce the impact of missing data when drawing conclusions and is more pertinant, given these battleground states are pivotal in deciding the election. 
In this section, I will consider the win margins for 5 key states, based on the NYT, and what this means, based on the polls in these states 27 days from the election

GDP Quarterly Growth and GDP Yearly Growth  |  RDI Growth and Unemployment
:-------------------------:|:-------------------------:
![](Prob2.png)|![](Prob3.png)

GDP Quarterly Growth and GDP Yearly Growth  |  RDI Growth and Unemployment
:-------------------------:|:-------------------------:
![](Prob4.png)|![](Prob5.png)

|Incumbency Status vs. Two-Party Popular Vote Share (1948-2016) |
|:-:|
|![](Prob6.png)|

The breakdown for the above battleground state win margins are as follows:

* **Florida.**  The win margin for florida is X. This is based on the polls in such state, which currently stand at X for Biden and Y for Trump. This would mean Biden would carry all the electoral votes from this state. 

* **Ohio.**  The win margin for ohio is X. This is based on the polls in such state, which currently stand at X for Biden and Y for Trump. This would mean Biden would carry all the electoral votes from this state. 

This tells us that, in the most important states, Biden has the clear advantage. Basesd on our probabalistc models, Biden stands a good chance of carriyng X of the Y total electoral votes. This is significnat, as a decisisve win in the swing states gives Biden a significantly higher chance of winning the eleciton. This is in stark contrast to 2016, which, as blog 1 demonstrated, had trump dispoportionalty take the electoral votes in the swing states, and led him to victory. 

**Final Takeaways**

In this blog, we used probabalistic models to evaaltue the electoral prospects for the 2020 candidates. An analysis of the swing states affirms earlier blog's favoring biden using linear regression models, as biden seems like he will take the swing states, and thus stands a pole positon for the elections. OF course, polls are not the only metric for evalauting candidate, but based on my findings in previous blogs, stands as a good indicator for the upcoming election. 







