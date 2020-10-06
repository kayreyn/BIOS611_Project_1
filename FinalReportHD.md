BIOS 611 Project 1
=======================
"Heart Disease - Final Report"
---------------------------

### Introduction

Heart Disease is a broad term that can be applied to many heart conditions that negatively impact heart health.  These complications can arise from a variety of factors, including genetics, environment, and unhealthy habits [1].  Individuals with heart disease are at a greater risk for heart attacks and heart failure [2].    

Finding indicators of heart disease can aid doctors in indentifying at risk individuals who need to be placed on preventative treatment. Are there certain demographic information and tests that accurately indicate the prevalence of heart disease in patients?  Which of these indicators have the most weight in determining heart disease status?  Can a model be created to accurately predict whether a patient has heart disease based on medical test records?

### Data Origins

The heart disease data used in this project is publicly available from UC Irvine at 
https://archive.ics.uci.edu/ml/datasets/heart+Disease. It is a collection of data collected from 4 institutions: the Cleveland Clinic Foundation, Hungarian Institute of Cardiology, V.A. Medical Center, and University Hospital. There are thirteen explanatory variables detailing patient demographics (sex, age) and heart test measurements (chest pain, cholesterol levels, etc.).  The response variable, heart disease, indicates the presence of heart disease in a patient.  The original dataset contains measurements on 303 patients.  For this analysis, 6 patients with missing values were removed. After filtering, there are 160 patients without heart disease and 137 patients with heart disease.    

### Preliminary Analysis and Variable Clarifications

Before beginning analysis, some preliminary graphs were created to examine the distributions of the variables. These graphs aid in checking for potential issues with lack of categorical data representation and logistic regression assumption violations.

Below are boxplots illustrate the distributions of the continuous variables in the dataset. These variables are age of the participant, resting blood pressure, cholesterol level, maximum heart rate, and ST depression induced by excercise relative to rest.

![](figures/cont_var_distributions.png)

With the exception of ST depression induced by excercise relative to rest for the heart disease group, the distributions appear to be symmetrical without too many eggregious outliers. This will ensure that the estimated beta coefficients in the logistic regression model are accurate. Many of the distributions overlap signifcantly, which will reduce odds ratio sizes and make it more difficult to identify significant relationships. 

The bar graphs displayed below make it easy to visualize the frequency of the levels of discrete variables in the data.  Several of these variables clarification on their meaning to understand why they were included in the data set. 

![](figures/disc_var_distributions.png)

The variables resting electrocardiographic results, thalium, and peak exercise ST segment slope all have one category that has very small counts. This could result in overfitted models because these categories will be underrespresented.  Thalium and chest pain type seem to have the most dramatic differences in counts, potentially indicating their future significance in predicitive models. 

### Methods

A logistic regression model will be created to estimate which variables have the most impact in explaining the presence of heart disease. Variable selection will ensures that variables that contribute the same information in determining disease status are not both included, or that variables that are not related to disease are not confounding results. This model's predictive power will be evaluated with a ROC curve, specificity, and sensitivity.

### Logistic Regression Model

Before creating a finalized regression model, variable selection was implemented to determine which variables will create the strongest model.  The best model had an AIC of 219.7 and included 9 variables.

The beta coefficients and 95% confidence intervals were then calculated and back-transformed onto the original scale.  P values less than 0.05 signify a significant beta coefficient. 

#### Regression Output Table
![](figures/log.reg.table.png)

As an example of interpretation, we are 95% confident that an individual who is male is between 1.758 to 13.8 times as likely to be diagnosed with heart disease as a female, holding all other variables constant.  Additionally, as the maximum heart rate of a patient increases by 1 beats per minute, we are 95% confident that he or she will be 0.964 to 1.006 times as likely to be diagnosed with heart disease.  

Modifying the threshold at which an individual is labeled as having heart disease can increase prediction success. Various thresholds between 0 and 1 were checked with the model to identify the threshold which minimized misclassifications.  A graph of these misclassification rates can be seen below. The threshold that will be used for future predictions is 0.43.

#### Threshold Misclassification Rates
![](figures/Threshold_Classification.png)

One way to measure whether a logistic regression model is good is by examining a ROC curve.  A ROC curve plots the model's sensitivity values against its specificity values. The better a model does at classification, the larger the area under this curve will be.  A ROC curve for this regression model is placed below.  The area under the curve is 0.93, which indicates this regression model is very good at prediciting disease status. 

![](figures/ROC_Curve.png)

To evaluate the predictive strength of the model, a k-fold cross validation simulation was conducted. With each simulation, 90% of the heart disease data was allocated to a training set, and the remaining 10% set aside as a testing set.  The training set is used to create a logistic regression model using the same variables identified in variable selection above.  This training can then be used to test its ability in accurately predicting the disease status of patients in the testing set.  From these predictions, measures of sensitivity, specificity, and ROC curves can be generated. This model had an average area under the curve of 0.937, average sensitivity of 0.87, and average specificity of 0.88.  All of these indicate that the model's predictive accuracy is very strong.

### Discussion

The logistic regression model identified several variables that have a significant effect on heart disease status, including being male, having asymptomatic chest pain, increasing resting blood pressure, and having colored major blood vessels. Identifying these significant variables could help doctors monitor characteristics that could lead to heart disease.

This model also does a very good job with prediciting the disease status of patients. Therfore, it could be used to identify individuals who are at risk of developing heart disease so they can be treated preventively.


#### Citations 
[1] https://www.mayoclinic.org/diseases-conditions/heart-disease/symptoms-causes/syc-20353118
[2] https://www.cdc.gov/heartdisease/about.htm
