# Final Election Prediction
## Oct 29, 2020

Throughout this past semester, I have analyzed the impacts of variables such as second-quarter GDP, incumbency status, and turnout in a presidential candidate's predicted popular vote share. However, no single variable has been more related or more predictive of a candidate's populate vote share than a candidate's average support in the polls. Given my "best" models have consistently relied on such a variable, my final prediction model for the 2020 election will be primarily based on average support.  

**The Average Support Model** 

My model consists of a linear regression between the popular vote share and average support for Democratic and Republican presidential candidates. I constructed such regression based on popular vote and average support data from 1968 to 2016, or the past 13 presidential election cycles. The model necessarily excludes other variables, like second-quarter GDP, given the model's ambiguous or lack of a significant improvement in its predictive ability from the incorporation of such variables. The formulas and coefficients for both the Democratic and Republican candidate models are demonstrated below: 

* **Democrat average support model.** For Democratic candidates, the formula for the linear regression model based on average support is: predicted popular vote share = 23.4186 + 0.5286 (avg_support). Thus, for every 1% increase in the average support for Democratic candidates, such candidates' predicted popular vote shares increase by 0.5286 percentage points. 

* **Republican average support model.** For Republican candidates, the formula for the linear regression model based on average support is: predicted popular vote share = 12.5561 + 0.7829 (avg_support). Thus, for every 1% increase in the average support for Republican candidates, such candidates' predicted popular vote shares increase by 0.7829 percentage points. This also means my model predicts a greater increase in the popular vote share for Republican candidates, relative to Democratic candidates, when their respective support in the polls rises. 

**Model Validation** 

| Model  | Party |  R-squared | Mean Squared Error  | Leave-One-Out Validation  | Cross Validation  |
|:-:|:-:|:-:|:-:|:-:|:-:|
| Average Support Model  | Democrat  |  0.64  | 2.63 | -0.72  | 1.59  |
|  Average Support Model   |  Republican | 0.72  | 3.35  |  -0.09 |  1.98 |

The in-sample and out-of-sample performance of my model is summarized in the table above. Some of the major takeaways include:

* **In-sample fit.** The in-sample fit for the average support model is fairly strong for both parties. While the r-squared value for the Republican candidate average support model is greater than the r-squared value for the Democratic candidate model, the Democratic candidate average support model has a lower mean squared error relative to the Republican model. 

* **Out-of-sample error.** The out-of-sample error for the average support model is not large either. In fact, the leave-one-out validation value for the Republican canddiate average support model is only -0.09. However, the Democratic candidate average support model has the lower cross validaiton value of the two parties. 

Ultimatley, such validations demonstrate that the average support model for both parties performs relativley well, considering in-sample fit and out-of-sample error. 

**National Election Predictions for 2020** 

United States Presidential Election Turnout (1980-2016)  |  United States Midterm Election Turnout (1982-2014)
:-------------------------:|:-------------------------:
![](Prediction.png)|![](Prediction2.png)




