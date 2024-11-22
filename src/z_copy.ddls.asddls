@AbapCatalog.sqlViewName: 'ZCOPY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COPY CDS'
define view Z_COPY
   with parameters p_scheme_id1 : ukm_e_cct_id_s_id,
                    p_sagency_id1 : ukm_e_cct_id_sa_id,
                    p_scheme_id2 : ukm_e_cct_id_s_id,
                    p_sagency_id2 : ukm_e_cct_id_sa_id
as select from Z_CDS_KM1( p_scheme_id : $parameters.p_scheme_id1, 
                          p_sagency_id : $parameters.p_sagency_id1 ) as a
                          left outer join Z_CDS_KM2( p_scheme_id : $parameters.p_scheme_id2, 
                      p_sagency_id : $parameters.p_sagency_id2 ) as b  
on a.Mapping_group = b.Mapping_group
{ key a.DIM_CP , 
      a.SOURCE_SYSTEM , 
      b.PR1_CP , 
      b.TARGET_SYSTEM 
}
