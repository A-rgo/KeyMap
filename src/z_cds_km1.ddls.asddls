@AbapCatalog.sqlViewName: 'ZKM1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '1ST CDS VIEW'
@VDM : {viewType: #BASIC}

@ObjectModel: {
  usageType.serviceQuality: #C,
  usageType.sizeCategory: #XXL,
  usageType.dataClass: #MASTER
}

define view Z_CDS_KM1
with parameters p_scheme_id : ukm_e_cct_id_s_id,
                p_sagency_id : ukm_e_cct_id_sa_id
as select from ukmdb_keybnss0 as a 
inner join ukmdb_agcbnss0 as b on a.agency_id = b.agency_id
inner join ukmdb_schbnss0 as c on a.scheme_id = c.scheme_id
inner join ukmdb_mgpbnss0 as d on a.object_id = d.object_id
 {  key a.key_value_id as DIM_CP  ,
        b.cct_sagency_id as SOURCE_SYSTEM  ,
        d.group_id as Mapping_group    
}
where c.cct_scheme_id = $parameters.p_scheme_id //'927'
and b.cct_sagency_id = $parameters.p_sagency_id //'DIMCLNT100'
