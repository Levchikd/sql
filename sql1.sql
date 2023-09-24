SELECT 
    *
FROM
    employees
WHERE
    gender = 'F'
        AND (first_name = 'Kellie'
        OR first_name = 'Aruna');
        
SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('Denis' , 'Elvis');
    
SELECT 
    *
FROM
    employees
WHERE
    first_name NOT IN ('John' , 'Mark', 'Jacob');
    
USE employees; 
    
SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('Mark%');
    
SELECT 
    *
FROM
    employees
WHERE
    hire_date LIKE ('%2000%');
    
SELECT 
    *
FROM
    employees
WHERE
    emp_no LIKE ('1000_');

SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('%Jack%');
    
SELECT 
    *
FROM
    employees
WHERE
    first_name NOT LIKE ('%Jack%');
    
SELECT 
    *
FROM
    salaries
WHERE
    salary BETWEEN 66000 AND 70000;
    
SELECT 
    *
FROM
    salaries
WHERE
    emp_no NOT BETWEEN 10004 AND 10012;
    
SELECT 
   dept_name
FROM
    departments
WHERE
    dept_no BETWEEN 'd003' AND 'd006';
    
SELECT 
   dept_name
FROM
    departments
WHERE
    dept_no IS NOT NULL;
    
SELECT 
   *
FROM
    employees
WHERE
    hire_date > '2000-01-01' AND gender = 'F';

SELECT 
   *
FROM
    salaries
WHERE
    salary > 150000;
    
SELECT DISTINCT
   hire_date
FROM
    employees;
    
SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    salary >= 100000;
    
SELECT 
    COUNT(*)
FROM
    dept_manager;

SELECT 
    *
FROM
    employees
ORDER BY hire_date DESC;

SELECT 
    salary, COUNT(emp_no) AS emps_with_same_salary
FROM
    salaries
WHERE
    salary > 80000
GROUP BY salary
ORDER BY salary;

SELECT 
    emp_no
FROM
    salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000;

SELECT 
    emp_no
FROM
    dept_emp
WHERE
    from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1
LIMIT 100;

SELECT 
    *
FROM
    titles;

Insert into titles
(
	emp_no,
    title,
    from_date
)
Values
(
	999903,
    'Senior Engineer',
    '1997-10-01'
);

Create table departments_dup
(
	  `dept_no` char(4) NOT NULL,
  `dept_name` varchar(40) NOT NULL,
  PRIMARY KEY (`dept_no`),
  UNIQUE KEY `dept_name` (`dept_name`)
);

Insert	into departments_dup
(
	dept_no,
	dept_name
)
SELECT 
    *
FROM
    departments;

Insert into departments
(
	dept_no,
    dept_name
)
VALUES
(
	'd010',
    'Business analysis'
);

SELECT 
    *
FROM
    departments
ORDER BY dept_no DESC;
    
