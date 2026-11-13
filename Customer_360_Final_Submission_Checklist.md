# Customer 360 & Marketing Attribution — Final Submission Checklist

Use this checklist before submitting the internship project.

## 1. Documentation
- [ ] `Customer_360_Marketing_Attribution_Final_Documentation.docx` is saved in the project.
- [ ] `Customer_360_Project_Architecture.png` is saved in the `Documentation` folder.
- [ ] The documentation describes both the Customer 360 dashboard and Campaign Performance dashboard.
- [ ] The documentation does not include an unwanted dashboard PDF appendix.

## 2. BigQuery and dbt
- [ ] BigQuery SQL files are present in the `sql` folder.
- [ ] The dbt project folder contains its models and test definitions.
- [ ] `dbt run` completed successfully.
- [ ] `dbt test` completed successfully.

## 3. Data and analysis files
- [ ] Required CSV exports are present in the `data` folder.
- [ ] The completed RFM workbook `customer_rfm_completed.xlsx` is saved.
- [ ] The RFM workbook contains the scoring guide and the R, F, M, combined score, and category fields.
- [ ] Campaign spend is clearly labelled as illustrative wherever campaign ROI, CPA, or ROAS is presented.

## 4. Tableau
- [ ] The packaged workbook `Customer_360_Marketing_Attribution.twbx` opens successfully.
- [ ] The Customer 360 dashboard opens and its published Tableau Public link works.
- [ ] The Campaign Performance dashboard opens and shows ROI by Campaign, ROAS by Campaign, and CPA by Campaign.
- [ ] The illustrative-spend disclaimer is visible on the Campaign Performance dashboard.

## 5. Final quality check
- [ ] Open the Word documentation and check page breaks, tables, headings, and links.
- [ ] Open the Excel workbook and confirm the data is readable.
- [ ] Open the packaged Tableau workbook once more before submission.
- [ ] Keep a backup copy of the complete project folder.

## Important scope notes
- The 1,000-customer sample results and the broader GA4 event aggregates are different analysis scopes; do not present them as directly reconcilable.
- Campaign spend values are illustrative assumptions, not actual advertising-platform costs.
- Do not claim customer lifetime value (CLV) is complete unless a dedicated CLV calculation has been added and validated.
