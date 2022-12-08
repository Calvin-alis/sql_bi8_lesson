/*
	Lesson 6: 07.12.22 - 09.12.22
    Topic:
    1. Set. Operation on set. Union/Union all
    2. Subqueries
    3. CRUD
    4. LIMIT
    5. DML: INSERT/UPDATE/DELETE
*/
SELECT * FROM employees;

SELECT * FROM dept_emp;

SELECT * FROM titles;

SELECT * FROM departments;

SELECT ee.emp_no, ee.last_name, ee.first_name ,et.title, ede.dept_no, ed.dept_name
FROM employees AS ee
INNER JOIN titles AS et USING(emp_no)
LEFT JOIN dept_emp AS ede USING(emp_no)
INNER JOIN departments AS ed ON(ede.dept_no = ed.dept_no)
ORDER BY ee.emp_no;

SELECT * FROM t1;

# Union - Union ALL 

# UNION - унікальні значення
# UNION ALL  - дублікати
SELECT 1
UNION 
SELECT '2'
UNION 
SELECT 'Slovo'
UNION 
SELECT 4;

/*
	Union 				res
    1			2			1
    2			3			2	
    3			4			3
							4
	Union all
	1
	2
	3
	2
	3
	4
*/

SELECT 1
UNION 
SELECT 2;

SELECT 1, 2;

SELECT 1,1, 1, 1
UNION
SELECT 1, 2, 3, 4;


SELECT * 
FROM ( SELECT 1
				UNION
                SELECT 2
                UNION 
                SELECT 3) AS o
UNION 
SELECT * 
FROM ( SELECT 2
				UNION
                SELECT 3
                UNION 
                SELECT 4) AS oo;
                
                

SELECT * 
FROM ( SELECT 1
				UNION
                SELECT 2
                UNION 
                SELECT 3) AS o
UNION ALL
SELECT * 
FROM ( SELECT 2
				UNION
                SELECT 3
                UNION 
                SELECT 4) AS oo;
			
	
SELECT emp_no, birth_date AS flag, 'birth_date' FROM employees 
WHERE emp_no < 10010 AND gender = 'M' 
UNION ALL
SELECT emp_no, salary, 'salary' FROM salaries 
WHERE emp_no BETWEEN 10051 AND 10052 AND salary  > 50000;


SELECT first_name AS 'Name', 'first_name'  AS 'Flag', emp_no FROM employees.employees 
UNION 
SELECT last_name,  'last name', 'Null' FROM employees.employees;


SELECT emp_no, birth_date AS date, 'birthday'  AS flag # <- можна використовувати різні колонки
		FROM employees 
WHERE emp_no <10010
UNION 
SELECT emp_no, hire_date, 'hiredate'
		FROM employees 
WHERE emp_no BETWEEN 10060 AND 10070;


SELECT emp_no, hire_date AS value,  'hire_date' AS type
FROM employees
WHERE emp_no  = 10050
UNION ALL
SELECT emp_no, first_name ,  'first_name' 
FROM employees
WHERE emp_no  = 10051
UNION ALL
SELECT emp_no,  last_name ,  'last_name' 
FROM employees
WHERE emp_no  = 10052;

SELECT COUNT(first_name)
FROM employees;

SELECT first_name FROM employees
UNION 
SELECT first_name FROM employees;


SELECT e.first_name , ee.first_name
FROM employees AS e
INNER JOIN employees AS ee USING(emp_no);


# Slide 5
SELECT
			e.emp_no,   
            e.first_name,   
            e.last_name, 
			NULL  AS dept_no,
			NULL  AS from_date   
 FROM 
			employees AS   e  WHERE last_name  = 'Denis' 
 UNION  
 SELECT   
			NULL  AS emp_no, 
			NULL  AS first_name, 
			NULL  AS last_name, 
			dm.dept_no,   
			dm.from_date
 FROM 
			dept_manager AS dm;

 
# Slide 7
SELECT
		CONCAT(first_Name, ' ' ,last_Name) fullname 
        FROM employees.employees 
        WHERE first_name LIKE 'a%'  
UNION 
        SELECT CONCAT(first_Name,' ',last_Name)
        FROM employees.employees 
        WHERE first_name LIKE 'b%';


