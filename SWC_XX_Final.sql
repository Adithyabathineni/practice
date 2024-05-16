USE master;

GO
IF EXISTS (SELECT "name"
           FROM Sysdatabases
           WHERE "name" = 'SWC_XX')
		   BEGIN
		   DROP DATABASE SWC_XX;
		   END

PRINT '>>> Creating a new SWC_XX database';
PRINT '';

GO
CREATE DATABASE SWC_XX;

PRINT '>>> SWC_XX database Created';
PRINT '';

GO
USE SWC_XX;

GO

--=============
-- Table Creation
--=============

PRINT '>>> Creating the Province Table';
PRINT '';

GO

DROP TABLE IF EXISTS Province

GO

CREATE TABLE Province
(
  code NCHAR(2) PRIMARY KEY,
  "name" NVARCHAR(50) NOT NULL,
  frenchName NVARCHAR(50) NOT NULL
);

GO

INSERT INTO Province (code, "name", frenchName) VALUES ('AB', 'Alberta', 'Alberta');
INSERT INTO Province (code, "name", frenchName) VALUES ('BC', 'British Columbia', 'British Columbia');
INSERT INTO Province (code, "name", frenchName) VALUES ('MB', 'Manitoba', 'Manitoba');
INSERT INTO Province (code, "name", frenchName) VALUES ('NB', 'New Brunswick', 'New Brunswick');
INSERT INTO Province (code, "name", frenchName) VALUES ('NL', 'New foundland and Labrador', 'New foundland and Labrador');
INSERT INTO Province (code, "name", frenchName) VALUES ('NS', 'Nova Scotia', 'Nova Scotia');
INSERT INTO Province (code, "name", frenchName) VALUES ('ON', 'Ontario', 'Ontario');
INSERT INTO Province (code, "name", frenchName) VALUES ('PE', 'Prince Edward Island', 'Prince Edward Island');
INSERT INTO Province (code, "name", frenchName) VALUES ('QC', 'Quebec', 'Quebec');
INSERT INTO Province (code, "name", frenchName) VALUES ('SK', 'Saskatchewan', 'Saskatchewan');
INSERT INTO Province (code, "name", frenchName) VALUES ('NT', 'Northwest Territories', 'Northwest Territories');
INSERT INTO Province (code, "name", frenchName) VALUES ('NU', 'Nunavut', 'Nunavut');
INSERT INTO Province (code, "name", frenchName) VALUES ('YT', 'Yukon', 'Yukon');


PRINT '>>> Province Table Created';
PRINT '';

PRINT '>>> Creating the Purchaser Table';
PRINT '';
GO

DROP TABLE IF EXISTS Purchaser

GO

CREATE TABLE Purchaser
(
  id INT PRIMARY KEY,
  "firstName" NVARCHAR(50) NOT NULL
	 CONSTRAINT CK_Purchaser_firstName CHECK(LEN(firstName) >= 3),
  "lastName" NVARCHAR(50),
  "email" NVARCHAR(50) NOT NULL,
  phone NVARCHAR(20) NOT NULL,
  altPhone NVARCHAR(20)
);


GO 

DROP INDEX IF EXISTS idx_emailId ON Purchaser;
CREATE UNIQUE INDEX idx_emailId ON Purchaser(email);

GO

INSERT INTO Purchaser (id, firstName, lastName, email, phone) VALUES(1, 'Joey', 'Doe', 'john.doe@email.com','5876752009');
INSERT INTO Purchaser (id, firstName, lastName, email, phone) VALUES(2, 'May', 'Smith', 'may.smith@email.com','5876952009');
INSERT INTO Purchaser (id, firstName, lastName, email, phone) VALUES(3, 'Vinh', 'Gallagher', 'vinh.gallagher@email.com','5876755644');
INSERT INTO Purchaser (id, firstName, lastName, email, phone) VALUES(4, 'Troy', 'Allen', 'troy.allen@email.com','5874566390');

