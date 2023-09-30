USE employees;
-- Use a CTE (a Common Table Expression) and a SUM() function in the SELECT statement in a query to find out how many male employees have never signed a contract with a salary value higher than or equal to the all-time company salary average.
WITH cte AS 
(
	SELECT AVG(salary) AS avg_salary FROM salaries
)
SELECT
	SUM(CASE WHEN s.salary <= c.avg_salary THEN 1 ELSE 0 END) AS no_be_m_s,
    COUNT(s.salary) AS no_of_salary_contracts
FROM
	salaries s
		JOIN
	employees e ON s.emp_no = e.emp_no AND e.gender = 'M'
		CROSS JOIN
	cte c;
    
-- Use a CTE (a Common Table Expression) and (at least one) COUNT() function in the SELECT statement of a query to find out how many male employees have never signed a contract with a salary value higher than or equal to the all-time company salary average.
WITH cte AS 
(
	SELECT AVG(salary) AS avg_salary FROM salaries
)
SELECT
	COUNT(CASE WHEN s.salary <= c.avg_salary THEN 1 ELSE NULL END) AS no_be_m_s,
    COUNT(s.salary) AS no_of_salary_contracts
FROM
	salaries s
		JOIN
	employees e ON s.emp_no = e.emp_no AND e.gender = 'M'
		CROSS JOIN
	cte c;
    
-- Use MySQL joins (and don’t use a Common Table Expression) in a query to find out how many male employees have never signed a contract with a salary value higher than or equal to the all-time company salary average (i.e. to obtain the same result as in the previous exercise).
SELECT 
    COUNT(CASE
        WHEN s.salary < a.avg_s THEN 1
        ELSE NULL
    END) AS no_be_m_s
FROM
    (SELECT 
        AVG(salary) AS avg_s
    FROM
        salaries s) AS a
        JOIN
    salaries s
        JOIN
    employees e ON e.emp_no = s.emp_no AND e.gender = 'M'

-- Use two common table expressions and a SUM() function in the SELECT statement of a query to obtain the number of male employees whose highest salaries have been below the all-time average.
WITH cte1 as 
(	
	SELECT AVG(salary) as avg_s
    FROM salaries
),
cte2 AS
(
	SELECT
			s.emp_no, 
            MAX(salary) as h_s
	FROM 
		salaries s 
			JOIN
		employees e ON s.emp_no = e.emp_no AND e.gender = 'M'
	GROUP BY s.emp_no
)
SELECT 
	COUNT(CASE WHEN cte2.h_s < cte1.avg_s THEN 1 ELSE NULL END) as avg_b_s
FROM 
	cte2 
		CROSS JOIN
	cte1;
-- Store the highest contract salary values of all male employees in a temporary table called male_max_salaries.    
CREATE TEMPORARY TABLE male_max_salaries
SELECT
	s.emp_no,
    MAX(s.salary)
FROM
	salaries s
		JOIN
	employees e ON s.emp_no = e.emp_no AND e.gender = 'F'
GROUP BY s.emp_no;

SELECT 
    *
FROM
    male_max_salaries
-- Create a temporary table called dates containing the following three columns: - one displaying the current date and time, - another one displaying two months earlier than the current date and time, and a - third column displaying two years later than the current date and time.
CREATE TEMPORARY TABLE dates
SELECT
	NOW() AS cur_date,
    DATE_SUB(NOW(), INTERVAL 2 MONTH) AS 2_m,
    DATE_SUB(NOW(), INTERVAL -2 YEAR) AS 2_l;

SELECT 
    *
FROM
    dates

-- Create a query joining the result sets from the dates temporary table you created during the previous lecture with a new Common Table Expression (CTE) containing the same columns. Let all columns in the result set appear on the same row.
WITH cte AS
(
	SELECT
		NOW() AS cur_date,
		DATE_SUB(NOW(), INTERVAL 2 MONTH) AS 2_m,
		DATE_SUB(NOW(), INTERVAL -2 YEAR) AS 2_l
)
SELECT * 
FROM dates
		JOIN
    cte;
-- Again, create a query joining the result sets from the dates temporary table you created during the previous lecture with a new Common Table Expression (CTE) containing the same columns. This time, combine the two sets vertically.
WITH cte AS
(
	SELECT
		NOW() AS cur_date,
		DATE_SUB(NOW(), INTERVAL 2 MONTH) AS 2_m,
		DATE_SUB(NOW(), INTERVAL -2 YEAR) AS 2_l
)
SELECT * 
FROM dates
		UNION ALL
SELECT *
FROM cte;

DROP TABLE IF EXISTS male_max_salaries;
DROP TABLE IF EXISTS dates;