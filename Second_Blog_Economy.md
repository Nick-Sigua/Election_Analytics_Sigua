# The Economy and Popular Vote
## Sept 18, 2020

"It's the economy, stupid." Such were the famous words uttered by James Carville, Bill Clinton's campaign strategist, in 1992 towards campaign workers as one of the three messages they should focus on. This phrase perhaps best encapsulates the basic understanding most people have of the role the economy plays in deciding elections. But how can the economy really help us predict elections? Recent literature has offered some insight into these questions, with Healy and Lenz finding that voters primarily respond to the election year economy instead of longer-term economic figures. In turn, this blog will seek to understand how the economy can predict elections by first analyzing the relationship between Q2 election-year economic variables and vote shares, fitting models between these economic variables and vote share, and ultimately using the model with the greatest predictive power to predict the 2020 election. 

**The Relationship between Election-Year Economic Variables and Popular Vote Share** 

Popular                  |  Electoral
:-------------------------:|:-------------------------:
![](Economy2.png)|![](Economy3.png)

Popular                  |  Electoral
:-------------------------:|:-------------------------:
![](Economy1.png)|![](Economy4.png)


In order to understand how the economy can predict election results, its important to first understand the relationship between election-year economic variables and the popular vote share. The graphics above display such, comparing second quarter economic figures like unemployment and GDP agaisnt the incumbent popular vote shares from the years 1948-2016. Some of the major takeaways include:

* **A tenuous relationship.** The two-party vote share for the incumbent candidate has historically been only tenuosly to moderatley related with various second quarter economic variables. This is evident from the wide and unlinear spread of data points in the top line of each graph. While this is to be expected for figures like x and y, which are cumulative and thus continue growing no matter the year and thus harder to relate to popular vote, other figures, like unemployment, are not and yet are still shown to have weak relationship. The only variables which demonstrate some semblance of a moderate linear relationship are quarterly and yearly GDP growth. 

* **Correlated economic variables.** The graphic also indicates that some variables are highly correlated to one another. For example, x and y, or z and f. Such indicates a bivariate model plotting multiple economic variables might be rendundant; rather, best to use univariate models based on these correlations between economic figures. 


Model

We will use univariate modeling, to avoid redundancies in highly correlated variables, but chart all of them. 

Table
takeaways:
in sample fit: most models had poor in sample fits, fitting with the tenous relationship we noted in the beggining. 

