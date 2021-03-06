SELECT * FROM photos LIMIT 5;

SELECT pg_size_pretty( pg_total_relation_size('photos') );

/* create table that only has research grade photos */
CREATE TABLE research_grade AS SELECT * FROM observations o
JOIN taxa t ON (t.taxon_id=o.taxon_id)
JOIN photos p ON (p.observation_uuid=o.observation_uuid)
WHERE o.quality_grade ='research';

/* create tables for larger fungi clades and selected genus */
CREATE TABLE basidios AS SELECT * FROM research_grade WHERE ancestry LIKE '%47169%';
CREATE TABLE ascomycota AS SELECT * FROM research_grade WHERE ancestry LIKE '%48250/%';
CREATE TABLE morchella AS SELECT * FROM research_grade WHERE ancestry LIKE '%56830/%';
CREATE TABLE verpa AS SELECT * FROM research_grade WHERE ancestry LIKE '%118001/%';
CREATE TABLE gyromitra AS SELECT * FROM research_grade WHERE ancestry LIKE '%85118/%';

SELECT * FROM verpa;
/* no verpas in this set */


SELECT
  t.taxon_id,
  t.name taxon_name,
  'https://www.inaturalist.org/observations/' || obs.observation_uuid as observation_url,
  o.login,
  'https://inaturalist-open-data.s3.amazonaws.com/photos/' || p.photo_id || '/medium.' || p.extension as photo_url
FROM taxa t
JOIN observations obs ON (t.taxon_id = obs.taxon_id)
JOIN photos p ON (obs.observation_uuid=p.observation_uuid)
JOIN observers o ON (obs.observer_id = o.observer_id)
WHERE t.ancestry LIKE '48460/1/%'
LIMIT 10;

/* morels research grade photo list */
SELECT
  *,
  'https://www.inaturalist.org/observations/' || observation_uuid as observation_url,
  'https://inaturalist-open-data.s3.amazonaws.com/photos/' || photo_id || '/medium.' || extension as photo_url
FROM morchella
LIMIT 10;

/* gyromitra */
SELECT * FROM research_grade WHERE ancestry LIKE '%85118/%';

/* gyromitra research grade list */
SELECT
  'https://inaturalist-open-data.s3.amazonaws.com/photos/' || photo_id || '/medium.' || extension as photo_url
FROM research_grade WHERE ancestry LIKE '%85118/%';

/* gyromitra casual grade list */
SELECT
  'https://inaturalist-open-data.s3.amazonaws.com/photos/' || photo_id || '/medium.' || extension as photo_url
FROM casual_grade WHERE ancestry LIKE '%85118/%' limit 5;


SELECT count(*) FROM ascomycota;
/* 530346 */

SELECT count(*) FROM basidios;
/* 1787595 */

SELECT count(*) FROM morchella;
/* 7389 */

SELECT count(*) FROM gyromitra;
/* 7854 */

/* need to select ~4000 random samples for a double negative sample */
SELECT count(*) FROM ascomycota TABLESAMPLE bernoulli (0.754) WHERE ancestry NOT LIKE ALL (ARRAY['%85118/%', '%56830/%']);
/* 3920, perfect */

/* need to select ~3000 randoms for a broader double neg */
SELECT count(*) FROM basidios TABLESAMPLE bernoulli (0.168) WHERE ancestry NOT LIKE ALL (ARRAY['%85118/%', '%56830/%']);
/* 3010, also perfect */

select count(*) from research_grade where observed_on >= '2015-01-01' and ancestry LIKE '%85118/%';

/* gyromitra research grade list */
SELECT
  'https://inaturalist-open-data.s3.amazonaws.com/photos/' || photo_id || '/medium.' || extension as photo_url
FROM research_grade WHERE ancestry LIKE '%85118/%';

/* morel research grade list */
SELECT
  'https://inaturalist-open-data.s3.amazonaws.com/photos/' || photo_id || '/medium.' || extension as photo_url
FROM research_grade WHERE ancestry LIKE '%56830/%';

/* asco research grade list */
SELECT
  'https://inaturalist-open-data.s3.amazonaws.com/photos/' || photo_id || '/medium.' || extension as photo_url
FROM research_grade WHERE ancestry LIKE '%48250/%';

/* basidio research grade list */
SELECT
  'https://inaturalist-open-data.s3.amazonaws.com/photos/' || photo_id || '/medium.' || extension as photo_url
FROM research_grade WHERE ancestry LIKE '%47169%';

where width >= 400 and height >= 400

create table recent as select photo_id, ancestry, extension from research_grade where observed_on >= '2020-01-01' and width >= 400 and height >= 400;


/* gyromitra research grade list */
SELECT
  'https://inaturalist-open-data.s3.amazonaws.com/photos/' || photo_id || '/large.' || extension as photo_url
FROM recent WHERE ancestry LIKE '%85118/%';

/* morel research grade list */
SELECT
  'https://inaturalist-open-data.s3.amazonaws.com/photos/' || photo_id || '/large.' || extension as photo_url
FROM recent WHERE ancestry LIKE '%56830/%';

/* asco research grade list */
SELECT
  'https://inaturalist-open-data.s3.amazonaws.com/photos/' || photo_id || '/large.' || extension as photo_url
FROM ascomycota TABLESAMPLE bernoulli (1.285) WHERE ancestry NOT LIKE ALL (ARRAY['%85118/%', '%56830/%'])and height >= 400 and width >= 400 and observed_on >= '2020-10-01';

/* basidio research grade list */
SELECT
  'https://inaturalist-open-data.s3.amazonaws.com/photos/' || photo_id || '/large.' || extension as photo_url
FROM basidios TABLESAMPLE bernoulli (0.357) WHERE ancestry NOT LIKE ALL (ARRAY['%85118/%', '%56830/%']) and height >= 400 and width >= 400 and observed_on >= '2020-10-01';

select count(*) from basidios TABLESAMPLE bernoulli (0.357) WHERE ancestry NOT LIKE ALL (ARRAY['%85118/%', '%56830/%']) and height >= 400 and width >= 400 and observed_on >= '2020-10-01';
select count(*) FROM ascomycota TABLESAMPLE bernoulli (1.285) WHERE ancestry NOT LIKE ALL (ARRAY['%85118/%', '%56830/%'])and height >= 400 and width >= 400 and observed_on >= '2020-10-01';

SELECT
  'https://inaturalist-open-data.s3.amazonaws.com/photos/' || photo_id || '/large.' || extension as photo_url, name
FROM research_grade where (ancestry like '%85118/%' or ancestry like '%56830/%') and height >= 400 and width >= 400 and observed_on >= '2020-10-01';

SELECT MIN(COUNT(*)) OVER () FROM research_grade GROUP BY name LIMIT 1;

create table greater_100_basidios as select ancestry, taxon_id from research_grade group by taxon_id, ancestry having count(*) > 100 and ancestry LIKE '%47169/%';

select ancestry, taxon_id, count(*) from research_grade group by taxon_id, ancestry having count(*) > 100 and ancestry LIKE '%47169/%';

select * from greater_100_basidios