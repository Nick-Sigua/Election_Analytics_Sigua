# Testing Narratives  
## December 1, 2020

In this blog, I will seek to provide an initial analysis of the evidence surrounding a post-election narrative. I will do this by first summarizing the narrative and explaining why it is important to test such. Then I will explain the testable implications of this narrative and how I could use these implications to derive a method of testing the narrative. Finally, I will describe the afromentioned test results and explain whether they might provide preliminary evidence for the narrative I am focusing on. 

**The Pandemic Narrative**

The main post-election narrative I will investigate is the notion that the coronavirus pandemic negatively impacted Trump's bid for re-election. Various media outlets, like the [Times](https://time.com/5907973/donald-trump-loses-2020-election/) and the [Washington Post](https://www.washingtonpost.com/elections/interactive/2020/trump-pandemic-coronavirus-election/), contributed this narrative by touting that the occurrence of such pandemic and all its associated issues dragged Trump's prospects for winning the election down and was a factor in his loss. Pundits, like [Sarah Longwell](https://time.com/5907973/donald-trump-loses-2020-election/), founder of the Republican Voters Against Trump, similarly reflected this sentiment and pointed towards the occurrence of the pandemic as an inhibiting factor on Trump's electoral efforts. The narrative largely builds off the major [pre-election day pandemic narrative](https://www.cnn.com/2020/10/29/politics/coronavirus-trump-analysis/index.html) of the same vein, which was seemingly validated based on the election results.

This narrative is important to test for several reasons. For one, the narrative is based on a unique shock to the 2020 race. Given we have discussed shocks, among other variables, in our analysis of elections throughout this semester, testing how a prolonged shock like a pandemic could impact an incumbent candidate is a natural extension of what we have analyzed in class and would provide valuable insight into how such might affect future elections. The narrative is also important to test because the pandemic has influenced some of the variables we have analyzed over the semester, like the economy. Thus, a test of such a narrative could provide a fuller understanding of all the dynamics of the 2020 election and a variable that has affected other election-variables we have incorporated in past models.

**Testable Implications**

Ideally, the best test of the afromentioned pandemic narrative would be to compare Trump's actual popular vote share in an election where the pandemic occurred to Trump's popular vote share in a simultaneous and identical election where the pandemic did not happen; if Trump's vote share were lower in the election where the pandemic occurred, such would prove the pandemic had a negative impact on Trump's electoral prospects. In the absence of such an ideal test, there are a few testable implications I could analyze instead that could offer some preliminary evidence for the existence of the narrative. 

The main testable implication I will consider is whether there was a negative correlation between Trump's average support in the polls and the daily increase in Covid-19 cases. This implication is justifiable given, if the coronavirus pandemic negatively impacted Trump's bid for re-election, then the increasing prevalence of the virus, i.e., a rise in daily COVID-19 cases, would be negatively related to Trump's support in the polls (thus his chances at re-election). Thus, by running a linear regression and observing the direction of the correlation between the two variables, I can analyze whether the data associated with such implication of the narrative is consistent with the afromentioned narrative. 

To derive this correlation, I collected data on the daily increase in national Covid-19 cases and Trump's average support in the polls from the middle of February to election day in November. This will allow me to plot the daily increase in Covid-19 cases and Trump's corresponding average support across the duration of the pandemic. The Covid-19 data came from [The Covid-19 Tracking Project](https://covidtracking.com/about-data), which collects, cross-checks, and publishes Covid-19 data based on state and territory public health authorities; the average support data come from [RealClear Politics](https://www.realclearpolitics.com/epolls/2020/president/us/general_election_trump_vs_biden-6247.html), who aggregate many national polls to derive a candidate's support in the polls. Given I will analyze the relationship between Trump's average support and the daily increase in Covid-19 cases over time, I will necessarily use national-level data. State and county-level data for Trump's average support in the polls are infrequent and limited, especially considering I want to analyze such variables throughout the pandemic; thus, such data is not tenable. 

A supplemental testable implication I will consider is whether Biden mentioned the pandemic or pandemic-related issues more than Trump throughout his campaign speeches. This implication is justifiable given, if the coronavirus pandemic negatively impacted Trump's bid for re-election, then Biden would logically try to bring the issue into the spotlight and mention it a lot throughout his campaign, while Trump would try to downplay its prevalence and shift focus away from the virus. In such a sense, the pandemic would play a similar role to the economy under [Vavrek](https://hollis.harvard.edu/primo-explore/fulldisplay?docid=TN_cdi_askewsholts_vlebooks_9781400830480&context=PC&vid=HVD2&search_scope=everything&tab=everything&lang=en_US), with Biden running a clarifying campaign on the pandemic and Trump running an insurgent one, given the purported impacts of the pandemic on Trump's electoral hopes. Of course, this implication assumes each campaign acted in their best interest, although I believe this assumption is fairly reasonable.

To measure whether Biden mentioned the pandemic more than Trump, I will conduct a chi-squared analysis comparing the differential association of keywords between Biden and Trump's campaign speeches. The campaign speech data I will focus on is an aggregation of each candidate's campaign speeches from March 1st, 2020 to November 4th, 2020, which again covers the duration of the pandemic up to election day. Of course, this analysis, perhaps more than the first test, has its limitations. But such is only meant to provide further preliminary evidence that the data is consistent or inconsistent with the pandemic narrative. 

**Results**

Test #1

As mentioned, my first test will consist of analyzing the correlation between Trump's average support and the daily increase in COVID-19 cases throughout the pandemic and the election. The graph below plots the resulting points and linear regression of such data:

|  The Average Support for Trump vs. the Daily Increase in Positive Covid-19 Cases for the 2020 Election |
|:-:|
|![](Narrative1.png)|

The graph demonstrates that, generally, a greater daily increase in Covid-19 cases is associated with lower average support for Trump in the polls. The linear regression summarizes this negative relationship between the variables, with the coefficient for the daily increase in Covid-19 cases being negative. Given I identified the pandemic narrative's main testable implication to be that there was a negative correlation between Trump's average support in the polls and the daily increase in Covid-19 cases, the results of my first test seem to be consistent with the afromentioned narrative. 

of course, there are some limitations of this finding. for one, although there is a negative relationship, such is not too strong
r squared associated with relationshio is 0.31, not too good. this improves if you consider only before october, graph, but that in it of itself raises further questions.

moreover, issues with causaility, as to be expected with these initial tests.

But overall, such test and result do offer some preliminary evidence for test. explain that results and data are consistent with narrative, with increasing prevalance of virus associated with lower support, so narrative has some evidencde. 

Test #2



(make sure to really explain data and correlation, as soubhik was confused last time). just explain what correlation is, not too deep. 

could provide limitations of test in results, makes more sense. 
