-- HR Analytics SQL Project

-- 1. Total Employees
SELECT COUNT(*) AS total_employees
FROM hr_analytics;

-- 2. Employees who left the company
SELECT *
FROM hr_analytics
WHERE attrition = 'Yes';

-- 3. Average salary by department
SELECT
    department,
    ROUND(AVG(monthlyincome),2) AS avg_salary
FROM hr_analytics
GROUP BY department
ORDER BY avg_salary DESC;

-- 4. Attrition rate by department
SELECT
    department,
    COUNT(*) AS employees,
    SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(
        SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*),2
    ) AS attrition_rate
FROM hr_analytics
GROUP BY department
ORDER BY attrition_rate DESC;

-- 5. Employees earning above company average
SELECT
    empid,
    department,
    monthlyincome
FROM hr_analytics
WHERE monthlyincome >
(
    SELECT AVG(monthlyincome)
    FROM hr_analytics
);

-- 6. CTE Example
WITH dept_salary AS
(
    SELECT
        department,
        AVG(monthlyincome) AS avg_salary
    FROM hr_analytics
    GROUP BY department
)
SELECT *
FROM dept_salary
ORDER BY avg_salary DESC;

-- 7. Ranking Employees by Salary
SELECT
    empid,
    department,
    monthlyincome,
    RANK() OVER(
        PARTITION BY department
        ORDER BY monthlyincome DESC
    ) AS salary_rank
FROM hr_analytics;

-- 8. Row Number Example
SELECT
    empid,
    department,
    monthlyincome,
    ROW_NUMBER() OVER(
        PARTITION BY department
        ORDER BY monthlyincome DESC
    ) AS row_num
FROM hr_analytics;

-- 9. Previous Salary Comparison
SELECT
    empid,
    department,
    monthlyincome,
    LAG(monthlyincome) OVER(
        PARTITION BY department
        ORDER BY monthlyincome
    ) AS previous_salary
FROM hr_analytics;

-- 10. Dashboard KPI Query
SELECT
    COUNT(*) AS total_employees,
    AVG(age) AS avg_age,
    AVG(monthlyincome) AS avg_salary,
    SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) AS attrition_count
FROM hr_analytics;