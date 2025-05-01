#loading packages
library(mlr3verse)
install.packages('iml')
library(iml)

#loading Boston {MASS} data

install.packages('MASS')
library(MASS)

?Boston
df <- data("Boston", package = 'MASS')# did not understand this part
head(Boston)
as_tibble(Boston)
Boston %>% view()
dim(Boston)

Boston %>% autoplot() #not supported we use ggplot

#we load ggplot2
library(ggplot2)

#crime vs median value
ggplot(data = Boston, mapping = aes(x = crim, y = medv)) + geom_point() + labs(x ='crime', y = 'Median value') 

#rm vs median value
ggplot(data = Boston, mapping = aes(x = rm, y = medv)) + geom_point() + labs(x ='Rooms', y = 'Median value') 

#plotting a density function
ggplot(data = Boston) + geom_density(aes(x = medv)) #plot density function

#Industry vs median value
ggplot(data = Boston, mapping = aes(x = indus, y = medv)) + geom_point() + labs(x ='Industry', y = 'Median value')

#check for NA
Boston %>% is.na %>% sum()

#create task
task = TaskRegr$new(id = 'Boston', Boston, target = 'medv')
#task <- tsk('boston_housing')

#create a learner using random forest
lrn.ranger <- lrn("regr.ranger")

#create measures
measure <- msr("regr.rmse")

#create resampling
resampling <- rsmp('cv', folds = 5)

#Benchmarking decision tree, random forest and baseline model
design <- benchmark_grid(tasks = task, learners = c(lrn.ranger, lrn("regr.rpart"),lrn("regr.featureless")),
                         resampling = resampling)

bmr <- benchmark(design)

bmr$aggregate(measure=msr("regr.rmse"))

??resampling
??cv
mlr_resamplings$get("cv")

bmr %>% autoplot #random forest performs best

#train laearner on task
training <-lrn.ranger$train(task)

#testing our trained models and scoring it
preds = training$predict(task)  # `task` is your data (e.g., `tsk("iris")`)
preds$score(msr("regr.mae"))

#D) Create a Predictor (from the iml package) with the trained model
#The Predictor object acts as a wrapper around your trained model storing the model and the data needed to interpret it
#Once created, you can use this Predictor object with various interpretation methods from the iml package, such as:
  #Feature importance (with FeatureImp$new())
  #Partial dependence plots (with Partial$new())
  #Individual conditional expectation plots (with Ice$new())
  #Shapley values (with Shapley$new())
#The arguments being passed:
#learner: This is the trained machine learning model you want to interpret.
#data = task$data(): This provides the data that was used to train the model (or a sample of it). The task object likely comes from the mlr package and task$data() extracts the training data.
#y = task$target_names: This specifies the name of the target variable (what you're trying to predict) from the mlr task object.

### creating a predictor(capture all arguments:learner, y and data)

iml::Predictor
?Predictor

predictor <- Predictor$new(model = lrn.ranger,
                           data = task$data(),
                           y = task$target_names)

#E
#Once you have the predictor object, you can use it with various interpretability tools in iml, such as:
task$target_names
task$data()
lrn.ranger$model

#iml::
?importance
importance <- FeatureImp$new(predictor = predictor, loss = "rmse", n.repetitions = 20 )
importance$plot()


  
#1. Feature Importance
#imp <- FeatureImp$new(predictor, loss = "ce") #Classification
#imp$plot()  # Visualize feature importance

#2. Partial Dependence Plots (PDP)
#pdp <- Partial$new(predictor, feature = "age") 
#pdp$plot()  # Shows how "age"affects predictions

#3. Individual Conditional Expectation (ICE) Plots
#ice <- Ice$new(predictor, feature = "income")  
#ice$plot()  # Shows individual prediction curves

#4. SHAP (SHapley Additive exPlanations) Values
#shapley <- Shapley$new(predictor, x.interest = data[1, ])  
#shapley$plot()  # Explains a single prediction


#F
#Please note that this is what is done in feature filter methods. However there you would apply
#it to a different model, as a preprocessing step, while here we are actually interested in the
#feature importance within our model.

#Create a LocalModel object with the predictor as well as an observation of interest of your choosing
iml::Predictor
?LocalModel

lime <- LocalModel$new(predictor,
                       x.interest = as.data.frame(task$data(406)),
                       k =12 # number of considered variables, a lower k=decrease in predictive performance
                       )
install.packages('glmnet')
install.packages('gower')
library(glmnet)
library(gower)
lime$plot()

"Looking at the plot one can see that rm seems to be by far the most influential variable that has
a positive impact, while ptratio has the strongestne gative impact. It appears as so, while the 
apartments have a medium size, there is a lot of children per teacher as well as many lower class
citizens and high air pollution to counter that positive effect."