/*
	Lesson-8 29.12.22 - Index 
*/

USE employees;


DESCRIBE employees;

SHOW FULL PROCESSLIST;  # Показати всі процесси в системі 

KILL 28;  # Видалити процесс за Id

SHOW ENGINES;
 
 EXPLAIN SELECT * FROM 
employees AS e
INNER JOIN employees  AS ee;

EXPLAIN SELECT * FROM 
employees AS e
INNER JOIN salaries  AS ee USING(emp_no);

SELECT *
FROM employees
WHERE emp_no = 10050;

/*
	key - value: Кластерозований індекс. Один на всю таблицю.
    adress - key: Місце в області(heap)
    
    Типи індексів:
    Unique - унікальні індекси, можуть бути Null
    Simple/Regular/Normal index: Не кластеризований  індекс(не відсортований). Може бути до 1000 таких індексів.
    FullText index: для Blob/Text типів 
    Descending index: Від більшого до меньшого
*/

SHOW ENGINES;


SELECT COUNT(*) 
FROM employees;


SELECT * 
FROM employees;

SHOW INDEX FROM employees;



SELECT 
	COUNT(DISTINCT emp_no), COUNT(DISTINCT birth_date), COUNT(DISTINCT first_name),
	COUNT(DISTINCT last_name), COUNT(DISTINCT gender), COUNT(DISTINCT hire_date)
    FROM employees.employees;


SELECT emp_no, last_Name, first_Name
FROM employees
WHERE last_Name LIKE 'Ranta'; # 0.129 


    
EXPLAIN SELECT emp_no, last_Name, first_Name
FROM employees
WHERE last_Name LIKE 'Ranta'; # 0.112 

/*
	possible_keys - Ключі які можуть бути примінені для запиту
    key - який ключ був вибраний 
    rows - скільки значеннь потрібно пройти(перебрати)
    filtered - рівень фільтрація 
*/

# DROP INDEX last_Name ON  employees;

CREATE INDEX last_Name ON employees(last_Name); # Створити index, вказуемо імя ON на якій таблиці(колонку по якій буде індекс)

# DROP INDEX hireDate ON employees.employees;

SELECT emp_no, last_Name, first_Name
FROM employees
WHERE last_Name LIKE 'Ranta'; # 0.00091 


SELECT  0.112 / 0.0011;


EXPLAIN  SELECT emp_no, last_Name, first_Name
FROM employees
WHERE last_Name LIKE 'Ranta'; # 0.0012
 
 
 
SHOW INDEX FROM employees; # Показати всі індекси з таблиці

 /*
 Task 1. 
 Виконати запит на знаходження всіх співробітників в кого імя Parto (виконати без створення індексів) 
 Записати час виконання + виведення. 
 Зробити Explain для запиту.
 Створити індекс для first_name і порівняти результати
 */
 
 SELECT * 
 FROM employees
 WHERE first_Name LIKE 'Parto'; # Час виконання 0.167
 
 
 EXPLAIN  SELECT * 
 FROM employees
 WHERE first_Name LIKE 'Parto';
 
 
 CREATE INDEX firstName ON employees(first_Name);
 
EXPLAIN SELECT * 
 FROM employees
 WHERE first_Name LIKE 'Parto'; # Час виконання 0.0013
 
 SELECT  0.167 / 0.0013;
 
 
 EXPLAIN  SELECT * 
 FROM employees
 WHERE first_Name LIKE 'Tzvetan';
 
 
 # Індекс по двух колонках 
  
 EXPLAIN SELECT * 
 FROM employees
 WHERE first_Name LIKE 'Tzvetan' AND last_name LIKE 'Zielinski';  
 
 DROP INDEX first_and_last_name ON employees; # Видалити індекс, вказуемо імя індекса і де його знайти
 
CREATE INDEX first_and_last_name ON employees (first_name, last_name);  # Створити індекс по двум колонкам

# Cardinality - Чим більше, тим зліва  будемо використовувати 
SELECT 
COUNT( DISTINCT first_name), COUNT( DISTINCT last_name ) 
FROM employees;


CREATE INDEX first_and_last_name ON employees (last_name, first_name); 


/*
	WHERE  col1 = 1 and col2 = D
    
    col1  col2
	1	 	  A 	
    1	  	  B
    1		  C
    1		  D
    2		  E
    2		  F
    2		 G
    2		 H
    Index(col1, col2) = 4 * 1 = 4
    Index(col2, col1) = 1 * 1 = 1
*/
EXPLAIN SELECT * FROM 
employees AS e
INNER JOIN employees  AS ee;