/*  	
		Union Task 
        Task 0: Унікальни назви посад, двома  способами
		Task 1: Унікальні назви посад і назви департаментів одним списком
        Task 2: Відобразити всі імена для людей в кого прізвище починається на 'a' і 
        всі іменна для людей починається  'a'
*/
# Task 0: Унікальні назви посад, двома способами 
SELECT * FROM employees.departments;

# First var
SELECT DISTINCT title FROM employees.titles;

# Second var
SELECT title FROM employees.titles
UNION 
SELECT title FROM employees.titles;


# Task 1: Унікальні назви посад і назви департаментів одним списком
SELECT title FROM employees.titles 
UNION 
SELECT dept_name FROM employees.departments;



# Task 2: Відобразити ВСІ імена для людей в кого прізвище починається на 'a' і ВСІ іменна для людей починається  'a'
SELECT first_name AS 'name', 'first_name'
FROM employees.employees WHERE last_name LIKE 'a%' 
UNION ALL
SELECT last_name, 'last_name'
FROM employees.employees WHERE first_name LIKE 'a%' ;


/*
	 Вивезти одним списком всіх співробітників хто отримує зп більше ніж 150000 
     і в тих у кого діапазон  id від 43620 до 43630 з дублікатами
*/
SELECT emp_no
FROM salaries 
WHERE salary > 150000
UNION ALL
SELECT emp_no
FROM employees
WHERE emp_no BETWEEN 43620 AND 43630
ORDER BY emp_no;


/*	Де можемо використовувати sub
		SELECT - (1 - колонка или 1 -  значення)
		WHERE - (1 -  колона або  n -  значення)
		FROM/JOIN - (n - колонок, m - значеннь) + потрібно вказати Alias 
*/

# Вивезти id, імя і призвіще тих співробітників кого ЗП більше ніж 150000(без join)

# Step 1 Знайти всіх кто отримує більше ніж зп 
SELECT DISTINCT emp_no
FROM salaries
WHERE salary > 150000;


# Step 2 Вивезти інформацію
SELECT emp_no, first_name, last_name
FROM employees
WHERE emp_no IN (43624, 46439,47978,66793,80823,109334,493158);


# OR with Subqueries
SELECT emp_no, first_name, last_name
FROM employees
WHERE emp_no IN (
								SELECT DISTINCT emp_no
								FROM salaries
								WHERE salary > 150000 );

# Use Join 
SELECT es.emp_no, first_name, last_name
FROM employees AS ee
INNER JOIN   (
								SELECT DISTINCT emp_no
								FROM salaries
								WHERE salary > 150000 ) AS es USING(emp_no);
                                

/*
 Task 1 Вивезти всіх співробітників(emp_no, first_name, last_name, gender), які були коли-небудь менеджерами
 Реалізувати двома способами(sub in where and sub with join)
*/
SELECT * FROM dept_manager;

SELECT * FROM employees;

# Where statement 
SELECT ee.*
FROM employees.employees AS ee
WHERE ee.emp_no IN (SELECT emp_no FROM dept_manager);


# Inner statement
SELECT ee.*
FROM employees.employees AS ee
INNER JOIN ( SELECT emp_no FROM dept_manager) AS edm USING(emp_no);


SELECT ee.*
FROM ( SELECT emp_no FROM dept_manager) AS edm
INNER JOIN employees.employees AS ee USING(emp_no);



# Task 2: Відобразити всіх співробітників в кого ЗП більше ніж середня ЗП співробітника 10050
SELECT AVG(salary)
FROM employees.salaries
WHERE emp_no = 10050;

SELECT AVG(salary)
FROM employees.salaries;

SELECT emp_no, AVG(salary)
FROM employees.salaries
GROUP BY emp_no;

SELECT * 
FROM  employees.salaries
WHERE salary > ROUND(88987.3333, 2);


SELECT FLOOR(3.94), CEIL(3.14);


# OR
SELECT *
FROM employees.salaries
WHERE salary > 
									ROUND(( SELECT AVG(salary) 
									FROM employees.salaries 
									WHERE emp_no = 10050), 2);


# Task 3: Відобразити всіх співробітників в кого ЗП, більша ніж середня ЗП по компанії
SELECT AVG(salary)
FROM salaries;



SELECT emp_no ,AVG(salary) AS 'Avg employees',  (SELECT AVG(salary) FROM salaries) AS 'Avg по компанії'
FROM employees.salaries
WHERE salary > (SELECT AVG(salary) FROM salaries)
GROUP BY emp_no;




