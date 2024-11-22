*&---------------------------------------------------------------------*
*& Report ZKM_FETCH_API
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZKM_FETCH_API.

data:
  gv_bs_key_name        TYPE text60,
  gv_bs_caption         TYPE string ##NEEDED,
  gv_role               TYPE lcr_bs_role ##NEEDED.

*-- FM call to get the Business system
  CALL FUNCTION 'LCR_GET_OWN_BUSINESS_SYSTEM'
    EXPORTING
      bypassing_cache        = 'X'
    IMPORTING
      bs_key_name            = gv_bs_key_name
      bs_caption             = gv_bs_caption
      bs_role                = gv_role
    EXCEPTIONS
      no_business_system     = 1
      no_rfc_destination     = 2
      no_landscape_directory = 3
      illegal_arguments      = 4
      communication_error    = 5
      ld_error               = 6
      sld_api_exception      = 7
      OTHERS                 = 8.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.
  ENDIF.

*CONSTANTS:
*  gc_customer_object_type_code TYPE c LENGTH 3 VALUE '159',
*  gc_customer_scheme_code      TYPE c LENGTH 3 VALUE '918',
*  gc_contactp_obj_type_code    TYPE c LENGTH 4 VALUE '1405',
*  gc_contactp_scheme_code      TYPE c LENGTH 3 VALUE '927'.
*DATA:
*  gt_search_keys TYPE  mdg_t_object_key_bs,
*  gs_search_key  TYPE  mdg_s_object_key_bs,
*  gv_bs_key_name TYPE text60,
*  gs_kunnr       TYPE kunnr,
*  gs_parnr       TYPE parnr,
*  GT_MATCHING_OBJECTS  TYPE MDG_T_GET_MATCHING_EASY_BS.
*
*TABLES : but000, kna1, knvk.
*SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
*SELECT-OPTIONS:
* s_system FOR but000-bu_logsys NO INTERVALS OBLIGATORY,
* s_cust FOR kna1-kunnr NO INTERVALS MODIF ID mod.
*SELECT-OPTIONS:
* s_parnr FOR knvk-parnr NO INTERVALS MODIF ID pod.
**PARAMETERS: p_name TYPE string OBLIGATORY.
*SELECTION-SCREEN END OF BLOCK b1.
*
*LOOP AT s_cust.
*  gs_search_key-object_type_code = gc_customer_object_type_code.
*  gs_search_key-identifier_key-business_system_id = s_system. "gv_bs_key_name.
*  gs_search_key-identifier_key-ident_defining_scheme_code = gc_customer_scheme_code.
*  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*    EXPORTING
*      input  = s_cust-low
*    IMPORTING
*      output = gs_kunnr.
*  gs_search_key-identifier_key-id_value = gs_kunnr.
*  APPEND gs_search_key TO gt_search_keys.
*  CLEAR : gs_search_key,gs_kunnr.
*ENDLOOP.
*
*LOOP AT s_parnr.
**     Type code for Contact person ID is 1405
*  gs_search_key-object_type_code = gc_contactp_obj_type_code.
*  gs_search_key-identifier_key-business_system_id = 'DIMCLNT100'."s_system. "gv_bs_key_name.
**     Scheme code for Contact Person is 927
*  gs_search_key-identifier_key-ident_defining_scheme_code = gc_contactp_scheme_code.
**     The Contact Person field -PARNR must be sent after adding preceding zeros.
*  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*    EXPORTING
*      input  = s_parnr-low
*    IMPORTING
*      output = gs_parnr.
*  gs_search_key-identifier_key-id_value = gs_parnr.
*  APPEND gs_search_key TO gt_search_keys.
*  CLEAR : gs_search_key,gs_parnr.
*ENDLOOP.
*
*DATA : lv_string               TYPE char32.
*DATA : lv_mapping_grp_id       TYPE ukm_e_group_id.
*DATA : lv_bus_sys_id           TYPE mdg_business_system_id.
*DATA : lr_matching_api TYPE REF TO if_mdg_id_matching_api_bs.
*DATA : lv_x_error                  TYPE boolean.
*DATA : ls_search_key           TYPE  mdg_s_object_key_bs.
*DATA : ls_kms_key              TYPE key_map_s_drf_id.
*DATA : lt_bo_keys              TYPE drf_t_bo_tabfield.
*DATA : ls_bo_keys              LIKE LINE OF  lt_bo_keys.
*DATA : ls_kms_bo_key           LIKE LINE OF ls_bo_keys-bo_keys.
*
*TRY.
*    CALL METHOD cl_mdg_id_matching_api_bs=>get_instance
*      EXPORTING
*        iv_direct_db_insert       = abap_false
*        iv_set_lcl_system_by_api  = abap_true
*      IMPORTING
*        er_if_mdg_id_matching_api = lr_matching_api.
*  CATCH cx_mdg_id_matching_bs.
*    lv_x_error = abap_true.
*  CATCH cx_mdg_no_api_instance.
*    lv_x_error = abap_true.
*  CATCH cx_mdg_lcl_bus_sys_not_found.
*    lv_x_error = abap_true.
*ENDTRY.
*
*IF gt_search_keys IS NOT INITIAL.
*  TRY .
*    CALL METHOD LR_MATCHING_API->get_matching
*    EXPORTING
*      it_search_key               =      gt_search_keys            " Multiple Object Keys inlcuding Object Type Code
**      is_search_key               =                  " Object Key inlcuding Object Type Code
*      iv_target_system            =       'ZCCEP_PR1'           " Key Name of Business System
**      iv_access_ctrl_reg_directly = abap_false       " 'X' Get KM from ctrl. reg. directly
**      iv_do_not_access_ctrl_reg   = abap_false       " 'X' Ignore customizing & do not access ctrl. reg.
*    IMPORTING
*      et_matching_objects         =     gt_matching_objects             " Identifier Set data of multiple pairs of mapped objects
**      es_matching_objects_easy    =                  " Identifier Set data of mapped objects
*    .
*  CATCH cx_mdg_missing_input_parameter. " Missing Input parameter in a method
*  CATCH cx_mdg_missing_id_data.         " One or more ID data are missing
*  CATCH cx_mdg_otc_idm_error.           " ID matching related OTC error
*  CATCH cx_mdg_id_matching_bs.          " General ID matching messages
*  CATCH cx_mdg_idsc_invalid.            " IDS code does not exist
*  CATCH cx_mdg_no_ctrl_reg_defined.     " For OTC no central registry defined in KM
*  CATCH cx_mdg_km_invalid_id_value.     " Invalid ID value
*
*  ENDTRY.
*
*ENDIF.
*
*TYPES: BEGIN OF ty_output,
*         source_system TYPE ukm_e_cct_id_sa_id,
*         dim_cp        TYPE char32,
*         target_system TYPE ukm_e_cct_id_sa_id,
*         pr1_cp        TYPE char32,
*       END OF ty_output.
*
*DATA: gt_output  TYPE STANDARD TABLE OF ty_output.
*
*IF gt_matching_objects IS NOT INITIAL.
*
**  gt_output = VALUE #(
**                      source
**                      ).
*
*
*ENDIF.