# Кількість ітерацій які повинно бути виконанно 
SELECT 297802 * 297802;


# Index for JOIN
EXPLAIN SELECT ee.emp_no, ee.first_name, ee.last_name, es.salary
 FROM employees.employees AS ee
INNER JOIN  employees.salaries AS es USING(emp_no);  
 
EXPLAIN SELECT ee.emp_no, ee.first_name, ee.last_name, es.salary
 FROM employees.employees AS ee
INNER JOIN  employees.salaries AS es USING(emp_no)
WHERE ee.last_name LIKE 'Ranta';  


 EXPLAIN
 SELECT * FROM 
 employees
 WHERE gender = 'F';
 
 CREATE INDEX gender ON employees(gender);
 
 DROP INDEX gender ON employees;
 
 SELECT * FROM 
 employees
 WHERE gender = 'F'; # 0.0010
 
 EXPLAIN SELECT * FROM 
 employees
 WHERE gender = 'M'; 
 
#select 0.144 / 0.0017;

SHOW INDEX FROM salaries;

DROP INDEX To_date ON salaries;

SELECT *
FROM salaries;

CREATE INDEX To_date ON salaries(to_date);

EXPLAIN 
SELECT 
to_date 
FROM salaries;

EXPLAIN SELECT emp_no, last_Name, first_Name
FROM employees
WHERE last_Name like 'Ranta';


SELECT  LOWER('Ranta'), UPPER('Ranta');


EXPLAIN SELECT emp_no, last_Name, first_name
FROM employees
WHERE LOWER(last_Name)   LIKE 'R_nta'; # Виключиться  індекс через функцію lower/upper


EXPLAIN SELECT emp_no, last_Name, first_Name
FROM employees
WHERE UPPER(last_Name) like 'RANTA';


SHOW INDEX FROM employees;

EXPLAIN SELECT emp_no, last_Name, first_Name
FROM employees  IGNORE INDEX (last_Name, firstName) # Вказуємо індекси які будуть ігноровані 
WHERE last_Name LIKE 'Ranta';


SELECT emp_no, last_Name, first_Name
FROM employees  IGNORE INDEX (last_Name, firstName)
WHERE last_Name like 'Ranta';

select * from salaries;

SELECT * FROM employees;

CREATE INDEX last_Name_prefix ON employees(last_Name(8)); # Створюємо  префіксний індекс, буде індекс по першим 8 символам


EXPLAIN SELECT *
FROM 	employees
INNER JOIN salaries;

SELECT  298936 * 1770864;


EXPLAIN 
SELECT *
FROM 	employees.employees
INNER JOIN employees.salaries USING(emp_no);

CREATE INDEX hireDateE ON employees(hire_date, first_name);

CREATE INDEX hireDate ON employees(hire_date );

SELECT * FROM employees;

SHOW INDEX FROM employees;

 EXPLAIN SELECT *  FROM
employees 
WHERE YEAR(hire_date) = 1985;

 EXPLAIN SELECT *  FROM
employees 
WHERE hire_date LIKE  '1985%';


EXPLAIN SELECT *  FROM
employees 
WHERE hire_date LIKE '1985-01-01';


EXPLAIN SELECT *  FROM
employees 
WHERE hire_date = '1985-01-01';


EXPLAIN SELECT *  FROM
employees 
WHERE hire_date BETWEEN '1985-01-01' AND '1999-01-01'; 


EXPLAIN SELECT *  FROM
employees.employees FORCE INDEX (hireDate) # Вказуємо який індекс потрібно використати (ключове слово FORCE)
WHERE hire_date BETWEEN '1985-01-01' AND '1999-01-01'; 


EXPLAIN SELECT *  FROM
employees.employees FORCE INDEX (hireDate) # Вказуємо який індекс потрібно використати (ключове слово FORCE)
WHERE hire_date LIKE '1985%'; 

EXPLAIN SELECT *  FROM  
employees.employees IGNORE INDEX (hireDate) # Ігноруємо індекс , ключове слово IGNORE
WHERE hire_date BETWEEN '1985-01-01' AND '1999-01-01'; 



SHOW INDEX FROM employees;

ALTER TABLE employees.employees 
ALTER INDEX last_Name INVISIBLE; #  Робимо індекс не можливим для використання 

EXPLAIN SELECT emp_no, last_Name, first_Name
FROM employees  IGNORE INDEX(last_name_prefix)
WHERE last_Name like 'Ranta';


# Видалення індексів 
CREATE INDEX last_Name ON employees(last_Name);

DROP INDEX last_Name ON employees;

ALTER TABLE employees
DROP INDEX last_Name;


