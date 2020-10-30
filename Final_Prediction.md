# Final Election Prediction
## Oct 29, 2020

Throughout this past semester, I have analyzed the impacts of variables such as second-quarter GDP, incumbency status, and turnout in a presidential candidate's predicted popular vote share. However, no single variable has been more related or more predictive of a candidate's populate vote share than a candidate's average support in the polls. Given my "best" models have consistently relied on such a variable, my final prediction model for the 2020 election will be primarily based on average support.  

**The Average Support Model** 

My model consists of a linear regression between the popular vote share and average support for Democratic and Republican presidential candidates. I constructed such regression based on popular vote and average support data from 1968 to 2016, or the past 13 presidential election cycles. The model necessarily excludes other variables, like second-quarter GDP, given the model's ambiguous or lack of a significant improvement in its predictive ability from the incorporation of such variables. The formulas and coefficients for both the democratic and republican candidate models are demonstrated below: 

* **Democrat average support model.** For Democratic candidates, the formula for the linear regression model based on average support is: predicted popular vote share = 23.4186 + 0.5286 (avg_support). Thus, for every 1% increase in the average support for Democratic candidates, such candidates' predicted popular vote shares increase by 0.5286 percentage points. 

* **Republican average support model.** For Republican candidates, the formula for the linear regression model based on average support is: predicted popular vote share = 12.5561 + 0.7829 (avg_support). Thus, for every 1% increase in the average support for Republican candidates, such candidates' predicted popular vote shares increase by 0.7829 percentage points. This also means my model predicts a greater increase in the popular vote share for Republican candidates, relative to Democratic candidates, when their respective support in the polls rises. 

**Model Validation** 

| Model  | Party |  R-squared | Mean Squared Error  | Leave-One-Out Validation  | Cross Validation  |
|:-:|:-:|:-:|:-:|:-:|:-:|
| Average Support Model  | Democrat  |  0.6433995  | 2.627632 | -0.7204367  | 1.587792  |
|  Average Support Model   |  Republican | 0.7213893  | 3.347599  |  -0.08748293 |  1.980792 |

model validation table? <- yes. 

then in sample and out of sample, bolded 





