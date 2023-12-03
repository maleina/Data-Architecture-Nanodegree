--Question 1 
SELECT e.Employee_ID, e.Employee_Name, jt.Job_Title, d.Department_Name
FROM Employee as e
JOIN Employee_Role as er
ON e.Employee_ID = er.Employee_ID
JOIN Job_Title as jt
ON er.Job_Title_Cd = jt.Job_Title_ID
JOIN Department as d
ON er.Department_Cd = d.Department_ID;

-- Question 2
INSERT INTO Job_Title (Job_Title)
VALUES ('Web Programmer');

SELECT * FROM Job_Title;

-- Question 3
UPDATE Job_Title
SET Job_Title = 'Web Developer'
WHERE Job_Title = 'Web Programmer';

SELECT * FROM Job_Title;

-- Question 4
DELETE FROM Job_Title WHERE Job_Title = 'Web Developer';

SELECT * FROM Job_Title;

-- Question 5
SELECT d.Department_Name, count(1) as num_employees
FROM Employee as e
JOIN Employee_Role as er
ON e.Employee_ID = er.Employee_ID
JOIN Department as d
ON er.Department_Cd = d.Department_ID
where er.Role_End_Date >= '2100-01-01'
group by d.Department_Name;

-- Question 6
SELECT e.Employee_Name, jt.Job_Title, d.Department_Name, (SELECT Employee_Name FROM Employee where Employee_ID in (SELECT Manager_ID from Employee where Employee_Name = 'Toni Lembeck')) as manager_name, er.Role_Start_Date, er.Role_End_Date
FROM Employee as e
JOIN Employee_Role as er
ON e.Employee_ID = er.Employee_ID
JOIN Department as d
ON er.Department_Cd = d.Department_ID
JOIN Job_Title as jt
on er.Job_Title_Cd = jt.Job_Title_ID
JOIN Employee_Manager as em
ON e.Employee_ID = em.Employee_ID
where e.Employee_Name = 'Toni Lembeck'
and er.Role_Start_Date = em.Manager_Start_Date;