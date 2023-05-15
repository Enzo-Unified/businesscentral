# BusinessCentral Integration

This repo provides an overview of Enzo Server and DataZen's capabilities and a lab to perform data integration operations with both platforms. 

# Overview
Enzo Server and DataZen provide deep integration capabilities with BusinessCentral's APIs to enable rapid Business Process Automation, data discovery, and data movement use cases.  Both Enzo and DataZen hide the low-level OAuth 2.0 authentication complexity, store Bearer Tokens securely, and refresh the Bearer Tokens when required. 

## Configuration
Configuring Enzo and DataZen requires the creation of an Azure Active Directory Enterprise Application along with other important configuration steps in BusinessCentral. Configuration steps are documented in the [BusinessCentralConfiguration.pdf](https://www.enzounified.com/downloads/BusinessCentralConfiguration.pdf) document on the [Enzo Unified](https://www.enzounified.com) website. 

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
