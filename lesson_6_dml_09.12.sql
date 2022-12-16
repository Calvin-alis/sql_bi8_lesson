# Lesson  6: 09.12.22  - 14.09.22
/*
  Update, 
  Insert, 
  TRANSACTION,
  Delete,
  TRUNCATE
*/
CREATE DATABASE IF NOT EXISTS lesson_6;

USE lesson_6;

SHOW TABLES;

SELECT * FROM dept_emp;



SELECT * FROM employees;

# DML(Data Manipulation Language) - Select, Insert, Update, Delete
# DDL(Data Definition Language) - Create, Alter, Drop, Rename
# DCL(Data Control Language) - Grant, Revake
# TCL(Transaction Control Language) - Savepoint, Commit, Rollback 

/* CRUD 
	Create
    Read/Rewrite 
    Update
    Delete 
*/

# DROP TABLE tasks;

select 1 + 1;
# IF NOT EXISTS

CREATE TABLE IF NOT EXISTS  tasks(
	task_id INT AUTO_INCREMENT, # +1 
	title VARCHAR(255) NOT NULL, 
    start_date DATE,
    due_date DATE,
    priority TINYINT NOT NULL DEFAULT 3,
    description TEXT,
    PRIMARY KEY(task_id)
    );
    

 DESC tasks;

SELECT * FROM tasks;



# INSERT - добавить значение

INSERT INTO tasks VALUES ('Learn mysql INSERT', 1);

# Добавить данные в таблицу(перечислить колонки)  
INSERT INTO tasks(title, priority) 	VALUES 
						('Learn mysql INSERT', 1);


INSERT INTO tasks(title) 	VALUES 
						('Learn mysql INSERT without prio');
                        
SELECT * 
FROM tasks;

INSERT INTO tasks(title, priority) 	
VALUES ('Learn mysql INSERT with Default', DEFAULT); # Звертаемся до default значення

SELECT * FROM tasks;

INSERT INTO tasks(start_date, priority) 	VALUES (NOW(), 1); # будет ошибки из за NOT NULL


INSERT INTO tasks(title, start_date, due_date, priority, description)
 VALUES ('Learn mysql INSERT', CURRENT_DATE(),CURRENT_DATE(),1, 'test');

SELECT * FROM tasks;

# Якщо потрібно більше ніж один раз вставити значення
INSERT INTO tasks VALUES 
								(8,'Learn mysql INSERT', CURRENT_DATE(),CURRENT_DATE(),1 ,'test2'),
                                (9,'Learn mysql INSERT', CURRENT_DATE(),CURRENT_DATE(), 2, 'test3'),
                                (10,'Learn mysql INSERT', CURRENT_DATE(),CURRENT_DATE(), 4 ,'test4'),
                                (12,'Learn mysql INSERT', CURRENT_DATE(),CURRENT_DATE(), 5 , 'test5');


INSERT INTO tasks(task_id, title) VALUES 
								(10001, 'Insert task_id');
					
                    
INSERT INTO tasks( title) VALUES 
								('Return Id 10002 task_id');

DESC tasks;

SELECT * FROM tasks;


INSERT INTO tasks(title, start_date, due_date, description)  VALUES
								('Learn mysql INSERT', CURRENT_DATE(),CURRENT_DATE(),'test2');
					
                    
INSERT INTO tasks(title) VALUES ('Try default');

INSERT INTO tasks(title, priority) 
SELECT dept_name, 1
FROM employees.departments;

SELECT * FROM tasks;

INSERT INTO tasks(title, priority)  VALUES
('Count of deparments', (SELECT COUNT(dept_name) FROM employees.departments));

SELECT * FROM tasks;
 
 /*
	Task 1. Try Insert
	Вставити в таблицю Tasks - значення назви(title) 'test', пріорітет - використати дефолтний 
    дата_до якої виконати - поточна
    дата початку - 5 років від поточної 
 */
 DESC tasks;
 

 
 INSERT INTO tasks(title, start_date, priority,due_date) VALUES
 ('test', CURRENT_DATE(), DEFAULT,  DATE_SUB(curdate(), INTERVAL 5 year));
  
  
 SELECT * FROM tasks;
 
# DROP TABLE stats;


CREATE TABLE stats (
    c1 INT,
    c2 INT,
    c3 INT
);

DESC stats;

SELECT * FROM stats;

INSERT INTO stats(c1,c2,c3)
VALUES( 
					(SELECT MAX(salary) FROM employees.salaries),
                    (SELECT COUNT(emp_no) FROM employees.employees),
                    (SELECT MIN(salary) FROM employees.salaries) ) ;


