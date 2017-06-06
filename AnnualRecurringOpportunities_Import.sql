
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AnnualRecurringOpportunities_Import]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AnnualRecurringOpportunities_Import]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/************************************************************************
** Object Name:	AnnualRecurringOpportunities_Import
**
** Description:	Imports data into the RecurringOpportunitiesImport_Staging table from the Renewals Console 
**				for licenses with an end date on the last day of the month 8 months out 
**
** Called From:	SQL Job
** ReturnCodes:	None
**
** RevisionHist:
**------------------------------------------------------
** Date     	 	Name       	Description
**------------------------------------------------------
** 07/29/2013		CMurphy		Initial Coding
** 09/30/2013       CMurphy     Added price level to select
** 05/15/2014		CMurphy     Hotfix to add logic for LTD/PTY/SARL
*******************************************************************************/
CREATE PROCEDURE [dbo].[AnnualRecurringOpportunities_Import](
 @HeaderId UNIQUEIDENTIFIER
 )

AS

SET NOCOUNT ON	-- Reduce network traffic

;WITH CTE_licenseTable ( HeaderId, Assigned, Description, PotentialCust, EstCloseDate, TYPE, PriceLevel) 
AS (

/*Annual License Upsale*/
--INC
SELECT DISTINCT
'HeaderId' = @HeaderId,
'Assigned' = isnull(AEB.MTB_PrimarySalesRepSystemUserId,TB.AdministratorId),
'Description' = 'Annual License Upsale '+ a.SOPNUMBE,
'PotentialCustomer' = AEB.AccountId ,
'EstCloseDate' = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,1,GETDATE())),101),
'Type' = 908600000, --Software,
'pricelevel' = PLB.PriceLevelId


FROM INC.INC.dbo.csiActiveContracts a
INNER JOIN [MTB_MSCRM].[dbo].[PriceLevelBase] PLB
ON a.PRCLEVEL = PLB.Name COLLATE Latin1_General_CI_AI	
INNER JOIN INC.INC.dbo.SOP10100 s ON a.SOPNUMBE = s.SOPNUMBE
LEFT JOIN  MTB_MSCRM.dbo.AccountExtensionBase AEB
ON s.GPSFOINTEGRATIONID = AEB.MTB_ID_Search
INNER JOIN MTB_MSCRM.dbo.AccountBase AB
ON AEB.AccountId = AB.AccountId
LEFT JOIN MTB_MSCRM.dbo.TeamBase TB
ON AB.OwnerId = TB.TeamId
WHERE 
ITEMNMBR <> 'ADEET010A' --Not QT 
AND a.EndDate = DATEADD(dd,0,DATEDIFF(dd,0,DATEADD(s,-1,DATEADD(mm,DATEDIFF(m,0,GETDATE())+9,0))))--End date = the last day of the month 8 months out
AND a.PRCLEVEL LIKE '%ANN%' 

UNION ALL

--LTD
SELECT DISTINCT
'HeaderId' = @HeaderId,
'Assigned' = isnull(AEB.MTB_PrimarySalesRepSystemUserId,TB.AdministratorId),
'Description' = 'Annual License Upsale '+ a.SOPNUMBE,
'PotentialCustomer' = AEB.AccountId ,
'EstCloseDate' = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,1,GETDATE())),101),
'Type' = 908600000, --Software,
'pricelevel' = PLB.PriceLevelId


FROM LTD.LTD.dbo.csiActiveContracts a
INNER JOIN [MTB_MSCRM].[dbo].[PriceLevelBase] PLB
ON a.PRCLEVEL = PLB.Name COLLATE Latin1_General_CI_AI	
INNER JOIN LTD.LTD.dbo.SOP10100 s ON a.SOPNUMBE = s.SOPNUMBE
LEFT JOIN  MTB_MSCRM.dbo.AccountExtensionBase AEB
ON s.GPSFOINTEGRATIONID = AEB.MTB_ID_Search
INNER JOIN MTB_MSCRM.dbo.AccountBase AB
ON AEB.AccountId = AB.AccountId
LEFT JOIN MTB_MSCRM.dbo.TeamBase TB
ON AB.OwnerId = TB.TeamId
WHERE 
ITEMNMBR <> 'ADEET010A' --Not QT 
AND a.EndDate = DATEADD(dd,0,DATEDIFF(dd,0,DATEADD(s,-1,DATEADD(mm,DATEDIFF(m,0,GETDATE())+9,0))))--End date = the last day of the month 8 months out
AND a.PRCLEVEL LIKE '%ANN%'

UNION ALL

