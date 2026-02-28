WITH tranches_2024 AS (
    SELECT *
    FROM tranches
    WHERE operation_datetime >= '2024-01-01' 
      AND operation_datetime <  '2025-01-01'
),
exact_matches AS (
    SELECT 
        tr.doc_id AS tranche_id,
        tr.inn,
        tr.account,
        tr.operation_datetime AS tranche_date,
        tr.operation_sum AS tranche_sum,
        tx.doc_id AS transaction_id,
        tx.operation_datetime AS transaction_date,
        tx.operation_sum AS transaction_sum,
        1 AS match_condition
    FROM tranches_2024 tr
    JOIN transactions tx 
      ON tr.inn = CAST(tx.inn AS text) 
     AND tr.account = tx.account
    WHERE tx.operation_datetime >= tr.operation_datetime 
      AND tx.operation_datetime <= tr.operation_datetime + INTERVAL '10 days'
      AND tx.operation_sum = tr.operation_sum
),
unmatched_tranches AS (
    SELECT tr.*
    FROM tranches_2024 tr
    WHERE tr.doc_id NOT IN (SELECT tranche_id FROM exact_matches)
),
running_sums AS (
    SELECT 
        ut.doc_id AS tranche_id,
        ut.inn,
        ut.account,
        ut.operation_datetime AS tranche_date,
        ut.operation_sum AS tranche_sum,
        tx.doc_id AS transaction_id,
        tx.operation_datetime AS transaction_date,
        tx.operation_sum AS transaction_sum,
        SUM(tx.operation_sum) OVER (
            PARTITION BY ut.doc_id 
            ORDER BY tx.operation_datetime
        ) AS cum_sum,
        COALESCE(
            SUM(tx.operation_sum) OVER (
                PARTITION BY ut.doc_id 
                ORDER BY tx.operation_datetime 
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            ), 0
        ) AS prev_cum_sum
    FROM unmatched_tranches ut
    JOIN transactions tx 
      ON ut.inn = CAST(tx.inn AS text) 
     AND ut.account = tx.account
    WHERE tx.operation_datetime >= ut.operation_datetime
),
cumulative_matches AS (
    SELECT 
        tranche_id,
        inn,
        account,
        tranche_date,
        tranche_sum,
        transaction_id,
        transaction_date,
        transaction_sum,
        2 AS match_condition
    FROM running_sums
    WHERE prev_cum_sum < tranche_sum
)
SELECT * FROM exact_matches
UNION ALL
SELECT * FROM cumulative_matches
ORDER BY tranche_id, match_condition, transaction_date;
