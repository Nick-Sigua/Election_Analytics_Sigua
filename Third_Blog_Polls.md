# Polls in Popular Vote Predictions
## Sept 24, 2020

Polls have become a mainstay in the modern-day election. From the moment the primaries start to the moment elections end, the media coverage of a candidates' approval rating is non-stop. While such can be largely attributed to horse-race journalism, the emphasis on polls during the campaign season does beg the question as to how predictive polls are in presidential elections. We will consider this question first by analyzing the historical relationship between a candidate's average support in the polls and their subsequent popular vote share. Then, we will consider the variation in the pollster quality in recent elections and construct a predictive model based on weighing these differences in poll quality. Finally, we will compare such model to previous and unweighted average support models, and use the model with the least error relative to the 2016 results to predict the 2020 election.

**The Relationship between a Candidate's Average Poll Support and Popular Vote Share** 

Average Poll Support vs. Incumbent Popular Vote Share (1968-2016) |  Average Poll Support vs. Challenger Popular Vote Share (1968-2016)
:-------------------------:|:-------------------------:
![](Polls1.png)|![](Polls2.png)

To understand how polls can predict election results, it is necessary to first understand the relationship between a candidate's average poll support and their popular vote share. The graphics above display historical trends for such, using aggregated measures of poll support for an incumbent or non-incumbent candidate six weeks before an election and said candidates' popular vote shares from 1968 to 2016. Some of the major takeaways include:

* **A strong relationship.** The graphs indicate that a candidate's average support in the polls has historically been highly related to their respective popular vote shares. This is evident based on the generally linear and relativley narrow spread of the data points for both the incumbent and challenger graphs. 

* **Higher incumbent accuracy.** While both graphs present strong and linear relationships for the variables in question, it is also clear that the relationship between a candidate's average support and their popular vote share is stronger for incumbent candidates than non-incumbent candidates. Such can be seen by the data points in the incumbent graph falling closer to a one-for-one diagonal line between the x-axis and y-axis than the non-incumbent graph. 

**The Variation in Pollster Quality** 

2016 Polls  |  2020 Polls
:-------------------------:|:-------------------------:
![](Polls3.png)|![](Poll4.png)

When considering the relationship between the polls and a candidate's popular vote share, one must also be cognizant of the differences in quality between various polls. The graphic above demonstrates the variation in quality for national polls in the 2016 and 2020 elections, graded by FiveThirtyEight based on a given pollster's historical accuracy and methodology.

**Uneven distribution.** One of the most apparent takeaways from analyzing the above graphs is that the 2016 and 2020 national election polls are not distributed equally across the quality. For example, for the 2016 election, there is a massive spike of A- and C+ graded polls, with relatively low counts for the rest of the grades. Similarly, in 2020 there is a massive spike of B/C graded polls with lower counts for the other grades.

**Constructing a Prediction Model** 

When constructing a prediction model, we will consider its prediction for 2016 to evaluate such model against the actual popular vote results for both the incumbent and the non-incumbent party candidate. 

Given relationship between the polls and the popular vote, as well as the variation in quality between different polls, the first component of our 2016 prediction model will be an aggregate support of 2016 national polls, weighted for quality. Polls with a higher grade will be weighted greater, or polls with grades of A+,A, and A- will recieve a weight of 0.8, 0.2, and 0.05, respectivley. 

The second component will be second quarter GDP, given such variable was the economic variable most related to popular vote shares in last week's blog post (link in last week). 

Each of these components are weighted equally in our final prediction model for 2016. Given such model, the prediction for incumbent party candidate is 47.24%, and the prediction for the non-incumbent party candidate is 44.15%. Given the actual results were 47.06% and 44.92%, respectivley, such model seems viable; however, an evaluation of its predictive ability agaisnt other models is still necessary.  






