--PTY
SELECT DISTINCT
'HeaderId' = @HeaderId,
'Assigned' = isnull(AEB.MTB_PrimarySalesRepSystemUserId,TB.AdministratorId),
'Description' = 'Annual License Upsale '+ a.SOPNUMBE,
'PotentialCustomer' = AEB.AccountId ,
'EstCloseDate' = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,1,GETDATE())),101),
'Type' = 908600000, --Software,
'pricelevel' = PLB.PriceLevelId


FROM PTY.PTY.dbo.csiActiveContracts a
INNER JOIN [MTB_MSCRM].[dbo].[PriceLevelBase] PLB
ON a.PRCLEVEL = PLB.Name COLLATE Latin1_General_CI_AI	
INNER JOIN PTY.PTY.dbo.SOP10100 s ON a.SOPNUMBE = s.SOPNUMBE
LEFT JOIN  MTB_MSCRM.dbo.AccountExtensionBase AEB
ON s.GPSFOINTEGRATIONID = AEB.MTB_ID_Search
INNER JOIN MTB_MSCRM.dbo.AccountBase AB
ON AEB.AccountId = AB.AccountId
LEFT JOIN MTB_MSCRM.dbo.TeamBase TB
ON AB.OwnerId = TB.TeamId
WHERE 
ITEMNMBR <> 'ADEET010A' --Not QT 
AND a.EndDate = DATEADD(dd,0,DATEDIFF(dd,0,DATEADD(s,-1,DATEADD(mm,DATEDIFF(m,0,GETDATE())+9,0))))--End date = the last day of the month 8 months out
AND a.PRCLEVEL LIKE '%ANN%'

UNION ALL

--SARL
SELECT DISTINCT
'HeaderId' = @HeaderId,
'Assigned' = isnull(AEB.MTB_PrimarySalesRepSystemUserId,TB.AdministratorId),
'Description' = 'Annual License Upsale '+ a.SOPNUMBE,
'PotentialCustomer' = AEB.AccountId ,
'EstCloseDate' = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,1,GETDATE())),101),
'Type' = 908600000, --Software,
'pricelevel' = PLB.PriceLevelId

FROM SARL.SARL.dbo.csiActiveContracts a
INNER JOIN [MTB_MSCRM].[dbo].[PriceLevelBase] PLB
ON a.PRCLEVEL = PLB.Name COLLATE Latin1_General_CI_AI	
INNER JOIN SARL.SARL.dbo.SOP10100 s ON a.SOPNUMBE = s.SOPNUMBE
LEFT JOIN  MTB_MSCRM.dbo.AccountExtensionBase AEB
ON s.GPSFOINTEGRATIONID = AEB.MTB_ID_Search
INNER JOIN MTB_MSCRM.dbo.AccountBase AB
ON AEB.AccountId = AB.AccountId
LEFT JOIN MTB_MSCRM.dbo.TeamBase TB
ON AB.OwnerId = TB.TeamId
WHERE 
ITEMNMBR <> 'ADEET010A' --Not QT 
AND a.EndDate = DATEADD(dd,0,DATEDIFF(dd,0,DATEADD(s,-1,DATEADD(mm,DATEDIFF(m,0,GETDATE())+9,0))))--End date = the last day of the month 8 months out
AND a.PRCLEVEL LIKE '%ANN%'

UNION ALL

/*Enterprise License Upsale*/
--INC
SELECT DISTINCT
'HeaderId' = @HeaderId,
'Assigned' = isnull(AEB.MTB_PrimarySalesRepSystemUserId,TB.AdministratorId),
'Description' = 'Enterprise License Upsale '+ a.SOPNUMBE,
'PotentialCustomer' = AEB.AccountId ,
'EstCloseDate' = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,1,GETDATE())),101),
'Type' = 908600000, --Software,
'pricelevel' = PLB.PriceLevelId

FROM INC.INC.dbo.csiActiveContracts a
INNER JOIN [MTB_MSCRM].[dbo].[PriceLevelBase] PLB
ON a.PRCLEVEL = PLB.Name COLLATE Latin1_General_CI_AI	
INNER JOIN INC.INC.dbo.SOP10100 s ON a.SOPNUMBE = s.SOPNUMBE
LEFT JOIN MTB_MSCRM.dbo.AccountExtensionBase AEB
ON s.GPSFOINTEGRATIONID = AEB.MTB_ID_Search
INNER JOIN MTB_MSCRM.dbo.AccountBase AB
ON AEB.AccountId = AB.AccountId
LEFT JOIN MTB_MSCRM.dbo.TeamBase TB
ON AB.OwnerId = TB.TeamId
WHERE 
ITEMNMBR <> 'ADEET010A' --Not QT 
AND a.EndDate = DATEADD(dd,0,DATEDIFF(dd,0,DATEADD(s,-1,DATEADD(mm,DATEDIFF(m,0,GETDATE())+9,0))))--End date = the last day of the month 8 months out
AND (a.PRCLEVEL LIKE '%AEL%' OR a.PRCLEVEL LIKE '%PEL%' OR a.PRCLEVEL LIKE '%AME%') 

