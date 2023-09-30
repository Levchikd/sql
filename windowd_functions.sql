USE employees;

-- Write a query that upon execution, assigns a row number to all managers we have information for in the "employees" database (regardless of their department). Let the numbering disregard the department the managers have worked in. Also, let it start from the value of 1. Assign that value to the manager with the lowest employee number.
SELECT 
	*,
    ROW_NUMBER() OVER (ORDER BY emp_no) AS row_num
    FROM
		dept_manager;
-- Write a query that upon execution, assigns a sequential number for each employee number registered in the "employees" table. Partition the data by the employee's first name and order it by their last name in ascending order (for each partition).        
SELECT 
	emp_no,
	first_name,
    last_name,
    ROW_NUMBER() OVER (PARTITION BY first_name ORDER BY last_name ASC) AS row_num
FROM
	employees;
    
SELECT
	dm.emp_no,
	salary,
    ROW_NUMBER() OVER() AS row_num1,
    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num2
FROM
	dept_manager dm
		JOIN 
    salaries s ON dm.emp_no = s.emp_no
ORDER BY row_num1, emp_no, salary ASC;

SELECT
	emp_no,
    first_name,
    last_name,
    ROW_NUMBER() OVER w AS row1
FROM
	employees
WINDOW w AS (PARTITION BY first_name ORDER BY emp_no ASC);
-- Find out the lowest salary value each employee has ever signed a contract for. 
SELECT a.emp_no, a.salary as min_salary
FROM 
(
	SELECT emp_no, salary, ROW_NUMBER() OVER w AS row_n
    FROM salaries
    WINDOW w AS (PARTITION BY emp_no ORDER BY salary ASC) 
) a
WHERE a.row_n = 1;
-- Write a query containing a window function to obtain all salary values that employee number 10560 has ever signed a contract for. Order and display the obtained salary values from highest to lowest.
SELECT 
	emp_no, 
    salary,
	RANK () OVER (ORDER BY salary DESC) as rank_n
FROM 
	salaries
WHERE 
	emp_no = 10560;
    


SELECT 
	emp_no, 
    salary,
	RANK () OVER w as rank_n
FROM 
	salaries
WHERE 
	emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

SELECT
	emp_no,
	salary,
	DENSE_RANK() OVER w AS rank_num
FROM
	salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

SELECT
	e.first_name,
    e.emp_no,
    RANK() OVER w as rank_n
FROM
	employees e 
		JOIN
	salaries s ON e.emp_no = s.emp_no
    AND e.emp_no BETWEEN 10500 AND 10600
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

SELECT
	e.first_name,
    e.emp_no,
    salary,
    DENSE_RANK() OVER w as rank_n,
    YEAR(s.from_date)-YEAR(e.hire_date)
FROM
	employees e 
		JOIN
	salaries s ON e.emp_no = s.emp_no
    AND e.emp_no BETWEEN 10500 AND 10600
WHERE YEAR(s.from_date)-YEAR(e.hire_date) > 4
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

SELECT
	emp_no,
	salary,
    LAG(salary) OVER w AS prev_s,
    LEAD(salary) OVER w AS sub_s,
    salary - LAG(salary) OVER w AS diff_s,
	LEAD(salary) OVER w - salary AS dif_s
FROM
	salaries
 WHERE emp_no BETWEEN 10500 and 10600
 WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);
 
SELECT
	emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
	LAG(salary, 2) OVER w AS 1_before_previous_salary,
	LEAD(salary) OVER w AS next_salary,
	LEAD(salary, 2) OVER w AS 1_after_next_salary
FROM
	salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)
LIMIT 1000;