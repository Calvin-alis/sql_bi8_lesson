/* 
	Lesson - 2. Aggregation function. 23.11 - 28.11
	Topic: 
		1. Type of date
        2. Order by - Add info about type
        3. Aggregation func
        4. Group by 
        5. Having 
        6. Round, Ceil, Floor
*/

USE employees;	

SHOW TABLES;


SELECT * FROM
 salaries;

SHOW  COLUMNS  FROM  employees.salaries; # показывает типы данных в таблице по колонкам


# SELECT md5('');


/* Aggregation func

	max() - find max in column. Example: 		SELECT MAX(salary) FROM employees.salaries;
	min()  - find min in column. Example: 			SELECT MIN(salary) FROM employees.salaries;
    avg()  - find mean in column. Example:  		SELECT AVG(salary) FROM employees.salaries;
    count() - calculate all in column. Example: 	SELECT COUNT(*) FROM employees.salaries;
    sum() - calculate sum. Example: 				SELECT SUM(salary) FROM employees.salaries;
    
 */
SELECT MIN(salary)
 FROM employees.salaries;
 
 SELECT MAX(salary), MIN(salary)
 FROM salaries;
 
 SELECT SUM(salary) 
 FROM employees.salaries;
 
 SELECT AVG(salary) 
 FROM employees.salaries;
 

 # Task 1. Avg - реалізувати avg без avg salary
SELECT SUM(salary) / COUNT(salary)
FROM employees.salaries;


SELECT *
FROM 
employees
WHERE gender = 'M';
 
 SELECT COUNT(*) AS "☀️"
 FROM 
 employees
 WHERE gender = 'M';
 
 SELECT COUNT(*)
 FROM employees 
 WHERE gender = 'F';
 
 
 SELECT COUNT(*)
 FROM employees 
 WHERE gender = 'M';
 
 SELECT gender, COUNT(gender)
 FROM employees
 GROUP BY gender;
 
 SELECT 
 *
 FROM 
 salaries;

 
SELECT 
 emp_no, COUNT(salary), AVG(salary), MAX(salary), SUM(salary)
 FROM 
 salaries
 GROUP BY emp_no;
 
 SELECT 
 first_name, last_name
 FROM 
employees
GROUP BY first_name, last_name;
 
 
 SELECT 
 emp_no , AVG(salary)
 FROM 
 salaries
 WHERE emp_no BETWEEN 10100 AND 10110  
 GROUP BY emp_no;
 
 
 SELECT * FROM 
 employees;


SELECT AVG(salary), ROUND(AVG(salary),  1)
FROM salaries;


# Відобразити Найменьше/Найбільше день на родження (серед M,F)
 
 SELECT MAX(birth_date), MIN(birth_date)
 FROM employees
 WHERE gender = 'F';
 

 SELECT MAX(birth_date), MIN(birth_date)
 FROM employees 
 WHERE gender = 'M';
 
 
 SELECT 
    gender, MIN(birth_date), MAX(birth_date)
FROM
    employees
GROUP BY gender;
 
SELECT  MIN(emp_no), MAX(emp_no)
FROM employees ;



 SELECT first_name, COUNT(emp_no), gender
 FROM employees
 WHERE gender = 'M' AND last_name LIKE  'X%'
 GROUP BY first_name;
 
 
 SELECT * 
 FROM employees;
 
 
SELECT first_name, last_name, COUNT(emp_no)
FROM employees
WHERE first_name = 'Georgi' AND last_name = 'Facello'
GROUP BY first_name, last_name;
 
 
 SELECT emp_no, first_name, last_name
 FROM employees
 WHERE first_name = 'Georgi' AND last_name = 'Facello';
 
SELECT first_name, last_name, COUNT(emp_no)
FROM employees
GROUP BY first_name, last_name
HAVING COUNT(emp_no) = 2;
 
 SELECT first_name, last_name, COUNT(emp_no)
