@EndUserText.label: 'Select Options Demo'
@ClientHandling.type: #CLIENT_INDEPENDENT
define table function ZDEMO_SEL_OPT 
with parameters sel_opt1 : abap.char( 1333 ),
                sel_opt2 : abap.char( 1333 )
returns {
  //CLIENT : abap.clnt;
  SOURCE_SYSTEM : ukm_e_cct_id_sa_id;
  DIM_CP : abap.char( 32 ); 
  TARGET_SYSTEM : ukm_e_cct_id_sa_id; 
  PR1_CP : abap.char( 32 ); 
}
implemented by method ZCL_AMDP_FINAL=>GET_DATA;
