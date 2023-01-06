# Windows function - 06.01.23
/*
	Корисні посилання: 
		1. https://tproger.ru/translations/sql-window-functions/
        2. https://oracleplsql.ru/cume_dist-function.html - Синтаксис № 2 функции CUME_DIST - используется как аналитическая функция
        3. https://www.youtube.com/watch?v=UiAwYUEGxIc 
        4. https://www.youtube.com/watch?v=yeIoV832zKw
        5. https://habr.com/ru/company/otus/blog/490296/ 
*/
/*
	SELECT   
    название_функции(Столбец для вычисление) 
	OVER (ключевое слово для начала windows function)
    ( внутри over можна указать три параметра: 
					PARTITION BY - столбец для группировки 
                    ORDER BY - столбец для сортировки 
                    [frame] ROWS, RANGE - выражение для ограничение строк в пределах группы
                    
*/

/*
	Windows function - 3 main types
		1. Aggregate types(avg, sum, max, min, count)
        2. Ranking (Row_number, rank, dense_rank, percent_rank, ntile)
        3. Value (Lag/Lead, First_value/Last_value, Nth_value)
*/
USE fk_demo;


DROP TABLE IF EXISTS salas;


CREATE TABLE IF NOT EXISTS sales (
    sales_employee VARCHAR(50) NOT NULL,
    fiscal_year INT NOT NULL,
    sale DECIMAL(14 , 2 ) NOT NULL,
    PRIMARY KEY(sales_employee , fiscal_year)
);


INSERT INTO sales(sales_employee,fiscal_year,sale)
VALUES
	('Bob',2016,100),
	('Bob',2017,150),
	('Bob',2018,200),
	('Alice',2016,150),
	('Alice',2017,100),
	('Alice',2018,200),
	('John',2016,200),
	('John',2017,150),
	('John',2018,250);

SELECT * FROM
sales;


SELECT SUM(sale)  AS 'Sum'
FROM sales;

SELECT sales_employee, SUM(sale)
FROM sales
GROUP BY sales_employee;

SELECT fiscal_year, SUM(sale)
FROM sales
GROUP BY fiscal_year;

SELECT AVG(sale)
 FROM
sales;
 
 /*
 
    
	SELECT   
    название_функции(Столбец для вычисление) 
	OVER (ключевое слово для начала windows function)
    ( внутри over можна указать три параметра: 
					PARTITION BY - столбец для группировки 
                    ORDER BY - столбец для сортировки 
                    [frame] ROWS, RANGE - выражение для ограничение строк в пределах группы
                    
*/ 
SELECT
	fiscal_year, sales_employee, sale,
    SUM(sale) OVER (PARTITION BY fiscal_year) AS total_sales, # PARTITION BY  - аналог group by  
    SUM(sale) OVER () total  # Використання віконної функції
FROM sales;


SELECT
	fiscal_year, sales_employee, sale,
    AVG(sale) OVER (PARTITION BY fiscal_year) avg_sales, # PARTITION BY  - аналог group by 
    MAX(sale) OVER (PARTITION BY fiscal_year),
    AVG(sale) OVER () total_sales,
    ROUND(AVG(sale) OVER (PARTITION BY fiscal_year), 2)
FROM sales;


# Або без Windows Function 
SELECT
	sales.fiscal_year, 
    sales.sales_employee, 
    sales.sale, 
    sel_f_y.sum_sale,
    s.all_sum
FROM sales 
INNER JOIN ( 
		SELECT fiscal_year, SUM(sale) AS sum_sale 
        FROM 	sales
        GROUP BY fiscal_year) 
        AS sel_f_y ON (sales.fiscal_year = sel_f_y.fiscal_year)
CROSS JOIN (
SELECT 
SUM(sale)  AS all_sum
FROM sales) AS s;

# Запустимо окремо код 
SELECT fiscal_year, SUM(sale) AS sum_sale 
FROM 	sales
GROUP BY fiscal_year;

SELECT 
SUM(sale)  AS all_sum
FROM sales;


# Slide 7 
/*
	Row_number - віконна функція яка присвою кожному полу(строці) значення +1 від попереднього 
    Використовуємо Order By 
*/
USE employees;

