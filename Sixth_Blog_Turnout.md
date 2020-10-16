# Turnout in Popular Vote Predictions
## Oct 15, 2020

Campaigns have employed many strategies to mobilize their base and increase voter turnout throughout past presidential elections (source?). This begs the question: how can turnout help predict a candidate's popular vote share? In this blog, I will seek to answer such a question. I will first consider trends in turnout as a percentage for the voting-eligible population for the presidential and midterm elections. I will then incorporate this turnout variable in a linear regression model, stratified by party affiliation, and compare it to models from previous weeks. Finally, I will use this new model to predict the 2020 election, considering several turnout scenarios.

**Turnout Trends in the United States**

United States Presidential Election Turnout (1980-2016)  |  United States Midterm Election Turnout (1982-2014)
:-------------------------:|:-------------------------:
![](Turnout1.png)|![](Turnout2.png)

The graphs above demonstrate trends in the turnout rate (as a percentage of the voting-eligible-population) for United States elections from 1980 to 2016. Some of the major takeaways include: 

* **Increasing turnout for presidential elections.** From the data available, the voter turnout rate for presidential elections has generally increased from 1980 to 2016. This is evident given that the turnout rate for most elections before 2000 fell below 55% while such rate was above 59% for the majority of elections post-2000. 

* **Decreasing turnout for midterm elections.** From the data available, the turnout rate for midterm elections has generally decreased from 1982 to 2014. This is evident given that the turnout rate for midterm elections peaked around 42% in 1982 and fell to around 36% in 2014. However, one should note that the turnout rate increased consistently from 1988 to 2010 and was likely significantly higher in 2018 relative to 2014. 

**Incorporating the Turnout Rate in Models and Model Comparisons**

We will now incorporate the turnout rate of presidential elections in a model that predicts candidates' vote share. The main model we will consider is a linear regression model that factors in the turnout rate for presidential elections from 1980 to 2016 and the average support for a candidate six weeks before the election. A candidates' average support is factored in the model given such was found to be the most predictive variable for a candidate's popular vote share in my week 3 blog (source). I will compare the afromentioned model to a linear regression model based solely on the average support for a given candidate. Each model will be separated by party, i.e., each model will have two versions that predict the vote share for a candidate from one of the two major parties, using the same linear regression formula but with average support data specific to each party's candidate. 

| Model  | Variable(s)  | Party  | R-squared  | Mean Squared Error  | Cross Validation  |
|:-:|:-:|:-:|:-:|:-:|:-:|
| 1  | Average Support, Turnout Rate  | Democrat  | 0.56  | 2.58  | 3.27  |
| 1  | Average Support, Turnout Rate  | Republican  | 0.82  | 2.47  | 2.85  |
|  2 | Average Support  |  Democrat | 0.47  | 2.83  | 2.73  |
|  2 |  Average Support |  Republican | 0.71   | 3.13  | 3.18  |

The table above demonstrates the in-sample fit, via variables like r-squared and the mean squared error, and out-of-sample error, via the cross-validation values, for each of the previously mentioned models. 

**In-sample fit.** The in sample fit for model 1 is better than the respective fit for model 2, for both democrat and republican candidates. This is given the R squared values are higher and MSE lower for model 1 when compared to their model 2 counterpart 

**Out-of-sample error.**

both models good, one is better for this...one is better for that.. 



