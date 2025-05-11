/* Real vs Fake Articles by Category (with Difference)*/

WITH cte AS (
  SELECT date, title, text, source, author, category, label,
    EXTRACT(DAY FROM date) AS day,
    EXTRACT(MONTH FROM date) AS month,
    EXTRACT(YEAR FROM date) AS year,
    TO_CHAR(date, 'Dy') AS day_name
  FROM articles
  GROUP BY date, title, text, source, author, category, label
),
counts AS (
  SELECT 
    category,
    COUNT(CASE WHEN label = 'real' THEN 1 END) AS real_count,
    COUNT(CASE WHEN label = 'fake' THEN 1 END) AS fake_count
  FROM cte
  GROUP BY category
)
SELECT 
  category,
  real_count,
  fake_count,
  real_count - fake_count AS difference
FROM counts;

/*Yearly Fake vs Real Article Percentage*/

SELECT 
  EXTRACT(YEAR FROM date) AS year,
  COUNT(*) AS total_articles,
  ROUND(100.0 * COUNT(CASE WHEN label = 'fake' THEN 1 END) / COUNT(*), 2) AS fake_percentage,
  ROUND(100.0 * COUNT(CASE WHEN label = 'real' THEN 1 END) / COUNT(*), 2) AS real_percentage
FROM articles
GROUP BY year
ORDER BY year;

/* Top 5 Sources by Volume & Label Breakdown*/

SELECT 
  source,
  COUNT(*) AS total_articles,
  COUNT(CASE WHEN label = 'real' THEN 1 END) AS real_articles,
  COUNT(CASE WHEN label = 'fake' THEN 1 END) AS fake_articles,
  ROUND(100.0 * COUNT(CASE WHEN label = 'fake' THEN 1 END) / COUNT(*), 2) AS fake_percentage,
  ROUND(100.0 * COUNT(CASE WHEN label = 'real' THEN 1 END) / COUNT(*), 2) AS real_article
FROM articles
WHERE source IS NOT NULL
GROUP BY source
LIMIT 5;

/* Monthly Breakdown of Real vs Fake Articles*/

SELECT
  TO_CHAR(date, 'Month') AS month,
  COUNT(CASE WHEN label = 'real' THEN 1 END) AS real_articles,
  COUNT(CASE WHEN label = 'fake' THEN 1 END) AS fake_articles,
  ROUND(100.0 * COUNT(CASE WHEN label = 'fake' THEN 1 END) / COUNT(*), 2) AS fake_percentage,
  ROUND(100.0 * COUNT(CASE WHEN label = 'real' THEN 1 END) / COUNT(*), 2) AS real_article
FROM articles
GROUP BY TO_CHAR(date, 'Month')
ORDER BY month;

/* Day-wise Fake vs Real Article Percentage*/

SELECT
  TO_CHAR(date, 'Day') AS day,
  COUNT(CASE WHEN label = 'real' THEN 1 END) AS real_articles,
  COUNT(CASE WHEN label = 'fake' THEN 1 END) AS fake_articles,
  ROUND(100.0 * COUNT(CASE WHEN label = 'real' THEN 1 END) / COUNT(*), 2) AS real_article,
  ROUND(100.0 * COUNT(CASE WHEN label = 'fake' THEN 1 END) / COUNT(*), 2) AS fake_percentage
FROM articles
GROUP BY TO_CHAR(date, 'Day')
ORDER BY day DESC;

/*Category-wise Fake Article Percentage*/

SELECT 
  category,
  COUNT(*) AS total_articles,
  COUNT(CASE WHEN label = 'fake' THEN 1 END) AS fake_articles,
  ROUND(100.0 * COUNT(CASE WHEN label = 'fake' THEN 1 END) / COUNT(*), 2) AS fake_percentage
FROM articles
GROUP BY category
ORDER BY fake_percentage DESC;

/*Source Reliability Score (Top Reliable Sources)*/

SELECT 
  source,
  COUNT(*) AS total_articles,
  ROUND(100.0 * COUNT(CASE WHEN label = 'real' THEN 1 END) / COUNT(*), 2) AS reliability_score
FROM articles
WHERE source IS NOT NULL
GROUP BY source
HAVING COUNT(*) > 10
ORDER BY reliability_score DESC;

/*Fake News Trend Over Time (Monthly)*/

SELECT 
  TO_CHAR(date, 'YYYY-MM') AS year_month,
  COUNT(CASE WHEN label = 'fake' THEN 1 END) AS fake_articles,
  COUNT(*) AS total_articles,
  ROUND(100.0 * COUNT(CASE WHEN label = 'fake' THEN 1 END) / COUNT(*), 2) AS fake_percentage
FROM articles
GROUP BY year_month
ORDER BY year_month;

/*Most Repeated Fake News Titles*/

SELECT 
  title,
  COUNT(*) AS appearances
FROM articles
WHERE label = 'fake'
GROUP BY title
ORDER BY appearances DESC
LIMIT 10;

