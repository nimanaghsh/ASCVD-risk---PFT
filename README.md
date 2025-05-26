# ASCVD Risk and Pulmonary Function in People With and Without HIV

This repository contains R code and figure outputs for a study investigating the associations between pulmonary function test (PFT) measures and cardiovascular (CVD) risk scores, stratified by HIV status and cohort (MACS and WIHS). The analysis includes multivariable linear regressions, forest plots, and comparative boxplots.

## 📁 Repository Contents

- `scripts/`: R scripts for analysis and visualization
- `README.md`: Project overview

---

## 📊 Figures and Descriptions

### **Figure 1. Associations Between PFT Measures and CVD Risk Models**
- **(A)** Forest plot of adjusted linear regression models evaluating associations between post-bronchodilator FEV₁, FVC, FEV₁/FVC, and DLCO and four CVD risk models (ASCVD, PREVENT ASCVD, PREVENT CVD, PREVENT HF), stratified by HIV status.
- **(B)** Subplots show regression results by pulmonary variable and cardiovascular risk score, separately for MACS (males) and WIHS (females).

---

### **Figure 2. Boxplots of CVD Risk Scores by HIV Status**
- Four cardiovascular risk scores are compared between HIV-positive and HIV-negative individuals, stratified by gender (MACS and WIHS).
- P-values are derived from Wilcoxon rank-sum tests.

---

### **Figure 3. HIV-Related Immunologic and Clinical Predictors of CVD Risk**
- **(A)** Adjusted regression models for CD4 count (log₂-transformed) and CVD risk scores among PLWH, shown for MACS, WIHS, and overall.
- **(B)** Regression models for viral load (log₁₀-transformed) and CVD risk scores.
- **(C)** Boxplots comparing CVD risk scores between ART-treated and untreated PLWH (Mann–Whitney U test).
- **(D)** CVD risk scores by ART regimen category (Kruskal–Wallis test).
- **(E)** Association between time from HIV seropositivity to ART initiation and CVD risk.
- **(F)** Association between time from AIDS diagnosis to study visit and CVD risk.

---

### **Figure 4. Lung Function Categories and CVD Risk**
Forest plots of β coefficients with 95% confidence intervals for the association between lung function categories and CVD risk models, stratified by HIV status and cohort.
- **(A)** Spirometry categories (Normal, OLD, PRISm, Restrictive)
- **(B)** DLCO impairment (Normal vs. Mild, Moderate/Severe)
- **(C)** Global lung function status (Normal vs. Impaired)

All models adjust for income, education, hepatitis C infection, and cocaine use. Models for PLWH include additional adjustment for CD4 count, viral load, and ART category.

---

## 📄 License

This project is shared under the [MIT License](LICENSE). No individual-level patient data are shared.
