-- =================================================
-- ========= DESGLOSE ADVENTURE WORKS 2019 =========
-- =================================================

-------------------------------------------
-- IMPORTANTE RECORDAR !!!!!!!!!!!!!!!!!!!:
-------------------------------------------

-- GROUP BY ----> Se procesa antes que SELECT

-- FROM ----> Se procesa antes que SELECT y que GROUP BY

-- NO podemos usar un ALIAS en la cláusula WHERE. Solo puede usar alias en una cláusula ORDER BY.

-- Las tablas derivadas tampoco pueden tener una cláusula ORDER BY. La consulta externa puede, pero la 
-- consulta interna no.

-- La cláusula ORDER BY no es válida en vistas, funciones inline, tablas derivadas, subconsultas y 
-- expresiones de tabla comunes, a menos que también se especifique TOP, OFFSET o FOR XML.

-- ============================================================================================
-- ============================================================================================

-- BusinessEntityID es el ID del empleado

SELECT * FROM [HumanResources].[Employee]                  -- BusinessEntityID
SELECT * FROM [HumanResources].[Department]                -- DepartmentID
SELECT * FROM [HumanResources].[EmployeeDepartmentHistory] -- BusinessEntityID, DepartmentID, ShiftID
SELECT * FROM [HumanResources].[JobCandidate]
SELECT * FROM [HumanResources].[EmployeePayHistory]
SELECT * FROM [HumanResources].[JobCandidate]
SELECT * FROM [HumanResources].[Shift]

-- PersonID 
-- PersonType nos indica si la persona es EM: Employee, IN: , SP: , SC: , VC: , GC:
-- ContactTypeID

SELECT * FROM [Person].[Address]                -- AddressID, StateProvinceID
SELECT * FROM [Person].[AddressType]            -- AddressTypeID
SELECT * FROM [Person].[BusinessEntity]         -- BusinessEntityID
SELECT * FROM [Person].[BusinessEntityAddress]  -- BusinessEntityID, AddressID, AddressTypeID
SELECT * FROM [Person].[BusinessEntityContact]  -- BusinessEntityID, PersonID, ContactTypeID
SELECT * FROM [Person].[ContactType]            -- ContactTypeID
SELECT * FROM [Person].[CountryRegion]          -- CountryRegionCode
SELECT * FROM [Person].[EmailAddress]           -- BusinessEntityID, EmailAddressID
SELECT * FROM [Person].[Password]               -- BusinessEntityID
SELECT * FROM [Person].[Person]                 -- BusinessEntityID, PersonType
SELECT * FROM [Person].[PersonPhone]            -- BusinessEntityID, PhoneNumberTypeID
SELECT * FROM [Person].[PhoneNumberType]        -- PhoneNumberTypeID
SELECT * FROM [Person].[StateProvince]          -- StateProvinceID, StateProvinceCode, CountryRegionCode,TerritoryID


SELECT * FROM [Production].[BillOfMaterials]
SELECT * FROM [Production].[Culture]                   -- CultureID
SELECT * FROM [Production].[Document]
SELECT * FROM [Production].[Illustration]
SELECT * FROM [Production].[Location]                  -- LocationID
SELECT * FROM [Production].[Product]                   -- ProductID, ProductSubcategoryID, ProductModelID
SELECT * FROM [Production].[ProductSubcategory]        -- ProductSubcategoryID, ProductCategoryID
SELECT * FROM [Production].[ProductCategory]           -- ProductCategoryID
SELECT * FROM [Production].[ProductCostHistory]        -- ProductID
SELECT * FROM [Production].[ProductDescription]        -- ProductDescriptionID
SELECT * FROM [Production].[ProductDocument]
SELECT * FROM [Production].[ProductInventory]          -- ProductID, LocationID
SELECT * FROM [Production].[ProductListPriceHistory]   -- ProductID
SELECT * FROM [Production].[ProductModel]              -- ProductModelID
SELECT * FROM [Production].[ProductModelIllustration]
SELECT * FROM [Production].[ProductModelProductDescriptionCulture]
SELECT * FROM [Production].[ProductPhoto]
SELECT * FROM [Production].[ProductProductPhoto]
SELECT * FROM [Production].[ProductReview]
SELECT * FROM [Production].[ScrapReason]
SELECT * FROM [Production].[TransactionHistory]        -- TransactionID, ProductID, ReferenceOrderID, ReferenceOrderLineID
SELECT * FROM [Production].[TransactionHistoryArchive] -- TransactionID, ProductID, ReferenceOrderID, ReferenceOrderLineID
SELECT * FROM [Production].[UnitMeasure]
SELECT * FROM [Production].[WorkOrder]
SELECT * FROM [Production].[WorkOrderRouting]


SELECT * FROM [Purchasing].[ProductVendor]        -- ProductID, BusinessEntityID
SELECT * FROM [Purchasing].[PurchaseOrderDetail]  -- PurchaseOrderID, PurchaseOrderDetailID, 
SELECT * FROM [Purchasing].[PurchaseOrderHeader]  -- PurchaseOrderID, EmployeeID, VendorID, ShipMethodID
SELECT * FROM [Purchasing].[ShipMethod]           -- ShipMethodID
SELECT * FROM [Purchasing].[Vendor]               -- BusinessEntityID


SELECT * FROM [Sales].[CountryRegionCurrency]        -- CountryRegionCode, CurrencyCode
SELECT * FROM [Sales].[CreditCard]                   -- CreditCardID
SELECT * FROM [Sales].[Currency]                     -- CurrencyCode
SELECT * FROM [Sales].[CurrencyRate]                 -- CurrencyRateID
SELECT * FROM [Sales].[Customer]                     -- CustomerID, PersonID, StoreID, TerritoryID
SELECT * FROM [Sales].[PersonCreditCard]             -- BusinessEntityID, CreditCardID
SELECT * FROM [Sales].[SalesOrderDetail]             -- SalesOrderID, SalesOrderDetailID, ProductID, SpecialOfferID
SELECT * FROM [Sales].[SalesOrderHeader]             -- SalesOrderID, CustomerID, SalesPersonID (el simil a BusinessEntityID), TerritoryID, BillToAddressID, 
                                                     -- ShipToAddressID, ShipMethodID, CreditCardID, CurrencyRateID
SELECT * FROM [Sales].[SalesOrderHeaderSalesReason]  -- SalesOrderID, SalesReasonID
SELECT * FROM [Sales].[SalesPerson]                  -- BusinessEntityID, TerritoryID
SELECT * FROM [Sales].[SalesPersonQuotaHistory]      -- BusinessEntityID
SELECT * FROM [Sales].[SalesReason]                  -- SalesReasonID
SELECT * FROM [Sales].[SalesTaxRate]                 -- SalesTaxRateID, StateProvinceID
SELECT * FROM [Sales].[SalesTerritory]               -- TerritoryID
SELECT * FROM [Sales].[SalesTerritoryHistory]        -- BusinessEntityID, TerritoryID
SELECT * FROM [Sales].[ShoppingCartItem]             -- ShoppingCartItemID, ShoppingCartID, ProductID
SELECT * FROM [Sales].[SpecialOffer]                 -- SpecialOfferID
SELECT * FROM [Sales].[SpecialOfferProduct]          -- SpecialOfferID, ProductID
SELECT * FROM [Sales].[Store]                        -- BusinessEntityID, SalesPersonID