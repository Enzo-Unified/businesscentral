# BusinessCentral Data Integration

This repo provides an overview of Enzo Server integration capabilities with BusinessCentral (online) and sample SQL code to read and write data.

# Overview
Enzo Server provides deep integration capabilities with BusinessCentral's APIs to enable rapid Business Process Automation and data discovery use cases.  Enzo hides the low-level OAuth 2.0 authentication complexity, automatically generates and stores Bearer Tokens securely, and refreshes the Bearer Tokens as needed automatically. 

## About Enzo Server
Enzo Server provides direct connectivity to BusinessCentral using native SQL commands to read/write data quickly. Using SQL commands allows integration teams to quickly build otherwise complex business process automation logic and enables data discovery scenarios. SQL Server Management Studio (SSMS) is the recommended tool to execute SQL commands against Enzo by either connecting directly to Enzo or using a Linked Server to Enzo. Since Enzo Server is a SQL Server emulator, you can connect to it directly. Enzo implements a subset of the T-SQL language necessary to access the API of the remote system; complex SQL operations (such as JOIN or GROUP BY) are not supported. 

## Direct vs. Linked Server Connections
Enzo Server accepts connections from SSMS directly or through Linked Server. When creating integration scripts, such as jobs using the SQL Server Agent for example, or creating deep integrations within a database (as a Stored Procedure for example), connecting to Enzo through a Linked Server connection is necessary. Most operations can be performed either directly or through a Linked Server connection, but there are differences due to the way Linked Server works. 

As a result, the following table outlines which operations are officially supported for the BusinessCentral adapter (note: in some cases, an unsupported operation may work, but it is not guaranteed to work in future releases):

| Operation | Direct | Linked Server |
|---|---|---|
| EXEC | Supported | Supported |
| SELECT | Supported | Supported |
| INSERT | Supported | Not Supported |
| UPDATE | Supported | Not Supported |
| DELETE | Supported | Not Supported |