GO
/* UNCOMMENT THIS TO CHECK FOR UNIQUE CONSTRAINT ON EMAIL
INSERT INTO Purchaser (id, firstName, lastName, email, phone, altPhone)
VALUES (5, 'John', 'Paul', 'AB@example.com', '1234567890', '57487878567');
INSERT INTO Purchaser (id, firstName, lastName, email, phone, altPhone)
VALUES (6, 'Adithya', 'Bathineni', 'AB@example.com', '1234567891', '5748690373'); 
*/
PRINT '>>> Purchaser Table Created';
PRINT '';

PRINT '>>> Creating the PurchaserAddress Table';
PRINT '';
GO

DROP TABLE IF EXISTS PurchaserAddress

GO

CREATE TABLE PurchaserAddress
(
  id INT PRIMARY KEY,
  "purchaserId" INT NOT NULL
	FOREIGN KEY (purchaserId)
	REFERENCES Purchaser(id),
  "streetNumber" INT,
  "streetName" NVARCHAR(50),
  "city" NVARCHAR(50),
  country NVARCHAR(30)
	  CONSTRAINT Country_DF
	  DEFAULT 'CANADA',
  provinceCode NCHAR(2) NOT NULL
	FOREIGN KEY (ProvinceCode)
	REFERENCES Province(code),
  postalCode NVARCHAR(10)
);

GO

INSERT INTO PurchaserAddress (id, "purchaserId","streetNumber", "streetName", "city", provinceCode, postalCode) 
VALUES(101, 1, '890', 'ABC ST E', 'Waterloo', 'ON' ,'N2J 2V2');
INSERT INTO PurchaserAddress (id, "purchaserId","streetNumber", "streetName", "city", provinceCode, postalCode) 
VALUES(102, 2, '900', 'ABC ST E', 'CALGARY', 'AB' ,'C2J 2V3');
INSERT INTO PurchaserAddress (id, "purchaserId","streetNumber", "streetName", "city", provinceCode, postalCode) 
VALUES(103, 3, '163', 'NORTH AVE W', 'WINNIPEG', 'MB' ,'M4R 3E4');
INSERT INTO PurchaserAddress (id, "purchaserId","streetNumber", "streetName", "city", provinceCode, postalCode) 
VALUES(104, 4, '223', 'WINSTON DR', 'VANCOUVER', 'BC' ,'R3W 2EC');

PRINT '>>> PurchaserAddress Table Created';
PRINT '';

PRINT '>>> Creating the Supplier Table';
PRINT '';
GO

DROP TABLE IF EXISTS Supplier

GO

CREATE TABLE Supplier
(
  id int IDENTITY(1001,1) PRIMARY KEY,
  "name" NVARCHAR(20)
);

GO
INSERT INTO Supplier("name") 
VALUES('DELL');
INSERT INTO Supplier("name") 
VALUES('HP');
INSERT INTO Supplier("name") 
VALUES('SAMSUNG');
INSERT INTO Supplier("name") 
VALUES('LENOVO');
INSERT INTO Supplier("name") 
VALUES('MAX');

PRINT '>>> Supplier Table Created';
PRINT '';


DROP TABLE IF EXISTS DesktopBundle

GO

CREATE TABLE DesktopBundle
(
  id INT PRIMARY KEY,
  "name" NVARCHAR(30)
);

GO
INSERT INTO DesktopBundle (id,"name") 
VALUES (1,'DELL ECO');
INSERT INTO DesktopBundle (id,"name") 
VALUES (2,'DELL BIZ');
INSERT INTO DesktopBundle (id,"name") 
VALUES (3,'HP ECO');
INSERT INTO DesktopBundle (id,"name") 
VALUES (4,'HP BIZ');
INSERT INTO DesktopBundle (id,"name") 
VALUES (5,'NA');

PRINT '>>> DesktopBundle Table Created';
PRINT '';

PRINT '>>> Creating the Part Table';
PRINT '';
GO

DROP TABLE IF EXISTS Part

GO

