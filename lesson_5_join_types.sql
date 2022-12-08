/*
	Lesson 4. 02.12.22 - 07.12.22 - Join table
    Types of Join
*/
SHOW DATABASES;

SHOW TABLES;


SELECT * FROM
 departments_dup;

SELECT * FROM 
dept_manager_dup;

# Structural - наявність данних
# Primary/Foreign key - Integrity part
# Join - Manipulative

SELECT * FROM employees;

SELECT * FROM dept_emp;


SELECT *
FROM employees.employees AS ee
INNER JOIN employees.dept_emp AS ede ON(ee.emp_no = ede.emp_no) ; # <-- безлічь умов 


SELECT *
FROM employees.employees AS ee
JOIN employees.dept_emp AS ede ON(ee.emp_no = ede.emp_no) ; # <-- безлічь умов 


SELECT *
FROM employees.employees AS ee
INNER JOIN employees.dept_emp AS ede USING(emp_no); # <-- однакова назва та  тільки по одній колонці


# Без AS  потрібно вказувати повну адресу 

SELECT ee.emp_no, CONCAT(ee.first_name,' ' , ee.last_name) AS 'Full name', ese.salary
FROM employees.employees AS ee
INNER JOIN employees.salaries AS ese USING(emp_no)
ORDER BY ee.emp_no ASC; 


SELECT ee.emp_no, ede.dept_no
FROM employees.employees AS ee
INNER JOIN employees.dept_emp AS ede
ON( ee.emp_no = ede.emp_no AND ee.hire_date = ede.from_date)
ORDER  BY ee.emp_no;


SELECT ee.emp_no, ede.emp_no ,ede.dept_no
FROM employees.employees AS ee
LEFT JOIN employees.dept_emp AS ede
ON ( ee.emp_no = ede.emp_no AND ee.hire_date = ede.from_date)
WHERE ede.emp_no IS NULL
ORDER  BY ee.emp_no;


 

# departments_dup - dept_manager_dup
DESC departments_dup;

DESC employees;

DESC dept_manager_dup;

SELECT * FROM departments_dup;

SELECT * FROM dept_manager_dup;



/*
				Inner Join 
	id			id_sec			result_table
	1			3						3 - 3
	2			4						4 -4 
    3			5	
    4			6
*/



SELECT ee.emp_no,  ee.first_name, ee.last_name, es.salary
FROM employees.employees AS ee
INNER JOIN employees.salaries AS es ON (ee.emp_no = es.emp_no)
WHERE ee.emp_no = 10051;




SELECT ee.emp_no, ee.first_name, ee.last_name, ee.hire_date, ed.dept_no
FROM employees.dept_manager AS edm
INNER JOIN employees.departments AS ed USING(dept_no)
LEFT JOIN employees.employees AS ee USING(emp_no)
WHERE edm.dept_no = 'Quality Management'
ORDER  BY ee.emp_no;

# Task 1. Inner join для employees і salaries, спробувати умову ON та Using
SELECT *
FROM employees
INNER JOIN salaries USING(emp_no);


SELECT *
FROM employees  ee
JOIN salaries  es ON ee.emp_no = es.emp_no;

# Task 1.1 Після INNER JOIN,  вивезти з salaries(salary, emp_no),  з  employees вивезти (first_name, last_name, birth_date)
SELECT ee.emp_no, es.salary
FROM employees AS ee
INNER JOIN salaries AS  es USING(emp_no)
ORDER BY ee.emp_no;

/*
		Left Join 
	id			id_sec 			result_table
    1				3					1 - NULL
    2				4					2 - NULL
    3				5					3 - 3
    4				6					4 - 4
    
*/
SELECT ee.emp_no, es.emp_no, es.salary
FROM employees AS ee
LEFT JOIN  salaries as es USING(emp_no)
WHERE es.emp_no IS NULL
ORDER BY ee.emp_no;



SELECT * FROM departments_dup;

SELECT * FROM dept_manager_dup;

SELECT * 
FROM departments_dup
LEFT JOIN dept_manager_dup USING(dept_no);
  

SELECT ee.*, es.*
FROM employees.employees AS ee
LEFT JOIN employees.salaries AS es USING(emp_no)
WHERE es.emp_no IS NULL;
  
/*
				Right Join
    	id			id_sec 			result_table
    1				3					null - 5
    2				4		 			null - 6	
    3				5					3 - 3
    4				6					4 - 4
  */  
  
SELECT *
FROM departments_dup;

SELECT *
FROM dept_manager_dup;

SELECT * 
FROM departments_dup
RIGHT JOIN dept_manager_dup USING(dept_no);

SELECT ee.*, es.*
FROM employees.employees AS ee
RIGHT JOIN employees.salaries AS es ON(ee.emp_no = es.emp_no)
WHERE ee.emp_no IS NOT NULL;

/*
	Full Join 
	id			id_sec 			result_table
    1				3					1 - null
    2				4		 			2 - null
    3				5					3 - 3
    4				6					4 - 4
										null - 5
										null - 6 
*/


/*
	Slide 17 
	Task 1: Extract a list containing information about all managers’ employee number,first and last name,  
	department  number,  and hire date.
 */
SELECT * 
FROM
 dept_manager;

SELECT * 
FROM employees;

SELECT * FROM dept_emp;


SELECT ee.emp_no, ee.first_name, ee.last_name, ede.dept_no, ee.hire_date
FROM employees.employees AS ee
INNER JOIN employees.dept_emp AS ede USING(emp_no);

SELECT ee.emp_no, ee.first_name, ee.last_name, ede.dept_no, ee.hire_date
FROM employees.employees AS ee
LEFT JOIN employees.dept_emp AS ede USING(emp_no);

