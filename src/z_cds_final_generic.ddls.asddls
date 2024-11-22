@AbapCatalog.sqlViewName: 'ZKM_FGC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Optional CDS Parameter'
define view Z_CDS_FINAL_GENERIC
    with parameters p_carrid : s_carr_id,
    @Consumption.defaultValue: 'US'
                    p_country_frm : land1
                    //p_conn_id : s_conn_id
as select from Z_SPFLI_SEL( p_car: $parameters.p_carrid , p_ctry_fr: $parameters.p_country_frm)
{
 key carrid,
 //@Consumption.filter.mandatory: false
 key connid,
   @Consumption.filter.mandatory: false
  countryfr
}
where carrid = $parameters.p_carrid
and countryfr = $parameters.p_country_frm
//where connid = $parameters.p_conn_id