DROP INDEX last_Name ON employees
ALGORITHM = INPLACE  
LOCK = DEFAULT;


DROP INDEX last_Name ON employees
ALGORITHM = COPY # Створюється копія таблиці без індекс(без можливості insert/delete)

LOCK = DEFAULT;


DROP TABLE IF EXISTS t;


CREATE TABLE IF NOT EXISTS  t (
pk INT PRIMARY KEY,
c VARCHAR(10)
);

DESCRIBE t;

# DROP INDEX `PRIMARY` ON t;

CREATE INDEX sal_desc ON salaries(salary DESC);

EXPLAIN 
SELECT *
FROM salaries
WHERE salary > 10050
ORDER BY salary ;

SHOW INDEXES FROM employees;

/*
	 Сardinality - унікальні значення 
     Visible - включити/виключати індекс
     Expression - вказати довжену строки
*/
CREATE INDEX gender ON employees(gender);

EXPLAIN 
SELECT * 
FROM employees
WHERE gender = 'M';


SHOW INDEXES FROM employees
WHERE VISIBLE = 'YES';


/*
		B-Tree Index - Binary Search - log2N
*/

EXPLAIN select first_name from employees;



SHOW INDEX FROM employees;

DROP TABLE IF EXISTS contacts;

CREATE TABLE IF NOT EXISTS contacts (
	id 							INT 												AUTO_INCREMENT 			PRIMARY KEY,
	first_name 				VARCHAR(50) 							NOT NULL,
	last_name 				VARCHAR(50) 							NOT NULL,
	phone 						VARCHAR(15) 							NOT NULL,
	email 						VARCHAR(100) 							NOT NULL, 						
    UNIQUE KEY unique_email (email)
);

EXPLAIN SELECT * FROM contacts;


SHOW INDEXES FROM contacts;

SELECT * FROM contacts;

INSERT INTO contacts(first_name,last_name,phone,email)
VALUES('John','Doe','(408)-999-9765','john.doe@mysqltutorial.org');


INSERT INTO contacts(first_name,last_name,phone,email)
VALUES('Johny','Doe','(408)-999-4321','john.doe@mysqltutorial.org');

INSERT IGNORE INTO contacts(first_name,last_name,phone,email) # Уникнути помилки, без вставки, пропускає auto_increment
VALUES('Johny','Doe','(408)-999-4321','john.doe@mysqltutorial.org1');


SELECT *
FROM contacts;

CREATE  UNIQUE 	INDEX name_phone 
ON contacts(first_name,last_name, phone);


INSERT INTO contacts(first_name,last_name,phone,email)
VALUES('johny1','doe','(408)-999-9765','john.doe@mysqltutorial1.org');

INSERT INTO contacts(first_name,last_name,phone,email)
VALUES('johny','do','(408)-999-9765','john.doe@mysqltutorial2.org');



EXPLAIN 
SELECT *
FROM employees.employees
WHERE last_name LIKE 'Adam';

EXPLAIN 
SELECT *
FROM employees.employees
WHERE last_name LIKE '_dam'; # відключає індекс 

SELECT LOWER('TRY LOWER');

SELECT UPPER('try upper');

EXPLAIN 
SELECT *
FROM employees.employees
WHERE last_name  LIKE LOWER('Adam');


EXPLAIN 
SELECT *
FROM employees.employees
WHERE last_name  LIKE upper('Adam');


CREATE TABLE complex_talbe (
c1 	INT PRIMARY KEY,
c2	FLOAT,
c3 	INT,
c4  	INT,
INDEX complex_index (c2,c3,c4) # Створюємо індекси під час створення таблиці
);

CREATE INDEX index_name
ON table_name(c2,c3,c4);

INSERT INTO complex_talbe VALUES
(2, 2, 3, 4);




CREATE TABLE try_prefix_index  (
c1 	VARCHAR(50),
c2	VARCHAR(50),
c3 	VARCHAR(50),
c4  	VARCHAR(50),
INDEX complex_index (c2,c3,c4) # Створюємо індекси під час створення таблиці
);

EXPLAIN SELECT * FROM try_prefix_index;

SHOW INDEX FROM 
try_prefix_index;


CREATE INDEX prefix_c1 ON try_prefix_index(c1(5));

SHOW INDEX FROM employees;

ALTER TABLE employees
ALTER INDEX  gender  INVISIBLE; # Змінити видімість ключа, приймає два значення(Visible/Invisible)

DROP INDEX invisibl_hire_date ON employees;

CREATE INDEX invisibl_hire_date ON employees(hire_date) INVISIBLE ; # При створенні індекса по замовчуванню visible

