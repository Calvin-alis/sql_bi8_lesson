/*
	Lesson 4  : 30.11.22
    Work with data and data function 
*/


# MONTH - повертає місяць від дати
SELECT DAYOFMONTH('9999-12-31'), MONTH('2005-01-00');

SELECT NOW(), YEAR(NOW()), MONTH(NOW()), DAY(NOW()), HOUR(NOW());

SELECT NOW(), NOW(6);


SELECT DAYOFMONTH(NOW()), MONTH(NOW()), YEAR(NOW());


SELECT DAYOFMONTH('2002-26-06'), month('2022-07-01');  # поменять местами месяц и день 


SELECT DATE_ADD('2022-11-30', INTERVAL 96 HOUR); 

SELECT DATE_ADD('2022-11-30', INTERVAL 5 DAY); 

SELECT DATE_ADD(NOW(), INTERVAL -5 MONTH); # додавати кількісне значення


SELECT DAYNAME(DATE_ADD('2022-11-30', INTERVAL 5 DAY));

SELECT DAYNAME(NOW()), DAYNAME('1981-05-12') ;

SELECT DAYNAME(DATE_ADD(NOW(), INTERVAL -1 DAY));


SELECT DAYNAME(DATE_ADD('2022-09-12', INTERVAL 5  DAY)); 


SELECT  DAYNAME('1996-02-06');



# Slide 3
SELECT DATE_SUB(NOW(),  INTERVAL 65 MINUTE);

SELECT DATE_SUB(NOW(), INTERVAL -65 MINUTE);

SELECT DATE_ADD('2016-06-01', INTERVAL -1 YEAR);

SELECT DATE_SUB('2022/07/28', INTERVAL 7850000000 second);


# Task 1. Знайти скільки секунд в одному дні * одному році
SELECT 60 * 60 * 24;

SELECT (60 * 60 * 24 * 365) * 5;


SELECT DAYOFYEAR(NOW());

SELECT DAYOFYEAR(DATE_ADD(NOW(), INTERVAL 1 DAY));


SELECT TIMESTAMPDIFF(year, '1998-01-01', NOW());

# статичні дані від до 2037
# Перевод у дні 
SELECT TO_DAYS('2022-06-01 23:34:25'); # може не враховувати високосні роки


SELECT ceil((TO_DAYS('2024-06-01 23:34:25') -  TO_DAYS('9999-06-01 23:34:25')) / 365);


# Slide 4 - AddTime
SELECT ADDTIME('2017-12-31 23:59:59.59999' , '0:0:1.00002');

SELECT ADDTIME('21:14:56', '2000000000:04:0001');


SELECT TO_DAYS('2019-06-01 23:59.59'), TO_DAYS('2019-06-01 00:00.00'); # не має важливість години *тільки дні


SELECT DATE_ADD(NOW(), INTERVAL 10 MINUTE);


# Slide 5 - TimeZone(TZ) - конвертує часові пояси

SELECT @@GLOBAL.time_zone, @@SESSION.time_zone; # глобальна зона так зона сессії 

SELECT NOW();

# Задати свій тайм зон 
SET time_zone  = '+02:00'; # наш час +3, +2
# SET global = '+06:00';



SELECT CONVERT_TZ(NOW(),  '+00:00' ,'+07:00') AS 'Tokio';


# Task 1: От нашого часу змінити зону та вивести її, для 3 часовиї поясів
SELECT CONVERT_TZ(NOW(), '+00:00' ,'+07:00') AS 'Tokio', NOW() AS 'Kyiv';


# Task 1: От нашого часу змінити зону та вивести її, для 3 часовиї поясів

SELECT CONVERT_TZ(NOW(),  '+00:00' ,'-02:00') AS 'London';

SELECT CONVERT_TZ(NOW(),  '+00:00' ,'-10:00') AS 'Kupertino';
SELECT CONVERT_TZ(NOW(),  '+00:00' ,'-02:00') AS 'London';
SELECT CONVERT_TZ(NOW(),  '+00:00' ,'+06:00') AS 'Тайвань', NOW() AS 'Kyiv';


SELECT 
CONVERT_TZ(concat(curdate(), ' ',current_time()) , '+00:00' ,'+06:00'),
CONVERT_TZ(concat(curdate(), ' ',current_time()) , '+00:00' ,'+06:00'),
CONVERT_TZ(concat(curdate(), ' ',current_time()) , '+00:00' ,'+06:00'),
CONVERT_TZ(concat(curdate(), ' ',current_time()) , '+00:00' ,'+06:00')
;


SELECT CONVERT_TZ(now(), '+00:00', '+06:00')  AS 'Time in Tokio', 
				CONVERT_TZ(now(), '+00:00', '-04:00')  AS 'Time in New-York',
                CONVERT_TZ(now(), '+00:00', '+01:00')  AS 'Time in London' ;


