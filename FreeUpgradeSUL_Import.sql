USE [MSCRM_Custom]

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
IF OBJECT_ID ('[dbo].[FreeUpgradeSUL_Import]') IS NOT NULL
	DROP PROC [dbo].[FreeUpgradeSUL_Import]
GO 
 
/*
** ObjectName:	[FreeUpgradeSUL_Import]
** 
** Description:	Creates Customer Product records in CRM for Free SUL Upgrades associated with Rel 17
**				 
** Revision History
** --------------------------------------------------------------------------
** Date				Name			Description
** --------------------------------------------------------------------------
** 2014-1-29		CMurphy			Initial Creation

*/

CREATE PROCEDURE [dbo].[FreeUpgradeSUL_Import](
 @HeaderId UNIQUEIDENTIFIER
 )

AS

SET NOCOUNT ON

DECLARE @productID UNIQUEIDENTIFIER,
		@prcLevel UNIQUEIDENTIFIER

SET @productID = (SELECT productId FROM [MTB_MSCRM].[dbo].[ProductBase]
					WHERE Name = 'MTB 17 English Single User Electronic')
SET @prcLevel = (SELECT PriceLevelId FROM [MTB_MSCRM].[dbo].[PriceLevelBase]
					WHERE name  ='CDMX-UCL')



				
   INSERT INTO IntegrationStaging.dbo.[FreeUpgradeSUL_Staging](
			[HeaderId],
			[RowId],
			[MTB_ContactId],
			[MTB_ProductId],
			[MTB_Quantity],
			[MTB_PurchaseDate],
			[MTB_licensing],
			[UpgradeId],
			[MTB_PriceList],
			[MTB_AccountId],
			[StatusReason]) 

SELECT		'HeaderId'                              = '6C3D87C4-96B6-49E9-83FA-CC428AC16403'--@HeaderId
			,'RowID'								= NEWID()
			,'MTB_ContactId'					= cb.ContactId
			,'MTB_ProductId'					= @productID
			,'MTB_Quantity'						= 1 
			,'MTB_PurchaseDate'					= GETDATE()  
			,'MTB_Licensing'					= 102241 -- UCL-Unit Copy Prepetual License
			,'UpgradeId'							= NULL
			,'MTB_PriceList'					= @prcLevel
			,'MTB_AccountId'					= cb.ParentCustomerId
			,'StatusReason'							= 908600014 --Free



--Contact     
FROM MTB_MSCRM.dbo.ContactExtensionBase ceb WITH (NOLOCK)

--Account
	inner JOIN MTB_MSCRM.dbo.ContactBase cb WITH (NOLOCK)
	ON 	ceb.ContactId = cb.ContactId
WHERE MTB_ID_Search IN 
(256038,421071,367642, 1522687)


GO
GRANT EXEC ON dbo.FreeUpgradeSUL_Import TO [DEVELOPER]
GRANT EXEC ON dbo.FreeUpgradeSUL_Import TO [OT]
GRANT EXEC on dbo.FreeUpgradeSUL_Import TO [COSMO\crmimport]
GO	