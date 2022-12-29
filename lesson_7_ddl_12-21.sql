/*
	Lesson  7 14.12.22 - 21.12 : DDL
     DDL(Data Definition Language) - Create, Alter, Drop, Rename 
    1. Create DB/ SHOW/ Exists
    2.  Types of engines
    3. Rename/Transfer
    4. Constraints
    5. Alter table
    6. Modify/Change
*/



# CREATE DATABASE  test_create_db;

USE test_create_db;

CREATE DATABASE IF NOT EXISTS test_create_db; # Щоб не було помилок

SHOW DATABASES; # Список БД


#  DROP DATABASE  IF EXISTS test_create_db;
 
 DROP DATABASE IF  EXISTS test_create_db;
 
/*
START TRANSACTION;

DROP DATABASE IF  EXISTS	test_create_db;

DROP DATABASE test_create_db;

SHOW DATABASES;

ROLLBACK;
*/


SHOW DATABASES;

USE test_create_db;

SHOW ENGINES;

/*
		MyISAM - 
        ISAM (англ. Indexed Sequential Access Method — индексно-последовательный метод доступа) — способ хранения данных для быстрого доступа к ним. 
        Способ был разработан компанией IBM для мейнфреймов в 1963 году, в настоящее время это основной способ представления данных почти во всех базах данных.
		В ISAM отдельно хранятся записи с данными и индексы (служебные данные), служащие для быстрого доступа к записям. 
        Данные хранятся последовательно (изначально ISAM использовался для хранения данных на ленточных накопителях, обеспечивающих только последовательные чтение/запись). 
		Второй набор данных — хеш-таблица — индексы, содержащие указатели, которые позволят извлечь определенные записи без поиска по всей базе данных. 
        Это несколько отличается от индексов в современных поисковых базах данных, так как в них индексы хранятся прямо в записях.
        Ключевая особенность ISAM — индексы малы и поиск по ним быстр. 
		Изменение в записях не требует изменять все записи, требуется только перестроить индекс.
*/
/*
		MEMORY
        MEMORY механизм хранения (прежде известный как HEAP) составляет таблицы специального назначения с содержанием, которое сохранено в памяти. 
        Поскольку данные уязвимы для катастрофических отказов, аппаратные проблемы, или отключения электричества питания, 
        только используют эти таблицы в качестве временных рабочих областей или кэшей только для чтения для данных, которые вытягивают от других таблиц.
*/
/*
		CSV
        Work with csv files
*/
/*
		Add requests:
        More about engine - https://habr.com/ru/post/64851/
        ACID - https://habr.com/ru/post/555920/
        Псевдокод - https://techrocks.ru/2020/03/27/how-to-write-pseudocode/
*/
/*
		InnoDB - ACID model
*/

DROP TABLE IF  EXISTS tasks;

