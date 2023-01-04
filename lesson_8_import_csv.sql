/*
	Lesson-9 29.12
    Import Csv
*/

SELECT * FROM SIM_CARDS;

 #DROP TABLE IF EXISTS sim;
#DROP TABLE IF EXISTS application;
USE employees;

DESC SIM_CARDS;

SELECT *
FROM application;


SELECT * 
FROM sim;


ALTER TABLE SIM_CARDS
RENAME  TO  sim;

ALTER TABLE sim
RENAME COLUMN CHANGE_USER TO   change_user ;

DESC sim;
/*
	STR_TO_DATE - конвертувати строку в дату 
    (column_name, 'Формат строки(шаблон строкі щоб конвертувати)')
*/
SELECT STR_TO_DATE('18.08.2022', '%d.%m.%Y');

SELECT STR_TO_DATE('14:51:23', '%s:%i:%H');

SELECT STR_TO_DATE('18.08.2022 14:51:23','%d.%m.%Y %s:%i:%H' );

SELECT *
FROM sim;



UPDATE employees.sim
SET 
CHANGE_DATE = str_to_date(CHANGE_DATE,  '%d.%m.%Y  %H:%i:%s');



SELECT * FROM sim;

RENAME TABLE sim_cards TO sim;

SELECT * FROM sim;

ALTER TABLE sim
RENAME COLUMN  CHANGE_USER TO change_user;



SELECT * FROM sim;

DESC sim;


SELECT CONCAT(SUBSTR('ANNA', 1, 1), LOWER(SUBSTR('ANNA', 2 ))) AS 'Name';

# Task 1. Змінити назву всіх колонок на lower_case

# Task 2. Змінити тип колонки change_date на DATA
ALTER TABLE sim 
CHANGE COLUMN  CHANGE_DATE change_date DATE;

# Task 3. Змінити тип колонок text на varchar(64)
DESC sim;

ALTER TABLE sim 
CHANGE COLUMN CHANGE_USER change_user VARCHAR(64),
CHANGE COLUMN PUK1 puk1 VARCHAR(64);


# Task 4. Перевести change_user в нормальний формат(Перша літера з великої, всі інші з маленької)
UPDATE employees.sim
SET 
change_user =  CONCAT( substring(change_user, 1, 1), LOWER(substring(change_user, 2 )));


# Second part - Use table from different DB
DROP DATABASE tempdb;

CREATE DATABASE IF NOT EXISTS  tempdb;


USE tempdb;

CREATE TABLE titles AS  # Створили і заповнили таблицю з іншої бд
SELECT * FROM employees.titles;

SELECT * FROM
 titles;
 
 
SELECT *
FROM employees.employees AS  em, 
 tempdb.titles AS  tt
WHERE em.emp_no = tt.emp_no
AND tt.to_date > CURRENT_DATE();

SHOW TABLES;

# new version of join
SELECT  *
FROM employees.employees em
INNER JOIN titles AS  tt
ON (em.emp_no = tt.emp_no)
WHERE tt.to_date > CURRENT_DATE();


SELECT *
FROM tempdb.titles  AS tt
WHERE tt.to_date > current_date()
AND tt.emp_no IN ( SELECT  em.emp_no
       FROM employees.employees  AS em
       WHERE em.gender = 'M' );