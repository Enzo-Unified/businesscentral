# BusinessCentral Data Integration

This repo provides an overview of Enzo Server integration capabilities with BusinessCentral (online) and sample SQL code to read and write data.

# Overview
Enzo Server provides deep integration capabilities with BusinessCentral's APIs to enable rapid Business Process Automation and data discovery use cases.  Enzo hides the low-level OAuth 2.0 authentication complexity, automatically generates and stores Bearer Tokens securely, and refreshes the Bearer Tokens as needed automatically. 

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

## Enzo Server
Enzo Server provides direct connectivity to BusinessCentral using native SQL commands to read/write data quickly. Using SQL commands allows integration teams to quickly build otherwise complex business process automation logic and enables data discovery scenarios. Use SQL Server Management Studio (SSMS) to execute SQL commands against Enzo by either connecting directly to Enzo or use a Linked Server. Since Enzo Server is a SQL Server emulator, you can connect to it directly. Note that Enzo implements a subset of the T-SQL language just necessary to access the API of the remote system; as a result, you can only perform simple SQL operations (for example, you cannot use the JOIN or GROUP BY operators against Enzo). 

### Reading from BusinessCentral
All BusinessCentral API endpoints that allow you to read data are exposed through EXEC and SELECT commands. 

The following SELECT command in SQL Server Management Studio returns all Vendors from BusinessCentral:

```
SELECT * FROM BusinessCentral.Vendors WHERE company_id='dc50d5e8-f9c9-ed11-94cc-000d3a220b2f'
```

To access vendors directly from SQL Server (from a trigger or stored procedure for example), you will need to include the Linked Server (called ENZO below) and Database name (BSC) to the previous command:

```
SELECT * FROM ENZO.BSC.BusinessCentral.Vendors WHERE company_id='dc50d5e8-f9c9-ed11-94cc-000d3a220b2f'
```




## Enzo Integration Use Cases

## DataZen Use Cases

# Lab

## Enzo Integration Lab

## DataZen Lab
