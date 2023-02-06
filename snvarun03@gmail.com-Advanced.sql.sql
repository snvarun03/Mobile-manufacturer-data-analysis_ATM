--SQL Advance Case Study


--Q1--BEGIN 
select [State],f.[Date],f.IDCustomer from FACT_TRANSACTIONS f inner join DIM_DATE d on f.[Date]=d.[DATE] inner join dim_location l on 
f.IDLocation=l.IDLocation
where [YEAR] between 2005 and GETDATE()



--Q1--END

--Q2--BEGIN
select top 1 l.[State],sum(Quantity)[Most qty],ma.Manufacturer_Name
from FACT_TRANSACTIONS f inner join DIM_LOCATION l on f.IDLocation=l.IDLocation inner join DIM_MODEL m on f.IDModel=m.IDModel
inner join DIM_MANUFACTURER ma on m.IDManufacturer=ma.IDManufacturer
where ma.Manufacturer_Name='Samsung' and l.country='US'
group by [State],ma.Manufacturer_Name
order by sum(Quantity) desc









--Q2--END

--Q3--BEGIN      
select Model_Name,count(IDCustomer)[Number of Transactions],ZipCode,[state] from FACT_TRANSACTIONS f 
inner join DIM_LOCATION l on f.IDLocation=l.IDLocation
inner join DIM_MODEL m on f.IDModel=m.IDModel
group by Model_Name,ZipCode,[State]
order by count(idcustomer) desc









--Q3--END

--Q4--BEGIN
select top 1 manufacturer_name,idmodel,model_name,min(unit_price)[Cheap Price] from DIM_MODEL m 
inner join DIM_MANUFACTURER ma on m.IDManufacturer=ma.IDManufacturer
group by idmodel,Model_Name,Manufacturer_Name
order by [Cheap Price] asc








--Q4--END

--Q5--BEGIN
select Manufacturer_Name,Model_Name,avg(Unit_price)[Average price]
from DIM_MODEL m inner join DIM_MANUFACTURER ma on m.IDManufacturer=ma.IDManufacturer
where Manufacturer_Name in (select top 5 Manufacturer_Name from FACT_TRANSACTIONS f inner join DIM_MODEL m on f.IDModel=m.IDModel 
							inner join DIM_MANUFACTURER ma on m.IDManufacturer=ma.IDManufacturer group by Manufacturer_Name
							order by sum(quantity))
group by Manufacturer_Name,Model_Name
order by avg(Unit_price) desc












--Q5--END

--Q6--BEGIN
select Customer_Name,avg(totalprice)[Average price],year(f.[Date])[Year of Transaction]
from DIM_CUSTOMER c inner join FACT_TRANSACTIONS f on c.IDCustomer=f.IDCustomer
where year([Date]) in (select [year] from DIM_DATE where [YEAR]=2009)
group by Customer_Name,year(f.[Date])
having avg(totalprice)>500











--Q6--END
	
--Q7--BEGIN 

select * from (select top 5 Manufacturer_name
    from FACT_TRANSACTIONS f
    left join DIM_Model m on f.IDModel = m.IDModel
    left join DIM_MANUFACTURER ma  on m.IDManufacturer = ma.IDManufacturer
    where datepart(Year,[Date])='2008' 
    group by Manufacturer_name, Quantity 
    Order by  sum(Quantity ) desc 
    intersect
select top 5 Manufacturer_name
    from Fact_Transactions f
    left join DIM_Model m on f.IDModel = m.IDModel
    left join DIM_MANUFACTURER ma  on m.IDManufacturer = ma.IDManufacturer
    Where DATEPART(Year,[Date])='2009' 
    group by Manufacturer_name, Quantity 
    Order by  sum(Quantity ) desc  
    intersect
select top 5 Manufacturer_name
    from Fact_Transactions T1
    left join DIM_Model D1 ON T1.IDModel = D1.IDModel
    left join DIM_MANUFACTURER D2  ON D2.IDManufacturer = D1.IDManufacturer
    where DATEPART(Year,date)='2010' 
    group by Manufacturer_name, Quantity 
    order by  sum(Quantity ) desc)  as topbrand















--Q7--END	
--Q8--BEGIN
select * from(select row_number() over (order by sum(totalprice) desc) as Top2, Manufacturer_Name,sum(totalprice)[Total_amt],year([date])[year] 
from DIM_MANUFACTURER ma inner join DIM_MODEL m on ma.IDManufacturer=m.IDManufacturer
		inner join FACT_TRANSACTIONS f on m.IDModel=f.IDModel where year([date])=2009 group by Manufacturer_Name,year([date])) as T1
where top2=2 
union all
select * from(select row_number() over (order by sum(totalprice) desc) as Top2, Manufacturer_Name,sum(totalprice)[Total_amt],year([date])[year] 
from DIM_MANUFACTURER ma inner join DIM_MODEL m on ma.IDManufacturer=m.IDManufacturer
		inner join FACT_TRANSACTIONS f on m.IDModel=f.IDModel where year([date])=2010 group by Manufacturer_Name,year([date])) as T2
		where top2=2









--Q8--END
--Q9--BEGIN
select Manufacturer_Name from(select Manufacturer_Name,sum(totalprice)[total_amt] from FACT_TRANSACTIONS f
inner join DIM_MODEL m on  f.IDModel=m.IDModel 
inner join DIM_MANUFACTURER ma on  m.IDManufacturer=ma.IDManufacturer where year([date])=2010
group by Manufacturer_Name,year([date])) as Tab_1
except
select Manufacturer_Name from(select Manufacturer_Name,sum(totalprice)[total_amt] from FACT_TRANSACTIONS f 
inner join DIM_MODEL m on  f.IDModel=m.IDModel 
inner join DIM_MANUFACTURER ma on  m.IDManufacturer=ma.IDManufacturer where year([date])=2009
group by Manufacturer_Name,year([date])) as Tab_2


















--Q9--END

--Q10--BEGIN
select top 100 Customer_Name,year(t.[Date]),avg(totalprice)[Average amount spent],avg(quantity)[Average of Quantity],
(avg(totalprice)-lag(avg(totalprice)) over (partition by customer_name order by year(t.[date])))/
lag(avg(totalprice)) over (partition by customer_name order by year(t.[date])) *100 [Year on Year change]
from FACT_TRANSACTIONS t inner join DIM_CUSTOMER c on t.IDCustomer=c.IDCustomer
group by Customer_Name,year(t.[Date])
order by [Average amount spent] desc











--Q10--END
	