SELECT 
ROW_NUMBER()  -- Віконна функція row_number, початок з одиниці 
OVER (ORDER BY emp_no  DESC),  -- Over  ключове слово для створення вікна, в середині пропусуємо order by, щоб корректно показувати інформацію
ee.*
FROM employees.employees AS ee;


SELECT
 ROW_NUMBER() -- Віконная функція без параметрів
 OVER -- Сторюємо вікно
 (
 PARTITION BY gender  -- Аналог group by 
 ORDER BY gender, emp_no)  # Розбиваемо по gender, нумеруємо спочатку M, скидає значення до 1 і знову нумеруємо F
AS 'Row number', -- Даємо псевдонім віконній функції 
 ee.* 
FROM employees.employees AS ee;


# Slide 10
DROP TABLE IF EXISTS scores;
CREATE TABLE IF NOT EXISTS scores (
    name VARCHAR(20) PRIMARY KEY,
    score INT NOT NULL
);

INSERT INTO
	scores(name, score)
	VALUES
				('Smith',81),
				('Jones',55),
				('Williams',55),
				('Taylor',62),
				('Brown',62),
				('Davies',84),
				('Evans',87),
				('Wilson',72),
				('Thomas',72),
				('Johnson',100);

SELECT * FROM 
scores;

SELECT name, score,
	ROW_NUMBER() -- Віконна функція підрахунку строк
    OVER -- Створення вікна
    (ORDER BY score asc ) -- Сортування по score
    row_num,
	CUME_DIST() OVER (ORDER BY score) cume_dist_val # range 0 to 1
FROM scores;
/*
	(55) 2 / 10 = 0.2
    (62)  4/ 10 = 0.4
    (72) 6 / 10 = 0.6
    (81) 7 / 10 = 0.7
    (84) 8 / 10 = 0.8
    (87) 9 / 10 = 0.9
*/

# Вивезти 5 рядок з таблиці

/*
	Ранжирование даних 
    Dense rank
    Rank  - Оператор RANK схожий на ROW_NUMBER,
    але присвоює однакові номери рядкам з однаковими значеннями, а "зайві" номери пропускає
*/

SELECT * FROM
 sales;

SELECT sales_employee, fiscal_year, sale,
	DENSE_RANK() OVER
									(
											PARTITION BY fiscal_year
											ORDER BY sale  ASC
									)  'dense rank ' ,
    RANK() OVER 
									( 
										PARTITION BY fiscal_year 
										ORDER BY sale ASC
                                    ) AS 'Rank'
FROM sales;

/*
	ID 		sale 			dense_rank					rank
	1			1000			1-1								1-3
	2			1000			1-1								1-3
	3			1000			1-1								1-3
	4			100				2-2									4
*/



/* 5.Выбрать сотрудников и отобразить их рейтинг по году принятия на работу
.Попробуйте разные типы рейтингов.*/
SELECT emp_no, year(hire_date),
RANK() 
		OVER (ORDER BY year(hire_date)),
DENSE_RANK () 
		OVER (ORDER BY year(hire_date)),
NTILE (15) 
			OVER (ORDER BY year(hire_date))
FROM employees.employees;

CREATE TABLE overtime (
    employee_name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    hours INT NOT NULL,
    PRIMARY KEY (employee_name , department)
);

INSERT INTO overtime(employee_name, department,hours)
VALUES
				('Diane Murphy','Accounting',37),
				('Mary Patterson','Accounting',74),
				('Jeff Firrelli','Accounting',40),
				('William Patterson','Finance',58),
				('Gerard Bondur','Finance',47),
				('Anthony Bow','Finance',66),
				('Leslie Jennings','IT',90),
				('Leslie Thompson','IT',88),
				('Julie Firrelli','Sales',81),
				('Steve Patterson','Sales',29),
				('Foon Yue Tseng','Sales',65),
				('George Vanauf','Marketing',89),
				('Loui Bondur','Marketing',49),
				('Gerard Hernandez','Marketing',66),
				('Pamela Castillo','SCM',96),
				('Larry Bott','SCM',100),
				('Barry Jones','SCM',65);

# Slide 15
SELECT * FROM
 overtime;
/*
	First_value - повертає перше значення у вікні
*/
SELECT employee_name, hours,
FIRST_VALUE(employee_name) 
				OVER (ORDER BY hours ASC) AS least_over_time
