# 📊 Psychosocial Dimensions of Student Life Using Statistical Techniques

This project analyzes and predicts **depression levels** in college students based on survey responses collected via a Google Form. The survey captures various psychological, emotional, and behavioral indicators such as **dejection, apathy, pessimism,** and **social withdrawal**. Multiple machine learning models were applied to the dataset, and the best-performing model was identified.

---

## 🧠 Models Used
- **Decision Tree**  
- **Random Forest**  
- **Gradient Boosting**  

---

## 🧪 Statistical Tests
- **Cronbach’s Alpha:** Assesses internal consistency (reliability) of the survey items.  
- **Chi-Square Test of Independence:** Evaluates the association between depression level and academic field/gender.

---

## 📌 Key Findings
- **Mild Depression** is the most prevalent category (**51.41%**), followed by **Moderate Depression** (**41.06%**), and **Severe Depression** (**7.52%**).  
- **Sleep disturbance** and **physical exhaustion** show significant association with **gender**.  
- Students in **Engineering** show the highest incidence of mild depression.  
- Important features influencing depression levels include:  
  - **Dejection**  
  - **Pessimism**  
  - **Apathy**  
  - **Social withdrawal** (noted in some models)

---

## 🧾 Data Collection
- **Source:** Google Form  
- **Questions:** 48 psychological indicators  
- **Target Variable:** `Coded_score` (Depression Level)

---

## ⚖️ Libraries Used
- **pandas**, **numpy** – Data manipulation  
- **matplotlib**, **seaborn** – Data visualization  
- **scikit-learn** – Model building, evaluation, and visualization  
- **scipy / R (chisq.test)** – Statistical hypothesis testing

---

## 📚 Conclusion

By applying rigorous **statistical analysis** and **machine learning techniques**, this project successfully:

- Identified **key indicators** significantly related to depression levels.  
- Validated the **reliability** of the survey questionnaire using **Cronbach’s Alpha**.  
- Developed highly **accurate predictive models** for depression levels.  
- Found **Gradient Boosting** to be the most effective model with the **highest accuracy**.
