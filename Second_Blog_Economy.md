# The Economy and Popular Vote
## Sept 18, 2020

"It's the economy, stupid." Such were the famous words uttered by James Carville, Bill Clinton's campaign strategist, in 1992 towards campaign workers as one of the three messages they should focus on. This phrase perhaps best encapsulates the basic understanding most people have of the role the economy plays in deciding elections. But can the economy help us predict elections? Recent literature has offered some insight into these questions, with Healy and Lenz finding that voters primarily respond to the election year economy instead of longer-term economic figures. In turn, this blog will seek to understand how the economy can predict elections by first analyzing the relationship between Q2 election-year economic variables and vote shares, fitting models for these economic variables and vote shares, and ultimately using the model with the greatest predictive power to predict the 2020 election. 

**The Relationship between Election-Year Economic Variables and Popular Vote Share** 

Popular                  |  Electoral
:-------------------------:|:-------------------------:
![](Economy2.png)|![](Economy3.png)

Popular                  |  Electoral
:-------------------------:|:-------------------------:
![](Economy1.png)|![](Economy4.png)


In order to understand how the economy can predict election results, its important to first understand the relationship between election-year economic variables and the popular vote share. The graphics above display such, comparing second quarter economic figures like unemployment and GDP agaisnt the incumbent popular vote shares from the years 1948-2016. Some of the major takeaways include:

* **A tenuous relationship.** The two-party vote share for the incumbent candidate has historically only been tenuosly to moderatley related with various second quarter economic variables. This is evident from the wide and unlinear spread of data points in the top line of each graph. While this is to be expected for variables like GDP and stock volume, which are cumulative and generally increase irregardless of presidential terms, other figures, like unemployment, are not cumulative and vary significantly between presidential terms but are still shown to have a weak relationship with the incumbent vote share. The only variables which demonstrate some semblance of a moderate linear relationship with popular vote share are quarterly and yearly GDP growth. 

* **Correlated economic variables.** The graphic also indicates that some economic variables are highly correlated to one another. For instance, GDP and RDI, or the stock open and the stock close present near perfect postive linear relationships. Such indicates a bivariate model plotting multiple economic variables together might be rendundant and unessasary; rather, this blog will mainly consider univariate models for plotting the afromentioned economic variables and incumbent vote shares. 

**Fitting Prediction Models** 

Now we will proceed with creating prediction models. We will do these for each of the second quarter economic variables, running a linear regression using data sets containing historic incumbet vote shares and afromentioned economic data. Below are the fit variables associated with each of the models, with the purpose of determining which model has the best predictive power. Each model is univariate, containing one of the afromentioned economic variables. We evaluate these models based on the variables charted in the table below. 

|  Model | Variable  | R-squared  | Mean Squared Error  | Leaving One Out Validation  | Cross Validation |
|:-:|:-:|:-:|:-:|:-:|:-:|
| 1 | Quarterly GDP Growth  | 0.326   | 4.2  | -0.849  | 1.818  |
| 2 | Yearly GDP Growth  | 0.296  | 4.296  | -2.74  | 1.84  |
| 3  | GDP  | 0.039  | 5.019  | -1.369   | 2.02  |
| 4 | RDI  | 0.08  | 4.861  | -2.333  | N/A  |
| 5  | RDI Growth  | 0.258  | 4.367  | -3.192   | N/A  |
| 6 | Inflation  | 0.049  | 4.993  | -1.5  | 2.041  | 
| 7 | Unemployment  | 0.00004  | 5.12  | 0.887  | 2.251  |
| 8 | Stock Open  | 0.04  | 5.018   | -2.707  | 2.104  |
| 9  | Stock Close  | 0.04   | 5.019  | -2.776  | 1.967   |
| 10  | Stock Volume  | 0.05  | 4.99  | -2.243  | 2.265  |




Model

We will use univariate modeling, to avoid redundancies in highly correlated variables, but chart all of them. 

Table
takeaways:
in sample fit: most models had poor in sample fits, fitting with the tenous relationship we noted in the beggining. 

