-- Create new database tables

CREATE TABLE Education_Level (
	Edu_Lvl serial primary key,
	Edu_Lvl_Des varchar(100)
);

CREATE TABLE Employee (
	Employee_ID varchar(10) primary key,
	Hire_Date date,
	Employee_Name varchar(100),
	Email varchar(50),
	Education_Lvl int references Education_Level (Edu_Lvl)
);

CREATE TABLE Job_Title (
	Job_Title_ID serial primary key,
	Job_Title varchar(100)
);

CREATE TABLE Department (
	Department_ID serial primary key,
	Department_Name varchar(100)
);

CREATE TABLE Employee_Role (
	Employee_ID varchar(10) references Employee (Employee_ID),
	Job_Title_Cd int,
	Role_Start_Date date,
	Role_End_Date date,
	Department_Cd int references Department (Department_ID),
	Primary key (Employee_ID, Role_Start_Date)
);

CREATE TABLE Employee_Manager(
	Employee_ID varchar(10) references Employee (Employee_ID),
	Manager_ID varchar(10) references Employee (Employee_ID),
	Manager_Start_Date date,
	Manager_End_Date date,
	Primary key (Employee_ID, Manager_Start_Date)
);

CREATE TABLE Office_Locations (
	Location_ID serial primary key,
	Location_Name varchar(100)
);

CREATE TABLE Employee_Location (
	Employee_ID varchar(10) references Employee (Employee_ID),
	Location_Cd int references Office_Locations (Location_ID),
	Loc_Start_Date date,
	Loc_End_Date date,
	Primary key (Employee_ID, Loc_Start_Date)
);

CREATE TABLE Salary (
	Employee_ID varchar(10) references Employee (Employee_ID),
	Salary money,
	Salary_Start_Date date,
	Salary_End_Date date,
	Primary key (Employee_ID, Salary_Start_Date)
);

CREATE TABLE City (
	City_ID serial primary key,
	City_Name varchar(50)
);

CREATE TABLE State (
	State_ID serial primary key,
	State_Abrv varchar(2)
);

CREATE TABLE Employee_Address (
	Employee_ID varchar(10) primary key references Employee (Employee_ID),
	Address varchar(200),
	City_Cd int references City (City_ID),
	State_Cd int references State (State_ID)
);


-- populate the lookup tables (verify the contents with a select just after inserting)

INSERT INTO Education_Level (Edu_Lvl_Des)
SELECT DISTINCT (education_lvl) FROM proj_stg;

select * from Education_Level;

INSERT INTO Job_Title (Job_Title)
SELECT DISTINCT (JOB_TITLE) FROM proj_stg;

select * from Job_Title;

INSERT INTO Department (Department_Name)
SELECT DISTINCT (DEPARTMENT_NM) FROM proj_stg;

select * from Department;

INSERT INTO Office_Locations (Location_Name)
SELECT DISTINCT (LOCATION) FROM proj_stg;

select * from Office_Locations;

INSERT INTO City (City_Name)
SELECT DISTINCT (CITY) FROM proj_stg;

select * from City;

INSERT INTO State (State_Abrv)
SELECT DISTINCT (STATE) FROM proj_stg;

select * from State;

-- Insert data into core tables and select from them afterwards to verify that they were
--populated correctly

INSERT INTO Employee (Employee_ID, Hire_Date, Employee_Name, Email, Education_Lvl)
SELECT EMP_ID, CAST(HIRE_DT as date), EMP_NM, EMAIL, el.Edu_Lvl
FROM proj_stg as stg
JOIN Education_Level as el
on stg.EDUCATION_LVL = el.Edu_Lvl_Des
where stg.end_dt >= '2100-01-01';

-- Note: there are six employees who have since taken different positions, so the Employee table should have 199 rows
select emp_id, count(1)
from proj_stg
group by emp_id
having count(1) > 1;

select * from Employee;

INSERT INTO Employee_Role (Employee_ID, Job_Title_Cd, Role_Start_Date, Role_End_Date, Department_Cd)
SELECT EMP_ID, jt.Job_Title_ID, CAST(START_DT as date), CAST(END_DT as date), d.Department_ID
FROM proj_stg as stg
JOIN Job_Title as jt
on stg.job_title = jt.job_title
JOIN Department as d
ON stg.department_nm = d.Department_Name;

select * from Employee_Role;

INSERT INTO Employee_Manager (Employee_ID, Manager_ID, Manager_Start_Date, Manager_End_Date)
SELECT EMP_ID, e.employee_id, CAST(START_DT as date), CAST(END_DT as date)
FROM proj_stg as stg
JOIN Employee as e
on stg.manager = e.employee_name;

-- There should be 204 rows since the president doesn't have a manager
select * from Employee_Manager;

INSERT INTO Employee_Location (Employee_ID, Location_Cd, Loc_Start_Date, Loc_End_Date)
SELECT EMP_ID, ol.Location_ID, CAST(START_DT as date), CAST(END_DT as date)
FROM proj_stg as stg
join Office_Locations ol
on stg.location = ol.Location_Name;

select * from Employee_Location;

INSERT INTO Salary (Employee_ID, Salary, Salary_Start_Date, Salary_End_Date)
SELECT EMP_ID, CAST(SALARY as money), CAST(START_DT as date), CAST(END_DT as date)
FROM proj_stg;

select * from Salary;

INSERT INTO Employee_Address (Employee_ID, Address, City_Cd, State_Cd)
SELECT stg.EMP_ID, stg.ADDRESS, c.city_id, s.state_id
FROM proj_stg as stg
join City as c
on stg.city = c.city_name
join state as s
on stg.state = s.state_abrv
where stg.end_dt >= '2100-01-01';

-- Employee address should only have 199 rows because we don't maintain a history
select * from Employee_Address;
