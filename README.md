# Customer 360 and Marketing Attribution Platform

## Project overview

This project brings together customer, ecommerce activity, and
marketing-touchpoint data to create a unified Customer 360 view and
analyze marketing attribution and campaign performance.

The project uses the Google Analytics 4 (GA4) public sample ecommerce
dataset, a synthetic CRM customer dataset, SQL transformations in
BigQuery/dbt, Python/Google Colab for supporting data work, and Tableau
Public for dashboards.

> **Important data note:** The CRM/customer records used in this project
> are synthetic. Campaign spend values are illustrative rather than
> actual advertising-platform spend. ROI, ROAS, and CPA results based on
> those values are demonstrations and should not be interpreted as
> verified business performance.

## Project objectives

-   Build a unified customer view by connecting CRM customers to website
    visitor activity.
-   Summarize customer activity, purchases, and revenue.
-   Create customer segments using RFM (Recency, Frequency, Monetary)
    analysis.
-   Compare first-touch, last-touch, linear, and time-decay attribution
    approaches.
-   Analyze campaign performance using spend, conversions, and
    attributed revenue.
-   Present the results in Tableau dashboards.

## Technology stack

-   **Google BigQuery** --- cloud data warehouse and SQL analysis
-   **GA4 public sample ecommerce data** --- website event source
-   **dbt Core and dbt BigQuery adapter** --- data transformation and
    testing
-   **Python / Google Colab** --- supporting data preparation and export
-   **Microsoft Excel** --- workbook-based RFM and CLV analysis
-   **Tableau Public** --- interactive dashboards

## Data sources

### GA4 public sample ecommerce data

Source table:

`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

The analyzed sample covers **1 November 2020 through 31 January 2021**.

### Synthetic CRM data

Synthetic customer and identity-mapping records are used to demonstrate
how CRM customer records can be linked to website visitor identifiers.
These records are not real customer data.

### Illustrative campaign spend

Campaign spend inputs are illustrative. Any CPA, ROI, or ROAS figures
calculated from them are scenario-based demonstration metrics, not
actual paid-media results.

## Data transformation

The dbt project contains the following six models:

1.  `customer_profile`
2.  `orders`
3.  `sessions`
4.  `session_touchpoints`
5.  `attribution_models`
6.  `campaign_performance`

The attribution model includes:

-   First touch
-   Last touch
-   Linear
-   Time decay with a 7-day half-life assumption

These are rule-based attribution methods. They describe how credit is
assigned under stated rules; they do not establish causal marketing
impact.

## Customer analysis

The project includes:

-   Customer 360 profile and activity summaries
-   Purchase and revenue summaries
-   RFM scores and customer categories
-   Illustrative customer lifetime value (CLV) estimates

CLV calculations rely on assumptions such as observation period,
expected lifespan, gross margin, and customer acquisition cost. Where
actual business inputs are unavailable, estimates are illustrative and
should not be treated as validated predictions.

## Dashboards

The Tableau Public workbook contains:

-   **Customer 360 Dashboard** --- customer and revenue KPIs, customer
    segmentation, and CLV by segment
-   **Campaign Performance Dashboard** --- campaign CPA, ROI, and ROAS
    views

Published Tableau Public dashboard:

[View the Customer 360 and Marketing Attribution
dashboard](https://public.tableau.com/app/profile/abhinayasri.yalabaka/viz/Customer_360_Marketing_Attribution/Dashboard1?publish=yes)

## Repository structure

The project folder is organized into the following main areas. Exact
filenames may vary depending on the final files included in the
repository.

``` text
Customer_360_Attribution/
├── customer_360_dbt/       # dbt project, models, tests, and configuration
├── sql/                    # standalone SQL analysis queries
├── data/
│   ├── raw/                # source/sample input files
│   └── campaign_performance.csv
├── Documentation/          # project documentation and architecture diagram
├── Workbooks/              # Tableau packaged workbook and analysis workbooks
├── README.md
└── Customer_360_Final_Submission_Checklist.md
```

Do not upload credentials, service-account JSON files, access tokens,
passwords, or private customer information to GitHub.

## Setup and reproduction

This repository is intended as a project handover and demonstration. To
reproduce the BigQuery/dbt workflow:

1.  Install Python and dbt Core with the BigQuery adapter in a virtual
    environment.
2.  Configure Google Cloud authentication securely using your own Google
    Cloud account and an appropriately permissioned service account or
    application-default credentials.
3.  Create or select a BigQuery project and dataset in the appropriate
    location.
4.  Update the dbt profile configuration for your own project, dataset,
    and authentication method. Do not commit credentials.
5.  From the dbt project directory, run:

``` bash
dbt debug
dbt run
dbt test
```

6.  Review the generated BigQuery models and use the supplied SQL and
    supporting files for analysis.
7.  Open the packaged Tableau workbook in Tableau Desktop/Public and
    reconnect data sources if prompted. The published dashboard link
    above can be used to view the online demonstration.

Exact setup values, dataset names, and paths may need adjustment for
another user's Google Cloud environment.

## Testing and validation

The dbt project includes data tests for key model fields and customer
profile row-count validation. The project work included successful
`dbt debug`, `dbt run`, and `dbt test` executions in the development
environment.

These checks validate configured data-quality rules. They are not a
complete measure of predictive accuracy, causal validity, or production
performance.

## Known limitations

-   The GA4 dataset is an obfuscated public sample and is limited to its
    available date range.
-   CRM/customer identity data is synthetic.
-   Campaign spend values are illustrative.
-   Attribution outputs depend on the selected rule and available
    touchpoint data.
-   The 7-day time-decay half-life is an explicit modeling assumption.
-   Some purchases may not be attributable when visitor or session
    identity is unavailable.
-   CLV outputs depend on assumptions and a small number of purchasing
    customers; they are exploratory estimates, not validated forecasts.
-   The project is a portfolio/internship demonstration and is not
    presented as a production-hardened system.

## Author and purpose
Author: Yalabaka Abhinaya Sri
Prepared as an internship project demonstrating customer analytics, data
transformation, marketing attribution, data quality checks, and
dashboard development.
