# Polls in Popular Vote Predictions
## Sept 24, 2020

Polls have become a mainstay in the modern-day election. From the moment the primaries start to the moment elections end, the media coverage of a candidates' approval rating is non-stop. While such can be largely attributed to horse-race journalism, the emphasis on polls during the campaign season does beg the question as to how predictive polls are in presidential elections. We will consider this question first by analyzing the historical relationship between a candidate's average support in the polls and their subsequent popular vote share. Then, we will consider the variation in the pollster quality in recent elections and construct a predictive model based on weighing these differences in poll quality. Finally, we will compare such model to previous and unweighted average support models, and use the model with the least error relative to the 2016 results to predict the 2020 election.

**The Relationship between a Candidate's Average Poll Support and Popular Vote Share** 

Average Poll Support vs. Incumbent Popular Vote Share (1968-2016) |  Average Poll Support vs. Challenger Popular Vote Share (1968-2016)
:-------------------------:|:-------------------------:
![](Polls1.png)|![](Polls2.png)

To understand how polls can predict election results, it is necessary to first understand the relationship between a candidate's average poll support and their popular vote share. The graphics above display historical trends for such, using aggregated measures of poll support for an incumbent or non-incumbent candidate six weeks before an election and said candidates' popular vote shares from 1968 to 2016. Some of the major takeaways include:

* **A strong relationship.** The graphs indicate that a candidate's average support in the polls has historically been highly related to their respective popular vote shares. This is evident based on the generally linear and relativley narrow spread of the data points for both the incumbent and challenger graphs. 

* **Higher incumbent accuracy.** While both graphs present strong and linear relationships for the variables in question, it is also clear that the relationship between a candidate's average support and their popular vote share is stronger for incumbent candidates than non-incumbent candidates. Such can be seen by the data points in the incumbent graph falling closer to a one-for-one diagonal line between the x-axis and y-axis than the non-incumbent graph. While there might be multiple reasons for this discrepancy, I will note incumbents are generally favored in elections.  Thus, there are fewer instances, and therefore less data, for challengers with average support in the polls greater than 50 percent.


**The Variation in Pollster Quality** 

2016 Polls  |  2020 Polls
:-------------------------:|:-------------------------:
![](Polls3.png)|![](Poll4.png)

When considering the relationship between the polls and a candidate's popular vote share, one must also be cognizant of the differences in quality between different polls. The graphs above demonstrate the variation in quality for national polls for the elections of 2016 and 2020, graded by FiveThirtyEight based on said poll's historical accuracy and methadology. 

**Uneven distributin.** What is clear is that there is no symetry when it comes to distribution of quality. In 2016, there is a spike in polls with quality x, while in 2020 there is a spike in polls of quality y. Generally, there are more polls of B or higher than lower, but such is also segemented within its self (i.e A, A plus, A minus). One of the most suprsing things to me was the amount of bad polls, like many polls in C range, or lower. 
use this to justify weighting for poll quality.

**Constructing a Prediction Model** 





