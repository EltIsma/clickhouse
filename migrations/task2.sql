-- Active: 1717578863460@@172.17.0.2@8123@default


CREATE TABLE payments(
    id String,
    date Date,
    category String,
    purpose String,
    money Int64,
    counter Int64
)
ENGINE = ReplacingMergeTree(counter)
ORDER BY (category, date, id);

CREATE MATERIALIZED VIEW payments_mv 
TO payments
AS
SELECT
   simpleJSONExtractString(value, 'id') AS id,
   toDate(simpleJSONExtractString(value, 'date')) AS date,
   simpleJSONExtractString(value, 'category') AS category,
   simpleJSONExtractString(value, 'purpose') AS purpose,
   simpleJSONExtractInt(value, 'money') AS money,
   simpleJSONExtractInt(value, 'index') AS counter
FROM "source"
WHERE simpleJSONExtractString(value, 'type') = 'payment';


SELECT category, sum(money) FROM payments FINAL GROUP BY category;