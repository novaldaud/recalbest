IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Recalc_QTY]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_Recalc_QTY]