UNION ALL

--LTD
SELECT DISTINCT
'HeaderId' = @HeaderId,
'Assigned' = isnull(AEB.MTB_PrimarySalesRepSystemUserId,TB.AdministratorId),
'Description' = 'Enterprise License Upsale '+ a.SOPNUMBE,
'PotentialCustomer' = AEB.AccountId ,
'EstCloseDate' = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,1,GETDATE())),101),
'Type' = 908600000, --Software,
'pricelevel' = PLB.PriceLevelId

FROM LTD.LTD.dbo.csiActiveContracts a
INNER JOIN [MTB_MSCRM].[dbo].[PriceLevelBase] PLB
ON a.PRCLEVEL = PLB.Name COLLATE Latin1_General_CI_AI	
INNER JOIN LTD.LTD.dbo.SOP10100 s ON a.SOPNUMBE = s.SOPNUMBE
LEFT JOIN MTB_MSCRM.dbo.AccountExtensionBase AEB
ON s.GPSFOINTEGRATIONID = AEB.MTB_ID_Search
INNER JOIN MTB_MSCRM.dbo.AccountBase AB
ON AEB.AccountId = AB.AccountId
LEFT JOIN MTB_MSCRM.dbo.TeamBase TB
ON AB.OwnerId = TB.TeamId
WHERE 
ITEMNMBR <> 'ADEET010A' --Not QT 
AND a.EndDate = DATEADD(dd,0,DATEDIFF(dd,0,DATEADD(s,-1,DATEADD(mm,DATEDIFF(m,0,GETDATE())+9,0))))--End date = the last day of the month 8 months out
AND (a.PRCLEVEL LIKE '%AEL%' OR a.PRCLEVEL LIKE '%PEL%' OR a.PRCLEVEL LIKE '%AME%') 

UNION ALL

--PTY
SELECT DISTINCT
'HeaderId' = @HeaderId,
'Assigned' = isnull(AEB.MTB_PrimarySalesRepSystemUserId,TB.AdministratorId),
'Description' = 'Enterprise License Upsale '+ a.SOPNUMBE,
'PotentialCustomer' = AEB.AccountId ,
'EstCloseDate' = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,1,GETDATE())),101),
'Type' = 908600000, --Software,
'pricelevel' = PLB.PriceLevelId

FROM PTY.PTY.dbo.csiActiveContracts a
INNER JOIN [MTB_MSCRM].[dbo].[PriceLevelBase] PLB
ON a.PRCLEVEL = PLB.Name COLLATE Latin1_General_CI_AI	
INNER JOIN PTY.PTY.dbo.SOP10100 s ON a.SOPNUMBE = s.SOPNUMBE
LEFT JOIN MTB_MSCRM.dbo.AccountExtensionBase AEB
ON s.GPSFOINTEGRATIONID = AEB.MTB_ID_Search
INNER JOIN MTB_MSCRM.dbo.AccountBase AB
ON AEB.AccountId = AB.AccountId
LEFT JOIN MTB_MSCRM.dbo.TeamBase TB
ON AB.OwnerId = TB.TeamId
WHERE
ITEMNMBR <> 'ADEET010A' --Not QT 
AND a.EndDate = DATEADD(dd,0,DATEDIFF(dd,0,DATEADD(s,-1,DATEADD(mm,DATEDIFF(m,0,GETDATE())+9,0))))--End date = the last day of the month 8 months out
AND (a.PRCLEVEL LIKE '%AEL%' OR a.PRCLEVEL LIKE '%PEL%' OR a.PRCLEVEL LIKE '%AME%') 

UNION ALL

--SARL
SELECT DISTINCT
'HeaderId' = @HeaderId,
'Assigned' = isnull(AEB.MTB_PrimarySalesRepSystemUserId,TB.AdministratorId),
'Description' = 'Enterprise License Upsale '+ a.SOPNUMBE,
'PotentialCustomer' = AEB.AccountId ,
'EstCloseDate' = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,1,GETDATE())),101),
'Type' = 908600000, --Software,
'pricelevel' = PLB.PriceLevelId

