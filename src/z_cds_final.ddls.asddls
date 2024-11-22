@AbapCatalog.sqlViewName: 'ZKM_FINAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Combined CDS view'
@VDM : {viewType: #COMPOSITE}

@ObjectModel: {
  usageType.serviceQuality: #C,
  usageType.sizeCategory: #L,
  usageType.dataClass: #MASTER
}

define view Z_CDS_FINAL
    with parameters p_scheme_id1 : ukm_e_cct_id_s_id,
                    p_sagency_id1 : ukm_e_cct_id_sa_id,
                    p_scheme_id2 : ukm_e_cct_id_s_id,
                    p_sagency_id2 : ukm_e_cct_id_sa_id
as select from Z_CDS_KM1( p_scheme_id : $parameters.p_scheme_id1, 
                          p_sagency_id : $parameters.p_sagency_id1 ) as a 
inner join Z_CDS_KM2( p_scheme_id : $parameters.p_scheme_id2, 
                      p_sagency_id : $parameters.p_sagency_id2 ) as b  
on a.Mapping_group = b.Mapping_group
//{ key a.DIM_CP , 
//      a.SOURCE_SYSTEM , 
//      b.PR1_CP , 
//      b.TARGET_SYSTEM 
//}
//{ 
//      a.SOURCE_SYSTEM ,                 --active code
//      a.DIM_CP ,
//      b.TARGET_SYSTEM ,
//      b.PR1_CP   
//}
{ 
      key a.DIM_CP ,
      key b.PR1_CP,
      a.SOURCE_SYSTEM , 
      b.TARGET_SYSTEM
   
}
