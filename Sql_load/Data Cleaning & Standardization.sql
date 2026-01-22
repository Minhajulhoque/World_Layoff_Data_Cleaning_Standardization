-- SQL Project - Data Cleaning

SELECT * 
FROM world_layoffs.layoffs;

CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;

INSERT layoffs_staging 
SELECT * 
FROM world_layoffs.layoffs;

SELECT * 
FROM world_layoffs.layoffs_staging;

/* now when I am data cleaning I usually follow a few steps
1. check for duplicates and remove any
2. standardize data and fix errors
3. Look at null values and see what 
4. remove any columns and rows that are not necessary - few ways */


-- 1. Remove Duplicates

/* SELECT company, industry, total_laid_off, percentage_laid_off, `date`,
	ROW_NUMBER() OVER (
	PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`
	) AS row_num
FROM 
	world_layoffs.layoffs_staging;


SELECT *
FROM (
	SELECT company, industry, total_laid_off, percentage_laid_off, `date`,
	ROW_NUMBER() OVER (
	PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`
	) AS row_num
FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;*/ -- Draft

SELECT *
FROM world_layoffs.layoffs_staging
WHERE company = 'Oda';

SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
		PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
		) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;


/*WITH DUPLICATE_CTE AS 
(
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1
)
DELETE
FROM DUPLICATE_CTE; */ -- Draft

/*WITH DELETE_CTE AS (
	SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, 
    ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
	FROM world_layoffs.layoffs_staging
)
DELETE FROM world_layoffs.layoffs_staging
WHERE (company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, row_num) IN (
	SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, row_num
	FROM DELETE_CTE
) AND row_num > 1;

ALTER TABLE world_layoffs.layoffs_staging ADD row_num INT;

SELECT *
FROM world_layoffs.layoffs_staging;*/ -- Draft

CREATE TABLE `world_layoffs`.`layoffs_staging_2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int Default Null,
`row_num` INT
);

INSERT INTO world_layoffs.layoffs_staging_2
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging;

SELECT * 
FROM world_layoffs.layoffs_staging_2
WHERE row_num >= 2;

DELETE 
FROM world_layoffs.layoffs_staging_2
WHERE row_num >= 2;

SELECT *
FROM world_layoffs.layoffs_staging_2;


-- Standardizing data

-- Company

SELECT company, TRIM(company)
FROM layoffs_staging_2;

UPDATE layoffs_staging_2
SET company = TRIM(company);

-- Industry

SELECT DISTINCT industry
FROM layoffs_staging_2
ORDER BY 1;

SELECT *
FROM layoffs_staging_2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging_2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Country

SELECT DISTINCT country
FROM layoffs_staging_2
ORDER BY country;

UPDATE layoffs_staging_2
SET country = TRIM(TRAILING '.' FROM country);

SELECT DISTINCT country
FROM layoffs_staging_2
ORDER BY country;

-- Date

SELECT `date`,
str_to_date(`date`,'%m/%d/%Y')
FROM layoffs_staging_2;

UPDATE layoffs_staging_2
SET `date` = str_to_date(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging_2
MODIFY COLUMN `date` DATE;

-- Managing Null Values

SELECT *
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging_2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging_2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging_2
WHERE company LIKE 'Bally%';

SELECT t1.industry, t2.industry
FROM layoffs_staging_2 t1
JOIN layoffs_staging_2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging_2 t1
JOIN layoffs_staging_2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging_2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging_2;