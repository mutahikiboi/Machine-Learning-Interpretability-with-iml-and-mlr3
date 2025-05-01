#Machine Learning Interpretability with iml and mlr3

This repository demonstrates how to use the iml package to interpret machine learning models built with mlr3, focusing on the Boston Housing dataset.

##Overview
###The project explores:

Data preparation and visualization

Model training with mlr3

Global feature importance analysis

Local interpretability using LIME (Local Interpretable Model-agnostic Explanations)

##Key Features

Data Exploration: Visualizations of relationships between housing values and key features like crime rate, number of rooms, and industry presence.

Model Comparison: Benchmarks Random Forest, Decision Tree, and a baseline model using 5-fold cross-validation.

##Interpretability:

Global feature importance with FeatureImp

Local explanations with LocalModel (LIME implementation)

##Results

Random Forest performed best among the tested models

rm (average number of rooms) and lstat (lower status population) were most important globally

Local explanations showed how specific features influenced individual predictions

#License
MIT License


