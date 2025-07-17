# Phishing Email Detection

A complete end-to-end pipeline for detecting phishing emails using **SQLite**, **R**, and **machine learning**. This repository contains all scripts, data, and results needed to reproduce the analysis.

---

## Project Structure

```
Phishing_email_detection/
├── .gitignore                  # Git ignore rules
├── data/                       # Data directory
│   ├── features.csv            # Extracted feature table (CSV)
│   ├── logistic_model.rds      # Serialized trained model
│   ├── phishing_email.csv      # Original raw dataset (CSV)
│   └── phishing_email.sqlite   # SQLite database of emails
│
├── R/                          # R scripts
│   ├── database_connect.R      # DBI/SQLite connection helper
│   ├── import_csv.R            # Load CSV into SQLite
│   ├── query_data.R            # Exploratory SQL queries
│   ├── feature_engineering.R   # Feature extraction from text
│   ├── model_train.R           # Train & evaluate logistic model
│   └── visualize.R             # Generate ROC & confusion matrix plots
│
├── result/                     # Output figures
│   ├── confusion_matrix.png    # Confusion matrix heatmap
│   ├── phishing_model_performance.jpg  # Model performance summary
│   └── roc_curve.png           # ROC curve plot
│
│
├── phishing_report.Rmd         # R Markdown report with narrative, code, and figures
└── README.md                   # Project overview and instructions
```

---

## Prerequisites

- **R** (>= 4.0)
- **SQLite**
- R packages: `DBI`, `RSQLite`, `caret`, `pROC`, `readr`, `ggplot2`, `knitr`

Install required packages with:

```bash
Rscript -e 'install.packages(c("DBI","RSQLite","caret","pROC","readr","ggplot2","knitr"), repos="https://cloud.r-project.org")'
```

---

## Getting Started

1. **Clone the repository**:
   ```bash
   https://github.com/uudam42/ML_Phishing_Detection.git
   ```


2. **Place raw CSV**:
- Put the original `phishing_email.csv` into the `data/` folder.

3. **Run the pipeline step by step**:
```bash
Rscript R/import_csv.R
Rscript R/query_data.R
Rscript R/feature_engineering.R
Rscript R/model_train.R
Rscript R/visualize.R
````

After each script, check the generated file in `data/` or `result/`.

---

## Outputs

- **SQLite database**: `data/phishing_email.sqlite`
- **Feature table**: `data/features.csv`
- **Trained model**: `data/logistic_model.rds`
- **Plots**: `result/roc_curve.png`, `result/confusion_matrix.png`
- **Full report**: `phishing_report.Rmd`

---

## Report

Knitting the R Markdown report produces a self-contained HTML or PDF summary:

```bash
Rscript -e "rmarkdown::render('phishing_report.Rmd')"
```

---

## License

This project is released under the MIT License.