# camelStyle
# python_style
CREATE TABLE IF NOT EXISTS tasks (
	task_id INT AUTO_INCREMENT PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	start_date DATE,
	due_date DATE,
	status TINYINT NOT NULL,
	priority  TINYINT  UNSIGNED NOT NULL,
	description TEXT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE = INNODB;

DESCRIBE tasks;

DESC tasks;

SELECT * FROM tasks;


SHOW FULL PROCESSLIST; 

CREATE TABLE 
IF NOT EXISTS emplo_test LIKE employees.employees;

DESCRIBE tasks;

DESCRIBE emplo_test;

SELECT * FROM emplo_test;


DROP TABLE IF EXISTS checklists;


CREATE TABLE IF NOT EXISTS checklists (
					todo_id 		  INT 							 AUTO_INCREMENT,
					task_id 		  INT ,
					todo 			  VARCHAR(255) 			NOT NULL,
					is_completed BOOLEAN 					NOT NULL 					DEFAULT FALSE,
                    #,FOREIGN KEY (task_id) REFERENCES tasks (task_id) ON UPDATE RESTRICT ON DELETE CASCADE )
					PRIMARY KEY (todo_id , task_id)
                    );
                    

DESCRIBE checklists;

DROP TABLE IF EXISTS checklists;

# Slide 7
CREATE TABLE IF NOT EXISTS checklists (
					todo_id 			INT 			AUTO_INCREMENT,
					task_id 			INT,
					todo			 VARCHAR(255)			 NOT NULL,
					is_completed BOOLEAN NOT NULL DEFAULT FALSE,
					PRIMARY KEY (todo_id , task_id), 
                    FOREIGN KEY (task_id) REFERENCES tasks (task_id)
					ON UPDATE RESTRICT ON DELETE CASCADE 
                    );
                    
SELECT *
FROM information_schema.INNODB_FOREIGN_COLS;

DESC checklists;

ALTER TABLE checklists
DROP FOREIGN KEY checklists_ibfk_1;


CREATE TABLE IF NOT EXISTS checklists2 (
    todo_id INT AUTO_INCREMENT,
    task_id INT,
    todo VARCHAR(255) NOT NULL,
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (todo_id , task_id)
    
    ,CONSTRAINT constr_task FOREIGN KEY (task_id)
        REFERENCES tasks (task_id)
        ON UPDATE RESTRICT ON DELETE CASCADE );
        

ALTER TABLE checklists2 
DROP FOREIGN KEY constr_task;

DESC checklists2;


/*
	CONSTRAINT(Обмеження)- умовний фільтр для таблиці 
	1. Primary Key - унікальний ідентифікатор, Не може бути NULL та всі id Унікальні
	2. Not Null - не можете мати null значень 
    3. Unique - всі значення повинні бути унікальні (якщо данні вже є в таблиці, дублів не буде)
    4. Foreign Key - обмеження по зовнішнім ключам
    5. DEFAULT  - добавляє значення якщо не отримали
    6. Check - перевірка значення 
*/

# PRIMARY KEY CONSTRAINT
# DROP TABLE IF EXISTS try_primary_key_const;
CREATE TABLE IF NOT EXISTS try_primary_key_const (
	id INT PRIMARY KEY,
    info VARCHAR(10)
);

DESC try_primary_key_const;


INSERT INTO try_primary_key_const
VALUES
(NULL, 'Sometext'); # Поверне  error, primary key не може бути NULL

INSERT INTO try_primary_key_const
VALUES
(1, 'Sometext');

SELECT * FROM try_primary_key_const;

INSERT INTO try_primary_key_const
VALUES
(1, 'Sometext'); # Поверне error, primary key не може мати дублікатів 

/*
	Alter - внести зміну в структуру таблиці
	ALTER table(назва таблиці)
    Дія(ADD/DROP/MODIFY/CHANGE) COLUMN назва колонки
*/

ALTER TABLE try_primary_key_const
CHANGE COLUMN   # Вказуемо що будуть внесені зміни в колонку
info   # Назва колонки для якої буде вноситись зміна
new_info # Нова назва, можна вказати стару назву колонки
VARCHAR(35) NOT NULL ; # Зміни які внесли

DESC try_primary_key_const;

INSERT INTO try_primary_key_const VALUES
(2, NULL); # Буде помилка так як new_info не може бути Null

SELECT * FROM try_primary_key_const;

# Продовжити 
# Task 1. Таблицю try_primary_key_const Добавити колонку test_const_default Varchar(15) Default 'Default'
ALTER TABLE try_primary_key_const
ADD COLUMN 
test_const_default 
VARCHAR(15)
DEFAULT 'DEFAULT';

DESC try_primary_key_const;

# Task 2. Вставити 3-5 записив без test
INSERT INTO try_primary_key_const(id, new_info) VALUES
(4, 'Add 4'),
(5, 'Add 5'),
(6, 'Add 6');

SELECT * FROM
 try_primary_key_const;
 
 # Task 3. Змінити test_const_dedault на add_info with constraints(not null, default)
 ALTER TABLE try_primary_key_const
 CHANGE COLUMN test_const_default
 add_info
 VARCHAR(15) NOT NULL DEFAULT 'DEFAULT';
 
 
 DESC try_primary_key_const;

# Task 4 DROP add_info from try_primary_key_const
ALTER TABLE try_primary_key_const
DROP COLUMN add_info;

DESC try_primary_key_const;


ALTER TABLE try_primary_key_const
ADD COLUMN test_unique INT UNIQUE;

select * from try_primary_key_const;

INSERT INTO try_primary_key_const VALUES
(7, 'Some text', 1);

INSERT INTO try_primary_key_const VALUES
(8, 'Some text', 1); # Поверне помилку, для 3 колонки оскільки 3 колонка буде тільки унікальні значення 

DESC try_primary_key_const;


ALTER TABLE try_primary_key_const
ADD CONSTRAINT unique_constaint  UNIQUE(new_info); # Добавляемо констрейнт для new_info  з назвою 


ALTER TABLE try_primary_key_const
DROP CONSTRAINT  unique_constaint; # Видалення констрейнт по імені


ALTER TABLE try_primary_key_const
MODIFY new_info VARCHAR(50) UNIQUE; 


DESC try_primary_key_const;



ALTER TABLE try_primary_key_const
ADD COLUMN test_time_default DATE; # Добавляем колонку в кінець


DESC try_primary_key_const;


ALTER TABLE try_primary_key_const
ALTER test_time_default 
SET DEFAULT '1990-01-01'; # Задаємо дефолт значення 


ALTER TABLE try_primary_key_const
CHANGE COLUMN # Інший спосіб задання дефолт значення 
test_time_default
test_time_default
DATETIME 
DEFAULT CURRENT_TIMESTAMP();  


ALTER TABLE try_primary_key_const
ALTER test_time_default 
DROP DEFAULT; # Видаляємо дефолте значення

DESC try_primary_key_const;

SELECT * FROM
 try_primary_key_const;

ALTER TABLE try_primary_key_const
ADD COLUMN test_create_3_constrain
VARCHAR(15)  NOT NULL;

# CHECK - CONST
ALTER TABLE try_primary_key_const
ADD COLUMN age  TINYINT UNSIGNED;

DESC try_primary_key_const;


ALTER TABLE try_primary_key_const
CHANGE age age  INT ;  

ALTER TABLE try_primary_key_const
ADD CONSTRAINT check_age CHECK(age >=18 AND age <= 100); 

INSERT INTO 
	try_primary_key_const(test_create_3_constrain)
VALUES
	('NOT NULL');

SELECT * FROM 
try_primary_key_const;

DESC try_primary_key_const;


INSERT INTO try_primary_key_const( id, test_create_3_constrain, age, test_time_default) VALUES
(10002, 'Test const', 18, curtime() );


ALTER TABLE try_primary_key_const
DROP CONSTRAINT check_age;


# Task 6. Видалити всі constaint Unique
TRUNCATE try_primary_key_const;

ALTER TABLE try_primary_key_const
DROP PRIMARY KEY;

ALTER TABLE try_primary_key_const
AUTO_INCREMENT = 100005;
 
DESC try_primary_key_const;
 
ALTER TABLE try_primary_key_const
MODIFY id  INT  AUTO_INCREMENT ;

SELECT * FROM try_primary_key_const;


INSERT INTO try_primary_key_const( test_create_3_constrain, test_time_default) VALUES
('Test ', current_time());

ALTER TABLE try_primary_key_const
ALTER COLUMN age 
SET DEFAULT 18;

DESC try_primary_key_const;

ALTER TABLE try_primary_key_const
ALTER  age DROP DEFAULT;

/*
INSERT INTO checklists(task_id, todo)
VALUES(109, 'task 1');

INSERT INTO checklists(task_id, todo)
VALUES(109, 'task 1');

select * from checklists;

INSERT INTO checklists(task_id, todo, is_completed)
VALUES(987, 'wsx', -127); 
*/
 
SELECT * 
FROM checklists;

DROP TABLE IF EXISTS checklists;

 
SHOW TABLES;


RENAME TABLE  try_primary_key_const   TO try_primary_key_const_old;

SHOW TABLES;

SELECT * 
FROM employees.emplo_dup1;

RENAME TABLE employees.emplo_dup1 TO test_create_db.emplo_dup1; # Transfer in schemas

SHOW TABLES;

#DROP TABLE IF EXISTS posts;
 
CREATE TABLE IF NOT EXISTS posts (
			id 				INT 										AUTO_INCREMENT 				PRIMARY KEY,
			title 				VARCHAR(255) 					NOT NULL,
			excerpt 		VARCHAR(400),
			content 		TEXT,
			created_at	DATETIME,
			updated_at 	DATETIME
);

SELECT * FROM posts;

DESC posts;

/*
	ALTER TABLE імя_таблиці
    DROP COLUMNS імя_колонки/констрайнт 
*/

# Task 7. Із таблиці posts. видалати excerpt
ALTER TABLE posts # ALTER - вказуемо що будуть зміни в таблиці
DROP COLUMN excerpt; # вказуемо що видаляемо(DROP) колонку(COLUMN)


ALTER TABLE posts
ADD COLUMN d VARCHAR(15);

ALTER TABLE posts
ADD COLUMN d_after_id VARCHAR(15) AFTER id ;

DESC posts;




SELECT * FROM posts;

DESC posts;

SHOW TABLES;

SELECT * FROM tasks;


DROP TABLE IF  EXISTS tasks_change_struct;

CREATE TABLE IF NOT EXISTS tasks_change_struct (
	task_id INT AUTO_INCREMENT PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	start_date DATE,
	due_date DATE,
	status TINYINT NOT NULL,
	priority  TINYINT  UNSIGNED NOT NULL, # UNSIGNED - прибрати негативні значення тільки більше 0
	description TEXT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE = INNODB;

DESC tasks_change_struct;


ALTER TABLE tasks_change_struct
ADD COLUMN  hardware VARCHAR(255) AFTER status; 

SELECT * FROM 
tasks_change_struct;

ALTER TABLE tasks_change_struct
ADD COLUMN  hardware_group INT NOT NULL; 


ALTER TABLE tasks_change_struct
ADD COLUMN  id_last INT NOT NULL ;  # Добавити в кінці 

DESC tasks_change_struct;

ALTER TABLE tasks_change_struct
ADD COLUMN id INT NOT NULL FIRST; # Добавити першим

DESC tasks_change_struct;

SELECT * FROM tasks_change_struct;

# TRUNCATE tasks;
TRUNCATE checklists2;


SELECT * FROM  tasks_change_struct;

# DROP TABLE IF  EXISTS emplo_dup3;

CREATE TABLE IF NOT EXISTS emplo_dup3 LIKE  employees.employees;

INSERT INTO emplo_dup3 
SELECT *
FROM 
employees.employees
WHERE emp_no < 10050;

SELECT  COUNT(emp_no) 
FROM  test_create_db.emplo_dup3;



SELECT * 
FROM emplo_dup3;

/*
START TRANSACTION;

TRUNCATE TABLE emplo_dup3; # Видалення всіх значень(не підтримує транзакції)

ROLLBACK;
*/


DESC tasks_change_struct;

INSERT INTO tasks_change_struct(id, status,  priority, title ,start_date, due_date, hardware_group, id_last)
VALUES  (1, 0, 0, 'Learn NOT NULL constraint', '2017-02-01','2017-02-02', 10, 15),
				(2,  1, 1, 'Check and update NOT NULL constraint to your database', '2017-02-01',NULL, 11, 15);

DESC tasks_change_struct;

INSERT INTO tasks_change_struct(id ,task_id, title, status, priority, hardware_group, id_last)
VALUES  (3, 0,  'Learn NOT NULL constraint', 1, 10, 5, 8),
				(3,  2,  'Check and update NOT NULL constraint to your database', 2, 11, 7,1);
                
                
SELECT * FROM 
tasks_change_struct;

# Оновлення данних в яких NULL 
UPDATE tasks_change_struct # Вказати оновлення таблиц
SET # Ключове слово після якого вказуемо зміни
	due_date =  CURDATE()  + 1 	# Змінюємо значення в таблиці які відповідають умові 
WHERE 
	due_date IS NOT NULL; # Задаємо умову по якій буде йти зміна 
   
   
TRUNCATE TABLE tasks_change_struct;

ALTER TABLE tasks_change_struct
CHANGE COLUMN
	due_date
	end_date DATE NOT NULL;


INSERT INTO tasks_change_struct(id ,task_id, title, status, priority, hardware_group, id_last, start_date, end_date)
VALUES  (5, 6,  'Learn NOT NULL constraint', 1, 10, 5, 8, '1998-05-05', now()),
				(6,  7,  'Check and update NOT NULL constraint to your database', 2, 11, 7,1, '2001-08-01', now());

SELECT * FROM
tasks_change_struct;

UPDATE tasks_change_struct
SET
	end_date =  start_date  + 7
WHERE
	end_date IS  NOT NULL;

SELECT *
FROM  tasks_change_struct;



ALTER TABLE tasks_change_struct
MODIFY COLUMN
	end_date 
    DATE  NOT NULL;
    
    
DESCRIBE tasks_change_struct;


CREATE TABLE users (
	user_id 					INT 								AUTO_INCREMENT 							PRIMARY KEY,
	username 				VARCHAR(40),
	password 				VARCHAR(255),
	email 						VARCHAR(255) 
    );

    
CREATE TABLE roles(
	role_id INT AUTO_INCREMENT,
	role_name VARCHAR(50),
	PRIMARY KEY(role_id)
);

CREATE TABLE user_roles(
	user_id INT,
	role_id INT,
	PRIMARY KEY(user_id,role_id),
	FOREIGN KEY(user_id) REFERENCES users(user_id),
	FOREIGN KEY(role_id) REFERENCES roles(role_id)
);

CREATE TABLE pk_demos(
	id INT,
	title VARCHAR(255) NOT NULL
);

DESC pk_demos;

ALTER TABLE pk_demos
ADD PRIMARY KEY(id);

ALTER TABLE pk_demos
DROP PRIMARY KEY;

# DROP DATABASE IF EXISTS fk_demo;
CREATE DATABASE IF NOT EXISTS fk_demo;

SHOW DATABASES;

USE fk_demo;

# Restrict  
CREATE TABLE categories (
    categoryId INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL
)  ENGINE=INNODB;

CREATE TABLE products (
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    categoryId INT,
    CONSTRAINT fk_category FOREIGN KEY (categoryId) REFERENCES categories (categoryId) # RESRTICT
)  ENGINE=INNODB;

DESC categories;

DESC products;

INSERT INTO categories(categoryName)
VALUES ('Smartphone'), ('Smartwatch');

SELECT * FROM
categories;

INSERT INTO products(productName, categoryId) 
VALUES('iPhone',1);

SELECT * FROM 
products;

INSERT INTO products(productName, categoryId) VALUES('iPad',3);

# Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`fk_demo`.`products`, CONSTRAINT `fk_category` 
# FOREIGN KEY (`categoryId`) REFERENCES `categories` (`categoryId`))

INSERT INTO 
products(productName, categoryId) VALUES('iPad',2);

SELECT * FROM 
products;

UPDATE categories
SET categoryId = 100
WHERE categoryId = 1;

SELECT * FROM categories;


# CASCADE 

DROP TABLE products; 

CREATE TABLE products (
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    categoryId INT NOT NULL,
    CONSTRAINT fk_category FOREIGN KEY (categoryId) # Створюємо контстрейнт з назвою для FK 
        REFERENCES categories (categoryId) # Вказуємо звязок 
        ON UPDATE CASCADE    ON DELETE CASCADE #  Вказуємо новий тип обновлення 
)  ENGINE=INNODB;


INSERT INTO products(productName, categoryId)
VALUES
	('iPhone', 1),
	('Galaxy Note',1),
	('Apple Watch',2),
	('Samsung Galaxy Watch',2);

SELECT *
 FROM products;

UPDATE categories
SET categoryId = 100
WHERE categoryId = 1;

SELECT * FROM 
categories;

SELECT * FROM 
products;


DELETE FROM categories
WHERE categoryId = 2;

SELECT * FROM
 categories;

SELECT * FROM 
 products;


# Slide 25
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;


CREATE TABLE categories (
    categoryId INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL
)  ENGINE=INNODB;

CREATE TABLE products (
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    categoryId INT,
    CONSTRAINT fk_category FOREIGN KEY (categoryId)
        REFERENCES categories (categoryId)
        ON UPDATE SET NULL ON DELETE SET NULL # Вказуємо оновлення та видалення Set null
)  ENGINE=INNODB;


# Slide 26
INSERT INTO categories(categoryName)
VALUES
('Smartphone'),
('Smartwatch');

SELECT *
FROM categories;

INSERT INTO products(productName, categoryId)
VALUES
('iPhone', 1),
('Galaxy Note',1),
('Apple Watch',2),
('Samsung Galary Watch',2);

SELECT * 
FROM products;

UPDATE categories 
SET 
    categoryId = 100
WHERE
    categoryId = 1;

SELECT * 
FROM categories;

SELECT * 
FROM products;
    


DELETE FROM categories
WHERE categoryId = 2;

SELECT * FROM products;


SET foreign_key_checks = 0; # Відлючити констрейети


SET foreign_key_checks = 1; # Включити 

# DROP TABLE  IF EXISTS parts;
 
CREATE TABLE parts (
    part_no VARCHAR(18) PRIMARY KEY,
    description VARCHAR(40),
    cost DECIMAL(10 , 2 ) NOT NULL CHECK (cost >= 0),
    price DECIMAL(10 , 2 ) NOT NULL CHECK (price >= 0)
);


INSERT INTO parts(part_no, description,cost,price)
VALUES('A-001','Cooler', 100, 10);

DROP TABLE  IF EXISTS parts;

CREATE TABLE parts (
    part_no VARCHAR(18) PRIMARY KEY,
    description VARCHAR(40),
    cost DECIMAL(10 , 2 ) NOT NULL CHECK (cost >= 0),
    price DECIMAL(10 , 2 ) NOT NULL CHECK (price >= 0),
    CONSTRAINT parts_chk_price_gt_cost CHECK (price >= cost)
);

INSERT INTO parts(part_no, description,cost,price) 
VALUES('A-001','Cooler',-5,10);

SELECT * FROM parts;

DESC parts;
show full PROCESSLIST;

#SHOW TABLE STATUS from employees; 
# SHOW TABLE STATUS from employees; 
/*
	Видалити parts_chk_price_gt_cost  з parts
*/

ALTER TABLE parts
DROP CONSTRAINT parts_chk_price_gt_cost;

/*
	Добавити колонку після part_no 
    test_add INT NOT NULL 
*/
ALTER TABLE parts
ADD COLUMN test_add INT NOT NULL AFTER part_no;

SELECT *
FROM parts;