# Deep Sub
# Task 4: Знайти всіх співробітників, у яких зп більше ніж середне зп працівника з найбільшим номером
SELECT * FROM employees.salaries
WHERE salary > 
								(	SELECT AVG(salary) 
									FROM employees.salaries 
									WHERE emp_no = 
																	(SELECT  MAX(emp_no)
                                                                    FROM employees.employees)
                                    )
ORDER BY salary;



 # Step 1 - find more deep sub
 SELECT  MAX(emp_no)  FROM employees.employees;
  
  
 # Step 2 - find less deep sub(up all time)
SELECT AVG(salary) 
FROM employees.salaries 
WHERE emp_no = 499999;
     
     
# Step 3 - find last sub
SELECT * FROM employees.salaries
WHERE salary > 70625.0000
ORDER BY salary;


/*
	Task 5: Вивезти номер співробітників(чоловіків), в яких зп більше ніж середня ЗП серед жінок 
*/
SELECT emp_no
FROM employees 
WHERE gender  = 'm';

SELECT * 
FROM employees 
WHERE gender  = 'f';

SELECT * 
FROM salaries;

SELECT AVG(salary)
FROM salaries 
WHERE emp_no IN (
	SELECT emp_no 
    FROM employees
    WHERE gender = 'F'
);

SELECT AVG(salary) 
FROM salaries 
WHERE emp_no IN 
				(SELECT emp_no
				FROM employees.employees
				WHERE gender = 'F');
              

			
SELECT DISTINCT emp_no, ee.first_name, ee.last_name, ee.gender, salary , 
						(
											SELECT AVG(salary) 
                                            FROM salaries
                                            WHERE emp_no IN 
															(SELECT emp_no 
                                                            FROM employees 
                                                            WHERE gender = 'f')
						) AS 'Avg жінок'
FROM salaries
INNER JOIN employees AS ee USING(emp_no)
WHERE salary > (
						SELECT AVG(salary)
						FROM salaries 
						WHERE emp_no IN (
														SELECT emp_no 
														FROM employees
														WHERE gender = 'F'
)) AND emp_no IN (SELECT emp_no FROM employees WHERE gender = 'M');




# Slide 12 
# Task 1
SELECT 
    first_name, last_name, emp_no
FROM
    employees
WHERE
    emp_no NOT IN (SELECT DISTINCT
            emp_no
        FROM
            dept_manager);
            

# Task 2
SELECT 
    COUNT(emp_no)
FROM
    employees
WHERE
    emp_no NOT IN (SELECT DISTINCT
            emp_no
        FROM
            dept_manager);
            

# Slide 13
SELECT 
    MIN(t1.salary), MAX(t1.salary), AVG(t1.salary)
FROM
    (SELECT 
        YEAR(from_date), SUM(salary) AS salary
    FROM
        salaries
    GROUP BY YEAR(from_date)) AS t1;


# Slide 14
SELECT 
    first_name,
    last_name,
    salary,
    (SELECT 
            ROUND(AVG(salary), 0)
        FROM
            salaries) average_salary,
    salary - (SELECT 
            ROUND(AVG(salary), 0)
        FROM
            salaries) difference
FROM
    (SELECT 
        t1.*, t2.salary
    FROM
        employees t1
    INNER JOIN salaries t2 ON t1.emp_no = t2.emp_no) AS joined_tbls
ORDER BY first_name , last_name;


 /*
	CRUD
	C - CREATE
    R - READ/REWRITE
    U - UPDATE
    D  - DELETE  
 */
 
 # Limit
  SELECT *
 FROM employees 
 WHERE emp_no BETWEEN 10030 AND 10050
 LIMIT 10;
 
 SELECT * 
 FROM employees
 WHERE emp_no BETWEEN 10030 AND 10050
 LIMIT 10, 5;
 
 
 SELECT salary 
 FROM salaries
 ORDER BY salary DESC
 LIMIT 5;
 
/* Add task 

# Task 1: Відобразити всіх співробітників із dept, у котрих найвище зп - Доп. практика

SHOW TABLES;


SELECT * FROM employees.dept_emp
ORDER BY dept_no;


SELECT * from salaries;

SELECT * FROM 
employees.salaries 
WHERE salary = (SELECT MAX(salary) FROM employees.salaries) ;

*/


                                    

