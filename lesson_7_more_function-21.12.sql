/*
	Lesson 7. 21.12.22
    1. CTE
    2. Rand
    3. Substrings/ Reverse
*/
USE employees;


SELECT * FROM
 employees.employees;

# CTE - common table expression 
/*
		WITH - ключове слово
        назва для CTE 
        (колонка один alias, etc) - перераховуємо колонки та псевдоніми 
*/
WITH maxCTE(max_sal) AS (
	SELECT MAX(salary)
    FROM salaries
)

SELECT * FROM salaries 
CROSS JOIN maxCTE ;



WITH testCTE(full_name, id) # Створюємо CTE з назвою testCTE(full_name - псевдонім по колонці)
AS 
	( 
    SELECT CONCAT(first_name, ' ' ,last_name), emp_no
    FROM employees.employees
)

SELECT ee.*, tCte.full_name
 FROM employees AS ee
 INNER JOIN testCTE AS tCte ON(ee.emp_no = tCte.id); # Викликаємо cte


WITH all_sim_name AS (
	SELECT * 
    FROM employees 
    WHERE first_name = last_name
)

SELECT *
FROM all_sim_name;


WITH testMaleCTE(id, first_name, last_name, gender, type, time_t) # Перераховуємо колонки і їх alias 
AS 
	( 
    SELECT emp_no, first_name, last_name, gender, 'Male', now()
    FROM employees.employees
    WHERE gender = 'M' AND emp_no BETWEEN 10050 AND 10060
)

SELECT * 
FROM
employees AS ee
INNER JOIN testMaleCTE AS tmCte ON(ee.emp_no = tmCte.id);


WITH testFemaleCTE(id, last_name, gender, type)
AS (
	SELECT emp_no, last_name, gender, 'Female'
    FROM employees.employees
    WHERE gender = 'F' AND emp_no < 10050
)
 
SELECT  * FROM
testFemaleCTE
INNER JOIN testFemaleCTE AS te USING(id)
INNER JOIN testFemaleCTE AS te1 USING(id)
INNER JOIN testFemaleCTE AS te2 USING(id)
INNER JOIN testFemaleCTE AS te3 USING(id);


WITH testMaleCTE(id, first_name, last_name, gender, type) # Перераховуємо колонки і їх alias 
AS 
	( 
    SELECT emp_no, first_name, last_name, gender, 'Male'
    FROM employees.employees
    WHERE gender = 'M' AND emp_no BETWEEN 10050 AND 10060
),
 testFemaleCTE(id, first_name, last_name, gender, type)
AS (
	SELECT emp_no, first_name, last_name, gender, 'Female'
    FROM employees.employees
    WHERE gender = 'F' AND emp_no < 10050
)

SELECT *  FROM 
	 testFemaleCTE
 UNION ALL
SELECT * FROM 
	testMaleCTE;



SELECT * FROM
employees.salaries;

	
WITH avg_maleCTE(avg_male)
AS (
	SELECT AVG(salary)
    FROM employees.salaries
	WHERE emp_no IN ( SELECT emp_no FROM employees.employees WHERE gender = 'M')
    ),
avg_femaleCTE(avg_female)
AS (
	SELECT AVG(salary)
    FROM employees.salaries
	WHERE emp_no IN ( SELECT emp_no FROM employees.employees WHERE gender = 'F')
)

SELECT  IF((avg_female - avg_male) < 0, (avg_female - avg_male) * -1,avg_female - avg_male  ) , avg_male, avg_female
FROM avg_maleCTE, avg_femaleCTE ;

SELECT 
	(SELECT AVG(salary)
    FROM employees.salaries
	WHERE emp_no IN ( SELECT emp_no FROM employees.employees WHERE gender = 'M')) 
    - 
(
	SELECT AVG(salary)
    FROM employees.salaries
	WHERE emp_no IN ( SELECT emp_no FROM employees.employees WHERE gender = 'F')
);

/*
 Task 1: Вивезти максимальну ЗП по співробітниках в кого id менше ніж 10050,  і мінімальну зп в  діапазоні 10051 та 10099 
 use cte 
 *Додати колонку type - де буде значення min/max
 */
SELECT emp_no, max(salary) AS ms
 FROM salaries
 WHERE emp_no < 10050
 GROUP BY emp_no
 ORDER BY  ms DESC;
 
 SELECT MAX(salary)
 FROM salaries
 WHERE emp_no < 10050;
 
 

WITH max_value_in_idCTE(max_value, type)
AS (
	SELECT MAX(salary), 'max value'
    FROM employees.salaries
	WHERE emp_no  < 10050
    ),
min_value_CTE(min_value, type)
AS (
	SELECT MIN(salary), 'min value'
    FROM employees.salaries
	WHERE emp_no BETWEEN 10051 AND 10099
    )
    
#SELECT m.*, nim.*
#FROM max_value_in_idCTE AS m,  min_value_CTE AS nim;

SELECT *
FROM max_value_in_idCTE
UNION 
SELECT *
FROM min_value_CTE;



# Рекурсия  - виклик функцій сам себе 
# Факторіал !5 = 1 * 2 * 3 * 4 * 5 = 120
WITH RECURSIVE testRecursive(n, value) # n - порядкове значення,  з чим порівнюється
AS (
		SELECT 1, 1
        UNION
        SELECT n  + 1, value * (n + 1)
        FROM testRecursive # <- сам до себе(рекурсія)
		LIMIT 20
)