# Slide 6 - Now 

SELECT NOW(5);

SELECT NOW() + 0; 

SELECT NOW(4), current_timestamp(5), current_timestamp;

SELECT CURDATE(), current_date(), current_date;

SELECT CURDATE() + 0; # numeric contex 


# Curtime - системний час
SELECT CURTIME();

SELECT CURRENT_TIME(), CURTIME(), CURRENT_TIME;

SELECT CURTIME() + 0; # змінити на числовий тип




# Task 1: Відобразити значення поточної дати -1 рік

SELECT NOW(), curdate();

SELECT YEAR(curdate()) - 1;

SELECT YEAR(CURDATE())  - 1, MONTH(NOW()), DAY(current_timestamp());

SELECT DATE_SUB(curdate(), INTERVAL 1 YEAR);

SELECT DATE_ADD(NOW(), INTERVAL -1 YEAR) AS 'YEAR - 1';


# Task 2: Вивести всіх(порядковий номер) співробітників  і їх зп, кто працює на поточний момент
SELECT * 
FROM employees.salaries;


SELECT emp_no, salary,  from_date,to_date
FROM employees.salaries
WHERE curdate() BETWEEN  from_date AND  to_date;



/* Перевірка 
	Поточна дата 					2022-11-30
	Дата початку періода 		2020-01-01
	Дата закінчення періоду	2023-01-01
*/


# Task 3: Кто працює на поточну дату 01-01-1990
# 1 - var
SELECT *
FROM 	employees.salaries
WHERE from_date <= '1990-01-01' AND to_date >= '1990-01-01'
ORDER BY emp_no;


# 2 - var
SELECT * 
FROM employees.salaries
WHERE '1990-01-01' BETWEEN from_date AND to_date;

SELECT *
FROM salaries;

# Рахує різницю між датами
SELECT TIMESTAMPDIFF(day, NOW(), '2022-08-15');
SELECT TIMESTAMPDIFF(month, NOW(), '2022-09-15');
SELECT TIMESTAMPDIFF(year, NOW(), '2023-09-15');


# Slide 8 - Date_format 
SELECT DATE_FORMAT(NOW(), ' %W-%M-%y'), now();

SELECT DATE_FORMAT(CURRENT_TIME(), '%M %W %H   %h:%i %p'), CURRENT_TIME();


SELECT DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 12 HOUR), '%h %p %s'), CURRENT_TIME();

SELECT DATE_FORMAT(convert_tz(CURTIME(), '+00:00', '+05:00'), '%h:%i:%s') AS 'Time now h small',
				 DATE_FORMAT(convert_tz(CURTIME(), '+00:00', '+05:00'), '%H:%i:%s') AS 'Time now H big';   # test h - 

SELECT DATE_FORMAT(NOW(), '%D-%y -%a %d:%m:%b %j'); 

SELECT DATE_FORMAT(NOW(), '%H %k %I % %r %T %s %w'); 

SELECT DATE_FORMAT(convert_tz(CURTIME(), '+00:00', '+05:00'), '%r  %w');


SELECT DATE_FORMAT(NOW(), '%X %V'); 

SELECT DATE_FORMAT(NOW(), '%x %v');

SELECT DATE_FORMAT(NOW(), '%d%'); # щоб відобразити відсоток потрібно вписати їх два -Старі версії



# Task 1: Відобразити формат відносно поточної дати. Порядковий номер дня місяця, текстова назва місяця і двохзначне число рік
SELECT DATE_FORMAT(NOW(), '%D %M %y') AS 'Current date';


# Task 2: Відобразити формат відносно поточної дати з часом. Номер дня в році, номер тижня в році, текстова назва місяця скорочений формат
SELECT DATE_FORMAT(CONCAT(CURDATE(), ' ', CURTIME()), '%j %V  %b %M') as 'a';

SELECT CONCAT(CURDATE(), ' ', CURTIME());


# Task 3: Відобразити час am or pm 

SELECT DATE_FORMAT(CURRENT_TIME, '%r');

SELECT DATE_FORMAT(CURRENT_TIMESTAMP(), '%I %i %p %M');
				# DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 38 hour ), '%I %i %p %M');
                 
                 

# Slide 13
SELECT DAYOFMONTH(NOW());

SELECT DAYOFWEEK(NOW()); # Початок з неділя 1 - день тижня

SELECT WEEKDAY(NOW()); # Початок з пн 0 - день тижня

SELECT DAYOFWEEK(NOW()), WEEKDAY(NOW()); # 1 до 7  1 -  Sun  7  - Sat,  Weekday 0 - Mon  6 - Sun


SELECT DAYOFYEAR('2016-02-29');

SELECT DAYOFYEAR(NOW());


# Slide 14

SELECT EXTRACT(YEAR FROM NOW()), YEAR(NOW());