SELECT ee.emp_no, ee.first_name, ee.last_name, ede.dept_no, ee.hire_date
FROM employees.employees AS ee
RIGHT JOIN employees.dept_emp AS ede USING(emp_no);


/* 
	Slide 21
    Task 1: Join the 'employees' and the 'dept_manager'  tables to return a subset of all theemployees whose last name is Markovitch. 
    See if the output contains  amanager  with that name.
    Hint: Create an output containing information corresponding to the following fields:
	‘emp_no’, ‘first_name’, ‘last_name’, ‘dept_no’, ‘from_date’. Order by 'dept_no' descending,
	and then by 'emp_no'.
*/


SELECT * 
FROM dept_manager;

SELECT * FROM employees;


SELECT * FROM employees
WHERE last_name = 'Markovitch';


SELECT ee.emp_no, ee.first_name, ee.last_name, dm.dept_no, dm.from_date # не правильно 
FROM employees AS ee
INNER JOIN dept_manager AS dm USING(emp_no)
WHERE ee.last_name = 'Markovitch';



SELECT  ee.emp_no, ee.first_name, ee.last_name, dm.dept_no, dm.from_date
FROM employees AS ee
LEFT JOIN dept_manager AS dm USING(emp_no)
WHERE ee.last_name = 'Markovitch' #AND dm.dept_no IS NOT NULL
ORDER BY dm.dept_no DESC, ee.emp_no ASC;



# Old style - use block where
SELECT ee.emp_no, ee.first_name, ee.last_name, edm.dept_no, ee.hire_date
FROM employees.employees AS ee, employees.dept_manager AS edm
WHERE ee.emp_no =  edm.emp_no;


SELECT ee.emp_no, ee.first_name, ee.last_name, edm.dept_no, ee.hire_date
FROM employees.employees AS ee
INNER JOIN employees.dept_manager AS edm USING(emp_no);

/* 
	Slide 27 
	Extract a list containing information about all managers’ employee number,first and last name,  department  number,  and hire date. 
	Use the old type of joinsyntax  to obtain the result.
*/
SELECT  ee.emp_no, first_name, ee.last_name, edm.dept_no, ee.hire_date
FROM employees.employees AS ee         
INNER JOIN employees.dept_manager_dup AS edm
ON ee.emp_no = edm.emp_no;


SELECT ee.emp_no, ee.first_name, ee.last_name, edm.dept_no , ee.hire_date
FROM employees.employees AS ee, employees.dept_manager AS edm
WHERE ee.emp_no = edm.emp_no; 



/* 
	Slide 30 
    Select the first and last name,  the hire date, and the job title of all employees
    whose first name is “Margareta” and have the last name “Markovitch”.
    Hint: Using Join and WHERE Together
*/

SELECT * FROM employees;

desc employees;

SELECT * FROM employees
WHERE first_name = 'Margareta' AND  last_name = 'Markovitch';

SELECT * FROM titles;


SELECT ee.emp_no, ee.first_name, ee.last_name, ee.hire_date, et.title
FROM employees.employees AS ee
INNER JOIN employees.titles AS et USING(emp_no)
WHERE ee.first_name = 'Margareta' AND ee.last_name = 'Markovitch';


SELECT ee.first_name, ee.last_name, ee.hire_date, et.title
FROM employees.employees AS ee
JOIN employees.titles AS et
     ON (ee.emp_no = et.emp_no)
    WHERE ee.first_name = 'Margareta' AND ee.last_name = 'Markovitch'
   ;
   
    
SELECT 
		ee.emp_no, ee.first_name, ee.last_name, ee.hire_date, et.title
FROM 
		employees.employees AS ee 
INNER JOIN 
		employees.titles AS et 
        USING(emp_no)
WHERE 
		ee.first_name = 'Margareta' AND 
        ee.last_name = 'Markovitch';
        


/*
				Inner Join 
	id			id_sec			result_table
	1			3						
	2			4						
    3			5	
    4			6
    
				Left Join 
	id			id_sec 			result_table
    1				3					
    2				4					
    3				5					
    4				6					
    
    
				Right Join
    	id			id_sec 			result_table
    1				3					
    2				4		 			
    3				5					
    4				6					
    
    
				Full Join
     	id			id_sec 			result_table
    1				3					
    2				4		 				
    3				5					
    4				6					
										
                                        
*/


/*
		Cross - Join - декартовий добуток(по рядкам) 
        
        id 		id_sec
        1			1
        2			2
        3			3
        
        result 
        1	1
        1	2
        1	3
        2	1
		2	2
        2  3
        3	1
        3	2
        3	3
*/
SELECT * FROM dept_manager_dup;

SELECT *
FROM employees.dept_manager_dup
CROSS JOIN (SELECT 1) AS cel;


SELECT * FROM departments_dup;

SELECT * FROM dept_manager_dup;

SELECT *
FROM employees.dept_manager_dup
INNER JOIN departments_dup ;


SELECT *
FROM employees.dept_manager_dup
CROSS JOIN departments_dup ;


SELECT 9 * 26;

# Self Join - табличка join сама для себе
/*
		id 	p_id
		1		null
        2		1
        3		1
        4		2
        5		4
*/
SELECT *
FROM employees.employees AS ee
INNER JOIN employees.employees AS eee 
ON (ee.emp_no = eee.emp_no);


# Natual Join 
SELECT ee.emp_no, ee.first_name, ee.last_name, es.salary
FROM employees.employees AS ee
NATURAL JOIN employees.salaries AS  es;

/*
		1. Відобразити всіх співробітників(імя, останню посаду, яку займали, остання назва департаменту в якому працювали), 
			які не працюють на данний момент.
		2. Показати всіх чоловіків співробітників в кого поточна ЗП меньше середній поточній ЗП по компанії, 
			якщо такиї співробітників більше ніж 1000 за рік народження
*/