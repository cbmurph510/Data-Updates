SET QUOTED_IDENTIFIER ON
GO


IF OBJECT_ID(N'dbo.mtb_UpdSubscriptionStatusToReady') IS NOT NULL
   DROP PROCEDURE dbo.mtb_UpdSubscriptionStatusToReady
GO

/******************************************************************************
**	
** PURPOSE: Updates the product to ready in the renewalToCustomerProduct table
** currently in OnyxIntegration
**
**
** REVISION HISTORY:
**-----------------------------------------------------------------------------
** Date          Name          Description
**-----------------------------------------------------------------------------
** 03/21/2016    CMurphy        created sproc: mtb_UpdSubscriptionStatusToReady
**
******************************************************************************/
CREATE PROCEDURE dbo.mtb_UpdSubscriptionStatusToReady
AS
   SET NOCOUNT ON;
   
  
     
   --Age out anything older than 120 days in Staging table
   UPDATE   OnyxIntegration.dbo.renewalToLPSubscriptions
   SET      status = 'Expired'
           ,updateDate = GETDATE()
   WHERE    status = 'Hold'
            AND DATEDIFF(DAY, insertDate, GETDATE()) > 120
    
   -- Case for RENORD being invoiced and okay to send siteid = yes
   UPDATE   lp
   SET      lp.status = 'Ready'
           ,lp.updateDate = GETDATE()
   FROM     OnyxIntegration.dbo.renewalToLPSubscriptions AS lp
   WHERE    lp.orderNumber LIKE 'RENORD%'
			AND lp.startDateUtc <= GETUTCDATE()
            AND RTRIM(lp.MTBCompany) = RTRIM(DB_NAME())
            AND lp.status = 'Hold'
            AND EXISTS ( SELECT  1
                         FROM    dbo.csiSOPHeaderAdditional c
                         WHERE   c.SOPNUMBE = lp.renewalId
                                 AND c.OkToSendSiteID = 1 )
            AND (
                 EXISTS ( SELECT 1
                          FROM   sop10100 b
                          WHERE  b.orignumb = lp.orderNumber
                                 AND b.soptype = 3 )
                 OR EXISTS ( SELECT 1
                             FROM   sop30200 b
                             WHERE  b.orignumb = lp.orderNumber
                                    AND b.soptype = 3 )
                )


	 INSERT OnyxIntegration.dbo.LPQueue
	        (lpStageId, jsonMsg)
			SELECT lpStageId, jsonMsg FROM OnyxIntegration.dbo.renewalToLPSubscriptions
			WHERE status = 'Ready'
			 IF @@ERROR = 0 BEGIN
			 UPDATE OnyxIntegration.dbo.renewalToLPSubscriptions
			 SET status = 'Sent', sentDate = GETDATE()
			 WHERE status =  'Ready' END

GO

GRANT EXECUTE ON dbo.mtb_UpdSubscriptionStatusToReady TO Developer
GO
GRANT EXECUTE ON dbo.mtb_UpdSubscriptionStatusToReady TO DYNGRP
GO
