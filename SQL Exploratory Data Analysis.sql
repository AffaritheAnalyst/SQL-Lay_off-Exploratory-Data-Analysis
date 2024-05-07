-- Exploratory Data Analysis


SELECT *
FROM layoff_staging2;

SELECT max(total_laid_off), max(percentage_laid_off)
FROM layoff_staging2;

SELECT *
FROM layoff_staging2
WHERE percentage_laid_off = 1;

SELECT *
FROM layoff_staging2
WHERE percentage_laid_off = 1
order by total_laid_off DESC;

SELECT *
FROM layoff_staging2
WHERE percentage_laid_off = 1
order by funds_raised_millions DESC;

SELECT company, sum(total_laid_off)
FROM layoff_staging2
group by company
order by 2 desc;

SELECT min(`date`), max(`date`)
FROM layoff_staging2;

SELECT industry, sum(total_laid_off)
FROM layoff_staging2
group by industry
order by 2 desc;

SELECT country, sum(total_laid_off)
FROM layoff_staging2
group by country
order by 2 desc;

SELECT `date`, sum(total_laid_off)
FROM layoff_staging2
group by `date`
order by 2 desc;

SELECT year(`date`), sum(total_laid_off)
FROM layoff_staging2
group by year(`date`)
order by 1 desc;

SELECT stage, sum(total_laid_off)
FROM layoff_staging2
group by stage
order by 2 desc;

SELECT substring(`date`,1,7) AS `month`, sum(total_laid_off)
FROM layoff_staging2
WHERE substring(`date`,1,7) IS NOT NULL
group by `month`
order by 1 ASC;

WITH CTE_1 AS
(
SELECT substring(`date`,1,7) AS `month`, sum(total_laid_off) AS sum_total
FROM layoff_staging2
WHERE substring(`date`,1,7) IS NOT NULL
group by `month`
order by 1 ASC
)
SELECT `month` , sum_total, sum(sum_total) over(order by `month`) AS rolling_total
FROM CTE_1;



SELECT company, sum(total_laid_off)
FROM layoff_staging2
group by company
order by 2 desc;

SELECT company, YEAR(`date`), sum(total_laid_off)
FROM layoff_staging2
group by company, YEAR(`date`)
order by 3 DESC;


WITH CTE_2 (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), sum(total_laid_off)
FROM layoff_staging2
group by company, YEAR(`date`)
)
SELECT *
FROM CTE_2;

WITH CTE_2 (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), sum(total_laid_off)
FROM layoff_staging2
group by company, YEAR(`date`)
)
SELECT *, dense_rank() over(partition by years order by total_laid_off DESC)
FROM CTE_2
WHERE years IS NOT NULL;


WITH CTE_2 (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), sum(total_laid_off)
FROM layoff_staging2
group by company, YEAR(`date`)
), company_year_rank AS
(SELECT *, dense_rank() over(partition by years order by total_laid_off DESC) AS ranking
FROM CTE_2
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank;



WITH CTE_2 (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), sum(total_laid_off)
FROM layoff_staging2
group by company, YEAR(`date`)
), company_year_rank AS
(SELECT *, dense_rank() over(partition by years order by total_laid_off DESC) AS ranking
FROM CTE_2
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <=5;