FROM SARL.SARL.dbo.csiActiveContracts a
INNER JOIN [MTB_MSCRM].[dbo].[PriceLevelBase] PLB
ON a.PRCLEVEL = PLB.Name COLLATE Latin1_General_CI_AI	
INNER JOIN SARL.SARL.dbo.SOP10100 s ON a.SOPNUMBE = s.SOPNUMBE
LEFT JOIN MTB_MSCRM.dbo.AccountExtensionBase AEB
ON s.GPSFOINTEGRATIONID = AEB.MTB_ID_Search
INNER JOIN MTB_MSCRM.dbo.AccountBase AB
ON AEB.AccountId = AB.AccountId
LEFT JOIN MTB_MSCRM.dbo.TeamBase TB
ON AB.OwnerId = TB.TeamId
WHERE
ITEMNMBR <> 'ADEET010A' --Not QT 
AND a.EndDate = DATEADD(dd,0,DATEDIFF(dd,0,DATEADD(s,-1,DATEADD(mm,DATEDIFF(m,0,GETDATE())+9,0))))--End date = the last day of the month 8 months out
AND (a.PRCLEVEL LIKE '%AEL%' OR a.PRCLEVEL LIKE '%PEL%' OR a.PRCLEVEL LIKE '%AME%') 

UNION ALL 

/*Enterprise License Renewal Confirmation*/
--INC
SELECT DISTINCT
'HeaderId' = @HeaderId,
'Assigned' = isnull(AEB.MTB_PrimarySalesRepSystemUserId,TB.AdministratorId),
'Description' = 'Enterprise License Renewal Confirmation '+ a.SOPNUMBE,
'PotentialCustomer' = AEB.AccountId ,
'EstCloseDate' = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,5,GETDATE())),101),
'Type' = 908600000, --Software,
'pricelevel' = PLB.PriceLevelId

FROM INC.INC.dbo.csiActiveContracts a
INNER JOIN [MTB_MSCRM].[dbo].[PriceLevelBase] PLB
ON a.PRCLEVEL = PLB.Name COLLATE Latin1_General_CI_AI	
INNER JOIN INC.INC.dbo.SOP10100 s ON a.SOPNUMBE = s.SOPNUMBE
LEFT JOIN MTB_MSCRM.dbo.AccountExtensionBase AEB
ON s.GPSFOINTEGRATIONID = AEB.MTB_ID_Search
INNER JOIN MTB_MSCRM.dbo.AccountBase AB
ON AEB.AccountId = AB.AccountId
LEFT JOIN MTB_MSCRM.dbo.TeamBase TB
ON AB.OwnerId = TB.TeamId
WHERE 
ITEMNMBR <> 'ADEET010A' --Not QT 
AND a.EndDate = DATEADD(dd,0,DATEDIFF(dd,0,DATEADD(s,-1,DATEADD(mm,DATEDIFF(m,0,GETDATE())+9,0))))--End date = the last day of the month 8 months out
AND (a.PRCLEVEL LIKE '%AEL%' OR a.PRCLEVEL LIKE '%PEL%' OR a.PRCLEVEL LIKE '%AME%')

UNION ALL
--LTD
SELECT DISTINCT
'HeaderId' = @HeaderId,
'Assigned' = isnull(AEB.MTB_PrimarySalesRepSystemUserId,TB.AdministratorId),
'Description' = 'Enterprise License Renewal Confirmation '+ a.SOPNUMBE,
'PotentialCustomer' = AEB.AccountId ,
'EstCloseDate' = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,5,GETDATE())),101),
'Type' = 908600000, --Software,
'pricelevel' = PLB.PriceLevelId

FROM LTD.LTD.dbo.csiActiveContracts a
INNER JOIN [MTB_MSCRM].[dbo].[PriceLevelBase] PLB
ON a.PRCLEVEL = PLB.Name COLLATE Latin1_General_CI_AI	
INNER JOIN LTD.LTD.dbo.SOP10100 s ON a.SOPNUMBE = s.SOPNUMBE
LEFT JOIN MTB_MSCRM.dbo.AccountExtensionBase AEB
ON s.GPSFOINTEGRATIONID = AEB.MTB_ID_Search
INNER JOIN MTB_MSCRM.dbo.AccountBase AB
ON AEB.AccountId = AB.AccountId
LEFT JOIN MTB_MSCRM.dbo.TeamBase TB
ON AB.OwnerId = TB.TeamId
WHERE 
ITEMNMBR <> 'ADEET010A' --Not QT 
AND a.EndDate = DATEADD(dd,0,DATEDIFF(dd,0,DATEADD(s,-1,DATEADD(mm,DATEDIFF(m,0,GETDATE())+9,0))))--End date = the last day of the month 8 months out
AND (a.PRCLEVEL LIKE '%AEL%' OR a.PRCLEVEL LIKE '%PEL%' OR a.PRCLEVEL LIKE '%AME%')