SELECT * FROM 
testRecursive;


/* 
		Rand  - generate diaposon of 0 to 1 (math [  ) )
        seed - repr you value
        RAND( [seed]) -> RAND(5), 5 is seed

*/
SELECT RAND(); 



SELECT rand(), rand(), rand(); 

SELECT RAND(10);

SELECT RAND(10), RAND(10);

SELECT FLOOR(RAND()*(100 - 1)) * 1000;

SELECT FLOOR(RAND()*(10 - 5) + 5); # диапозон від 5 до 10

SELECT FLOOR(RAND()*(10 - 5 + 1)+5) ;

SELECT FLOOR(RAND()*(10-5+1) + 5) * 1000;

SELECT FLOOR(RAND() * 1000);

# SELECT RAND()*(b - a ) + a; a - звідки, b до куди

SELECT FLOOR(RAND()*(10090 - 10001)+10001);

SELECT *
FROM employees.employees
WHERE emp_no IN ( FLOOR(RAND()*(10090-10001)+10001)); #  Приклад


SELECT *
FROM employees
WHERE emp_no BETWEEN 10010 AND 10190
ORDER BY  RAND() 
LIMIT 10;


WITH random_value(id) AS (
SELECT emp_no
FROM employees
WHERE emp_no BETWEEN 10001 AND 10090
ORDER BY  RAND()
LIMIT 15
)
SELECT *
FROM employees 
WHERE emp_no IN (SELECT * FROM random_value ORDER BY id);
-- ORDER BY emp_no;



# Rand - Вивести  рандомних співробітників
# Рішення студента 
WITH minCTE(emp_no, type) 
AS(
  SELECT MIN(emp_no), 'min emp_no'
    FROM employees
  ),
    
    maxCTE(emp_no, type)
AS (SELECT MAX(emp_no), 'max emp_no'
    FROM employees
    )

SELECT FLOOR(RAND()*(maxCTE.emp_no-minCTE.emp_no)+minCTE.emp_no) AS random_1
FROM maxCTE, minCTE ;


SELECT * 
FROM employees 
ORDER BY RAND()
LIMIT 1;
								
# Рішення студента							
SELECT *
FROM employees
WHERE emp_no BETWEEN (SELECT MIN(emp_no) FROM employees) AND (SELECT MAX(emp_no) FROM employees)
ORDER BY  RAND()
LIMIT 1;

/*
			SUBSTRING, SUBSTR
            (string, start_position, number_of_char) -> ('Hello World!', 1, 5) -> Hello
            All string methods: https://dev.mysql.com/doc/refman/8.0/en/string-functions.html
*/

SELECT substring('Function substring', 9);
# return substring

SELECT SUBSTR('Function substring' FROM 9);
# return substring

SELECT length(substring('Function substring', 1, 9)),substring('Function substring', 1, 9) # Добавити alias
UNION ALL 
SELECT length(substring('Function substring', 1, 10)), substring('Function substring', 1, 10);
# return Function 

SELECT length('Name') ; # 1...len(n)

SELECT substring('Function substring'  FROM 1 FOR 4);
# return Func

SELECT substring('Function substring', 9);
# return substring

SELECT substring('Function substring', -3,  3);
/* Func -> 
			index 1: f, 
            index 2: u,
            index 3: n,
            index 4: c
	Func -> 
			index -1 : c ,
            index -2 : n,
            index -3 : u
#
# return ing

*/
SELECT substring('Function substring' FROM  -3 FOR 3);
# return ing

SELECT substring('Hello World!', -6 );

                
# substring - отримати 3 символа(last) з фрази 'I love sql'
SELECT substring('I love sql', -3);


SELECT substring('I love sql', length('I love sq') - 3);

SELECT substring('I love sql' FROM -3 FOR 3);

SELECT SUBSTR('Hello', 7); # Поверне Null, тому що макс індекс 5, вводе більше ніж 5 буде Null


# Вивести значення другого слова з фрази 'Function substring from'
SELECT LENGTH('Function ') , LENGTH('substring');

SELECT substring('Function substring from' FROM 9 FOR 10 );

SELECT SUBSTR('Function substring from' FROM 
length('Function ') FOR length('substring') + 1);


SELECT dept_no, SUBSTR(dept_name, 1, 1),  dept_name
 FROM departments;
 
 SELECT * FROM employees;
 



# Task 1. К кожному співробітнику вивезти його ініціали у форматі Some Name = S.N
SELECT emp_no, 
	first_name, 
    last_name, 
    concat(substring(first_name, 1, 1),"." ,substring(last_name, 1, 1)) as 'Init'
FROM employees;

 SELECT ee.emp_no, ee.first_name, ee.last_name, init.Initials
FROM 
 employees as ee
 LEFT JOIN (SELECT emp_no,
				CONCAT(
								SUBSTR(first_name, 1 , 1), '.' ,SUBSTR(last_name, 1 , 1)) AS Initials 
				FROM employees) as init 
                USING(emp_no);

/*
	REVERSE - перевернути строку 
    REVERSE (аргумент)
*/

SELECT REVERSE('Name'),REVERSE('annb');


SELECT REVERSE(REVERSE('Name'));


# Task 1. Перевірити і вивезти всіх співробітників, у кого імя палідром
SELECT *, upper(first_name) , lower(first_name)
FROM employees
WHERE first_name = REVERSE(first_name);





