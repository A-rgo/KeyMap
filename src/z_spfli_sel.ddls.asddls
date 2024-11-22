@AbapCatalog.sqlViewName: 'ZPOC_SPFLI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Spfli CDS'
define view Z_SPFLI_SEL
    with parameters p_car : s_carr_id,
                    p_ctry_fr : land1 
as select from spfli
{
    key carrid,
    key connid,
        countryfr
}
where
carrid = $parameters.p_car
and countryfr = $parameters.p_ctry_fr