*IF gt_search_keys IS NOT INITIAL.
*  LOOP AT gt_search_keys INTO ls_search_key.
*    CALL METHOD cl_mdg_id_matching_api_bs=>get_mapping_group_id
*      EXPORTING
*        is_search_key     = ls_search_key
*      IMPORTING
*        ev_mapping_grp_id = lv_mapping_grp_id.
*
*    select a~key_value_id
*      into @data(lv_km) from ( ukmdb_keybnss0 as a
*inner join ukmdb_agcbnss0 as b on a~agency_id = b~agency_id
*inner join ukmdb_schbnss0 as c on a~scheme_id = c~scheme_id
*inner join ukmdb_mgpbnss0 as d on a~object_id = d~object_id )
**{ key a.key_value_id as PR1_CP,
**      b.cct_sagency_id as TARGET_SYSTEM,
**      d.group_id as Mapping_group
**}
*where c~cct_scheme_id = @gc_contactp_scheme_code "'927'
*and b~cct_sagency_id = 'ZCCEP_PR1'
*and d~group_id = @lv_mapping_grp_id.
*
* endselect.
*
*    IF lv_mapping_grp_id IS NOT INITIAL.
*      ls_kms_key-group_id = lv_mapping_grp_id.
*      ls_kms_key-object_type_code   = ls_search_key-object_type_code.
*      CONCATENATE ls_kms_key-object_type_code ls_kms_key-group_id ls_kms_key-cdchgid
*              INTO ls_kms_bo_key-bo_key RESPECTING BLANKS.
*      APPEND ls_kms_bo_key TO ls_bo_keys-bo_keys.
*      CLEAR:  ls_kms_key.
*    ENDIF.
*  ENDLOOP.
*ENDIF.
