SELECT COUNT(*) AS customer_count
FROM {{ ref('customer_profile') }}
HAVING COUNT(*) != 1000