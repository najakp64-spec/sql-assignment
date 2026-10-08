create database ecomm;
use ecomm;

CREATE TABLE customer_churn(
    CustomerID                  INT  PRIMARY KEY,
    Churn                       BIT,
    Tenure                      INT,
    PreferredLoginDevice        VARCHAR(20),
    CityTier                    INT,
    WarehouseToHome             INT,
    PreferredPaymentMode        VARCHAR(20),
    Gender                      ENUM('Male','Female'),
    HourSpendOnApp              INT,
    NumberOfDeviceRegistered    INT,
    PreferedOrderCat            VARCHAR(20),
    SatisfactionScore           INT,
    MaritalStatus               VARCHAR(10),
    NumberOfAddress             INT,
    Complain                    BIT,
    OrderAmountHikeFromlastYear INT,
    CouponUsed                  INT,
    OrderCount                  INT,
    DaySinceLastOrder           INT,
    CashbackAmount              INT
    );
    
    
    -- handling missing values and outliers--
    
  -- 1--  
  
    use ecomm;
    select
          round(avg(WarehouseToHome)) as mean_WarehouseToHome,
          round(avg(HourSpendOnApp)) as mean_HourSpendOnApp,
          round(avg(OrderAmountHikeFromlastYear)) as mean_OrderAmountHikeFromlastYear,
          round(avg(DaySinceLastOrder)) as mean_DaySinceLastOrder from customer_churn;
          
	-- 2--
    
use ecomm;
select Tenure, count(*) as cnt from customer_churn
group by Tenure order by cnt desc limit 1;

select CouponUsed, count(*) as cnt from customer_churn
group by CouponUsed order by cnt desc limit 1;

select OrderCount, count(*) as cnt from customer_churn
group by OrderCount order by cnt desc limit 1;

-- 3--

use ecomm;
select count(*) from customer_churn
where WarehouseToHome > 100;

set sql_safe_updates = 0;
delete from customer_churn
where WarehouseToHome > 100;
set sql_safe_updates = 1;


-- dealing with inconsistencies--

-- 1--

use ecomm;
set sql_safe_updates = 0;
update customer_churn 
set PreferredLoginDevice = "Mobile Phone"
where  PreferredLoginDevice = "Phone";
set sql_safe_updates = 1;

-- 2--

use ecomm;
update customer_churn 
set PreferredPaymentMode = ' Cash on Delivery'
where PreferredPaymentMode = 'COD';

-- data transformation--

-- 1--

use ecomm;
alter table customer_churn rename column PreferedOrderCat to  PreferredOrderCat;

-- 2--

use ecomm;
alter table customer_churn rename column HourSpendOnApp to  HoursSpendOnApp;

-- 3--
use ecomm;
alter table customer_churn add column ComplaintReceived varchar (3);
update customer_churn set ComplaintReceived = 'Yes' 
where customerid > 0 and complain = 1;
update customer_churn set ComplaintReceived = 'No'
where customerid > 0 and complain = 0;

-- 4--

use ecomm;
alter table customer_churn add column churnstatus varchar(10);
update customer_churn set churnstatus = 'churned'
where customerid > 0 and churn = 1;
update customer_churn set churnstatus = 'active'
where customerid > 0 and churn = 0;

select churn,churnstatus from customer_churn limit 5;

-- 5--

alter table customer_churn 
drop column churn;
alter table customer_churn 
drop column complain;


-- data exploration & analysis--

-- 1--

select churnstatus ,
count(*) as customercount from customer_churn
group by churnstatus;

-- 2--

select 
      avg(Tenure) as avg_tenure,
      sum(cashbackamount) as total_cashback
from customer_churn
where churnstatus = 'churned';

-- 3--

select
   complaintreceived,
   count(*) as cnt from customer_churn
   where churnstatus ='churned'
   group by complaintreceived;
   
   -- 4--
   
   select citytier,count(*) from customer_churn
   where churnstatus = 'churned' and preferredordercat='laptop & accessory'
   group by citytier
   order by count(*) desc;
   
   -- 5--
   
   select preferredpaymentmode,
   count(*) as cnt
   from customer_churn
   where churnstatus='active'
   group by preferredpaymentmode
   order by cnt desc;
   
   -- 6--
   
   select sum(orderamounthikefromlastyear) as total_hike from customer_churn
   where maritalstatus= 'single'
   and preferredordercat= 'mobile phone';
   
   -- 7--
   
   select avg(numberofdeviceregistered) as avg_devices from customer_churn
   where preferredpaymentmode= 'UPI';
   
   -- 8--
   
   select citytier,count(*) as total_customers from customer_churn
   group by citytier
   order by total_customers desc limit 1;
   
   -- 9--
   
   select gender, sum(CouponUsed) as total_coupons from customer_churn
   group by gender
   order by total_coupons;
   
   -- 10--
   
   select preferredordercat,
   count(*) as numberofcustomers,
   max(hoursspendonapp) as max_hours_spend from customer_churn
   group by preferredordercat;
   
   
   -- 11-- 
   
   select sum(ordercount) as total_order_count from customer_churn
   where preferredpaymentmode = 'credit card'
   and satisfactionscore = (select max(satisfactionscore)fromcustomer_churn);
   
   -- 12--
   
   select avg(satisfactionscore) as avg_satisfaction_complained from customer_churn
   where complaintreceived = 'true';
   
   -- 13--
 
 select preferredordercat,count(*) as customers from ecomm.customer_churn
 where couponused= 5
 group by preferredordercat;
 
 -- 14--
 
 
 select preferredordercat,avg(cashbackamount) as avg_cashback from ecomm.customer_churn
 group by preferredordercat
 order by avg_cashback desc limit 3;
 
 -- 15--
 
 select preferredpaymentmode, tenure, ordercount
 from ecomm.customer_churn
where tenure = 10 and ordercount > 500;
 
 -- 16--
 
 
 select
    case
    when warehousetohome <= 5 then 'very close distance'
    when warehousetohome <= 10 then 'close distance'
    when warehousetohome <= 15 then 'moderate distance'
    else 'far distance'
    end as distance_category,
    churn,
    count(*) as total from ecomm.customer_churn
    group by distance_category,churn;
    
    
-- 17--

select* from ecomm.customer_churn
where MaritalStatus ='married'
and CityTier=1
and ordercount > (select avg(ordercount) from ecomm.customer_churn);

-- 18--

-- create table
create table ecomm.customer_returns (
         returnid int primary key,
         customerid int,
         returndate date,
         refundamount int);
         
-- insert data
insert into ecomm.customer_returns (ReturnID, CustomerID, ReturnDate, RefundAmount) VALUES
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);

select* from ecomm.customer_churn c
join ecomm.customer_returns r on c.CustomerID=r.customerid
where c.Churn = 1 and c.complain=1;





          
          
    
    