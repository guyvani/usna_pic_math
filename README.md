# USNA PIC MATH 

The Behavioral Risk Factor Surveillance System (BRFSS) is an annual statewide telephone surveillance system designed and funded by the Centers for Disease Control and Prevention (CDC), and conducted by the NYSDOH Division of Chronic Disease and Prevention, Bureau of Chronic Disease Evaluation and Research.
The BRFSS collects data on preventive health practices and risk behaviors that affect chronic diseases, injuries, and preventable infectious diseases. Examples include tobacco use, health care coverage, HIV/AIDS knowledge and prevention, physical activity, and consumption of fruits and vegetables. Demographic information is also collected to permit analyses of specific populations. While all data collected are self-reported, some variables are calculated based on given responses. For example, obesity is calculated based on the respondent's reported height and weight. Current smoking status and leisure
time physical activity are also calculated variables.
Overall health and pre-existing medical conditions are part of the factors that insurance companies evaluate in order to determine your insurability and related cost of insurance coverage.  
The current industry practice of assessing health risks is to model  each individual health outcome in isolation of the others. For instance, researchers may model risk of obesity in isolation of diabetes risks.
However it is often the case that these two health risks are not independent of one another.
The purpose of this challenge is to develop a model/algorithm that:

* allows modeling of the following health risks:  DIABETES(DIABETE3),  OVERWEIGHT OR OBESE CALCULATED VARIABLE(RFBMI5), COMPUTED SMOKING STATUS(SMOKER3) in a way that leverages potential dependencies among these three health outcomes. 
* determines early warning signs of diabetes and identify top behavioral and demographics risk factors associated with diabetes. In addition, provide a qualitative and quantitative description of the relationship between each of the top risk factors and risk of diabetes.    
* determines top behavioral and demographics risk factors associated with obesity. In addition, provide
	a qualitative and quantitative description of the relationship between each of the top risk factors and risk of obesity. 
* identifies respondents who answered that they do not smoke while they actually do.
* identifies respondents who answered that they do not suffer from diabetes when they actually do.
* provides deep insights on the relationship between diabetes, obesity and smoking status.   

