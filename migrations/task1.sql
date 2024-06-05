-- Active: 1717578863460@@172.17.0.2@8123@default

CREATE TABLE source (
    value String
) ENGINE Memory;


CREATE TABLE counters(
    id String,
    counter Int64
)
ENGINE = SummingMergeTree()
ORDER BY id;

CREATE MATERIALIZED VIEW counters_mv 
TO counters
AS
SELECT
   simpleJSONExtractString(value, 'id') AS id,
   simpleJSONExtractInt(value, 'value') AS counter
FROM "source"
WHERE simpleJSONExtractString(value, 'type') = 'counter';

SELECT id, counter FROM counters FINAL;