FROM overtime;


# Slide 16
SELECT employee_name, department, hours,
FIRST_VALUE(employee_name) 
		OVER (
				PARTITION BY Wdepartment
				ORDER BY hours ASC
				) least_over_time
FROM overtime;

SELECT employee_name, department, hours,
FIRST_VALUE(employee_name) 
		OVER (
				PARTITION BY department
				ORDER BY hours DESC
				) least_over_time
FROM overtime;


SELECT employee_name, department, hours,
FIRST_VALUE(hours) 
		OVER (
				PARTITION BY department
				ORDER BY hours ASC
				) least_over_time
FROM overtime;


SELECT COUNT(DISTINCT( department))
FROM overtime;

WITH salary_minCTE AS (
SELECT salary FROM employees.salaries
WHERE emp_no = 10001
LIMIT 1),
salary_maxCTE AS (
SELECT salary AS sal FROM employees.salaries
WHERE emp_no = 10001
ORDER BY salary DESC
LIMIT 1)


SELECT sal
FROM salary_minCTE, salary_maxCTE;


SELECT
 abs((SELECT salary FROM employees.salaries
WHERE emp_no = 10001
LIMIT 1) - 
(SELECT salary FROM employees.salaries
WHERE emp_no = 10001
ORDER BY salary DESC
LIMIT 1));




/* 
	Task 1.Отобразить сотрудников и напротив каждого, показать информацию о разнице текущей и первой зарплате.
*/


# Крок 1. Знайти найпершу ЗП по працівнику 
SELECT emp_no, salary,
FIRST_VALUE(salary) 
		OVER (
				PARTITION BY emp_no
				ORDER BY from_date ASC
				) fd
FROM employees.salaries;

# Крок 2. Знайти поточну ЗП працівника
SELECT emp_no, salary
FROM employees.salaries
WHERE curdate() BETWEEN from_date AND to_date;

# Крок 3. Відняти поточну зп під найпершої
SELECT emp_no,from_date,to_date,salary,
FIRST_VALUE (salary)
OVER (PARTITION BY emp_no
ORDER BY salary DESC) AS 'sal_first';


SELECT *
 FROM
 (
			SELECT emp_no, from_date, to_date,salary, 
            FIRST_VALUE(salary) OVER (PARTITION BY emp_no ORDER BY from_date ) AS firstsal, 
            salary  -  FIRST_VALUE(salary) OVER (PARTITION BY emp_no ORDER BY from_date ) AS diff_salary
            FROM employees.salaries) AS SAl
            WHERE curdate() BETWEEN from_date and to_date;

/*
	UNBOUNDED PRECEDING emp_no = 10001
	2.PRECEDING emp_no = 10198
	CURRENT_ROW emp_no = 10200
	2. FOLLOWING 
	UNBOUNDED FOLLOWING emp_no = 499999
*/
/*
	UNBOUNDED PRECEDING emp_no = 10001
    3 PRECEDING emp_no = 10002 # Min вгору число строк до строкі 
    CURRENT_ROW 	emp_no = 10005
    2 FOLLOWING emp_no = 10007  # Max вниз число строк після строки
	UNBOUNDED FOLLOWING emp_no = 499999
*/


/*
	Last Value - повертає останній об'єкт у вікні. Потрібно вказувати межі вікна.
*/

/*
	SELECT 
    назва_віконної функції(колонка якщо потрібна для обислення)
    OVER - ключове слово для створення вікна
    (
    partition by - колонка для розбивки(аналог group by)
    order by - колонка для сортування
    ROWS -  строкі  
    RANGE - діапозон строк(числові або дата type )
		для обмеження строк в межах группи
        * Потрібен Order by 
    )
    
*/
SELECT es.emp_no, ee.first_name, ee.last_name, es.salary,
	SUM(salary)
    OVER (
		PARTITION BY es.emp_no
        ORDER BY ee.hire_date
		ROWS UNBOUNDED  PRECEDING # Вказуємо діапазон від початку до кінця поточної строки 
    )
FROM employees.salaries AS es
INNER JOIN employees.employees AS ee USING(emp_no);


