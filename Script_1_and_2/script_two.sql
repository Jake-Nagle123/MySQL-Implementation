USE waterford_fc;

#----------------------------------
# Query 1 - WHERE...IN
# Objective: Return the first name and second name as name, the town, and county
# of employees who live in cork, tipperary and wexford. Sort by second name.
# Used: IN, ORDER BY
#----------------------------------

SELECT CONCAT(firstName, ' ', secondName) AS Name, town AS 'Town', county AS 'County'
FROM Employee
WHERE county IN ('Cork', 'Tipperary', 'Wexford')
ORDER BY secondName, firstName;

#----------------------------------
# Query 2 - WHERE...BETWEEN
# Objective: Using a multi-table join return the suppliers name, contact of supplier name, quantity
# of order, date of order and price where the quantity of the order is between 400 and 800. Sort by
# date of order.
# Used: Multi-table JOINs, Date function, ORDER BY, BETWEEN
#----------------------------------

SELECT supplierName AS 'Supplier', CONCAT(firstName, ' ', lastName) As Name, quantity AS 'Quantity', DATE_FORMAT(orderDate, '%a %D %M, %Y') AS 'Date of Order', price AS 'Price'  
FROM Supplier JOIN Supplies
ON supplier.orderId = supplies.orderId
JOIN Merchandise
ON merchandise.itemId = supplies.itemId
WHERE quantity BETWEEN 400 AND 800
ORDER BY orderDate;

#----------------------------------
# Query 3 - WHERE...LIKE
# Objective: Select stadium where name is like ford. Include the query the difference in days from
# club registraion date. Return the query sorted by registraion date.
# Used: WHERE, LIKE, Wildcard(%), DATEDIFF (Date function), ORDER BY, ORDER BY DESC 
#----------------------------------

SELECT clubName AS 'Team', league AS 'League', clubYear AS 'Registration Date', DATEDIFF(NOW(), clubYear) AS 'Days Ago', clubStadium AS 'Stadium'
FROM Team
WHERE clubStadium LIKE '%ford%'
ORDER BY clubYear DESC;

#----------------------------------
# Query 4 - GROUP BY
# Objective: Group the suppliers of merchandise by the county they are located, giving the 
# count per county. Sort by county.
# Used: Aggregate function (count), GROUP BY, ORDER BY
#----------------------------------

SELECT county AS 'County', COUNT(orderId) AS 'Number of locations'
FROM Supplier
GROUP BY county
ORDER BY county DESC;

#----------------------------------
# Query 5 - GROUP BY
# Objective: Group the merchandise items by price detailing the most expensive and least 
# expensive item. 
# Used: Aggregate function (MAX & MIN), GROUP BY
#----------------------------------

SELECT itemDesc AS 'Item Description', MAX(price) AS 'Most Expensive Item Price',
	   MIN(price) AS 'Least Expensive Item Price'
FROM Merchandise
GROUP BY itemDesc;

#----------------------------------
# Query 6 - GROUP BY
# Objective: Group the names of each supplier, along with every one order number, comma serparted.
# Used: GROUP_CONCAT, GROUP BY, ORDER BY
#----------------------------------

SELECT supplierName AS 'Supplier Name', GROUP_CONCAT(orderId) AS 'Order Numbers'
FROM Supplier
GROUP BY supplierName
ORDER BY supplierName;

#----------------------------------
# Query 7 - GROUP BY...HAVING
# Objective: Group the merchandise items. Include in the query the number of items, item description 
# and most exepensive price. Return only the items priced at over 50.
# Used: GROUP BY, HAVING, Aggregate function (MAX)
#----------------------------------

SELECT itemDesc AS 'Item Description', MAX(price) AS 'Most Expensive Price',
	   COUNT(itemId) AS 'Number of Items'
FROM Merchandise
GROUP BY itemDesc, price
HAVING price >= 50;

#----------------------------------
# Query 8 - GROUP BY..HAVING (Complex)
# Return the Players first name, second name as name, net salary, the sum of the players
# trophy, goal and win bonus, as well their mimuimum contract length. Group by last name
# and first name. Do not include players who currently are on a 4 year contract length
# Used: 3 table JOINS, GROUP BY, HAVING, Aggregate functions, Calculations
#----------------------------------

SELECT CONCAT(firstName, ' ', lastName) AS Name,
	MAX(NetSalary) AS 'Player Salary',
	SUM(trophy + goal + win) AS 'Player Bonuses', MIN(length) AS 'Contract Length'
From Player NATURAL JOIN Contract
NATURAL JOIN Bonus
GROUP BY lastName, firstName
HAVING MIN(length) <> 4;

#----------------------------------
# Query 9 - OUTER JOIN / ORDER BY
# Objective: Create an outer join that will select all the employees from the accountant table. Sort 
# by name.
# Used: OUTER JOIN, LEFT JOIN, ORDER BY
#----------------------------------

SELECT CONCAT(firstName, ' ', secondName) AS Name, trackIncome AS 'Accoutant - Track Income',
	   audit AS 'Accountant - Audit'
FROM Employee LEFT JOIN Accountant
On employee.employeeid = accountant.employeeid
ORDER BY secondName, firstName;

#----------------------------------
# Query 10 - OUTER JOIN / Multiple JOINS
# Objective: Create an outer join that will select all the employees. Included in this will be the 
# accountant and manager tables. Use an outer join to return all the null matches. Sort by name.
# Used: Three Table LEFT JOIN, NATURAL LEFT JOIN, ORDER BY
#----------------------------------

SELECT CONCAT(firstName, ' ', secondName) AS Name, trackIncome AS 'Accoutant - Track Income',
	   audit AS 'Accountant - Audit', gamePlan AS 'Manager - Game Plan', transport AS 'Manager - Transport'
FROM Employee NATURAL LEFT JOIN Accountant
NATURAL LEFT JOIN Manager
ORDER BY secondName, firstName;

COMMIT;