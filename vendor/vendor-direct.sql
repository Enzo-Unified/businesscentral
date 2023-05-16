/*
  Sample SQL code that interacts with Vendor records in BusinessCentral using a direct connection from SSMS to Enzo Server 
*/

--
--	HELP OPERATIONS
--
-- Built-in help command that returns all vendors
EXEC BusinessCentral.ListVendors help

--
-- EXEC OPERATIONS
--
-- EXEC operation to return all vendors:
EXEC BusinessCentral.ListVendors 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f'
-- EXEC operation to return all vendors that have an 'n' in their display name:
EXEC BusinessCentral.ListVendors 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', @filter='contains(displayName, ''n'')'

-- EXEC operation to insert a vendor (option 1)
EXEC BusinessCentral.postVendor help	-- help for this operation
EXEC BusinessCentral.postVendor 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', @number='V12341', @displayName='test vendor 1'

-- EXEC operation to insert a vendor using a custom payload (option 2)
EXEC BusinessCentral.postVendorRAW help	-- help for this operation
EXEC BusinessCentral.postVendorRAW 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', '{ "number": "V12342", "displayName": "test vendor 2" }'

-- EXEC operation to update a vendor (option 1) -- must have the latest @odata.etag value
EXEC BusinessCentral.patchVendor help	-- help for this operation
EXEC BusinessCentral.patchVendor 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', '9FF7BDEA-14F4-ED11-8848-000D3A36D3A4', 'W/"JzIwOzE1MTUwNjcxNzA5MzgyMzQ4MjE2MTswMDsn"', @displayName='test vendor 11'

-- EXEC operation to update a vendor using a custom payload (option 2)
EXEC BusinessCentral.patchVendorRAW help	-- help for this operation
EXEC BusinessCentral.patchVendorRAW 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', '9FF7BDEA-14F4-ED11-8848-000D3A36D3A4', 'W/"JzIwOzE1MTUwNjcxNzA5MzgyMzQ4MjE2MTswMDsn"', '{ "displayName": "test vendor 111" }'


--
--  SELECT OPERATIONS
--
-- Returns all available vendors (table name: vendors)
SELECT * FROM BusinessCentral.Vendors WHERE company_id = 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f'
-- Returns all available vendors (table name: vendors) with an 'n' in their display name:
SELECT * FROM BusinessCentral.Vendors WHERE company_id = 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f' and filter='contains(displayName, ''n'')'

--
--	INSERT, UPDATE, DELETE OPERATIONS
--
-- CREATE a Vendor using an INSERT command
INSERT INTO BusinessCentral.Vendor (company_id, id, [number], displayName) VALUES ('dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', null, 'V10000', 'test vendor')

-- UPDATE a Vendor (must have a valid @odata.etag value):
UPDATE BusinessCentral.Vendor 
	SET
		phoneNumber='1234567890'
	WHERE 
		company_id='dc50d5e8-f9c9-ed11-94cc-000d3a220b2f'		-- the company ID
		AND vendor_id='75F99A6E-FAC9-ED11-94CC-000D3A220B2F'		-- the id field of the vendor record
		AND [@odata.etag] = 'W/"JzE5OzgzNDMxOTgwMzEwNjg2NjQyOTExOzAwOyc="'

--  Delete a vendor record
DELETE FROM BusinessCentral.Vendor 
	WHERE 
		company_id='dc50d5e8-f9c9-ed11-94cc-000d3a220b2f'		-- the company ID
		AND vendor_id='625C8AFB-52F3-ED11-8848-000D3A373307'		-- the id field of the vendor record

