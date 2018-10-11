create VIEW [dbo].[V_MST_STOCK] AS
/*ORDER BY Stk_Date, Inv_Code, Who_Code*/
SELECT     Inv_Code, Who_Code, Stk_Date, SUM(STK_QTYBBAL) AS STK_QTYBBAL, SUM(STK_VALBBAL) AS STK_VALBBAL, SUM(STK_QTYIN) AS STK_QTYIN, SUM(STK_VALIN) 
                      AS STK_VALIN, SUM(STK_QTYOUT) AS STK_QTYOUT, SUM(STK_VALOUT) AS STK_VALOUT, SUM(STK_QTYADJ) AS STK_QTYADJ, SUM(STK_VALADJ) 
                      AS STK_VALADJ
                      --BK
FROM         (SELECT     Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Who_Code, Trs_Stk_Hdr.Stk_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 0 AS STK_QTYIN, 0 AS STK_VALIN, 
                                              SUM(Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3) 
                                              AS STK_QTYOUT, 
                                              SUM((Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3) 
                                              * Trs_Stk_Dtl.Stk_Itemprc) AS STK_VALOUT, 0 AS STK_QTYADJ, 0 AS STK_VALADJ
                       FROM          Trs_Stk_Hdr INNER JOIN
                                              Trs_Stk_Dtl ON Trs_Stk_Hdr.Stk_Number = Trs_Stk_Dtl.Stk_Number INNER JOIN
                                              Mst_Inv ON Trs_Stk_Dtl.Inv_Code = Mst_Inv.Inv_Code CROSS JOIN
                                              Mst_Par_Pcin
                       WHERE      (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Dtl.Stk_Number LIKE Mst_Par_Pcin.Pci_Serbk + '%')
                       GROUP BY Trs_Stk_Hdr.Stk_Date, Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Who_Code
                       UNION ALL --BT IN
                       SELECT     Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Stk_Supcd, Trs_Stk_Hdr.Stk_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 
                                             SUM(Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3) 
                                             AS STK_QTYIN, 
                                             SUM((Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3) 
                                             * Trs_Stk_Dtl.Stk_Itemprc) AS STK_VALIN, 0 AS STK_QTYOUT, 0 AS STK_VALOUT, 0 AS STK_QTYADJ, 0 AS STK_VALADJ
                       FROM         Trs_Stk_Hdr INNER JOIN
                                             Trs_Stk_Dtl ON Trs_Stk_Hdr.Stk_Number = Trs_Stk_Dtl.Stk_Number INNER JOIN
                                             Mst_Inv ON Trs_Stk_Dtl.Inv_Code = Mst_Inv.Inv_Code CROSS JOIN
                                             Mst_Par_Pcin
                       WHERE     (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Dtl.Stk_Number LIKE Mst_Par_Pcin.Pci_Serbt + '%') AND (Trs_Stk_Dtl.Stk_Itemtp LIKE 'M%')
                       GROUP BY Trs_Stk_Hdr.Stk_Date, Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Stk_Supcd
                       UNION ALL--BT OUT
                       SELECT     Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Who_Code, Trs_Stk_Hdr.Stk_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 0 AS STK_QTYIN, 0 AS STK_VALIN, 
                                             SUM(Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3) 
                                             AS STK_QTYOUT, 
                                             SUM((Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3) 
                                             * Trs_Stk_Dtl.Stk_Itemprc) AS STK_VALOUT, 0 AS STK_QTYADJ, 0 AS STK_VALADJ
                       FROM         Trs_Stk_Hdr INNER JOIN
                                             Trs_Stk_Dtl ON Trs_Stk_Hdr.Stk_Number = Trs_Stk_Dtl.Stk_Number INNER JOIN
                                             Mst_Inv ON Trs_Stk_Dtl.Inv_Code = Mst_Inv.Inv_Code CROSS JOIN
                                             Mst_Par_Pcin
                       WHERE     (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Dtl.Stk_Number LIKE Mst_Par_Pcin.Pci_Serbt + '%') AND (Trs_Stk_Dtl.Stk_Itemtp LIKE 'K%')
                       GROUP BY Trs_Stk_Hdr.Stk_Date, Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Who_Code
                       UNION ALL --BPB WITH OP
                       SELECT     Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Who_Code, Trs_Stk_Hdr.Stk_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 
                                             CASE WHEN OPD.OP_Itemqty1 IS NULL THEN CASE Inv_PUnit WHEN 1 THEN Trs_Stk_Dtl.Stk_Itemqty3 * Inv_Cont1 * inv_cont2 WHEN 2 THEN Trs_Stk_Dtl.Stk_Itemqty3 * Inv_Cont2 ELSE Trs_Stk_Dtl.Stk_Itemqty3 END ELSE Trs_Stk_Dtl.Stk_Itemqty3 --Trs_Stk_Dtl.Stk_Itemqty1* Inv_Cont1 * inv_cont2 +Trs_Stk_Dtl.Stk_Itemqty2* inv_cont2 +Trs_Stk_Dtl.Stk_Itemqty3 
                                              END AS stk_qtyin, Trs_Stk_Hdr.Stk_Xrate * Trs_Stk_Dtl.Stk_Itemqty3 * Trs_Stk_Dtl.Stk_Itemprc AS stk_valin, 0 AS STK_QTYOUT, 0 AS STK_VALOUT, 
                                             0 AS STK_QTYADJ, 0 AS STK_VALADJ
                       FROM         Trs_Stk_Dtl INNER JOIN
                                             Trs_Stk_Hdr ON Trs_Stk_Dtl.Stk_Number = Trs_Stk_Hdr.Stk_Number INNER JOIN
                                             Mst_Inv ON Trs_Stk_Dtl.Inv_Code = Mst_Inv.Inv_Code INNER JOIN
                                             Mst_Supp ON Trs_Stk_Hdr.Stk_Supcd = Mst_Supp.Sup_Code INNER JOIN
                                             Mst_Par_Pcin ON 1 = 1 INNER JOIN trs_OP_Dtl AS OPD ON Trs_Stk_Dtl.Stk_Refno=OPD.OP_Number AND TRS_STK_DTL.Inv_Code=OPD.Inv_Code AND Trs_Stk_Dtl.Stk_Dtlnote LIKE OPD.OP_DtlNote +'%'
                       WHERE     (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_Serbp + '%' OR
                                             Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_Serbpdp + '%') AND ((Trs_Stk_Dtl.STK_ITEMDSCP1 IN (1, NULL,0)) OR Trs_Stk_Dtl.STK_ITEMDSCP1 IS NULL) AND (Trs_Stk_Dtl.Stk_Refno IN
                                                 (SELECT     OP_Number
                                                   FROM          trs_OP_Hdr
                                                   WHERE      (OP_Flag <> 'B')))
                       UNION ALL--BPB NOT OP
                       SELECT     Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Who_Code, Trs_Stk_Hdr.Stk_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 
                                             CASE Inv_PUnit WHEN 1 THEN Trs_Stk_Dtl.Stk_Itemqty3 * Inv_Cont1 * inv_cont2 WHEN 2 THEN Trs_Stk_Dtl.Stk_Itemqty3 * Inv_Cont2 ELSE Trs_Stk_Dtl.Stk_Itemqty3
                                              END AS stk_qtyin, Trs_Stk_Hdr.Stk_Xrate * Trs_Stk_Dtl.Stk_Itemqty3 * Trs_Stk_Dtl.Stk_Itemprc AS stk_valin, 0 AS STK_QTYOUT, 0 AS STK_VALOUT, 
                                             0 AS STK_QTYADJ, 0 AS STK_VALADJ
                       FROM         Trs_Stk_Dtl INNER JOIN
                                             Trs_Stk_Hdr ON Trs_Stk_Dtl.Stk_Number = Trs_Stk_Hdr.Stk_Number INNER JOIN
                                             Mst_Inv ON Trs_Stk_Dtl.Inv_Code = Mst_Inv.Inv_Code INNER JOIN
                                             Mst_Supp ON Trs_Stk_Hdr.Stk_Supcd = Mst_Supp.Sup_Code INNER JOIN
                                             Mst_Par_Pcin ON 1 = 1
                       WHERE     (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_Serbp + '%' OR
                                             Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_Serbpdp + '%') AND ((Trs_Stk_Dtl.STK_ITEMDSCP1 IN (1, NULL,0)) OR Trs_Stk_Dtl.STK_ITEMDSCP1 IS NULL) AND 
                                             (Trs_Stk_Dtl.Stk_Refno NOT IN
                                                 (SELECT     OP_Number
                                                   FROM          trs_OP_Hdr
                                                   WHERE      (OP_Flag <> 'B')))
                       UNION ALL --BP 3 STN
                        SELECT     Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Who_Code, Trs_Stk_Hdr.Stk_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 
                                             CASE WHEN OPD.OP_Itemqty1 IS not NULL THEN Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3 else 0 end AS stk_qtyin,
                                              Trs_Stk_Hdr.Stk_Xrate * (Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3)
                                              * Trs_Stk_Dtl.Stk_Itemprc AS stk_valin, 0 AS STK_QTYOUT, 0 AS STK_VALOUT, 0 AS STK_QTYADJ, 0 AS STK_VALADJ
                       FROM         Trs_Stk_Dtl INNER JOIN
                                             Trs_Stk_Hdr ON Trs_Stk_Dtl.Stk_Number = Trs_Stk_Hdr.Stk_Number INNER JOIN
                                             Mst_Inv ON Trs_Stk_Dtl.Inv_Code = Mst_Inv.Inv_Code INNER JOIN
                                             Mst_Supp ON Trs_Stk_Hdr.Stk_Supcd = Mst_Supp.Sup_Code INNER JOIN
                                             Mst_Par_Pcin ON 1 = 1  INNER JOIN trs_OP_Dtl AS OPD ON Trs_Stk_Dtl.Stk_Refno=OPD.OP_Number AND TRS_STK_DTL.Inv_Code=OPD.Inv_Code AND Trs_Stk_Dtl.Stk_Dtlnote LIKE OPD.OP_DtlNote +'%'
                       WHERE     (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_Serbp + '%' OR
                                             Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_Serbpdp + '%') AND ((Trs_Stk_Dtl.STK_ITEMDSCP1 IN (3)) OR Trs_Stk_Dtl.STK_ITEMDSCP1 IS NULL) AND (Trs_Stk_Dtl.Stk_Refno IN
                                                 (SELECT     OP_Number
                                                   FROM          trs_OP_Hdr
                                                   WHERE      (OP_Flag <> 'B')))
                       UNION ALL --BP 3 STN
                       SELECT     Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Who_Code, Trs_Stk_Hdr.Stk_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 
                                             Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3 AS stk_qtyin,
                                              Trs_Stk_Hdr.Stk_Xrate * (Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3)
                                              * Trs_Stk_Dtl.Stk_Itemprc AS stk_valin, 0 AS STK_QTYOUT, 0 AS STK_VALOUT, 0 AS STK_QTYADJ, 0 AS STK_VALADJ
                       FROM         Trs_Stk_Dtl INNER JOIN
                                             Trs_Stk_Hdr ON Trs_Stk_Dtl.Stk_Number = Trs_Stk_Hdr.Stk_Number INNER JOIN
                                             Mst_Inv ON Trs_Stk_Dtl.Inv_Code = Mst_Inv.Inv_Code INNER JOIN
                                             Mst_Supp ON Trs_Stk_Hdr.Stk_Supcd = Mst_Supp.Sup_Code INNER JOIN
                                             Mst_Par_Pcin ON 1 = 1
                       WHERE     (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_Serbp + '%' OR
                                             Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_Serbpdp + '%') AND ((Trs_Stk_Dtl.STK_ITEMDSCP1 IN (3)) OR Trs_Stk_Dtl.STK_ITEMDSCP1 IS NULL) AND (Trs_Stk_Dtl.Stk_Refno NOT IN
                                                 (SELECT     OP_Number
                                                   FROM          trs_OP_Hdr
                                                   WHERE      (OP_Flag <> 'B')))
                       UNION ALL --NR
--------------------------------------------------------------------------------------------  
                      SELECT     Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Who_Code, Trs_Stk_Hdr.Stk_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 0 AS stk_qtyin, 0 AS stk_valin, 
                                             Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3
                                             AS STK_QTYOUT, Trs_Stk_Hdr.Stk_Xrate * Trs_Stk_Dtl.Stk_Itemqty3 * Trs_Stk_Dtl.Stk_Itemprc AS STK_VALOUT, 0 AS STK_QTYADJ, 
                                             0 AS STK_VALADJ
                       FROM         Trs_Stk_Dtl INNER JOIN
                                             Trs_Stk_Hdr ON Trs_Stk_Dtl.Stk_Number = Trs_Stk_Hdr.Stk_Number INNER JOIN
                                             Mst_Inv ON Trs_Stk_Dtl.Inv_Code = Mst_Inv.Inv_Code INNER JOIN
                                             Mst_Supp ON Trs_Stk_Hdr.Stk_Supcd = Mst_Supp.Sup_Code INNER JOIN
                                             Mst_Par_Pcin ON 1 = 1
                       WHERE     (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_SerNR2 + '%' OR
                                             Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_Sernr + '%') AND ((Trs_Stk_Dtl.STK_ITEMDSCP1 IN (1))) AND (Trs_Stk_Dtl.Stk_Refno IN
                                                 (SELECT     Stk_Number
                                                   FROM          Trs_Stk_Hdr
                                                   WHERE      (Stk_Flag <> 'B')))
                       UNION ALL-- NR
                       SELECT     Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Who_Code, Trs_Stk_Hdr.Stk_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 0 AS stk_qtyin, 0 AS stk_valin, 
                                             Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3
                                             AS STK_QTYOUT, Trs_Stk_Hdr.Stk_Xrate * Trs_Stk_Dtl.Stk_Itemqty3 * Trs_Stk_Dtl.Stk_Itemprc AS STK_VALOUT, 0 AS STK_QTYADJ, 
                                             0 AS STK_VALADJ
                       FROM         Trs_Stk_Dtl INNER JOIN
                                             Trs_Stk_Hdr ON Trs_Stk_Dtl.Stk_Number = Trs_Stk_Hdr.Stk_Number INNER JOIN
                                             Mst_Inv ON Trs_Stk_Dtl.Inv_Code = Mst_Inv.Inv_Code INNER JOIN
                                             Mst_Supp ON Trs_Stk_Hdr.Stk_Supcd = Mst_Supp.Sup_Code INNER JOIN
                                             Mst_Par_Pcin ON 1 = 1
                       WHERE     (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_SerNR2 + '%' OR
                                             Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_Sernr + '%') AND ((Trs_Stk_Dtl.STK_ITEMDSCP1 IN (1))) AND (Trs_Stk_Dtl.Stk_Refno NOT IN
                                                 (SELECT     Stk_Number
                                                   FROM          Trs_Stk_Hdr
                                                   WHERE      (Stk_Flag <> 'B')))
                       UNION ALL--NR
                       SELECT     Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Who_Code, Trs_Stk_Hdr.Stk_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 0 AS stk_qtyin, 0 AS stk_valin, 
                                             Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3 AS STK_QTYOUT,
                                              Trs_Stk_Hdr.Stk_Xrate * (Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3)
                                              * Trs_Stk_Dtl.Stk_Itemprc AS STK_VALOUT, 0 AS STK_QTYADJ, 0 AS STK_VALADJ
                       FROM         Trs_Stk_Dtl INNER JOIN
                                             Trs_Stk_Hdr ON Trs_Stk_Dtl.Stk_Number = Trs_Stk_Hdr.Stk_Number INNER JOIN
                                             Mst_Inv ON Trs_Stk_Dtl.Inv_Code = Mst_Inv.Inv_Code INNER JOIN
                                             Mst_Supp ON Trs_Stk_Hdr.Stk_Supcd = Mst_Supp.Sup_Code INNER JOIN
                                             Mst_Par_Pcin ON 1 = 1
                       WHERE     (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_SerNR2 + '%' OR
                                             Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_Sernr + '%') AND (Trs_Stk_Dtl.STK_ITEMDSCP1 IN (3) or Trs_Stk_Dtl.STK_ITEMDSCP1 is null) AND (Trs_Stk_Dtl.Stk_Refno IN
                                                 (SELECT     Stk_Number
                                                   FROM          Trs_Stk_Hdr
                                                   WHERE      (Stk_Flag <> 'B')))
                       UNION ALL --NR
                       SELECT     Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Who_Code, Trs_Stk_Hdr.Stk_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 0 AS stk_qtyin, 0 AS stk_valin, 
                                             Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3 AS STK_QTYOUT,
                                              Trs_Stk_Hdr.Stk_Xrate * (Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3)
                                              * Trs_Stk_Dtl.Stk_Itemprc AS STK_VALOUT, 0 AS STK_QTYADJ, 0 AS STK_VALADJ
                       FROM         Trs_Stk_Dtl INNER JOIN
                                             Trs_Stk_Hdr ON Trs_Stk_Dtl.Stk_Number = Trs_Stk_Hdr.Stk_Number INNER JOIN
                                             Mst_Inv ON Trs_Stk_Dtl.Inv_Code = Mst_Inv.Inv_Code INNER JOIN
                                             Mst_Supp ON Trs_Stk_Hdr.Stk_Supcd = Mst_Supp.Sup_Code INNER JOIN
                                             Mst_Par_Pcin ON 1 = 1
                       WHERE     (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_SerNR2 + '%' OR
                                             Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_Sernr + '%') AND (Trs_Stk_Dtl.STK_ITEMDSCP1 IN (3) or Trs_Stk_Dtl.STK_ITEMDSCP1 is null) AND (Trs_Stk_Dtl.Stk_Refno NOT IN
                                                 (SELECT     Stk_Number
                                                   FROM          Trs_Stk_Hdr
                                                   WHERE      (Stk_Flag <> 'B')))
                       UNION ALL --OPN
                       SELECT     Trs_Stk_Dtl.Inv_Code, Trs_Stk_Hdr.Who_Code, Trs_Stk_Hdr.Stk_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 0 AS stk_qtyin, 0 AS stk_valin, 
                                             0 AS STK_QTYOUT, 0 AS STK_VALOUT, 
                                             Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3 AS STK_QTYADJ,
                                              Trs_Stk_Hdr.Stk_Xrate * (Trs_Stk_Dtl.Stk_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Stk_Dtl.Stk_Itemqty3)
                                              * Trs_Stk_Dtl.Stk_Itemprc AS STK_VALADJ
                       FROM         Trs_Stk_Dtl INNER JOIN
                                             Trs_Stk_Hdr ON Trs_Stk_Dtl.Stk_Number = Trs_Stk_Hdr.Stk_Number INNER JOIN
                                             Mst_Inv ON Trs_Stk_Dtl.Inv_Code = Mst_Inv.Inv_Code INNER JOIN
                                             Mst_Par_Pcin ON 1 = 1
                       WHERE     (Trs_Stk_Hdr.Stk_Flag <> 'B') AND (Trs_Stk_Hdr.Stk_Number LIKE Mst_Par_Pcin.Pci_Seropn + '%')
                       UNION ALL--SLS
                       SELECT     Trs_Sls_Dtl.Inv_Code, Trs_Sls_Hdr.who_code, Trs_Sls_Hdr.Sls_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 0 AS stk_qtyin, 0 AS stk_valin, 
                                             Trs_Sls_Dtl.Sls_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Sls_Dtl.Sls_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Sls_Dtl.Sls_Itemqty3 AS stk_qtyout,
                                              (Trs_Sls_Dtl.Sls_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Sls_Dtl.Sls_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Sls_Dtl.Sls_Itemqty3) 
                                             * Trs_Sls_Hpp.Slh_Itemhpp AS stk_valout, 0 AS STK_qtyadj, 0 AS STK_VALADJ
                       FROM         Trs_Sls_Dtl INNER JOIN
                                             Mst_Inv ON Trs_Sls_Dtl.Inv_Code = Mst_Inv.Inv_Code INNER JOIN
                                             Trs_Sls_Hdr ON Trs_Sls_Dtl.Sls_Number = Trs_Sls_Hdr.Sls_Number LEFT OUTER JOIN
                                             Trs_Sls_Hpp ON Trs_Sls_Dtl.Inv_Code = Trs_Sls_Hpp.Inv_Code AND Trs_Sls_Dtl.Sls_Number = Trs_Sls_Hpp.Sls_Number
                       WHERE     (Trs_Sls_Hdr.Sls_Flag <> 'B') AND (Trs_Sls_Hdr.Sls_Invtp = 'S') AND (Trs_Sls_Hdr.Sls_Flag <> 'B')
                       UNION ALL--SLS RETURN
                       SELECT     Trs_Sls_Dtl.Inv_Code, Trs_Sls_Hdr.who_code, Trs_Sls_Hdr.Sls_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 
                                             Trs_Sls_Dtl.Sls_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Sls_Dtl.Sls_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Sls_Dtl.Sls_Itemqty3 AS stk_qtyin,
                                              (Trs_Sls_Dtl.Sls_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Sls_Dtl.Sls_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Sls_Dtl.Sls_Itemqty3) 
                                             * Trs_Sls_Hpp.Slh_Itemhpp AS stk_valin, 0 AS stk_qtyout, 0 AS stk_valout, 0 AS STK_qtyadj, 0 AS STK_VALADJ
                       FROM         Trs_Sls_Dtl INNER JOIN
                                             Mst_Inv ON Trs_Sls_Dtl.Inv_Code = Mst_Inv.Inv_Code INNER JOIN
                                             Trs_Sls_Hdr ON Trs_Sls_Dtl.Sls_Number = Trs_Sls_Hdr.Sls_Number LEFT OUTER JOIN
                                             Trs_Sls_Hpp ON Trs_Sls_Dtl.Inv_Code = Trs_Sls_Hpp.Inv_Code AND Trs_Sls_Dtl.Sls_Number = Trs_Sls_Hpp.Sls_Number
                       WHERE     (Trs_Sls_Hdr.Sls_Invtp = 'R') AND (Trs_Sls_Hdr.Sls_Flag <> 'B')
                       UNION ALL --SJ
                       SELECT     Trs_Sjl_Dtl.Inv_Code, Trs_Sjl_Hdr.Who_Code, Trs_Sjl_Hdr.Sjl_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 0 AS stk_qtyin, 0 AS stk_valin, 
                                             Trs_Sjl_Dtl.Sjl_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Sjl_Dtl.Sjl_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Sjl_Dtl.Sjl_Itemqty3 AS stk_qtyout, 
                                             (Trs_Sjl_Dtl.Sjl_Itemqty1 * Trs_Sjl_Dtl.Sjl_Itemprc1 + Trs_Sjl_Dtl.Sjl_Itemqty2 * Trs_Sjl_Dtl.Sjl_Itemprc2) 
                                             + Trs_Sjl_Dtl.Sjl_Itemqty3 * Trs_Sjl_Dtl.Sjl_Itemprc3 AS stk_valout, 0 AS STK_qtyadj, 0 AS STK_VALADJ
                       FROM         Trs_Sjl_Dtl INNER JOIN
                                             Mst_Inv ON Trs_Sjl_Dtl.Inv_Code = Mst_Inv.Inv_Code INNER JOIN
                                             Trs_Sjl_Hdr ON Trs_Sjl_Dtl.Sjl_Number = Trs_Sjl_Hdr.Sjl_Number
                       WHERE     (Trs_Sjl_Hdr.Sjl_Sjltp IN ('S', 'J')) AND (Trs_Sjl_Hdr.Sjl_Flag <> 'B')
                       UNION ALL --SJ RTN
                       SELECT     Trs_Sjl_Dtl.Inv_Code, Trs_Sjl_Hdr.Who_Code, Trs_Sjl_Hdr.Sjl_Date, 0 AS STK_QTYBBAL, 0 AS STK_VALBBAL, 
                                             Trs_Sjl_Dtl.Sjl_Itemqty1 * Mst_Inv.Inv_Cont1 * Mst_Inv.Inv_Cont2 + Trs_Sjl_Dtl.Sjl_Itemqty2 * Mst_Inv.Inv_Cont2 + Trs_Sjl_Dtl.Sjl_Itemqty3 AS stk_qtyin, 
                                             (Trs_Sjl_Dtl.Sjl_Itemqty1 * Trs_Sjl_Dtl.Sjl_Itemprc1 + Trs_Sjl_Dtl.Sjl_Itemqty2 * Trs_Sjl_Dtl.Sjl_Itemprc2) 
                                             + Trs_Sjl_Dtl.Sjl_Itemqty3 * Trs_Sjl_Dtl.Sjl_Itemprc3 AS stk_valin, 0 AS stk_qtyout, 0 AS stk_valout, 0 AS STK_qtyadj, 0 AS STK_VALADJ
                       FROM         Trs_Sjl_Dtl INNER JOIN
                                             Mst_Inv ON Trs_Sjl_Dtl.Inv_Code = Mst_Inv.Inv_Code INNER JOIN
                                             Trs_Sjl_Hdr ON Trs_Sjl_Dtl.Sjl_Number = Trs_Sjl_Hdr.Sjl_Number
                       WHERE     (Trs_Sjl_Hdr.Sjl_Sjltp IN ('R', 'T')) AND (Trs_Sjl_Hdr.Sjl_Flag <> 'B')) AS DATA
GROUP BY Inv_Code, Who_Code, Stk_Date