SELECT es.emp_no, ee.first_name, ee.last_name, es.salary,
	SUM(salary)
    OVER (
		PARTITION BY es.emp_no
        ORDER BY ee.hire_date
												-- Нижня рамка 									Верхня рамка 
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW # Вказуємо діапазон від початку до кінця поточної строки 
    ),
    SUM(salary)
    OVER (
		PARTITION BY es.emp_no
        ORDER BY ee.hire_date
											-- Нижня рамка 									Верхня рамка 
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING # Вказуємо діапазон від початку до кінця поточної строки 
    )
FROM employees.salaries AS es
INNER JOIN employees.employees AS ee USING(emp_no);

        

SELECT employee_name, hours,
LAST_VALUE(employee_name) OVER ( 
			ORDER BY hours
			RANGE BETWEEN # Діапозон мінімального і максимального значення 
											UNBOUNDED PRECEDING  # Нижній значення (min)
                                            AND 
											UNBOUNDED FOLLOWING # Верхнеє значення (max)
)  highest_overtime_employee
FROM employees.overtime;

# Без вказання range
SELECT employee_name, hours,
LAST_VALUE(employee_name) OVER ( 
			ORDER BY hours # Завжди вказуємо діапозон, працює тільки в рамках свого рядка
)  highest_overtime_employee
FROM overtime;


SELECT employee_name, department, hours,
	LAST_VALUE(employee_name) 
    OVER (
							PARTITION BY department
							ORDER BY hours  ASC
							 RANGE  BETWEEN
							 UNBOUNDED PRECEDING AND
							 UNBOUNDED FOLLOWING
) most_overtime_employee
FROM overtime;

SHOW TABLES;


/*
	Функції зміщення: 
		Lead - повертає наступний рядок у вікні
		Lag - повертає попередній рядок у вікні
        *Потрібно сортування 
*/
SELECT emp_no, from_date,
				LEAD( -- Створення віконної функції 
                from_date, -- Вказати стовбчиу
                10, -1)  -- Кількість значеннь
                OVER ( 
				PARTITION BY emp_no
				ORDER BY from_date ) nextSalaryDate
FROM employees.salaries;

USE employees;

SELECT * FROM employees.salaries 
WHERE emp_no = 10002;

SELECT emp_no, from_date,
			LEAD(from_date,4) 	OVER ( 	# LEAD Повертає наступне значення, якщо значення не буде, то поверне Null
									PARTITION BY emp_no
									ORDER BY from_date ) AS nextSalaryDate,
			LAG(from_date, 2) OVER ( 		# LAG Повертає попереднє значення,  якщо значення не буде, то поверне Null
									PARTITION BY emp_no
									ORDER BY from_date )  AS previosSalaryDate
FROM employees.salaries
WHERE emp_no < 10050 AND emp_no <> 10001;



# Slide 26 
CREATE TABLE depts_salaries 
	SELECT dept_name,
    YEAR(salaries.from_date) AS salaryYear,
    COUNT(emp_no)  AS emp_salaries 
    FROM employees.departments
	INNER JOIN employees.dept_emp USING (dept_no)
	INNER JOIN employees.salaries USING (emp_no)
GROUP BY dept_name , YEAR(salaries.from_date);

SELECT * FROM 
employees.depts_salaries;

WITH t AS (
		SELECT dept_name, SUM(emp_salaries) emp_salaries_sum
		FROM employees.depts_salaries
		GROUP BY dept_name
)


SELECT dept_name, emp_salaries_sum,
					ROUND(
					PERCENT_RANK()  # Створення віконної функції 
                    OVER (
					ORDER BY emp_salaries_sum ASC
					) ,2)  AS percentile_rank
FROM t;

/* 			
		(rank - 1) / (total_rows - 1) - formula to calculate PERCENT_RANK(діапозон від 0 до 1 )
		(1 - 1) / (9 - 1) = 0 / 8  = 0
        (2 - 1) / (9 - 1) = 1 / 8 = 0.125
        (3 - 1) / (9 - 1) = 2 / 8 = 0.25
        (4 - 1) / (9 - 1) = 3 / 8 = 0.375 etc.
*/

# Вивезти кумулятивний  сумму по ЗП
SELECT emp_no, salary,
		SUM(salary) OVER (
			PARTITION BY emp_no 	
            ROWS unbounded preceding
        ) 'Sum'
FROM employees.salaries;