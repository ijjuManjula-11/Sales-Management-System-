#SQL PROJECT MANJULA - Redefine Data Analytics 
#Creating DATA BASE MANAGEMENT 
create database sales_management;
use sales_management;
create table employees(
emp_id int primary key,
emp_name varchar(50),
department varchar(50),
salary int ,
joining_date DATE);
insert into employees values(1, 'Ravi Kumar', 'Sales', 45000, '2021-03-15'),
(2, 'Anita Sharma', 'Marketing', 50000, '2020-07-10'),
(3, 'Suresh Reddy', 'Sales', 42000, '2022-01-05'),
(4, 'Neha Verma', 'HR', 48000, '2019-11-20'),
(5,'Rahul','Analytics',45000,'2020-10-20'),
(6,'Siva','Dev',70000,'2020-4-22'),
(7,'paru','IT',80000,'2019-10-11');
#creating customer table 
create table customer(
customer_Id int primary key ,
cust_name varchar(30),
city varchar(30));
#inserting values into customer table
INSERT INTO customer VALUES
(101, 'Arjun Rao', 'Hyderabad'),
(102, 'Priya Singh', 'Bangalore'),
(103, 'Kiran Patel', 'Ahmedabad'),
(104, 'Sneha Iyer', 'Chennai'),
(105,'manjula','vijayawada'),
(106,'sumedha','Hyderabad'),
(107,'ramya','Vijayawada');
#creating Products Table 
create table products(
product_id int primary key,
prod_name varchar(50),
category varchar(40),
price Decimal(10,2));
#inserting values into products table 
INSERT INTO products VALUES
(201, 'Laptop', 'Electronics', 65000.00),
(202, 'Mobile Phone', 'Electronics', 30000.00),
(203, 'Office Chair', 'Furniture', 8500.00),
(204, 'Desk Lamp', 'Furniture', 2500.00),
(205,'Phone','Electronics',35000.00),
(206,'Ipad','Electronics',45000.00),
(207,'Calender','Stationary',55000.00);
#creating Table Orders 
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    emp_id INT,
    customer_id INT,
    product_id INT,
    quantity INT,
    total_amount DECIMAL(10,2),

    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
#inserting values into orders table 
insert into orders values
(1001, '2023-06-10',1,101,201,1,65000.00),
(1002, '2023-06-12',2,102,202,2,60000.00),
(1003, '2023-06-15',3,103,203,3,25500.00),
(1004, '2023-06-18',1,104,204,2,5000.00),
(1005,'2023-07-18',4,104,202,4,56000.00),
(1006,'2023-08-15',5,105,205,3,35000.00),
(1007,'2023-08-29',3,106,204,4,45000.00);
#1.Insert records into all tables. inserting the values into records done 
#2.Retrieve employees from Sales department.
select *from orders;
select emp_name,department from employees where department='sales';
#3. Find products priced above a specific amount.
select product_id,prod_name,category,price from products where price>35000.00;
#4. List customers from a city.
select cust_name,city from customer where city='vijayawada';
#5.update employee salary
update employees 
set salary=56000 where emp_id=3;
#6.Delete old orders.
delete from orders where order_date < '2022-2-10';
#7. Display order details with customer and product info.
select o.order_id,o.order_date,c.cust_name,c.city,p.prod_name,p.category,o.quantity,o.total_amount
 from orders o join customer c on c.customer_id=o.customer_id
 join products p on o.product_id=p.product_id;
 #8.Total orders handled by each employee.
 select e.emp_id,e.emp_name,count(o.order_id) as total_orders from employees e left join 
 orders o on e.emp_id=o.emp_id group by e.emp_id,e.emp_name;
 #9.Customers who never placed an order.
 select c.customer_id,c.cust_name,c.city from customer c left join orders o
 on c.customer_id=o.customer_id where o.order_id is null;
 #10.Total quantity sold per product.
 select p.product_id,p.prod_name,sum(o.quantity)as total_quantity from products p left join orders o on p.product_id=o.product_id
 group by p.product_id,p.prod_name;
 #11. Employees with no orders.
 select e.emp_id,e.emp_name ,e.department
 from employees  e left join orders o on e.emp_id=o.emp_id where o.order_id is null;
 #12. Employees handling multiple product categories.
 select e.emp_id,e.emp_name,count(distinct p.category)as category_count from employees e
 left join orders on e.emp_id=o.emp_id
 join products p on o.product_id=p.product_id group by e.emp_id,e.emp_name having count(distinct p.category)>1;
 #13. Rank employees by sales.
 select e.emp_id,e.emp_name,sum(o.total_amount)as sales_amount ,
 rank() over (order by sum(o.total_amount) desc)as sales_rank 
 from employees e left join orders o on e.emp_id=o.emp_id group by e.emp_id,e.emp_name;
 #14. Running total of sales per employee.
 SELECT 
    e.emp_id, e.emp_name,o.order_date,
    o.total_amount,
    SUM(o.total_amount) OVER (PARTITION BY e.emp_id ORDER BY o.order_date) AS running_total_sales
