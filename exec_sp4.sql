create procedure [dbo].[SP_Recalc_QTY] (
@awal datetime,
@akhir datetime
) as

DECLARE @RC int

update a
set a.Stk_Qtyin=0, a.Stk_Qtyout=0, a.Stk_Qtyadj=0
from Mst_Stock as a where a.Stk_Date between @awal and @akhir

update a
set a.Stk_Qtyin=s.STK_QTYIN, a.Stk_Qtyout=s.STK_QTYOUT
from V_MST_STOCK as s inner join Mst_Stock as a on s.Inv_Code=a.Inv_Code and s.Who_Code=a.Who_Code and s.Stk_Date=a.Stk_Date
where  S.Stk_Date between @awal and @akhir

--------------------------------
insert into Mst_Stock
select s.*,0,0 from V_MST_STOCK as s left outer join Mst_Stock as a on s.Inv_Code=a.Inv_Code and s.Who_Code=a.Who_Code and s.Stk_Date=a.Stk_Date
where a.Inv_Code is null and S.Stk_Date between @awal and @akhir
--------------------------------

update mst_stock set Stk_Qtyadj=0 where Stk_Date>=@awal

select @akhir=Pci_ClsStk+1 from Mst_Par_Pcin
EXECUTE @RC = [SP_SA_MST_STOCK] 
   @awal
  ,@akhir

DECLARE  @imax INT, 
         @i    INT
declare	@inv VARCHAR(20),
        @who varchar(5), 
        @vdate datetime
declare @fqtyADJ numeric(20),
		@fprcADJ numeric(20)
declare @fqty numeric(20),
		@fprc numeric(20)
DECLARE  @mst_stock  TABLE( 
                             RowID       INT    IDENTITY ( 1 , 1 ), 
                             inv VARCHAR(20),
                             who varchar(5), vdate datetime
                             ) 
INSERT @mst_stock 
SELECT   distinct inv_code, Who_Code,Stk_Date 
FROM     V_MST_STOCK
WHERE    stk_Date between @awal and @akhir AND STK_QTYADJ<>0
ORDER BY inv_code
SET @imax = @@ROWCOUNT 
SET @i = 1 
WHILE (@i <= @imax) 
	BEGIN
		SELECT @inv=inv, @who=who, @vdate=vdate
		FROM   @mst_stock 
		WHERE  RowID = @i 
		select @fqty=QTY,@fprc=NILAI from F_CEK_SALDO(@inv,@who, @vdate, @vdate)
		select @fqtyADJ=STK_QTYADJ,@fprcADJ=STK_VALADJ FROM V_MST_STOCK WHERE inv_code=@inv and who_code=@who and stk_date=@vdate AND STK_QTYADJ<>0
		update Mst_Stock set Stk_Qtyadj=@fqtyADJ-@fqty where inv_code=@inv and who_code=@who and stk_date=@vdate
		set @i=@i+1
	END

select @akhir=Pci_ClsStk+1 from Mst_Par_Pcin
EXECUTE @RC = SP_SA_MST_STOCK
   @awal
  ,@akhir

--------------------------------