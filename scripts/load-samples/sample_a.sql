-- ZESTAW A


-- 1 

SELECT SUM(CASE WHEN f.delay > 0 THEN 1 ELSE 0 END) / COUNT(*)
FROM flight f
  JOIN plane p ON p.id = f.plane_id
  JOIN airline a ON a.id = p.airline_id
  INNER JOIN flight_employee fe ON f.id = fe.flight_id
  INNER JOIN employee e ON e.id = fe.employee_id
GROUP BY a.id;


-- 2

SELECT SUM(CASE WHEN e.gender = 1 THEN 1 ELSE 0 END) AS "all flights (women)",
       SUM(CASE WHEN e.gender = 1 AND f.delay > 0 THEN 1 ELSE 0 END) AS "delayed flights (women)", 
       SUM(CASE WHEN e.gender = 0 THEN 1 ELSE 0 END) AS "all flights (men)", 
       SUM(CASE WHEN e.gender = 0 AND f.delay > 0 THEN 1 ELSE 0 END) AS "delayed flights (men)"
FROM flight f
    INNER JOIN flight_employee fe ON f.id = fe.flight_id
    INNER JOIN employee e ON e.id = fe.employee_id;


-- 3

INSERT INTO employee 
(id, 
 name, 
 surname, 
 birthdate, 
 gender, 
 occupation, 
 employment_date, 
 flown_hours, 
 airline_id)
SELECT employee_id_seq.NEXTVAL, a, b, c, d, f, g, h, i
FROM (SELECT MAX(e.name) a, 
             MIN(e.surname) b, 
             MEDIAN(birthdate) + 10 c,
             ROUND(AVG(CASE WHEN e.gender = 1 THEN 1 ELSE 0 END)) d,
             MIN(e.occupation) f,
             MEDIAN(employment_date) g,
             VARIANCE(flown_hours) / COUNT(*) h,
             e.airline_id i
      FROM employee e
      GROUP BY e.airline_id);


-- 4

UPDATE employee eu
SET eu.flown_hours = (SELECT SUM(24 * (f.arrival - f.departure))
                      FROM flight f
                        JOIN flight_employee fe ON f.id = fe.flight_id
                        JOIN employee e ON e.id = fe.employee_id);


-- 5

DELETE (SELECT *
        FROM airline a
          JOIN employee e ON e.airline_id = a.id
        WHERE TRUNC(MONTHS_BETWEEN(sysdate, e.birthdate)/12) < 18);