FROM employees
GROUP BY first_name, last_name
HAVING COUNT(emp_no) > 1
ORDER BY COUNT(emp_no) DESC
LIMIT 5;
 
 SELECT SUM(salary), COUNT(salary)
 FROM salaries;
 
 SELECT 4 / 2;
 
  SELECT SUM(salary) / COUNT(salary), AVG(salary)
 FROM salaries;
 
 # A - 15, B - 20, C - 30
 
 SELECT emp_no, SUM(salary), COUNT(salary)
 FROM salaries
 GROUP BY emp_no
 HAVING COUNT(salary) ;
 
/*
	Slide 8
	Task 1: Select all employees whose average salary is higher than $120,000 per  annum.
*/
# Крок 1:  Вивезти таблицю
SELECT * FROM
 salaries;

# Крок 2: AVG 
SELECT AVG(salary) FROM salaries;


# Крок 3: Having 
SELECT 
emp_no, AVG(salary) AS sal
FROM 
salaries
GROUP BY emp_no
HAVING AVG(salary) >= 120000
ORDER  BY sal DESC;


/*
	Slide 11
    Task 1: Select the employee numbers of all individuals who have signed  more than 
    1 contract after the 1st of January 2000.
    Hint: To solve this exercise, use the “dept_emp” table
*/
SELECT * FROM 
dept_emp;


SELECT *
FROM
dept_emp
WHERE from_date LIKE '2__0%';


SELECT 
emp_no
FROM dept_emp
WHERE from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1;


# Use concat 
SELECT CONCAT(first_name , " " , last_name) AS 'Full name'
FROM 
employees;

SELECT * FROM salaries ;

/*
	Slide 12
    Task 1: What is the total amount of money spent on salaries for all contracts 
    starting after the  1st of January 1997?
    starting after the  1st of January 1997?
*/
SELECT * FROM salaries;

SELECT * FROM salaries
WHERE from_date > '1997-01-01';


SELECT SUM(salary)
FROM salaries
WHERE from_date > '1997-01-01';

/*
	Slide 13
    Task 1: Which is the lowest employee number in the database?
	Task 2: Which is the highest employee number in the database?
*/
SELECT MIN(emp_no) FROM employees;

SELECT MAX(emp_no) FROM employees;


SELECT MAX(emp_no)
FROM employees.employees AS ee;


SELECT MIN(emp_no)  min_value , MAX(emp_no) AS "☀️"
 FROM employees;
 

/*
	Slide 15
	Task 1: Show average annual salaries that are above 100k USD paid to  employees
    who started after the 1st of January 1997?
*/

SELECT *
 FROM salaries;
 
 
 SELECT *
 FROM salaries
 WHERE from_date >=  '1997-01-01';


SELECT emp_no 
FROM salaries 
GROUP BY emp_no;


/*
'10066', '100512.8333'
'10068', '110374.2000'
'10136', '104907.3333'
'10151', '106037.2000'
'10173', '104170.3333'
'10232', '102270.8333'
*/
SELECT 
    emp_no, AVG(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01'
GROUP BY emp_no
HAVING AVG(salary) > 100000;



/*
	Slide 17
    Task 1: Round the average amount of money spent on salaries for
    all contracts  that started after the 1st of January 1997 to a precision of cents.
*/
SELECT 
emp_no, ROUND(AVG(salary), 2) AS 'Round'
FROM 
salaries
WHERE to_date > '1997-01-01'
GROUP BY emp_no;


# Round/Ceil/Floor - округлення для float
# Round - округляю до знаку який вкажемо, Ceil - округлення до більшого, Floor - округлення до меншого 
SELECT ROUND(5.1356, 2), CEIL(5.1356), FLOOR(5.9);

SELECT ROUND(3.14159, 2);

SELECT  CEIL(3.14159);

SELECT FLOOR(3.14159);


/*
	Вивести всіх співробітників в кого рік народження між 1955 і 1970
    Наступний пункт sorted 
*/

# First var
SELECT *
FROM employees 
WHERE birth_date BETWEEN '1955-01-01' AND '1970-12-31'
ORDER BY birth_date DESC;


# Second var
SELECT * 
FROM employees
WHERE birth_date >= '1955-01-01' AND birth_date <= '1970-12-31';


/*
	Вивести всіх співробітників кто отримав зп в  2002
    Наступний пункт sorted 
*/
SELECT *
FROM salaries
WHERE from_date <  '2003-01-01' AND from_date >= '2002-01-01'  ;
