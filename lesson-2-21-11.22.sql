/*
	Lesson 2 - BI8 - 21.11.22
	Start with Sql. Basic - Sql
	1. Типи комментарів
	2. Ключево слово Use, SELECT
	3. Оператор *, та вибір колон з таблиці
	4. Where - блок, AND/OR  
	5. In/Not In - оператори
	6. LIKE/BETWEEN - оператори LIKE(statement _ or %)
	7. Is null/is not null
*/


SELECT "SLOVO";

# Текст 
-- Текст 

/*
	 Текст 
     текст 
     текст 
*/


SELECT 4 * 2;

# Ключове слово Use - вказує що буде обрана по замовчування база даних
USE employees; 

# Show tables - показує всі наявні таблиці в базі даних 
SHOW TABLES;


SELECT # Вказує системі що повинна повернутись таблиця 
* # Оператор * - вказує що повинні повернутись всі значення 
 FROM # Ключове слово необхідне для того щоб вказати де шукати інформацію
 employees # Назва таблиці 
 ; # Закінчуємо команду ;

SELECT first_name, last_name 
FROM employees;


SELECT *
FROM salaries;


SELECT 
    *
FROM
    employees.employees;

# Distinct - повертає тільки унікальні значення 
SELECT emp_no FROM salaries ORDER BY emp_no;

SELECT 
DISTINCT (emp_no)  
FROM 
salaries
ORDER BY emp_no;


/*
	AND - оператор який повертає True/False, необхідно щоб зліва і зправа було True. Логічне та(і)
    OR -  оператор який повертає True/False, необхідно щоб злібо або зправа було True. Логічне або
    
	AND - має більшу пріоритетність виконання ніж OR 
    AND > OR

*/
SELECT *
FROM employees
WHERE first_name = 'Mary' AND gender = 'M';


SELECT *
FROM employees
WHERE first_name  = 'Mary' OR gender = 'M';


/*
	Slide 7. 
	Task 1: Retrieve a list with all female employees whose first name is Kellie.
	Task 2: Select a list of male employees whose first name is ‘Mark’ and all employees whose lastname is ‘Luit’
*/

# Task 1
SELECT *
FROM employees 
WHERE first_name = 'Kellie';

# Task 2
SELECT *
FROM employees
WHERE (first_name = 'Mark'  AND gender = 'M') OR last_name = 'Luit';



# Slide 9. Task 1. Retrieve a list with all employees whose first name is either Kellie or Aruna
SELECT * 
FROM employees
WHERE first_name = 'Kellie' OR first_name = 'Aruna';



/*
	IN - Оператор який проходить по значенню, повертає True/False, в залежності чи знайшло збіг 
	NOT IN - пошук значень які не входят 
 */
SELECT * 
FROM employees
WHERE emp_no IN (10001, 10002, 10005, 10050);


SELECT * 
FROM employees
WHERE emp_no NOT  IN (10001, 10002, 10005, 10050);


/*
	Slide 13
	Task 1: Use the IN operator to select all individuals from the “employees” table, whose first name is either “Denis”, or “Elvis”.
	Task 2: Extract all records from the ‘employees’ table, aside from those with employees named John, Mark, or Jacob.
*/

# Task 1
SELECT
*
FROM 
employees
WHERE first_name 
IN # Дозволяє пройтись по значенню в пошуку відповідності
 ('Denis', 'Elvis');

SELECT
*
FROM 
employees
WHERE first_name =  'Denis' OR first_name =  'Elvis';


# Task 2
SELECT *
FROM employees.employees
WHERE first_name 
NOT IN # Поверні ті результати з таблиці, які не співпадают 
 ('John', 'Marc', 'Jacob');
  


/*
	LIKE оператор - дозволяє шукати специфічні патерни.
	_ - на місці може знаходитись один будь-який символ
    % - дозволяє підставити безліч символів
*/
SELECT *
FROM employees.employees
WHERE first_name 
LIKE # Оператор пошуку патерну  
 'Mar_%'  # 
 ;


SELECT *
FROM employees.employees
WHERE first_name LIKE '%ar%' ;


SELECT *
FROM employees.employees
WHERE first_name NOT LIKE '%a' ; 


/*
	Slide 15
	Task 1: Working with the “employees” table, use the LIKE operator to select the data
	about all individuals, whose first name starts with “Mark”; specify that the name can be succeeded by any sequence of characters.

	Task 2: Retrieve a list with all employees who have been hired in the year 2000.

	Task 3: Retrieve a list with all employees whose employee number is written with 5
	characters, and starts with “1000”.
*/
# Task 1
SELECT * FROM employees 
WHERE first_name LIKE 'Mark%';

# Task 2
SELECT  * FROM employees
WHERE hire_date LIKE '2_00%';

# Task 3
SELECT * FROM employees
WHERE emp_no LIKE '1000_';
 

/*
	Slide 17
	Task 1: Extract all individuals from the ‘employees’ table whose first name contains “Jack”.
	Task 2: Once you have done that, extract another list containing the names of employees that do not contain “Jack”.
*/
# Task 1
SELECT 
*
FROM employees
WHERE first_name LIKE '%Jack%';

# Task 2
SELECT 
*
FROM employees
WHERE first_name NOT LIKE '%Jack%';

 

 
/*
	Between оператор - дозволяє вказати в якому діапазоні повинні знаходить значення 
    Конструкція: 
	значення Between значення_з_якого AND значення_до_якого
*/
SELECT 
* 
FROM employees
WHERE emp_no  BETWEEN 10001 AND 10050;


