USE employees;

DELIMITER $$
CREATE PROCEDURE avg_salary()
BEGIN
	SELECT 
		ROUND(AVG(salary),2)
    FROM
		salaries;
END$$

DELIMITER ;

CALL avg_salary();

DELIMITER $$

CREATE PROCEDURE emp_info(IN f_n VARCHAR(14), l_n VARCHAR(16), out e_n INT)
BEGIN
	SELECT emp_no
    INTO e_n
    FROM employees
    WHERE first_name = f_n and last_name = l_n;
END$$

DELIMITER ;

SET @v_emp_no = 0;
CALL emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;

DELIMITER $$
CREATE FUNCTION f_emp_info (f_name VARCHAR(255), l_name VARCHAR(255)) RETURNS DECIMAL(10,2)
DETERMINISTIC NO SQL READS SQL DATA
BEGIN

DECLARE v_salary DECIMAL(10,2);
DECLARE v_max_date DATE;

SELECT 
    MAX(s.from_date)
INTO v_max_date FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no
WHERE
    e.first_name = f_name
        AND e.last_name = l_name;
        
SELECT 
    s.salary
INTO v_salary FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no
WHERE
    e.first_name = f_name
        AND e.last_name = l_name
        AND s.from_date = v_max_date; 

RETURN v_salary;

END$$

DELIMITER ;

SELECT f_emp_info('Aruna', 'Journel');

-- Create a trigger that checks if the hire date of an employee is higher than the current date. If true, set this date to be the current date. Format the output appropriately (YY-MM-DD).
DELIMITER $$
CREATE TRIGGER t_hire_date
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
DECLARE v_c_d DATE;
SET v_c_d = DATE_FORMAT(SYSDATE(), '%Y-%m-%d') ;
	IF NEW.hire_date > v_c_d THEN
		SET NEW.hire_date = v_c_d;
	END IF;
END$$
DELIMITER ;

DROP TRIGGER t_hire_date;
INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  

DELETE FROM employees WHERE emp_no = 999904;

SELECT 
    *
FROM
    employees
ORDER BY emp_no DESC;

ALTER TABLE employees
DROP INDEX i_hire_date;

-- Select all records from the ‘salaries’ table of people whose salary is higher than $89,000 per annum. Then, create an index on the ‘salary’ column of that table, and check if it has sped up the search of the same SELECT statement.

SELECT 	
	*
FROM 
	salaries 
WHERE salary > 89000;

CREATE INDEX i_salary ON salaries(salary);

-- Similar to the exercises done in the lecture, obtain a result set containing the employee number, first name, and last name of all employees with a number higher than 109990. Create a fourth column in the query, indicating whether this employee is also a manager, according to the data provided in the dept_manager table, or a regular employee. 
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN d.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
    END AS is_manager
FROM
    employees e
        LEFT JOIN
    dept_manager d ON e.emp_no = d.emp_no
WHERE
    e.emp_no > 109990;

-- Extract a dataset containing the following information about the managers: employee number, first name, and last name. Add two columns at the end – one showing the difference between the maximum and minimum salary of that employee, and another one saying whether this salary raise was higher than $30,000 or NOT.
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS dif,
    IF(MAX(s.salary) - MIN(s.salary) > 30000,
        'Salary was raised by more then $30,000',
        'Salary was NOT raised by more then $30,000') AS salary_increase,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more then $30,000'
        ELSE 'Salary was NOT raised by more then $30,000'
    END AS salary_raise
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY s.emp_no , e.first_name , e.last_name;

SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    CASE
		WHEN MAX(d.from_date) >SYSDATE() THEN 'Is still employed'
        ELSE 'Not an employee anymore'
	END AS current_employee
FROM
	employees e
		LEFT JOIN dept_emp d ON d.emp_no = e.emp_no
GROUP BY e.emp_no
LIMIT 100;       