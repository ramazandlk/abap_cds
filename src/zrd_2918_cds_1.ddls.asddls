@AbapCatalog.sqlViewName: 'ZRD_V_CDS1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS1'
define view ZRD_2918_CDS_1 as select from ekko
            inner join ekpo      on ekpo.ebeln = ekko.ebeln
            inner join mara      on mara.matnr = ekpo.matnr
            left outer join makt on mara.matnr = makt.matnr
                                 and makt.spras = $session.system_language
left outer join lfa1 on lfa1.lifnr = ekko.lifnr
                   
{
    ekpo.ebeln,
    ekpo.ebelp,
    ekpo.matnr,
    makt.maktx,
    ekpo.werks,
    ekpo.lgort,
    ekpo.meins, 
    lfa1.lifnr,
    concat( lfa1.stras,lfa1.mcod3  ) as ad1
     
} 
