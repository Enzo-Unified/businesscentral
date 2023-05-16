/*
  Sample SQL code that interacts with Vendor records in BusinessCentral using a Linked Server connection from SSMS to Enzo Server 
*/

--
--	HELP OPERATIONS
--
-- Built-in help command that returns all vendors
EXEC ENZO.BSC.BusinessCentral.ListVendors help

--
-- EXEC OPERATIONS
--
-- EXEC operation to return all vendors:
EXEC ENZO.BSC.BusinessCentral.ListVendors 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f'
-- EXEC operation to return all vendors that have an 'n' in their display name:
EXEC ENZO.BSC.BusinessCentral.ListVendors 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', @filter='contains(displayName, ''n'')'

-- EXEC operation to insert a vendor (option 1)
EXEC ENZO.BSC.BusinessCentral.postVendor help	-- help for this operation
EXEC ENZO.BSC.BusinessCentral.postVendor 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', @number='V12341', @displayName='test vendor 1'

-- EXEC operation to insert a vendor using a custom payload (option 2)
EXEC ENZO.BSC.BusinessCentral.postVendorRAW help	-- help for this operation
EXEC ENZO.BSC.BusinessCentral.postVendorRAW 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', '{ "number": "V12342", "displayName": "test vendor 2" }'

-- EXEC operation to update a vendor (option 1) -- must have the latest @odata.etag value
EXEC ENZO.BSC.BusinessCentral.patchVendor help	-- help for this operation
EXEC ENZO.BSC.BusinessCentral.patchVendor 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', '9FF7BDEA-14F4-ED11-8848-000D3A36D3A4', 'W/"JzIwOzE1MTUwNjcxNzA5MzgyMzQ4MjE2MTswMDsn"', @displayName='test vendor 11'

-- EXEC operation to update a vendor using a custom payload (option 2)
EXEC ENZO.BSC.BusinessCentral.patchVendorRAW help	-- help for this operation
EXEC ENZO.BSC.BusinessCentral.patchVendorRAW 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', '9FF7BDEA-14F4-ED11-8848-000D3A36D3A4', 'W/"JzIwOzE1MTUwNjcxNzA5MzgyMzQ4MjE2MTswMDsn"', '{ "displayName": "test vendor 111" }'


--
--  SELECT OPERATIONS
--
-- Returns all available vendors (table name: vendors)
SELECT * FROM ENZO.BSC.BusinessCentral.Vendors WHERE company_id = 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f'
-- Returns all available vendors (table name: vendors) with an 'n' in their display name:
SELECT * FROM ENZO.BSC.BusinessCentral.Vendors WHERE company_id = 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f' and filter='contains(displayName, ''n'')'