SELECT 
* 
FROM employees
WHERE emp_no NOT BETWEEN 10001 AND 10050;




/*
	Slide 19
    Task 1: Select all the information from the “salaries” table regarding contracts from 66,000 to 70,000 dollars per year.
	Task 2: Retrieve a list with all individuals whose employee number is not between ‘10004’ and ‘10012’.
	Task 3: Select the names of all departments with numbers between ‘d003’ and ‘d006’.
*/
SHOW TABLES;

SELECT 
* 
FROM salaries;

# Task 1
SELECT 
* 
FROM salaries
WHERE salary BETWEEN 66000 AND 70000;

# Task 2
SELECT 
* 
FROM employees
WHERE emp_no NOT BETWEEN 10004 AND 10012;

# Task 3
SELECT
* 
FROM departments
WHERE dept_no BETWEEN 'd003' AND 'd006';


/*
	IS NULL - перевірка на відсутність значення, повертає True/False, якщо значення не має повертає True
    IS NOT NULL - якщо значення є повертає True
 */
SELECT * 
FROM employees
WHERE emp_no IS NULL;


SELECT * 
FROM employees
WHERE emp_no IS NOT NULL;



/*
	Slide 21
	Task 1: Select the names of all departments whose department number value is not null and 
    names have ‘a’ character on any position or ‘e’ on the second place.
*/
 # Task 1
SELECT
* 
FROM 
departments
WHERE 
dept_name LIKE '%a%' 
OR  
dept_name LIKE '_e%'
AND dept_no IS NOT NULL
ORDER BY # Дозволяє сортувани значення, можете сортувати по декільком колонкам 
 dept_no 
DESC  # ASC - в порядку від меньшого до більшого, Desc - від більшого до меньшого, по замовчуванню Asc
 ;
    
    

/*
	Slide 9 
    Task 1. Get a list of all first names from employees table
    Task 2. Get a list of all unique first names from employees table
    Task 3. Get a list of all department names (without duplicates) from departments table
*/

# Task 1
SELECT first_name 
FROM employees;

# Task 2
SELECT DISTINCT first_name
FROM employees;

# Task 3
SELECT DISTINCT dept_name
FROM departments;


# Alias - дати псевдонім , AS - дати псевдонім 
SELECT 
first_name AS 'Name', # Даємо псевдонім для first_name
 last_name 
FROM employees;

# Concat - дозволяє поєднати 
SELECT *,
CONCAT(emp_no, '  ', dept_no) AS 'Emp_no and Dept_no' # Поєднали значення в двух колонках і дал їм псевдонім 
FROM dept_emp;

# Slide 12.  Get a list of all full employee names (as a single column)
SELECT *,
CONCAT(first_name, " "  , last_name) AS 'Full name'
FROM employees;



SELECT 
    *
FROM
    employees.employees
WHERE # Ключове слово where,  дозволяє робити фільтрацію в отриманих даних 
 emp_no = 10001
 OR # Вказує що інший варіант також підійде(АБО)
 emp_no = 10002
 OR emp_no = 10003;
 
 
 # Slide 15. Get a list of all unique employee_ids who earned more than $100k at some points
 
SELECT DISTINCT emp_no
FROM salaries
WHERE salary > 100000
ORDER BY emp_no;



/*
	Slide 24
    Task 1: Once you have done that, extract another list containing the names of employees that do not contain “Jack”.
*/

# Task 1
SELECT * 
FROM employees
WHERE first_name NOT LIKE 'Jack%';

 
/*
	Slide 23
    Task 1: Retrieve a list with data about all female employees who were hired in the year 2000 or after.
	Task 2: Extract a list with all employees’ salaries higher than $150,000 per annum.
*/
# Task 1
SELECT 
* 
FROM 
employees
WHERE gender = 'F' and hire_date LIKE '2%';

# Task 2
SELECT 
*
FROM 
salaries
WHERE salary > 150000;


/*
	Order by - функція для сортування, може сортувати по одній або декільком колонкам. 
	Приймає два значення ASC/DESC. 
			1. ASC - по замовчуванню, сортування від меншого до більшого
            2. DESC - від більшого до меньшого
*/

# Example 1. Use desc
SELECT *
FROM employees
ORDER BY emp_no DESC;

# Example 2.  Two columns
SELECT *
FROM employees
ORDER BY last_name DESC, first_name DESC;


/*
		Slide _. 
        Task 1. 1. Show all data from employees table, sorted A-Z by first name
		Task 2. Show all employees, sorted Z-A by last name
*/

# Task 1
SELECT *
FROM employees
ORDER BY first_name ASC;


# Task 2
SELECT *
FROM employees
ORDER BY last_name DESC;


# Limit - вказує скільки потрібно повернути строк 
SELECT 
*
FROM salaries
LIMIT 5;



/*
	Slide _:
	1. Show 10 newest employees
	2. Show top 50 current salaries
*/

# Task 1
SELECT *
FROM employees 
LIMIT 10;


# Task 2
SELECT * 
FROM salaries
ORDER BY salary DESC
LIMIT 50;



# Що повернє код?
SELECT * 
FROM employees
WHERE hire_date >= '1986-01-01';


SELECT * 
FROM employees
WHERE hire_date < '1986-01-01';

SELECT * 
FROM salaries
WHERE emp_no = 10001;


/*
	Контрольні запитання:
		1. Between - навіщо потрібно, які особливості застосування?
        2. Like/wildcars - як можна використовувати, особливості застосування?
        3. Що робить Where?
        4. And/or - навіщо потрібні, особливості застосування?
        5. Order by - навіщо потрібен, які може приймати значення?
*/

