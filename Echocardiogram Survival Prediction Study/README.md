# Echocardiogram Survival Prediction Study
## Overview
This study analyzes echocardiogram data to predict whether patients will survive for at least one year following a heart attack. The dataset comprises 131 instances, each with 13 attributes that provide insights into patient health and heart function. This project was conducted for a startup that provides data science solutions for the health industry in Africa, aiming to leverage analytics to improve healthcare outcomes in the region.

## Objectives
**Predictive Analysis**: The primary goal is to determine if the existing data can be utilized to predict patient survival beyond one year. This involves analyzing various metrics and their correlation with patient outcomes.

**Identifying Key Indicators**: The study seeks to identify which variables serve as reliable indicators of a patient's potential longevity after experiencing a heart attack. Understanding these indicators can help in clinical assessments and treatment planning.

## Dataset Details
- Instances: 132
- Attributes: 13, including:
  - *survival*: Number of months a patient survived (or currently alive).
  - *still-alive*: Binary variable indicating if the patient is alive at the end of the survival period.
  - *age-at-heart-attack*: Age when the heart attack occurred.
  - *pericardial-effusion*: Indicates presence of fluid around the heart.
  - *fractional-shortening*: Measure of heart contractility; lower values indicate more abnormal function.
  - *epss*: E-point septal separation; larger values are increasingly abnormal.
  - *lvdd*: Left ventricular end-diastolic dimension; indicates heart size at end-diastole.
  - *wall-motion-score*: Measure of left ventricle segment movement.
  - *wall-motion-index*: Wall-motion score divided by the number of segments seen in an echocardiogram.
  - *alive-at-1*: Boolean indicating if the patient was alive at one year.

## Challenges
The study highlights the difficulties in predicting survival, particularly for patients who may not survive long-term. It addresses the need for handling missing data and applying statistical methods to derive meaningful insights.

## Key Skills
Data Analysis, Statistical Methods (Descriptive Statistics, Correlation Analysis, Regression Analysis, Survival Analysis, Cox Proportional Hazards Model, Hypothesis Testing), Data Cleaning and Preprocessing, Data Visualization, Python( Pandas, NumPy, and Matplotlib), Understanding of medical terminology and healthcare analytics.