FROM employees e
JOIN orders o 
    ON e.emp_id = o.emp_id;
#15.Highest paid employee per department.
select e.emp_id,e.emp_name,e.department,e.salary from employees e where e.salary=
(select max(salary) from employees where department=e.department);
#16.Salary vs department average.
select emp_id,emp_name,department,salary ,avg(salary)
 OVER (partition by department)as dept_wise_avg from employees;
 #17.Top 2 Products by category 
 SELECT 
    product_id,prod_name,category,price
FROM (
    SELECT 
        product_id,
        prod_name,
        category,
        price,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS rn
    FROM products
) t
WHERE rn <= 2;
#18.Salary difference from department average.
#19.Customers with more than 3 orders.
select c.customer_id,c.cust_name,c.city,count(o.order_id)as total_orders from customer c 
left join orders o on c.customer_id=o.customer_id group by c.customer_id,c.cust_name
having count(o.order_id)>3;
#20.Employees exceeding average sales.
#21.Monthly sales trends.
SELECT YEAR(order_date) AS year,MONTH(order_date) AS month,SUM(total_amount) AS monthly_sales
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;
#22. Detect duplicate orders.
select customer_id,product_id,order_date,quantity,count(*) as duplicate_count from orders group by
customer_id,product_id,order_date,quantity having count(*)>1;
#23.First and last order per employee.
select e.emp_id,e.emp_name,min(o.order_date) as first_order_date,max(o.order_date)as last_order_date 
from employees e 
join orders o on e.emp_id=o.emp_id group by e.emp_id,e.emp_name;
#24.compare product sales using LAG()
SELECT order_date,total_amount,
LAG(total_amount) OVER (ORDER BY order_date) AS previous_day_sales
FROM orders;
#25.Rank vs Dense_rank 
#rank : rank is a window function that assigns a rank to each row within a partition based on ordering,giving the same 
#rank to same value and skipping the nnext rank numbers 
#example of rank functionn  a-1,b-1,c-3
select emp_id,emp_name,department,salary ,rank() over(partition by department order by salary desc)as ranking from 
employees;
#dense_rank (): Dense_rank is also window function that assigns a rank to each row within a partition based on 
#ordering giving the same value for the same value and withount skipping the rank to next number 
#example : a-1,b-1,c-2 here it not skipped to 3 it continued to the next number 
select emp_id,emp_name,department,salary,dense_rank() over(partition by department order by salary desc)as ranking from
employees;
#26.group by  vs window functions 
#group by (): group by is used to aggregate rows into groups,returning one row per group 
#example
select department,avg(salary) from employees group by department;
#window function():window functions perform calculations across a set of related rows while retaining individual rows 
#27.Inner join vs left join 
#inner join(): inner join is used to get the values if they are matched if their is no row get matched then row 
#get excluded 
#left join(): left join is used to get  all the rows from the left table and matchinng rows from the 
#right table if their is no row matched then it returns the null 
#28.missing join condition impact
#incorect results data becomes meaning less duplicate and unrelated records 
#29.partition by usage 
#partition by is used in window function to divide the data into groups (partitions)while still keeping all individual rows 
#30.real world window functions usage 
#window functions are heavily used in finance ,marketing and for rnaking the data 
#it is used to rank employees in a company based on theier and salary by partitioning 
#2.shows cummulative sales growoth over time 
#3.used to find the duplicates for each order these are the use cases of window functons in real world 
#applications 
#------end---------




 
 
 
 