SELECT * FROM stats;

# DROP TABLE emplo_dup1;

CREATE TABLE   lesson_6.emplo_dup1 LIKE employees.employees;

SELECT * FROM emplo_dup1;

DESC emplo_dup1;

# Повністю очистити данні з таблиці
TRUNCATE  TABLE lesson_6.emplo_dup1;


SELECT * FROM emplo_dup1;


INSERT INTO emplo_dup1
SELECT * 
FROM employees.employees 
WHERE emp_no < 10050;


SELECT * FROM emplo_dup1;


# WHERE 
SELECT * FROM emplo_dup1;

# 1 - дія 
select * from emplo_dup1 
WHERE emp_no = 10001;

# 2 - дія
UPDATE emplo_dup1  # обираемо таблицю
SET  # вказати зміну
first_name  = 'new name', last_name = 'new last name' 
WHERE emp_no = 10001 OR emp_no = 10002;

UPDATE emplo_dup1  # обираемо таблицю
SET  # вказати зміну
gender  = 'F', last_name = 'new last name' 
WHERE emp_no = 10001;

SELECT * FROM emplo_dup1;



UPDATE emplo_dup1 
SET 
				first_name  = 'You name',
				last_name = 'New last name',
				hire_date = CURRENT_DATE()
WHERE emp_no = 10002;

SELECT * FROM emplo_dup1;

/*
	Змінити дату прийняття на роботу, 
    для всіх у кого id менше 10050 і рік прийняття на роботу більше ніж 1990
    hire_date - на поточну
*/
SELECT *
FROM emplo_dup1
WHERE YEAR(hire_date) > 1990;

UPDATE emplo_dup1
SET
	hire_date = NOW()
WHERE emp_no < 10050 AND YEAR(hire_date) > 1990;

SELECT * FROM emplo_dup1;


# Update - дві і більше таблиці
CREATE TABLE salaries_dup LIKE employees.salaries;

DESC salaries_dup;

INSERT INTO salaries_dup
SELECT *
FROM employees.salaries
WHERE emp_no < 10050 OR salary > 150000;

SELECT * FROM salaries_dup;

DESC salaries_dup;


CREATE TABLE lesson_6.titles_dup LIKE employees.titles;

INSERT INTO titles_dup
SELECT *
FROM employees.titles
WHERE emp_no < 10050;

SELECT * FROM titles_dup;


UPDATE emplo_dup1
INNER JOIN lesson_6.titles_dup USING(emp_no)
SET
first_name = title, 
last_name = title,
hire_date = from_date
WHERE NOW() BETWEEN from_date AND to_date AND length(titles_dup.title) < 10;

SELECT * FROM emplo_dup1;


SELECT * FROM titles_dup;

UPDATE emplo_dup1  
INNER JOIN lesson_6.salaries_dup USING(emp_no)
SET
 first_name = 'some_test_valu',
salary = salary - 100000
WHERE
salary > 80000;

SELECT * FROM emplo_dup1;

SELECT * FROM salaries_dup;


# Best practice 
START TRANSACTION;

UPDATE emplo_dup1 SET 
first_name  = 'You name',
last_name = 'New last name',
hire_date = CURRENT_DATE();

SELECT * FROM emplo_dup1;

ROLLBACK; # COMMIT;


SELECT *
FROM emplo_dup1;


# Delete 
SELECT * FROM emplo_dup1;

DELETE 
FROM emplo_dup1
WHERE emp_no = 10001;

SELECT * FROM emplo_dup1;

DELETE 
FROM emplo_dup1
ORDER BY emp_no DESC
LIMIT 5;

SELECT * FROM emplo_dup1;

DELETE
FROM emplo_dup1
WHERE emp_no BETWEEN 10001 AND 10010
ORDER BY emp_no ASC
LIMIT 5; 

SELECT * FROM emplo_dup1;

# DROP TABLE emplo_dup2;

CREATE TABLE emplo_dup2 LIKE employees.employees;

INSERT INTO emplo_dup2
SELECT * FROM employees.employees WHERE emp_no < 10050;


SELECT * FROM lesson_6.emplo_dup1 AS  d1
INNER JOIN lesson_6.emplo_dup2 AS d2 USING(emp_no);


DELETE d1.*, d2.*
FROM lesson_6.emplo_dup1 AS  d1
INNER JOIN lesson_6.emplo_dup2 AS d2 USING(emp_no);

SELECT * FROM emplo_dup1;

SELECT * FROM emplo_dup2;

TRUNCATE TABLE emplo_dup2;

