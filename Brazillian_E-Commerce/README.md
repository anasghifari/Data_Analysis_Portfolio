# Brazilian E-Commerce — End-to-End Data Analytics Project

![SQL](https://img.shields.io/badge/SQL-MariaDB-blue?logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.9-blue?logo=python&logoColor=white)
![Tableau](https://img.shields.io/badge/Tableau-Public-orange?logo=tableau&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-Data%20Analysis-green?logo=pandas&logoColor=white)

> **An end-to-end data analytics project analyzing 100,000+ orders from Olist, Brazil's largest e-commerce marketplace — covering product performance, logistics, customer behavior, payment trends, and seller quality.**

---

## Live Dashboard

**[View Interactive Tableau Dashboard](https://public.tableau.com/shared/8YGYRXJ9N?:display_count=n&:origin=viz_share_link)**

---

## Project Overview

This project performs a comprehensive analysis of the **Olist Brazilian E-Commerce Public Dataset** (2016–2018), covering over **99,000 orders** across **27 Brazilian states**.

The analysis is structured around **8 core business questions** that mirror real-world e-commerce analytics tasks — from revenue performance and logistics efficiency to customer retention and seller quality.

### Business Context

Olist is a Brazilian marketplace that connects small businesses to major e-commerce channels. This project simulates the work of a **Data Analyst at Olist**, providing actionable insights across 5 business pillars:

| Pillar | Focus |
|--------|-------|
| Product | Which categories drive the most revenue? |
| Revenue | How is the business growing month over month? |
| Logistics | How efficient is the delivery network? |
| Customer | How well does Olist retain its customers? |
| Payment | How do payment preferences affect order value? |

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| **MariaDB / SQL** | Data extraction, transformation, and analysis |
| **Python (Pandas, Matplotlib, Seaborn)** | Exploratory data analysis & visualization |
| **SQLAlchemy + PyMySQL** | Python-to-database connection |
| **Tableau Public** | Interactive business dashboard |
| **Jupyter Notebook** | Analysis documentation |

---

## 8 Business Questions Answered

| # | Question | Theme |
|---|----------|-------|
| 1 | Which product categories generate the highest GMV vs order volume? | Product |
| 2 | Which sellers have the highest late-delivery rate — and does it hurt their reviews? | Logistics |
| 3 | What is the monthly revenue growth trend (MoM %)? | Revenue |
| 4 | What percentage of customers place more than one order? | Retention |
| 5 | Which Brazilian states have the highest average order value (AOV)? | Geography |
| 6 | What is the preferred payment method, and how do installments affect order value? | Payment |
| 7 | Which states experience the biggest delivery time gap vs estimated date? | Delivery |
| 8 | Who are the top sellers by combined revenue and customer rating? | Sellers |

---

##  Key Insights

### Product & Revenue
- **Health & Beauty** is the top GMV category at **R$1.26M**, followed by **Watches & Gifts (R$1.04M)**
- Total platform GMV reached **R$8.47M** across the 2016–2018 period
- Revenue grew consistently from **R$350K/month (early 2017)** to nearly **R$1M/month (mid-2018)**

### Customer Behavior
- Only **~3% of customers** placed more than one order — a significant retention challenge
- This signals a major opportunity for **loyalty programs and re-engagement campaigns**

### Payment Insights
- **Credit card** is the dominant payment method (**76,795 transactions**)
- Credit card users average **~4 installments** per purchase and have the **highest average order value**
- Installment options lower the psychological barrier for high-value purchases

### Logistics & Delivery
- **All 27 Brazilian states** receive orders ahead of the estimated delivery date on average
- States like **Acre and Rondônia** are delivered up to **20 days early** — Olist sets very conservative estimates
- Sellers with higher late-delivery rates consistently receive **lower review scores** (negative correlation confirmed)

### Seller Quality
- Top performers combine **high revenue** with **high customer ratings (4.5+)**
- A small group of sellers from cities like **Belo Horizonte and Teresópolis** disproportionately drive platform quality

---

## Project Structure

```
brazilian-ecommerce-analytics/
│
├── 📄 brazillian_e-commerce.sql      # All 8 SQL analysis queries
├── 📓 brazilian_ecommerce_eda.ipynb  # Python EDA notebook (8 visualizations)
│
├── 📂 tableau_data/                  # Exported CSVs for Tableau
│   ├── gmv_by_category.csv
│   ├── monthly_revenue.csv
│   ├── payment_behavior.csv
│   ├── aov_by_state.csv
│   ├── delivery_gap.csv
│   └── top_sellers.csv
│
└── 📂 charts/                        # Chart exports from Python notebook
    ├── q1_gmv_by_category.png
    ├── q2_late_delivery_vs_review.png
    ├── q3_monthly_revenue_growth.png
    ├── q4_customer_retention.png
    ├── q5_aov_by_state.png
    ├── q6_payment_behavior.png
    ├── q7_delivery_gap_by_state.png
    └── q8_top_sellers.png
```

---

## Dataset

- **Source**: [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Period**: September 2016 — October 2018
- **Size**: ~100,000 orders, 9 relational tables
- **Tables used**:
  - `olist_orders_dataset`
  - `olist_order_items_dataset`
  - `olist_customers_dataset`
  - `olist_sellers_dataset`
  - `olist_products_dataset`
  - `olist_order_payments_dataset`
  - `olist_order_reviews_dataset`
  - `product_category_name_translation`

---

## How to Run

### SQL Analysis
1. Import the Olist dataset into **MariaDB / MySQL**
2. Open `brazillian_e-commerce.sql` in MySQL Workbench or DBeaver
3. Run each query block (labeled `-- 1.` through `-- 8.`)

### Python EDA Notebook
```bash
# Install dependencies
pip install sqlalchemy pymysql pandas matplotlib seaborn numpy jupyter

# Launch Jupyter
jupyter notebook brazilian_ecommerce_eda.ipynb
```

> The notebook connects directly to your local MariaDB instance.
> You will be prompted to enter your database password securely.

### Tableau Dashboard
[View live on Tableau Public](https://public.tableau.com/shared/8YGYRXJ9N?:display_count=n&:origin=viz_share_link)

Or open locally: download the `.twbx` file and open with Tableau Public Desktop.