Setting up a Linked Server to Enzo Server is simple but requires specific settings. Visit [the online documentation](https://www.enzounified.com/docs/linkedserver) for more information. 

This documentation assumes that the name given to a Linked Server connection is __ENZO__. In addition, the database name __BSC__ must be added to the call:

```
-- return all available commands when connected to Enzo directly
EXEC BusinessCentral.help 0

-- return all available commands when connected through a Linked Server connection called ENZO
EXEC ENZO.BSC.BusinessCentral.help 0
```

# Configuration
## Pre-Requisites
In order to run the sample code provided in this document, you will need to have an Enzo Server running on a Virtual Machine (Windows Server or Windows 10 or higher). You can quickly obtain a test Enzo Server Virtual Machine in AWS or Azure by using the __Enzo Server 3.1 Marketplace__ offer. For more information, please visit the [Enzo Download](https://www.enzounified.com/home/download) page on the [Enzo Unified](https://www.enzounified.com/) website. 

## BusinessCentral Configuration
Configuring Enzo to access BusinessCentral 365 requires the creation of an Azure Active Directory (AAD) Enterprise Application along with other important configuration steps in BusinessCentral administrative screens. In addition, Enzo needs to be configured to access BusinessCentral by creating a configuration setting. 

The necessary configuration steps are documented in the [BusinessCentralConfiguration.pdf](https://www.enzounified.com/downloads/BusinessCentralConfiguration.pdf) document on the [Enzo Unified](https://www.enzounified.com) website. 

## Enzo Server Configuration
The document provided in the Configuration section provides the SQL command necessary to store the security settings in Enzo. 

Enzo uses the following commands to create and update configuration settings respectivelly:

__\_configCreate__ and __\_configUpdate__

<details>
   <summary>Sample SQL command to create a configuration setting in Enzo</summary>

For reference, the SQL command to create a new configuration setting is provided below:

```
EXEC BSC.BusinessCentral._configCreate  
   'cronus',	-- name of the configuration 
   1,		-- make it the default setting 
   'AAD_APP_ID',	-- AppId of AAD Enterprise Application 
   null,	 
   'AAD_APP_SECRET', -- App Secret of AAD Enterprise Application 
   -- Business Central API base URL  (replace AAD_TENANT_ID with your Azure Tenant ID, which is a GUID value): 
   'https://api.businesscentral.dynamics.com/v2.0/AAD_TENANT_ID/Production/api/v2.0',  
   'bearer',   -- Indicates Bearer Token Auth is used 
   0,	    -- no encoding 
   0,	    -- no encoding  
   -- OAuth Configuration Settings: 
      '{    
      "tokenUrl": "https://login.microsoftonline.com/AAD_TENANT_ID/oauth2/v2.0/token",   
      "callTokenForRefresh": true,   
      "supportsTokenRefresh": false,   
      "redirect_uri": "https://localhost",   
      "scopes": "https://api.businesscentral.dynamics.com/.default",   
      "token_behavior": {    
         "authorization": "none",    
         "method": "POST",    
         "query_encode": false,    
         "payload_encode": false,    
         "query": "",    
         "grant_type": "client_credentials",    
         "payload": "grant_type={grant_type}&client_id={client_id}&client_secret={client_secret}&scope=https://api.businesscentral.dynamics.com/.default"    
      },   
      "refreshToken_behavior": null  
}', 
'AAD_TENANT_ID',	     -- Azure Directory Tenant ID 
'CRONUS_COMPANY_ID', -- CRONUS Company ID 
'CRONUS USA, Inc.'   -- CORNUS Company name 
```

</details>
   
# Reading from BusinessCentral
All BusinessCentral API endpoints that allow you to read data are exposed through EXEC and SELECT commands. 

To list all the available commands available, you can run the following SQL command on Enzo:

```
SELECT [procedure], tablename FROM BusinessCentral._handlers WHERE groups='API' 
```

<details>
   <summary>Sample output (10 records)</summary>

Here is a sample output of the first 10 records:

| procedure | tableName |
|---|---|
| getAccount | Account |
| getAgedAccountsPayable | AgedAccountsPayable |
| getAgedAccountsReceivable | AgedAccountsReceivable |
| getAttachments | Attachments |
| getAttachmentsForJournalLine | AttachmentsForJournalLine |
| getAttachmentsForJournalLineForJournal | AttachmentsForJournalLineForJournal |
| getBalanceSheet | BalanceSheet |
| getBankAccount | BankAccount |
| getCashFlowStatement | CashFlowStatement |
| getCompany | Company |

</details>
   
The above statement shows you that you can retrieve records from BusinessCentral using either an EXEC command using the __produce__ name, or a SELECT statement on the __tablename__ table.  Most __tablename__ tables allow the INSERT, UPDATE and DELETE operations but not all. 
   
## Using EXEC commands
You can fetch data from the BusinessCentral API using EXEC commands. 

```
-- retrieve all vendors from BusinessCentral
EXEC BusinessCentral.listVendors 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f'
```

The EXEC operator offers a few optional parameters. To view the list of parameters of the EXEC command, run this SQL:

```
EXEC BusinessCentral.listVendors help
```

For example, the __top__ parameter allows you to return the first few records:

```
-- retrieve 10 vendors from BusinessCentral
EXEC BusinessCentral.listVendors 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', 10
```

You can also use the parameter name:
```
-- retrieve 10 vendors from BusinessCentral
EXEC BusinessCentral.listVendors @company_id='dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', @top=10
```

To run the same command through a Linked Server connection to Enzo:
```
EXEC ENZO.BSC.BusinessCentral.listVendors @company_id='dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', @top=10
```

## Using SELECT commands
Generally speaking, using SELECT commands is more flexible than using EXEC operators because you can apply client-side filters on the data, select the desired column names, and perform ORDER BY operations (the ORDER BY is applied client-side). The following SELECT command in SQL Server Management Studio returns all Vendors from BusinessCentral (replace company_id with your BusinessCentral Company ID):

```
SELECT * FROM BusinessCentral.Vendors WHERE company_id='dc50d5e8-f9c9-ed11-94cc-000d3a220b2f'
```

To retrieve the first 10 records, use the TOP operator:

```
SELECT TOP 10 * FROM BusinessCentral.Vendors WHERE company_id='dc50d5e8-f9c9-ed11-94cc-000d3a220b2f'
```

To apply secondary filters (client-side) the filters __must be added after the parameters of the SQL command__. For example, the __listVendors__ command (__Vendors__ table) accepts the following parameters, so if you use them they must be listed immediately after the WHERE clause (the company_id is a required parameter): 

* company_id
* top
* skip
* limit
* filter
* expand
* select

To return all records that contain an 'n' character in their displayName field, the following command will work because the client-side filter on the displayName field is last in the WHERE clause:

```
SELECT * FROM BusinessCentral.Vendors WHERE company_Id = 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f' AND displayName like '%n%'
```

You can run the same command through a Linked Server connection to Enzo:
```
SELECT * FROM ENZO.BSC.BusinessCentral.Vendors WHERE company_Id = 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f' AND displayName like '%n%'
```

# Writing to BusinessCentral
You can perform inserts, updates, and delete operations using either an EXEC command or its equivalent INSERT, UPDATE or DELETE operation. 

> WARNING: The INSERT, UPDATE and DELETE operations are only supported when connecting directly to ENZO; it is recommended to use the EXEC operations to change data when using a Linked Server connection. 

## Using EXEC commands
EXEC operations come in two flavors for BusinessCentral: specifying individual parameters or by providing a raw JSON document. 

### Using individual parameters
For example, the PostVendor command takes 18 parameters, most of which are optional, such as the vendor __number__ and the __displayName__. To view the list of parameters available, run this command:

```
EXEC BusinessCentral.PostVendor help
```

Here is a sample SQL command to create a new Vendor by passing individual values:

```
EXEC BusinessCentral.PostVendor 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', null, 'V1001', 'test vendor'
```

The same command can be sent using a Linked Server connection to Enzo:

```
EXEC ENZO.BSC.BusinessCentral.PostVendor 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', null, 'V1001', 'test vendor'
```

### Using the RAW command
Each Enzo command that allows updating/inserting data also provides a secondary command of the same name, with RAW appended to it. These additional commands allow you to pass a custom JSON payload instead of providing individual parameters. 

To view the parameters of the PostVendorRAW command, use this command:

```
EXEC BusinessCentral.PostVendorRAW help
```

The PostVendorRAW command takes two parameters: the company_id, and the json payload. 

```
EXEC BusinessCentral.PostVendorRAW 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', '{ "number": "V1002", "displayName": "test vendor 2" }'
```

The same command can be sent using a Linked Server connection to Enzo:

```
EXEC ENZO.BSC.BusinessCentral.PostVendorRAW 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', '{ "number": "V1002", "displayName": "test vendor 2" }'
```

## UPDATE Operations
Most objects in BusinessCentral provide an HTTP PATCH (UPDATE) operation. The table name to use for the command is also provided as part of the help output. For example, the PatchVendor command's help output contains a __TableName__ column that would be used for the UPDATE operation. The table name is __vendor__. 

```
EXEC BusinessCentral.PatchVendor help
```

Updating data in BusinessCentral requires a valid __etag__ to avoid concurrency issues. The __etag__ value can be found by calling the vendor record. The following command returns the current __etag__ value for a given __vendor_id__:

```
SELECT [@odata.etag] FROM BusinessCentral.Vendor WHERE company_Id = 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f' AND vendor_id='625C8AFB-52F3-ED11-8848-000D3A373307'
```

The UPDATE operation on the __vendor__ table requires the __company_id__, the __vendor_id__, the __etag__, and the __SET__ section that updates specific fields: 

```
UPDATE BusinessCentral.Vendor 
SET email='test@enzounified.com' 
WHERE 
  company_Id = 'dc50d5e8-f9c9-ed11-94cc-000d3a220b2f' 
  AND vendor_id='625C8AFB-52F3-ED11-8848-000D3A373307' 
  AND [@odata.etag]='W/"JzIwOzE3NDc5MTgwODIxNjI2MjY0MzM0MTswMDsn"'
```

> The UPDATE operation may not work as expected using a Linked Server connection; if you are writing SQL code through a Linked Server connection, use the corresponding EXEC operation instead.

## INSERT Operations
Most objects in BusinessCentral provide an HTTP POST (INSERT) operation. The table name to use for the command is also provided as part of the help output. For example, the PatchVendor command's help output contains a __TableName__ column that would be used for the UPDATE operation. The table name is __vendor__. 

```
EXEC BusinessCentral.PatchVendor help
```

The INSERT operation on the __vendor__ table requires the __company_id__ and other values as desired: 

```
INSERT INTO BusinessCentral.Vendor (company_id, [number], displayName) VALUES ('dc50d5e8-f9c9-ed11-94cc-000d3a220b2f', 'V1003', 'test vendor 3')
```

> The INSERT operation may not work as expected using a Linked Server connection; if you are writing SQL code through a Linked Server connection, use the corresponding EXEC operation instead.

## DELETE Operations
Most objects in BusinessCentral provide an HTTP DELETE (DELETE) operation. The table name to use for the command is also provided as part of the help output. For example, the PatchVendor command's help output contains a __TableName__ column that would be used for the UPDATE operation. The table name is __vendor__. 

```
EXEC BusinessCentral.PatchVendor help
```

The INSERT operation on the __vendor__ table requires the __company_id__ and the __id__ of the vendor: 

```
DELETE FROM BusinessCentral.Vendor WHERE company_id='dc50d5e8-f9c9-ed11-94cc-000d3a220b2f' AND vendor_id='625C8AFB-52F3-ED11-8848-000D3A373307'
```

> The DELETE operation may not work as expected using a Linked Server connection; if you are writing SQL code through a Linked Server connection, use the corresponding EXEC operation instead.

