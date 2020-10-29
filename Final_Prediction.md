# Final Election Prediction
## Oct 29, 2020

Throughout this past semester, I have analyzed the impacts of variables such as second-quarter GDP, incumbency status, and turnout in a presidential candidate's predicted popular vote share. However, no single variable has been more related or more predictive of a candidate's populate vote share than a candidate's average support in the polls. Given my "best" models have consistently relied on such a variable, my final prediction model for the 2020 election will be primarily based on average support.  

**The Average Support Model** 

My model consists of a linear regression between the popular vote share and average support for democratic and republican presidential candidates. I constructed such regression based on popular vote and average support data from 1968 to 2016, or the past 13 presidential election cycles. The model necessarily excludes other variables, like second-quarter GDP, given the ambiguous or lack of a significant improvement in the model's predictive ability from the incorporation of such variables. The formulas and coefficients for both the democratic and republican candidate models are demonstrated below: 

* **Democrat average support model.** For democratic canddiates, the linear regression model based on average support states: predicted popular vote share = 23.4186 + 0.5286 (avg_support). 
postivie relationship, for every 1 percent 

