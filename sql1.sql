COMMIT;

ALTER TABLE departments_dup
DROP PRIMARY KEY;

ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;

ALTER TABLE departments_dup
CHANGE COLUMN dept_no dept_no CHAR(4) NULL;

insert into departments_dup
(
	dept_name
)
Values
(
	'Public Relations'
);

DELETE FROM departments_dup 
WHERE
    dept_no = 'd002'; 

INSERT INTO departments_dup(dept_no) VALUES ('d010'), ('d011');

DROP TABLE IF EXISTS dept_manager_dup;

CREATE TABLE dept_manager_dup (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    from_date DATE NOT NULL,
    to_date DATE NULL
);
 
INSERT INTO dept_manager_dup
select * from dept_manager;

 
INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES 
	(999904, '2017-01-01'),
	(999905, '2017-01-01'),
    (999906, '2017-01-01'),
	(999907, '2017-01-01');

DELETE FROM dept_manager_dup 
WHERE
    dept_no = 'd001';

SELECT 
    e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no;

SELECT
	e.emp_no, e.first_name, e.last_name, d.dept_no, d.from_date
FROM
	employees e
		LEFT JOIN
	dept_manager d ON e.emp_no = d.emp_no
WHERE
	e.last_name = 'Markovitch'
ORDER BY 
	e.emp_no DESC;

SELECT d.*, m.*
FROM
		departments d
			CROSS JOIN
		dept_manager m
WHERE 
	d.dept_no = 'd009' ;

SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    m.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON d.dept_no = m.dept_no
        JOIN
    titles t ON t.emp_no = e.emp_no
WHERE 
	t.title = 'Manager';
    
SELECT 
    e.gender, COUNT(dm.emp_no)
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY gender;

SELECT 
    *
FROM
    (SELECT 
        e.emp_no,
            e.first_name,
            e.last_name,
            NULL AS dept_no,
            NULL AS from_date
    FROM
        employees e
    WHERE
        last_name = 'Denis' UNION SELECT 
        NULL AS emp_no,
            NULL AS first_name,
            NULL AS last_name,
            dm.dept_no,
            dm.from_date
    FROM
        dept_manager dm) AS a
ORDER BY - a.emp_no DESC;

use employees;

SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no IN 
    (
		SELECT 
            *
        FROM
            employees
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01'
	);
	
    
 SELECT 
    e.*
FROM
    employees e
WHERE
	EXISTS
    (
		SELECT 
            *
        FROM
            titles t
        WHERE
            e.emp_no = t.emp_no and title = 'Assistant Engineer'
	);
	  
DROP TABLE IF EXISTS emp_manager;

CREATE TABLE IF NOT EXISTS emp_manager (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11)
);

INSERT INTO emp_manager
SELECT 
    u.*
FROM
    (SELECT 
        a.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS a UNION SELECT 
        b.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS b UNION SELECT 
        c.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no) AS c UNION SELECT 
        d.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no) AS d) as u;

CREATE OR REPLACE VIEW average_salary_managers AS
SELECT 
    ROUND(AVG(salary), 2)
FROM
    salaries s
        JOIN
    dept_manager m ON s.emp_no = m.emp_no;
    
