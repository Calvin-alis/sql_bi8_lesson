/*
	Lesson 7: 16.12.22
    1. Case/ When
    2. IF statement
*/
USE employees;

SELECT *
FROM salaries;


DESC employees;

DESC salaries;

SHOW TABLES;

/*
		Case # Стоверення блоку умову
        WHEN первое условие THEN второе возвращаемое значение
        WHEN первое условие THEN второе возвращаемое значение
		ELSE - вернет условие если не будет выполнено ни одно из них more_than_avgmore_than_avg
        END - конец case
*/
SELECT emp_no, first_name, last_name, gender,
CASE  # Ключове слово 
	WHEN gender = 'M' THEN 0
    WHEN gender = 'F' THEN 1
ELSE 'No info'
END AS 'Binary gender'
FROM employees;



# first form
SELECT emp_no,  first_name, last_name,
	CASE 
		WHEN gender = 'M'  THEN 0
		WHEN gender = 'f' THEN  1
		END AS 'Full gender'
FROM employees.employees;

# second form 
SELECT emp_no,  first_name, last_name, gender, 
	CASE gender WHEN gender = 'm'  THEN 0 ELSE 1 
    END  'Full gender'
    FROM employees.employees;
    
	#,CASE first_name WHEN first_name <> 'Mary' THEN 'Mary'  ELSE 'No mary'
   # END AS 'Like Mary'



SELECT *
FROM employees;

SELECT * FROM 
employees.salaries;

SELECT * FROM 
employees.titles;

SELECT *, 
timestampdiff(YEAR, from_date, NOW()),  
YEAR(NOW()) - YEAR(from_date) 
 FROM 
employees.titles
WHERE timestampdiff(year, from_date, now())  >= 30;

SELECT *, 
CASE  
WHEN timestampdiff(year, et.from_date, now())  < 30 THEN 'less than 30 years in company'
WHEN timestampdiff(year, et.from_date, now())  >= 30 THEN 'more than 30 years in company'
ELSE 'Null'
END AS 'Years in company'
FROM employees.titles AS et;



SELECT es.emp_no,  ee.first_name, ee.last_name, es.salary,
	-- CASE 
	-- 	WHEN gender = 'M'  THEN 'Male'
	-- 	WHEN gender = 'f' THEN 'Female'
    CASE ee.gender WHEN ee.gender = 'M' THEN 'Male' ELSE 'Female' 
		END AS 'Full gender',
	CASE 
		WHEN es.salary < 40000 THEN 'Low'
		WHEN es.salary BETWEEN 40000 AND 70000 THEN 'Low class'
        WHEN es.salary BETWEEN 70000 AND 100000 THEN 'Middle class'
        WHEN es.salary BETWEEN 100000 AND 120000 THEN 'High class'
        ELSE 'Class 1'
        END AS 'Level_of_salary'
FROM employees.salaries AS es
INNER JOIN employees.employees AS ee USING(emp_no);

SELECT *
FROM titles;

SELECT DISTINCT title
FROM titles;

SELECT ee.emp_no, ee.first_name, ee.last_name, ee.gender,
CASE  # Ключове слово 
	WHEN ee.gender = 'M' THEN 0
    WHEN ee.gender = 'F' THEN 1
ELSE 'No info' 
END AS 'Binary gender',
CASE 
	WHEN et.title LIKE 'Engineer' THEN 'Engineer'
    WHEN et.title LIKE 'A%' THEN 'Team lead'
    ELSE NULL
    END AS men
FROM employees as ee
INNER JOIN titles AS et USING(emp_no)
HAVING men IS NOT NULL;

/*
			IF(condition, value_if_true, value_if_false) 
            condition return True or False
*/
SELECT IF(5 > 10, '15 more than 10', '5 less than 10') as 'equal';

SELECT emp_no, salary, IF( salary >= 
 (SELECT AVG(salary) FROM employees.salaries), 'More or equal avg',  'Less that avg ') as 'AVG'
FROM employees.salaries
ORDER BY emp_no ASC
LIMIT 20 , 15;


SELECT es.emp_no,  ee.first_name, ee.last_name, es.salary,
	CASE 
		WHEN gender = 'M'  THEN 'Male'
		WHEN gender = 'f' THEN 'Female'
        ELSE 'Unknown'
		END AS 'Full gender',
	IF(es.salary < (SELECT MAX(salary)  / 2 FROM  employees.salaries) , 'Less than middle', 'More than middle') as 'Compere'
FROM employees.salaries AS es
INNER JOIN employees.employees AS ee USING(emp_no);


/* 
	Вивезти співробітників за групою 
    років роботи(групи створити самим)  в компанії і посадою
*/
SELECT DATE_SUB(NOW(), interval 5 year);

SELECT YEAR(NOW()) - YEAR(DATE_SUB(NOW(), interval 5 year));


SELECT de.emp_no, t.title,
IF (timestampdiff(year, de.from_date, now()) > 15 AND timestampdiff(year, de.from_date, now()) < 20 , 'Less than 21 years in company', 'more than 21 years in company') AS 'Years in company'
FROM dept_emp AS de
INNER JOIN titles AS t USING (emp_no);


SELECT de.emp_no, t.title,
CASE
				WHEN timestampdiff(year, de.from_date, now())  < 30 THEN 'less than 30 years in company'
				WHEN timestampdiff(year, de.from_date, now())  >= 30 THEN 'more than 30 years in company'
				ELSE null
				END AS YEARS
FROM dept_emp AS de
INNER JOIN titles AS t USING (emp_no);


SELECT emp_no, first_name, last_name,
CASE
	WHEN ABS(YEAR(hire_date) - YEAR(now()))  < 20 THEN 'mini period'
	WHEN YEAR(now()) - YEAR(hire_date) BETWEEN 20 AND 30 THEN 'middle period'
	WHEN YEAR(now()) - YEAR(hire_date) > 30 THEN'high period'
END AS period
FROM employees