CREATE TABLE Part
(
  number NVARCHAR(20) PRIMARY KEY,
  "type" NVARCHAR(20),
  "description" NVARCHAR(100)
  CONSTRAINT CK_part_description_length CHECK (LEN("description") >= 3),
  "unitPrice" money not null
   CONSTRAINT CK_part_unit_price_positive CHECK ("unitPrice">= $0),
  supplierId INT NOT NULL
	FOREIGN KEY (supplierId)
	REFERENCES Supplier(id),
);

GO
INSERT INTO Part (number,"type", "description", supplierId, unitPrice) 
VALUES('DL1010', 'Desktop', 'Dell Optiplex 1010', 1001, $40);
INSERT INTO Part (number,"type", "description", supplierId, unitPrice)
VALUES('DL5040', 'Desktop', 'Dell Optiplex 5040', 1001, $150);
INSERT INTO Part (number,"type", "description", supplierId, unitPrice)
VALUES('DLM190', 'Monitor', 'Dell 19-inch Monitor', 1001, $35);
INSERT INTO Part (number,"type", "description", supplierId, unitPrice) 
VALUES('HP400', 'Desktop', 'HP Desktop Tower', 1002, $60);
INSERT INTO Part (number,"type", "description", supplierId, unitPrice) 
VALUES('HP800', 'Desktop', 'HP EliteDesk 800G1', 1002, $200);
INSERT INTO Part (number,"type", "description", supplierId, unitPrice)
VALUES('HPM270', 'Monitor', 'HP 27-inch Monitor', 1002, $120);
INSERT INTO Part (number,"type", "description", supplierId, unitPrice) 
VALUES('SM330', 'Tablet', 'Samsung Galaxy Tab 7” Android Tablet', 1003, $110);
INSERT INTO Part (number,"type", "description", supplierId, unitPrice) 
VALUES('LEN101', 'Keyboard', 'Lenovo 101-Key Computer Keyboard', 1004, $7);
INSERT INTO Part (number,"type", "description", supplierId, unitPrice)
VALUES('LEN102', 'Mouse', 'Lenovo Mouse', 1004, $5);
INSERT INTO Part (number,"type", "description", supplierId, unitPrice) 
VALUES('DLM240', 'Monitor', 'Dell 24-inch Monitor', 1001, $80);
INSERT INTO Part (number,"type", "description", supplierId, unitPrice)
VALUES('HPM220', 'Monitor', 'HP 22-inch Monitor', 1002, $45);
INSERT INTO Part (number,"type", "description", supplierId, unitPrice) 
VALUES('MAX901', 'Camera', 'Max Web Camera', 1005, $20);
INSERT INTO Part (number,"type", "description", supplierId, unitPrice)
VALUES('HP501', 'Keyboard', 'HP 101-Key Computer Keyboard', 1002, $9);
INSERT INTO Part (number,"type", "description", supplierId, unitPrice) 
VALUES('HP502', 'Mouse', 'HP Mouse', 1002, $6);

PRINT '>>> Part Table Created';
PRINT '';

PRINT '>>> Creating the PurchaseProduct Table';
PRINT '';
GO

DROP TABLE IF EXISTS PurchaseProduct;
GO

CREATE TABLE PurchaseProduct 
(
  id INT IDENTITY PRIMARY KEY,
  "date" DATETIME,
  "quantity" int NOT NULL
   CONSTRAINT CK_PurchaseProduct_quantity_positive CHECK (quantity > 0),
  "purchaserId" int NOT NULL
	FOREIGN KEY ("purchaserId")
	REFERENCES Purchaser(id),
	"partnumber" nvarchar(20) 
	foreign key("partnumber")
	REFERENCES Part(number), 
  "supplierId" INT NOT NULL
	FOREIGN KEY ("supplierId")
	REFERENCES Supplier(id),
	"cost" MONEY
);

