
create database bank;
use bank;

create table branch(
branch_number INT NOT NULL PRIMARY KEY,
branch_Name char(50) NOT NULL);

#2	Inserting Records into created tables Branch
insert into branch (branch_number,branch_Name) values (1,"Bangalore"),(2,"Delhi");
select * from branch;

create table customer(
cust_id INT NOT NULL PRIMARY KEY,
fname char(30),
mname CHAR(30),
lname CHAR(30),
occupation CHAR(10),
dob DATE);

#2. Inserting Records into created table customer
insert into customer (cust_id,fname,mname ,lname,occupation,dob) 
values
(1,"Ramesh", 'Chandra','Sharma','Service','1976-12-06'),
(2,"Avinash", 'Sunder','Minha','Business','1974-10-16');

select * from customer;

create table employee(
emp_no INT NOT NULL PRIMARY KEY,
branch_number INT,
fname char(20),
mname CHAR(20),
lname CHAR(20),
dept CHAR(20),
desig CHAR(10),
mngr_no INT NOT NULL,
FOREIGN KEY(branch_number)REFERENCES branch(branch_number));

#2. Inserting Records into created table employee
insert into employee (emp_no,branch_number ,fname ,mname,lname,dept,desig ,mngr_no ) 
values 
(1,1,'Mark',	'steve','Lara',	'Account',	'Accountant',	2),
(2,2,'Bella','James',	'Ronald',	'Loan',	'Manager',1);

select * from employee;

create table accounts(
acc_number INT NOT NULL PRIMARY KEY	,
cust_id int NOT NULL, 
bid INT NOT NULL,
curbal INT,
acc_type CHAR(10),
open_date DATE,
acc_status  CHAR(10),
FOREIGN KEY(cust_id) REFERENCES customer(cust_id),
FOREIGN KEY(bid) REFERENCES branch(branch_number));

insert into accounts(acc_number ,cust_id , bid,curbal ,acc_type,open_date,acc_status) 
values 
(1,1,1,10000,'saving','2012-12-15','active'),
(2,2,2,'5000','saving','2012-06-12','active');

select * from accounts;

#3.	Select unique occupation from customer table
select distinct occupation from customer;

# 4.	Sort accounts according to current balance 
select * from accounts
order by curbal desc;

# 5.	Find the Date of Birth of customer name ‘Ramesh’
select cust_id, fname, mname, lname, dob date_of_birth from customer
where fname="Ramesh";

#6.	Add column city to branch table 
alter table branch add column city VARCHAR(30);
select*from branch;

# 7.	Update the mname and lname of employee ‘Bella’ and set to ‘Karan’, ‘Singh’ 
set sql_safe_updates =0;
update employee set mname="Karan", lname="Singh"
where fname="Bella";
select * from employee;

#8. Select accounts opened between '2012-07-01' AND '2013-01-01'
select * from accounts
where open_date >= '2012-07-01' and open_date  <= '2013-01-01';

#9.	List the names of customers having ‘a’ as the second letter in their names 
select * from customer
where fname like "_a%";

#10.	Find the lowest balance from customer and account table
select * 
from customer c 
join accounts ac on c.cust_id=ac.cust_id
order by curbal
limit 1;

# 11.	Give the count of customer for each occupation
select occupation,count(occupation) from customer
group by occupation;

#12.	Write a query to find the name (first_name, last_name) of the employees who are managers

# 1st method, considering  employees who are managers basis employee ID and manager ID
select e.emp_no,concat(e.fname," ",e.lname) as emp_full_name,e.mngr_no,concat(m.fname," ",m.lname) as manager_full_name from 
employee e 
join employee m
on e.mngr_no=m.emp_no;

# 2nd method, considering employees who are managers basis their designation
select e.fname,mname,lname from employee e where desig="manager";

#13.	List name of all employees whose name ends with a
select fname,mname,lname, concat(fname," ",mname," ",lname) full_name from customer
where lname like "%a";

#14.	Select the details of the employee who work either for department ‘loan’ or ‘credit’
select * from employee where dept="Loan" or dept="credit";

# 15. Write a query to display the customer number, customer firstname, account number for the customer’s who are born after 15th of any month.

select acc_number, fname, lname, acc_number, dob from customer c join accounts ac on c.cust_id=ac.cust_id
where day(c.dob)>15; 

# 16.	Write a query to display the customer’s number, customer’s firstname, branch id and balance amount for people using JOIN.
select acc_number, fname, bid branch_id, curbal from 
customer c 
join accounts ac on c.cust_id=ac.cust_id
join branch b on ac.bid=b.branch_number;

#17.	Create a virtual table to store the customers who are having the accounts in the same city as they live

create view customer_details as
select acc_number, fname, bid branch_id, branch_name curbal from 
customer c 
join accounts ac on c.cust_id=ac.cust_id
join branch b on ac.bid=b.branch_number;

# 18.	A. Create a transaction table 


create table transactions(
TID INT auto_increment primary key,
cust_id INT,
acc_number INT,
bid INT,
amount DECIMAL,
typr_trans VARCHAR(30),
DOT DATE,
FOREIGN KEY (Cust_id) REFERENCES customer(cust_id),
FOREIGN KEY (acc_number) REFERENCES accounts(acc_number),
FOREIGN KEY (bid) REFERENCES branch(branch_number));

#a. Write trigger to update balance in account table on Deposit or Withdraw in transaction table

select * from transactions;

DELIMITER //
CREATE TRIGGER update_balance
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE amount DECIMAL(10, 2);
    
    -- Get the amount from the inserted transaction
    SET amount = NEW.amount;
    
    IF NEW.typr_trans = 'deposit' THEN
        -- Update balance for deposit
        UPDATE accounts
        SET curbal = curbal + amount
        WHERE acc_number = NEW.acc_number;
    ELSEIF NEW.typr_trans = 'withdraw' THEN
        -- Update balance for withdrawal
        UPDATE accounts
        SET cubal = curbal - amount
        WHERE acc_number = NEW.acc_number;
    END IF;
END //
DELIMITER ;


insert into transactions values(1,1,1,1,1200,'deposit','2023-05-09');
select * from accounts;


#19. Write a query to display the details of customer with second highest balance
select c.*,acc.curbal from  
customer c join 
accounts acc on
c.cust_id=acc.cust_id
order by curbal desc limit 1 offset 1;

BACKUP DATABASE bank TO DISK = 'D:\Great Learning\Mini Project\DBMS\backup_file.bak';