UNION ALL

--PTY
SELECT DISTINCT
'HeaderId' = @HeaderId,
'Assigned' = isnull(AEB.MTB_PrimarySalesRepSystemUserId,TB.AdministratorId),
'Description' = 'Enterprise License Renewal Confirmation '+ a.SOPNUMBE,
'PotentialCustomer' = AEB.AccountId ,
'EstCloseDate' = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,5,GETDATE())),101),
'Type' = 908600000, --Software,
'pricelevel' = PLB.PriceLevelId

FROM PTY.PTY.dbo.csiActiveContracts a
INNER JOIN [MTB_MSCRM].[dbo].[PriceLevelBase] PLB
ON a.PRCLEVEL = PLB.Name COLLATE Latin1_General_CI_AI	
INNER JOIN PTY.PTY.dbo.SOP10100 s ON a.SOPNUMBE = s.SOPNUMBE
LEFT JOIN MTB_MSCRM.dbo.AccountExtensionBase AEB
ON s.GPSFOINTEGRATIONID = AEB.MTB_ID_Search
INNER JOIN MTB_MSCRM.dbo.AccountBase AB
ON AEB.AccountId = AB.AccountId
LEFT JOIN MTB_MSCRM.dbo.TeamBase TB
ON AB.OwnerId = TB.TeamId
WHERE  
ITEMNMBR <> 'ADEET010A' --Not QT 
AND a.EndDate = DATEADD(dd,0,DATEDIFF(dd,0,DATEADD(s,-1,DATEADD(mm,DATEDIFF(m,0,GETDATE())+9,0))))--End date = the last day of the month 8 months out
AND (a.PRCLEVEL LIKE '%AEL%' OR a.PRCLEVEL LIKE '%PEL%' OR a.PRCLEVEL LIKE '%AME%')

UNION ALL

--SARL
SELECT DISTINCT
'HeaderId' = @HeaderId,
'Assigned' = isnull(AEB.MTB_PrimarySalesRepSystemUserId,TB.AdministratorId),
'Description' = 'Enterprise License Renewal Confirmation '+ a.SOPNUMBE,
'PotentialCustomer' = AEB.AccountId ,
'EstCloseDate' = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,5,GETDATE())),101),
'Type' = 908600000, --Software,
'pricelevel' = PLB.PriceLevelId

FROM SARL.SARL.dbo.csiActiveContracts a
INNER JOIN [MTB_MSCRM].[dbo].[PriceLevelBase] PLB
ON a.PRCLEVEL = PLB.Name COLLATE Latin1_General_CI_AI	
INNER JOIN SARL.SARL.dbo.SOP10100 s ON a.SOPNUMBE = s.SOPNUMBE
LEFT JOIN MTB_MSCRM.dbo.AccountExtensionBase AEB
ON s.GPSFOINTEGRATIONID = AEB.MTB_ID_Search
INNER JOIN MTB_MSCRM.dbo.AccountBase AB
ON AEB.AccountId = AB.AccountId
LEFT JOIN MTB_MSCRM.dbo.TeamBase TB
ON AB.OwnerId = TB.TeamId
WHERE  
ITEMNMBR <> 'ADEET010A' --Not QT 
AND a.EndDate = DATEADD(dd,0,DATEDIFF(dd,0,DATEADD(s,-1,DATEADD(mm,DATEDIFF(m,0,GETDATE())+9,0))))--End date = the last day of the month 8 months out
AND (a.PRCLEVEL LIKE '%AEL%' OR a.PRCLEVEL LIKE '%PEL%' OR a.PRCLEVEL LIKE '%AME%')

)  

INSERT INTO IntegrationStaging.dbo.RecurringOpportunitiesImport_Staging(
HeaderId, Assigned, CreatedBy, Description, [potentialcustomer], [recalldate], TYPE, pricelevel) 

SELECT HeaderId, Assigned, (SELECT SystemUserId FROM MTB_MSCRM.dbo.SystemUserBase WHERE FullName = 'CRM Import'),Description, PotentialCust, EstCloseDate, TYPE, PriceLevel FROM CTE_licenseTable 

GO

GRANT EXEC ON dbo.[AnnualRecurringOpportunities_Import] TO [DEVELOPER]
GRANT EXEC ON dbo.[AnnualRecurringOpportunities_Import] TO [OT]
GRANT EXEC on dbo.[AnnualRecurringOpportunities_Import] TO [COSMO\crmimport]
GO	