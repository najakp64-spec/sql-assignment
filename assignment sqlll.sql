-- query for creating database
create schema Employee;

-- query for select database
use Employee;
create table Departments(
department_id int primary key,
department_name varchar(100));

create table Location(
location_id int primary key,
location varchar(30));

create table Employees(
employee_id  int primary key,
employee_name varchar (50),
gender enum('M', 'F'),
age int,
hire_date date,
designation varchar(100),
department_id int,
location_id int,
salary decimal(10,2),
foreign key (department_id) REFERENCES departments (department_id),
foreign key (location_id) REFERENCES location (location_id));

select * from departments;
select * from location;
select * from employees;


alter table employees
add column email varchar (100);

alter table employees
modify column designation varchar(200);

alter table employees
drop column age;

alter table employees
rename column hire_date to date_of_joining;

select * from departments;
select * from location;
select * from employees;


alter table departments
rename to departments_info;

alter table location
rename to locations;

select * from employees;


truncate table employees;
drop table employees;
drop database employees;

select * from employees;


-- database recreation
drop database if exists employee;
create database employee;
use employee;


create table departments(
       department_id int primary key,
       department_name varchar(100) not null unique);
       
       
       
create table location(
       location_id int primary key auto_increment,
       location_name varchar(100) not null unique);
       
       
create table employees(
     employee_id int primary key auto_increment,
     employee_name varchar(100) not null,
     gender char(1) check (gender in ('M' , 'F' )),
     age int check (age >=18),
     hire_date date default (current_date),
     department_id int,
     location_id int,
     foreign key (department_id) references departments(department_id),
     foreign key (location_id) references location(location_id));
     
     
     select * from employees;
     