GO
USE [SWC_XX]
GO
/****** Object:  Trigger [dbo].[UpdateCostOnPurchaseProduct]    Script Date: 07-04-2024 19:30:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================
-- **Triggers**
-- Create date: 04-07-2024
-- Description: Trigger to update cost column when
--				purchase data is entered / updated
-- ===============================================

CREATE TRIGGER [dbo].[UpdateCostOnPurchaseProduct]
ON [dbo].[PurchaseProduct]
AFTER UPDATE,INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE PurchaseProduct
    SET cost = (SELECT Part.unitPrice * PurchaseProduct.quantity 
                FROM Part
                WHERE PurchaseProduct.partnumber = Part.number)
END;

GO
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-10-31', 25 , 1, 1001, 'DL1010');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-10-31', 50, 1, 1001, 'DL5040');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-10-31', 25 , 1, 1001, 'DLM190');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-11-10', 15, 2, 1002,'HP400');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-11-20', 20, 2, 1002,'HP800');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-11-20', 20, 2, 1002,'HPM270');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-11-30', 10 , 4, 1003, 'SM330');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-12-05', 50 , 3, 1004, 'LEN101');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-12-05', 50 , 3, 1004, 'LEN102');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-12-05', 80 , 3, 1001, 'DLM240');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-12-10', 30 , 1, 1002, 'HPM220');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-12-15', 100 , 3, 1004, 'LEN102');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-12-15', 40 , 3, 1005, 'MAX901');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-12-20', 100, 4, 1002, 'HP501');
INSERT INTO PurchaseProduct ("date", "quantity","purchaserId","supplierId", partNumber) 
VALUES ('2022-12-20', 100 , 4, 1002, 'HP502');

PRINT '>>> PurchaseProduct Table Created';
PRINT '';

PRINT '>>> Creating the DesktopBundle Table';
PRINT '';
GO

DROP TABLE IF EXISTS DesktopBundle

GO

CREATE TABLE DesktopBundle
(
  id INT PRIMARY KEY,
  "name" NVARCHAR(30)
);

GO
INSERT INTO DesktopBundle (id,"name") 
VALUES (1,'DELL ECO');
INSERT INTO DesktopBundle (id,"name") 
VALUES (2,'DELL BIZ');
INSERT INTO DesktopBundle (id,"name") 
VALUES (3,'HP ECO');
INSERT INTO DesktopBundle (id,"name") 
VALUES (4,'HP BIZ');
INSERT INTO DesktopBundle (id,"name") 
VALUES (5,'NA');

PRINT '>>> DesktopBundle Table Created';
PRINT '';


PRINT '>>> Creating the Part_DesktopBundle Table';
PRINT '';
GO

DROP TABLE IF EXISTS Part_DesktopBundle

GO

CREATE TABLE Part_DesktopBundle
(
  id INT PRIMARY KEY,
  "partNumber" NVARCHAR(20)
	FOREIGN KEY ("partNumber")
	REFERENCES Part(number), 
  "desktopBundleId" INT NOT NULL
	FOREIGN KEY ("desktopBundleId")
	REFERENCES DesktopBundle(id)
);

GO
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (1, 'DL1010', 1);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (2, 'DL5040', 2);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (3, 'DLM190', 2);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (4, 'HP400', 3);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (5, 'HP800', 4);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (6, 'HPM270', 4);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (7, 'LEN101', 1);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (8, 'LEN101', 2);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (9, 'LEN102', 1);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (10, 'LEN102', 2);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (11, 'DLM240', 2);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (12, 'HPM220', 3);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (13, 'MAX901', 4);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (14, 'HP501', 3);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (15, 'HP501', 3);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (16, 'HP502', 4);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (17, 'HP502', 4);
INSERT INTO Part_DesktopBundle (id, "partNumber", "desktopBundleId") 
VALUES (18, 'SM330', 5);


PRINT '>>> Part_DesktopBundle Table Created';
PRINT '';

--===============
-- Views Creation
--===============

PRINT '>>> Creating PurchaseDetailsWithExtendedAmount view';
PRINT '';


DROP VIEW IF EXISTS VW_PurchaseDetailsWithExtendedAmount;
GO

CREATE VIEW VW_PurchaseDetailsWithExtendedAmount AS
SELECT 
    PurchaseProduct.date AS PurchaseDate,
    Purchaser.firstName AS PurchaserFirstName,
    Purchaser.lastName AS PurchaserLastName,
    Supplier.name AS SupplierName,
    Part.number AS PartNumber,
    Part.description AS PartDescription,
    PurchaseProduct.quantity AS Quantity,
    Part.unitPrice AS UnitPrice,
    FORMAT((Quantity * UnitPrice), 'C') AS ExtendedAmount
FROM 
    PurchaseProduct
JOIN 
    Purchaser ON PurchaseProduct.purchaserId = Purchaser.id
JOIN 
    Part ON PurchaseProduct.partNumber = Part.number
JOIN
    Supplier ON PurchaseProduct.supplierId = Supplier.id;
GO

--TEST CASE
--SELECT *
--FROM VW_PurchaseDetailsWithExtendedAmount
--ORDER BY PurchaserFirstName, PurchaseDate, PartNumber;
GO


PRINT '>>> Creating DesktopBundleTotalCost view';
PRINT '';
GO


DROP VIEW IF EXISTS VW_DesktopBundleTotalCost;
GO

CREATE VIEW VW_DesktopBundleTotalCost AS
SELECT 
    DesktopBundle.name AS DesktopBundleName,
    FORMAT(SUM(Part.unitPrice), 'C') AS TotalCost
FROM 
    DesktopBundle 
JOIN 
    Part_DesktopBundle ON DesktopBundle.id = Part_DesktopBundle.desktopBundleId
JOIN 
    Part  ON Part_DesktopBundle.partNumber = Part.number
GROUP BY 
    DesktopBundle.name;

--TEST CASE
-- GO
--SELECT * FROM VW_DesktopBundleTotalCost;

GO
DROP PROC IF EXISTS pGetPurchaseYM;
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ======================
-- **Stored Procedures**
-- ======================

-- ================================================
-- Create date: 04-07-2024
-- Description:	Stored Procedure to check purchases 
--				made by Customers in December 2022
-- ================================================
CREATE PROC pGetPurchaseYM
@Year VARCHAR(20),
@Month VARCHAR(20)
AS
SELECT p.firstName + ' ' + p.lastName [Customer Name],
pp.id [Transaction ID], pp."date" [Purchase Date], pp.partnumber [Part Number], 
FORMAT(cost, 'C') [Purchase Cost]
FROM Purchaser p JOIN PurchaseProduct pp
ON p.id = pp.purchaserId
WHERE DATEPART(YYYY, pp."date") = @Year
AND DATEPART(MM, pp."date") = @Month

--TEST CASE
--GO
--EXEC pGetPurchaseYM
--'2022', '12';


GO
DROP PROC IF EXISTS pGetPurchaseSupplier;
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Create date: 04-08-2024
-- Description:	Stored Procedure to check purchases 
--				that are made against a Supplier
-- ================================================
CREATE PROC pGetPurchaseSupplier
@Supplier VARCHAR(20)
AS
SELECT s.name [Supplier Name],
p.firstName + ' ' + p.lastName [Customer Name], 
pp."date" [Purchase Date], pp.partnumber [Part Number], 
FORMAT(cost, 'C') [Purchase Cost]
FROM Supplier s JOIN PurchaseProduct pp
ON s.id = pp.supplierId
JOIN Purchaser p
ON pp.purchaserId = p.id
WHERE s.name LIKE @Supplier;

-- TEST CASE
--GO
--EXEC pGetPurchaseSupplier
--'DELL';


GO
DROP PROC IF EXISTS pGetPurchasePartType;
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Create date: 04-08-2024
-- Description:	Stored Procedure to check purchases 
--				that are made against a Part Type
-- ================================================
CREATE PROC pGetPurchasePartType
@PartType VARCHAR(20)
AS
SELECT p.number [Part Name],
p.description [Part Description],
pr.firstName + ' ' + pr.lastName [Customer Name],
pp."date" [Purchase Date], 
FORMAT(cost, 'C') [Purchase Cost]
FROM Part p JOIN PurchaseProduct pp
ON p.number = pp.partnumber
JOIN Purchaser pr
ON pp.purchaserId = pr.id
WHERE p.type LIKE @PartType;

-- TEST CASE
--GO
--EXEC pGetPurchasePartType
--'MONITOR';
