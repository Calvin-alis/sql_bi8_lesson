/*
	Lesson 10:  06.01.23
    1. View
    2. Set stament
	3. Partition by
*/

/*
	Test: https://docs.google.com/forms/d/e/1FAIpQLScQ-28IWz_fMhThNCG8KNxNsDFTQG-3xnlLqZdd_9RuBllgWA/viewform
    test_view
*/
USE employees;

/*
	View - Дозволяє працювати з таблицею через запит, данні не зберігаються, тільки отримуємо результат 
    CREATE VIEW назва AS  запит який повертає таблицю 
*/
SELECT * FROM
employees;

DROP VIEW IF EXISTS test_view;

CREATE VIEW  test_view AS  # Створюємо view з назвою test_view, View - virtual table, stored seq, not date
SELECT emp_no
 FROM employees
 WHERE emp_no < 10050 AND gender = 'M';
 
SHOW TABLES;

SELECT * 
FROM test_view;


DROP VIEW IF EXISTS more_than_avg; # Видаляємо view


CREATE OR REPLACE VIEW more_than_avg AS  # Створюємо view з назвою more_than_avg, дозволяємо змінювати код 
SELECT ee.emp_no, ee.first_name, ee.last_name, es.salary
 FROM employees AS ee
 INNER JOIN  salaries AS es USING(emp_no)
 WHERE es.salary > (SELECT AVG(salary) FROM salaries);
 
 
 SELECT  * FROM 
 more_than_avg;
 
 ALTER VIEW more_than_avg AS  # Або оновити запит за допомогою alter
       SELECT ee.emp_no, ee.first_name, ee.last_name
		FROM employees AS ee
		INNER JOIN  salaries AS es USING(emp_no)
		WHERE es.salary > (SELECT AVG(salary) FROM salaries);
 
 SELECT * FROM more_than_avg;

/*
	SET - задати значення змінної 
    
    SET @назва_змінної = значення 
    АБО 
    SET @назва_змінної := значення 
    
*/
SET @counter = 100; # Статично вказуємо значення змінної

SELECT @counter;

SHOW SESSION VARIABLES;


SHOW  GLOBAL VARIABLES;

SET @count := 10; # Інший спосіб вказати значення 

SELECT @count;

SELECT 
	@msrp  := MAX(salary) # Передаємо значення з таблицю в змінну 
FROM 
	salaries
    ;
    
    
SELECT @msrp; 


SELECT *
FROM employees 
WHERE emp_no IN (SELECT emp_no FROM salaries WHERE salary = @msrp); # Використовуємо змінну 


# Task 1. Попередній запит реалізувати без змінних
SELECT *
FROM salaries;

SELECT MAX(salary) 
FROM salaries;

SELECT * 
FROM salaries 
WHERE 
salary = ( SELECT MAX(salary) FROM salaries);


SELECT *
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM salaries 
	WHERE 
	salary = ( SELECT MAX(salary) FROM salaries));
    
    
# Task 2. Використати змінну, показати всю інформацію про співпробітника для всіх чоловіків, кто працює на поточний момент

SELECT POW(25, 0.5);

SET @gender_male = 'M';

SET @curtime = current_date();

# Варіант студента 
SELECT 
 @meninfo  := first_name, last_name, hire_date
 FROM employees AS ee
 INNER JOIN dept_emp AS ede USING(emp_no)
 WHERE ee.gender = "M"
 AND CURDATE() BETWEEN ede.from_date AND ede.to_date;

 
SELECT 
	@emp_no := emp_no
FROM 
employees 
WHERE gender = 'm' ;

SELECT * 
FROM salaries 
WHERE emp_no IN (@emp_no);


SELECT ee.emp_no, ee.first_name, ee.last_name, ee.gender, es.to_date
FROM employees AS ee
INNER JOIN salaries  AS es USING(emp_no) 
WHERE  
	gender  =  @gender_male 
    AND
	@curtime BETWEEN  es.from_date AND es.to_date;
 


 /*
	More information about IF and Case
    IF(statement cond, True, False )
 */
 SELECT IF(1 = 2,'true','false'); -- false

SELECT IF(1 = 1,'true','false'); -- true


SELECT * FROM employees.dept_manager_dup;



SELECT *, IF(dept_no IS NULL, 'N/A', dept_no) dept_no
FROM dept_manager_dup;


SELECT 
    SUM(IF(title = 'Staff', 1, 0)) AS Staff,
    SUM(IF(title = 'Senior Staff', 1, 0)) AS 'Senior Staff'
FROM
    titles;


SELECT 
    COUNT(IF(title = 'Assistant Engineer', 1, NULL)) 'Assistant Engineer',
    COUNT(IF(title = 'Senior Staff', 1, NULL)) 'Senior Staff',
    COUNT(IF(title = 'Engineer', 1, NULL)) 'Engineer',
    COUNT(IF(title = 'Staff', 1, NULL)) 'Staff',
    COUNT(IF(title = 'Technique Leader', 1, NULL)) 'Technique Leader',
    COUNT(IF(title = 'Senior Engineer', 1, NULL)) 'Senior Engineer',
    COUNT(IF(title = 'Manager', 1, NULL)) 'Manager'
FROM
    titles;
    
SELECT SUM(case when title = 'Staff' then 1 else 0 end) as Staff,
               SUM(case when title = 'Senior Staff' then 1 else 0 end) as 'Senior Staff'
FROM titles;


 
/*
	Partition by - Розбиття таблиці 
    Type of part:
		1. Range - вказуємо діапазони(схоже на between)
        2. List - перераховуємо(схоже на in)
        3. Hash - генеруємо hash 
        4. Key - дозволяє інші типи 
	    Range/List/Hash - число, Key - інші типи
*/
DROP TABLE IF EXISTS ti;
CREATE TABLE ti (id INT, 
		amount DOUBLE, 
        tr_date DATE)
    ENGINE=INNODB
    PARTITION BY HASH( MONTH(tr_date) ) # Розбиття на частини
    PARTITIONS 6; # Кількість частин
    
    
DESC ti;

SELECT * FROM ti;
    
CREATE TABLE members (
    firstname VARCHAR(25) NOT NULL,
    lastname VARCHAR(25) NOT NULL,
    username VARCHAR(16) NOT NULL,
    email VARCHAR(35),
    joined DATE NOT NULL
)

PARTITION BY KEY(joined) # стоврюємо розбитя по даті
PARTITIONS 6;

DESC members;


DROP TABLE IF EXISTS members;

CREATE TABLE members (
    firstname VARCHAR(25) NOT NULL,
    lastname VARCHAR(25) NOT NULL,
    username VARCHAR(16) NOT NULL,
    email VARCHAR(35),
    joined DATE NOT NULL
)
PARTITION BY RANGE( YEAR(joined) ) ( # Тип range для partition 
    PARTITION p0 VALUES LESS THAN (1960),
    PARTITION p1 VALUES LESS THAN (1970),
    PARTITION p2 VALUES LESS THAN (1980),
    PARTITION p3 VALUES LESS THAN (1990),
    PARTITION p4 VALUES LESS THAN MAXVALUE
);



