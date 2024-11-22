CLASS zcl_amdp_final DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .

    TYPES:

      BEGIN OF ty_km,
        cp            TYPE ukmdb_keybnss0-key_value_id,
        object_scheme TYPE ukm_e_cct_id_s_id,
        system        TYPE ukm_e_cct_id_sa_id,
        Mapping_group TYPE ukm_e_group_id,
      END OF ty_km,
      tt_km1 TYPE STANDARD TABLE OF ty_km,
      tt_km2 TYPE STANDARD TABLE OF ty_km,

      BEGIN OF ty_final,
        SOURCE_SYSTEM  TYPE ukm_e_cct_id_sa_id,
        DIM_CP TYPE char32,
        TARGET_SYSTEM  TYPE ukm_e_cct_id_sa_id,
        PR1_CP TYPE char32,
      END OF ty_final,
      tt_km TYPE STANDARD TABLE OF ty_final.


    CLASS-METHODS : get_data FOR TABLE FUNCTION zdemo_sel_opt,
        get_data_amdp
        IMPORTING VALUE(sel_opt1) TYPE string
                  VALUE(sel_opt2) TYPE string
        EXPORTING VALUE(et_km)   TYPE tt_km
        RAISING cx_amdp_error.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS:
      get_km_data
        IMPORTING VALUE(sel_opt1) TYPE string
                  VALUE(sel_opt2) TYPE string
        EXPORTING VALUE(et_km1)   TYPE tt_km1
                  VALUE(et_km2)   TYPE tt_km2.
ENDCLASS.

CLASS zcl_amdp_final IMPLEMENTATION.

  METHOD get_data BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
                    OPTIONS READ-ONLY
                    USING zcl_amdp_final=>get_km_data.

*    DECLARE lv_CLNT "$ABAP.type( MANDT )" := session_context('CLIENT');
*    DECLARE lv_langu "$ABAP.type( spras )" := 'E';

    CALL "ZCL_AMDP_FINAL=>GET_KM_DATA"( SEL_OPT1 => :SEL_OPT1, SEL_OPT2 => :SEL_OPT2,
                                        ET_KM1 => :ET_KM1, ET_KM2 => :ET_KM2 );

    return SELECT
*    lv_clnt as client,
    a.SYSTEM as source_system,
    a.cp as dim_cp,
    b.SYSTEM as target_system,
    b.cp as pr1_cp
    from :et_km1 as a
    inner join :et_km2 as b
    on a.Mapping_group = b.Mapping_group;

  endmethod.

  METHOD get_km_data BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING
  ukmdb_keybnss0 ukmdb_agcbnss0 ukmdb_schbnss0 ukmdb_mgpbnss0.

*    DECLARE lv_CLNT "$ABAP.type( MANDT )" := session_context('CLIENT');

    ET_KMT = select
           a.key_value_id as CP  ,
           c.cct_scheme_id AS OBJECT_SCHEME  ,
           b.cct_sagency_id as SYSTEM  ,
           d.group_id as Mapping_group
           from ukmdb_keybnss0 as a
   inner join ukmdb_agcbnss0 as b on a.agency_id = b.agency_id
   inner join ukmdb_schbnss0 as c on a.scheme_id = c.scheme_id
   inner join ukmdb_mgpbnss0 as d on a.object_id = d.object_id;

   ET_KM1 = APPLY_FILTER( :ET_KMT, :SEL_OPT1 );
   ET_KM2 = APPLY_FILTER( :ET_KMT, :SEL_OPT2 );

  ENDMETHOD.

  METHOD get_data_amdp BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING
  ukmdb_keybnss0 ukmdb_agcbnss0 ukmdb_schbnss0 ukmdb_mgpbnss0.

*    DECLARE lv_CLNT "$ABAP.type( MANDT )" := session_context('CLIENT');

    ET_KMT = select
           a.key_value_id as CP  ,
           c.cct_scheme_id AS OBJECT_SCHEME  ,
           b.cct_sagency_id as SYSTEM  ,
           d.group_id as Mapping_group
           from ukmdb_keybnss0 as a
   inner join ukmdb_agcbnss0 as b on a.agency_id = b.agency_id
   inner join ukmdb_schbnss0 as c on a.scheme_id = c.scheme_id
   inner join ukmdb_mgpbnss0 as d on a.object_id = d.object_id;

   ET_KM1 = APPLY_FILTER( :ET_KMT, :SEL_OPT1 );
   ET_KM2 = APPLY_FILTER( :ET_KMT, :SEL_OPT2 );

   ET_KM = SELECT
    a.SYSTEM as source_system,
    a.cp as dim_cp,
    b.SYSTEM as target_system,
    b.cp as pr1_cp
    from :et_km1 as a
    inner join :et_km2 as b
    on a.Mapping_group = b.Mapping_group;

  ENDMETHOD.

ENDCLASS.