SELECT EXTRACT(YEAR_MONTH FROM NOW());

SELECT EXTRACT(DAY_MINUTE FROM NOW()); # Повертае число


SELECT EXTRACT(MICROSECOND FROM '2013-01-12 10:30:00.000133');


SELECT emp_no, first_name, last_name, gender,  EXTRACT(YEAR FROM birth_date) as 'Year'
 FROM employees.employees;



SELECT *
FROM
employees
WHERE MONTH(birth_date) = 1;


# Slide 15 
SELECT TO_DAYS(NOW()) ;

SELECT FROM_DAYS(TO_DAYS(NOW())), TO_DAYS(NOW()) / 365;

SELECT FROM_DAYS(731869);

SELECT FROM_DAYS(366);


# Slide 17 
SELECT unix_timestamp(NOW()); # з 1970 1 січня

SELECT FROM_UNIXTIME(1663177986);

SELECT FROM_UNIXTIME('1663165134') ; -- 0

SELECT  from_unixtime(unix_timestamp(NOW())), 
				unix_timestamp(NOW()); # превращает в дату


# Slide 18
SELECT HOUR('20:06:03');

SELECT HOUR(NOW());


SELECT HOUR(NOW()), MINUTE(NOW());


SELECT LAST_DAY(NOW());

SELECT LAST_DAY(date_add(NOW(), interval 1 month)), 
dayname(LAST_DAY(date_add(NOW(), interval 1 month)));


SELECT LAST_DAY(DATE_ADD(NOW(), INTERVAL 1 MONTH));
SELECT LAST_DAY('2016-02-00');

SELECT LAST_DAY('2016-02-01'), LAST_DAY('2017-02-01');


SELECT DAY(last_day(now())), DAY(NOW());

SELECT DAYNAME(DATE_SUB(NOW(), INTERVAL DAY(NOW())-1 DAY));

# Знайти і вивезти першний день місяця 

# First variant 
SELECT 
    DATE_ADD(LAST_DAY(DATE_ADD(NOW(), INTERVAL - 1 MONTH)),
        INTERVAL 1 DAY),
    DAYNAME(DATE_ADD(LAST_DAY(DATE_ADD(NOW(), INTERVAL - 1 MONTH)),
		INTERVAL 1 DAY));


SELECT DAY(curdate()) - (DAY(CURDATE()) - 1);

# Second variant
SELECT DATE_FORMAT(SUBDATE(NOW(), (day(NOW())-1)), '%M %W') AS 'First day'; # отримати перший день


# Slide 19
SELECT MAKETIME(12,12,30);

SELECT MAKETIME(10,35,17.123456);


# Slide 20
SELECT MONTH('2016-05-02');

SELECT MONTHNAME(NOW()),  MONTHNAME('2022-08-01');


# Slide 21 - Тільки роки і місяці  
SELECT FROM_UNIXTIME(200806);

SELECT from_unixtime(168706905);

SELECT PERIOD_ADD(200806, curdate() + 0);

SELECT PERIOD_ADD(200806,-5);

SELECT PERIOD_ADD(200806, 5 * 12);

SELECT PERIOD_DIFF(201806,201703);  # різниця по місяцям 

SELECT PERIOD_DIFF(200806,201703);

SELECT PERIOD_DIFF(202209,202208);


# Slide 22
SELECT QUARTER('2018-03-11');

SELECT QUARTER('2018-05-11');
SELECT QUARTER('2018-08-11');

SELECT QUARTER('2018-11-11');

SELECT SECOND('11:18:59.10');

SELECT SECOND(NOW()), NOW();


# Slide 23
SELECT STR_TO_DATE('01,5,2013','%d,%m, %Y');

SELECT STR_TO_DATE('May 1, 2013','%M  %d,%Y');

SELECT STR_TO_DATE('a09:30:17','a%h:%i:%s');

SELECT STR_TO_DATE('ab09:30:17','ab%h:%i:%s');

SELECT STR_TO_DATE('09:30:17abcwefwefwef','%h:%i:%s');

SELECT STR_TO_DATE('abc','abc');

SELECT STR_TO_DATE('9','%Y');

SELECT STR_TO_DATE('9','%s');


# Slide 24
SELECT TIME('2013-12-30  01:02:07');

SELECT TIME(NOW());

SELECT TIME('2023-12-31  01:02:03.000623');

SELECT *,TIME(birth_date) FROM employees.employees;

# Slide 25 
SELECT WEEKDAY('2008-02-03 22:23:00');
SELECT WEEKDAY('2007-11-06');

SELECT WEEKOFYEAR('2008-12-31');

SELECT WEEK('2008-02-20');

SELECT WEEK('2008-02-20',0);

SELECT WEEK('2008-02-20',1);

SELECT WEEK('2016-12-31'); 

# Slide 26
SELECT UNIX_TIMESTAMP();
