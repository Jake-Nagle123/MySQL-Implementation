#----------------------------------------
# Drop the Waterford FC database/schema
#----------------------------------------

DROP SCHEMA IF EXISTS waterford_fc;

#----------------------------------------
# Create Database for Waterford FC
#----------------------------------------

CREATE SCHEMA IF NOT EXISTS waterford_fc;

USE waterford_fc;

#--------------------------------------------------------------------------------
# 01: Create tables for database
#--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TEAM (
clubReg VARCHAR(6) NOT NULL,
clubName VARCHAR(30) NOT NULL,
clubYear DATE NOT NULL,
league VARCHAR(25) NOT NULL,
clubStadium VARCHAR(30) NOT NULL,
PRIMARY KEY (clubReg)
);

CREATE TABLE IF NOT EXISTS EMPLOYEE (
employeeId INT AUTO_INCREMENT,
clubReg VARCHAR(6),
firstName VARCHAR(30) NOT NULL,
secondName VARCHAR(30) NOT NULL,
street VARCHAR(30) NOT NULL,
town VARCHAR(40) NOT NULL,
county VARCHAR(40) NOT NULL,
phoneNumber VARCHAR(30),
PRIMARY KEY (employeeId),
CONSTRAINT fk_clubReg_01 FOREIGN KEY(clubReg) REFERENCES TEAM(clubReg)
ON UPDATE CASCADE
ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS ACCOUNTANT (
employeeId INT NOT NULL,
trackIncome VARCHAR(20),
audit VARCHAR(20),
PRIMARY KEY (employeeId),
CONSTRAINT fk_employeeId_01 FOREIGN KEY(employeeId) REFERENCES EMPLOYEE(employeeId)
ON UPDATE CASCADE
ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS MANAGER (
employeeId INT NOT NULL,
clubReg VARCHAR(6) NOT NULL,
gamePlan ENUM('A', 'B', 'C'),
transport ENUM('Car', 'Plane', 'Bus', 'Other'),
PRIMARY KEY (employeeId),
CONSTRAINT fk_employeeId_02 FOREIGN KEY(employeeId) REFERENCES EMPLOYEE(employeeId)
ON UPDATE CASCADE
ON DELETE NO ACTION,
CONSTRAINT fk_clubReg_02 FOREIGN KEY(clubReg) REFERENCES TEAM(clubReg) 
ON UPDATE CASCADE
ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS SUPPLIER (
orderId VARCHAR(8) NOT NULL,
supplierName VARCHAR(25) NOT NULL,
firstName VARCHAR(30) NOT NULL,
lastName VARCHAR(30) NOT NULL,
street VARCHAR(30) NOT NULL,
town VARCHAR(40) NOT NULL,
county VARCHAR(40) NOT NULL,
phoneNumber VARCHAR(30),
PRIMARY KEY (orderId)
);

CREATE TABLE IF NOT EXISTS MERCHANDISE (
itemId VARCHAR(10) NOT NULL,
clubReg VARCHAR(6),
itemDesc VARCHAR(255) NOT NULL,
size ENUM('S', 'M', 'L'),
color ENUM('Blue', 'Black', 'White', 'Green'),
price DECIMAL(5,2) NOT NULL,
PRIMARY KEY (itemId),
CONSTRAINT fk_clubReg_03 FOREIGN KEY(clubReg) REFERENCES TEAM(clubReg)
ON UPDATE CASCADE
ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS SUPPLIES (
orderId VARCHAR(8) NOT NULL,
itemId VARCHAR(10) NOT NULL,
quantity INT NOT NULL,
orderDate DATE NOT NULL,
PRIMARY KEY (orderId, itemId),
CONSTRAINT fk_orderId FOREIGN KEY(orderId) REFERENCES SUPPLIER(orderId)
ON UPDATE CASCADE 
ON DELETE NO ACTION,
CONSTRAINT fk_itemId FOREIGN KEY(itemId) REFERENCES MERCHANDISE(itemId)
ON UPDATE CASCADE
ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS PLAYER (
playerId INT AUTO_INCREMENT NOT NULL,
clubReg VARCHAR(6),
shirtNumber TINYINT UNSIGNED NOT NULL,
plPosition ENUM('GK', 'DF', 'MD', 'FW') NOT NULL,
firstName VARCHAR(30) NOT NULL,
lastName VARCHAR(30) NOT NULL,
street VARCHAR(30) NOT NULL,
town VARCHAR(40) NOT NULL,
county VARCHAR(40) NOT NULL,
phoneNumber VARCHAR(30),
emailAddress VARCHAR(40),
PRIMARY KEY (playerId),
CONSTRAINT fk_clubReg_04 FOREIGN KEY(clubReg) REFERENCES TEAM(clubReg)
ON UPDATE CASCADE
ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS CONTRACT (
contractId VARCHAR(8),
playerId INT NOT NULL,
netSalary DECIMAL(7,2),
length TINYINT UNSIGNED,
PRIMARY KEY (contractId),
CONSTRAINT fk_playerId FOREIGN KEY(playerId) REFERENCES PLAYER(playerId)
ON UPDATE CASCADE
ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS BONUS (
bonusId VARCHAR(4) NOT NULL,
contractId VARCHAR(8),
trophy DECIMAL(7,2),
goal DECIMAL(6,2),
win DECIMAL(6,2),
PRIMARY KEY (bonusId),
CONSTRAINT fk_contractId FOREIGN KEY(contractId) REFERENCES CONTRACT(contractId)
ON UPDATE CASCADE
ON DELETE SET NULL
);

COMMIT;

#--------------------------------------------------------------------------------
# 02: Populate tables with records
#--------------------------------------------------------------------------------

INSERT INTO Team (clubReg, clubName, clubYear, league, clubStadium) VALUES
('100750', 'Waterford FC', '2017-07-20', 'Premier Division', 'Turners Cross'),
('100800', 'Waterford FC', '2018-07-14', 'Premier Division', 'Turners Cross'),
('100850', 'Waterford FC', '2019-06-10', 'Second division', 'Turners Cross'),
('100900', 'Waterford United FC', '2020-06-23', 'Second division', 'Turners Cross'),
('101000', 'Waterford United FC', '2021-07-24', 'Second division', 'Waterford RSC'),
('101150', 'Waterford United FC', '2022-08-10', 'Second division', 'Waterford RSC'),
('101300', 'Waterford FC', '2023-06-01', 'Premier Division', 'Waterford RSC'),
('101500', 'Waterford FC', '2024-07-22', 'Premier Division', 'Waterford RSC');

INSERT INTO Employee VALUES
(1, '101500', 'Mikey', 'Foster', 'Abbeyside', 'Dungarvan', 'Waterford', '0514219786'),
(2, '101300', 'Liam', 'Turner', '5 Ballycarnane Woods', 'Tramore', 'Waterford', '0515084623'),
(3, '101150', 'Mary', 'Burch', '7 Riverstone Road', 'Clonmel', 'Tipperary', '0629554771'),
(4, '101000', 'Jason', 'Boyd', '7 North St', 'New Ross', 'Wexford', '0532419872'),
(5, '100900', 'Irene', 'Carson', '3 King Street Upper', 'Dungarvan', 'Waterford', '0515725045'),
(6, '100850', 'Amie', 'Finch', '14 Church St', 'Youghal', 'Cork', '0219810683'),
(7, '100800', 'Mikey', 'Moore', '6 Drurys Ave', 'Midleton', 'Cork', '0218514679'),
(8, '100750', 'Freddy', 'Wood', '3 The Orchard', 'Dunmore', 'Waterford', '0516851609');

INSERT INTO Accountant VALUES
(1, 'Daily', 'Yearly'),
(2, 'Daily', null),
(3, 'Daily', 'Yearly'),
(4, null, 'Yearly'),
(5, 'Daily', null),
(6, null, 'Yearly'),
(7, 'Daily', null),
(8, null, null);

INSERT INTO Manager VALUES
(1, '101500', null, null),
(2, '101300', null, null),
(3, '101150', null, null),
(4, '101000', null, null),
(5, '100900', null, null),
(6, '100850', null, null),
(7, '100800', null, null),
(8, '100750', 'A', 'Car');

INSERT INTO Supplier(orderId, supplierName, firstName, lastName, street, town, county, phoneNumber)
VALUES
('0001', 'Northshore Clothing', 'Declan', 'McCarthy', '22 O\'Connell Street', 'Limerick City', 'Limerick', '0612342567'),
('0002', 'Northshore Clothing', 'Ronan', 'Kelly', '22 O\'Connell Street', 'Limerick City', 'Limerick', '0612342567'),
('0003', 'CuppaCraft Co.', 'Siobhan', 'McKeegan', '12 Copper Coast Road', 'Dunmore East', 'Waterford', '0518767543'),
('0004', 'BrewBuddy Creations', 'Conor', 'Murphy', '12 Harbourview Drive', 'Kinsale', 'Cork', '0214567890'),
('0005', 'Ember Streetwear', 'Niamh', 'Walsh', '22 Ballybricken Heights', 'Waterford City', 'Waterford', '0518234567'),
('0006', 'Vanguard Threads', 'Padraig', 'Nolan', '2 The Green', 'Ardmore', 'Waterford', '0513876543'),
('0007', 'Northshore Clothing', 'Ronan', 'Kelly', '22 O\'Connell Street', 'Limerick City', 'Limerick', '0612342567'),
('0008', 'Vanguard Threads', 'Orla', 'Dunne', '2 The Green', 'Ardmore', 'Waterford', '0513876543');

INSERT INTO Merchandise VALUES
('1024620050', '101500', 'Jersey 2024', 'M', 'Blue', 60.00),
('1034620075', '101300', 'Jersey 2023', 'M', 'Blue', 60.00),
('1038621053', '101150', 'Mug 2022', 'L', 'Black', 15.00),
('1048691003', '101000', 'Mug 2021', 'M', 'White', 12.50),
('1055830054', '100900', 'Shorts 2020', 'S', 'White', 45.00),
('1064990010', '100850', 'Jersey 2019', 'L', 'Black', 70.00),
('1074620170', '100800', 'Jersey 2018', 'S', 'Blue', 50.00),
('1084621112', '100750', 'Jersey 2017', 'M', 'Black', 60.00);

INSERT INTO Supplies VALUES
('0001', '1024620050', 750, '2024-02-24'),
('0002', '1034620075', 500, '2024-02-06'),
('0003', '1038621053', 250, '2024-05-12'),
('0004', '1048691003', 250, '2024-08-06'),
('0005', '1055830054', 500, '2024-07-23'),
('0006', '1064990010', 600, '2024-09-28'),
('0007', '1074620170', 200, '2024-02-06'),
('0008', '1084621112', 500, '2024-11-01');

INSERT INTO Player VALUES
(1, '101500', 8, 'MD', 'Sean', 'Murphy', '42 Riverbank Lane', 'Ballygunner', 'Waterford', '0871234567', 'sean.murphy@waterfordmail.ie'),
(2, '101300', 7, 'FW', 'Liam', 'Kelly', '7 Church Hill', 'Tramore', 'Waterford', '0859876543', 'liam.kelly@fastmail.ie'),
(3, '101150', 14, 'MD', 'Eoin', 'Walsh', '4 Lismore Close', 'Ferrybank', 'Waterford', '0865432198', 'eoin.walsh@waterfordmail.ie'),
(4, '101000', 10, 'FW', 'Cathal', 'Hogan', '33 Castleview Drive', 'Dungarvan', 'Waterford', null, 'cathal.hogan@gmail.ie'),
(5, '100900', 4, 'DF', 'Declan', 'Kelly', '8 Main Street', 'Passage East', 'Waterford', '0837654321', 'declan.kelly@fastmail.ie'),
(6, '100850', 9, 'FW', 'Tadhg', 'Moloney', '14 Seaview Terrace', 'Tramore', 'Waterford', null, 'tadhg.moloney@gmail.ie'),
(7, '100800', 3, 'DF', 'Dara', 'Kinsella', '5 Abbeyside Walk', 'Dungarvan', 'Waterford', '0891122334', 'dara.kinsella@waterfordmail.ie'),
(8, '100750', 20, 'GK', 'Conor', 'Hayes', '8 Barrack Street', 'Waterford City', 'Waterford', '0876543210', 'conor.hayes@gmail.ie');

INSERT INTO Contract VALUES
('10223456', 1, 8000.00, 5),
('10334567', 2, 12000.00, 3),
('10445678', 3, 6500.00, 4),
('10556789', 4, 8500.00, 3),
('10667890', 5, 6500.00, 2),
('10778901', 6, 7250.00, 3),
('10889012', 7, 8500.00, 5),
('10990123', 8, 4000.00, 4);

INSERT INTO Bonus VALUES
('0001', '10223456', 5000.00, 800.00, 400.00),
('0002', '10334567', 5000.00, 1200.00, 600.00),
('0003', '10445678', 5000.00, 500.00, 200.00),
('0004', '10556789', 4500.00, 750.00, 250.00),
('0005', '10667890', 3000.00, 400.00, 350.00),
('0006', '10778901', 5000.00, 650.00, 400.00),
('0007', '10889012', 4000.00, 350.00, 500.00),
('0008', '10990123', 2500.00, 100.00, 150.00);

COMMIT;

#--------------------------------------------------------------------------------
# 03: Create Indexes
#--------------------------------------------------------------------------------

# Index for Team(team registration)
CREATE UNIQUE INDEX team_clubreg_indx ON Team(clubReg DESC);

SHOW INDEX FROM Team;

# Index for Employee(countys based)
CREATE INDEX emp_county ON Employee(county);

SHOW INDEX FROM Employee;

# Index for Accountant(income tracking)
CREATE INDEX acc_trackinc ON Accountant(trackIncome);

SHOW INDEX FROM Accountant;

# Index for Supplier names
CREATE INDEX supplier_name ON Supplier(supplierName);

SHOW INDEX FROM Supplier;

# Index for Supplies(order dates)
CREATE INDEX supplies_orddt ON Supplies(orderDate DESC);

SHOW INDEX FROM Supplies;

# Index for Merchandise(prices)
CREATE INDEX merch_price ON Merchandise(price DESC);

SHOW INDEX FROM Merchandise;

# Index for Player(email addresses)
CREATE INDEX player_email ON Player(emailAddress);

SHOW INDEX FROM Player;

# Index for Contract(length of)
CREATE INDEX contract_length ON Contract(length DESC);

SHOW INDEX FROM Contract;


COMMIT;

#--------------------------------------------------------------------------------
# 04: Create Triggers
#--------------------------------------------------------------------------------

#----------------------------------
# Trigger 1 - Before Insert Trigger
#----------------------------------

# Creating a Trigger to ensure that no player Contract is entered over 5 years
DELIMiTER $$
CREATE TRIGGER before_contract_insert
	BEFORE INSERT ON Contract
	FOR EACH ROW
	IF NEW.length > 5 THEN SET NEW.length = 5;
END IF $$
DELIMITER ;

COMMIT;

# A look at the Contract table before Trigger test / changes made
SELECT *
FROM Contract;

# Test of before_contract_insert Trigger (Changes made to player 7(length = 9) & player 8(length = 50 )
INSERT INTO Contract (contractId, playerId, netSalary, length) VALUES
('10105890', 7, 6000.00, 9),
('10115891', 8, 7500.00, 50);

# Table view - Trigger works if length for Player 7 & 8 is 5 
# Notice length of playerId 7 & 8 equals 5 despite inserting 9 and 50 values
SELECT *
FROM Contract
ORDER BY length DESC;

# Undo Insert into Contract (Testing done, going back to last Commit before testing phase)
ROLLBACK;

# Table gone back to how was entered at beginning
SELECT *
FROM Contract;

COMMIT;

#----------------------------------
# Trigger 2 - After Insert Trigger
#----------------------------------

# Creating a table that will store the next Triggers information
# The role of the Trigger will be to store the Teams new registrations (clubReg) every year
CREATE TABLE IF NOT EXISTS teamRegistry_records (
id INT AUTO_INCREMENT NOT NULL,
clubReg VARCHAR(6) NOT NULL,
action VARCHAR(50),
changedate DATETIME,
PRIMARY KEY (id),
CONSTRAINT clubReg FOREIGN KEY(clubReg) REFERENCES Team(clubReg)
ON UPDATE CASCADE
ON DELETE NO ACTION
);

# Creating a Trigger to store new Team registrations every year
# Will store an id, the new club registraion, action and when details added
DELIMITER $$
CREATE TRIGGER after_team_insert
	AFTER INSERT ON Team
	FOR EACH ROW
BEGIN
    INSERT INTO teamRegistry_records
    VALUES (id, NEW.clubReg, 'INSERT', NOW());
END $$
DELIMITER ;

COMMIT;

# A look at the Team table before Trigger test / changes made
SELECT *
FROM Team;

# Test the after_team_insert Trigger by inserting values into the Team table
INSERT INTO Team (clubReg, clubName, clubYear, league, clubStadium) VALUES
('101800', 'Waterford FC', '2024-12-20', 'Premier Division', 'Turners Cross');

# A look at the now updated Team table after inserting new values in  
# By using the ORDER BY I have put the new values(clubReg 101800) on the Top line
SELECT *
FROM Team
ORDER BY clubReg DESC;

# A look at the table created for teamRegistry_records Trigger 
# The teamRegistry_records Trigger table worked if (id, clubReg, insert, date & time) added to table
SELECT *
FROM teamRegistry_records;

# Undo Insert into Team(Testing done, Trigger works - going back to last Commit before testing phase)
ROLLBACK;

#----------------------------------
# Trigger 3 - Before Update Trigger
#----------------------------------

# Creating a table (player_audit) that will store the Triggers information
# Reasoning for Trigger is to document if a player changes position, shirt Number, moves county
CREATE TABLE IF NOT EXISTS player_audit (
    updateId INT AUTO_INCREMENT NOT NULL,
    playerId INT,
    shirtNumber TINYINT UNSIGNED,
    plPosition ENUM('GK', 'DF', 'MD', 'FW'),
    county varchar(40),
    updateDate DATETIME,
    action VARCHAR(50),
    PRIMARY KEY (updateId),
    CONSTRAINT playerId FOREIGN KEY(playerId) REFERENCES Player(playerId)
	ON UPDATE CASCADE
	ON DELETE NO ACTION
);

# Creating a Trigger - role of the Trigger will be to store players old info before update made
DELIMITER $$
CREATE TRIGGER before_player_update
	BEFORE UPDATE ON Player
	FOR EACH ROW
BEGIN
	INSERT INTO player_audit
    SET action = 'update',
	playerId = OLD.playerId,
	shirtNumber = OLD.shirtNumber,
    plPosition = OLD.plPosition,
    county = OLD.county,
    updateDate = NOW();
END $$
DELIMITER ;

COMMIT;

# View player table before test / changes (PlayerId 5 will be changed)
SELECT * 
FROM Player;

# Change / test the Trigger by updating Player Table (this should update Trigger)
UPDATE Player
SET shirtNumber = 6, plPosition = 'FW', county='Cork'
WHERE playerId = 5;

# Look to see if Trigger table sucessfully updated
SELECT *
FROM player_audit;

# View updated player table post changes (PlayerId 5 changed)
SELECT * 
FROM Player;

# Undo Update of Player Table (Testing done, going back to last Commit before testing phase)
ROLLBACK;

#----------------------------------
# Show All Triggers
#----------------------------------

SHOW TRIGGERS;


#--------------------------------------------------------------------------------
# 05: Create views
#--------------------------------------------------------------------------------

#----------------------------------
# View 01 - Show all Accoutants who track income
#----------------------------------

# WITH CHECK OPTION added for security and making table view only releveant to that specific group
# Now end users not able to insert or update other areas (for example accountant.audit)
CREATE OR REPLACE VIEW accountants_tracking_income AS
	SELECT accountant.employeeId, CONCAT(firstName, ' ', secondName) AS Name, trackIncome
    FROM Employee JOIN Accountant
    ON employee.employeeId = accountant.employeeId
    WHERE accountant.trackIncome IS NOT Null
    WITH CHECK OPTION;

# View the output of View 01
SELECT * FROM accountants_tracking_income;

#----------------------------------
# View 02 - Simplifying order from Suppliers for end users 
#----------------------------------

CREATE OR REPLACE VIEW ordersfromsuppliers AS
	SELECT supplier.orderId, supplierName, CONCAT(firstName, ' ', lastName) AS Name, quantity, orderDate
	FROM Supplier NATURAL JOIN Supplies;
    
# View the output of View 02
SELECT * FROM ordersfromsuppliers;

#----------------------------------
# View 03 (Part_1)  - Simplifying search for Players basic details
#----------------------------------

# Creating View 03 - playerdetails
CREATE OR REPLACE VIEW playerdetails AS
	SELECT playerId, CONCAT(firstName, ' ', lastName) AS Name, shirtNumber, plPosition, county
    FROM Player;
    
# View the output of View 03 - playerdetails
SELECT * FROM playerdetails;

#----------------------------------
# View 03 (Part_2) - Simplifying search for Players basic details
# Using Alter View statement to make changes
#----------------------------------

# Using ALTER VIEW statement to only select attacking players (forwards, midfielders)
ALTER VIEW playerdetails AS
	SELECT playerId, CONCAT(firstName, ' ', lastName) AS Name, shirtNumber, plPosition, county
    FROM Player
    WHERE plPosition IN ('FW', 'MD');

# View the output of the modified View (View 03 (Part_2)) - playerdetails
SELECT * FROM playerdetails;

#----------------------------------
# View 04 - Simplifying search for Employee basic details
#----------------------------------

# Creating View 04 - employeedetails (With check option added)
CREATE OR REPLACE VIEW employeedetails AS
	SELECT employeeId, CONCAT(firstName, ' ', secondName) AS Name, county, phoneNumber AS 'Contact Details'
	FROM Employee
    WITH CHECK OPTION; 

# View the output of the View (View 04) - employeedetails
SELECT * FROM employeedetails;

#----------------------------------
# Showing all Views created & their output
#----------------------------------

# Using the SHOW FULL TABLES statement with pattern matching to show only VIEWS in table return
SHOW FULL TABLES
WHERE table_type LIKE 'V%';

# View - 01
SELECT * FROM accountants_tracking_income;

# View - 02
SELECT * FROM ordersfromsuppliers;

# View - 03
SELECT * FROM playerdetails;

# View - 04
SELECT * FROM employeedetails;


COMMIT;






