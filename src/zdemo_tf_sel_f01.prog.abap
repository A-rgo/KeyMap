*&---------------------------------------------------------------------*
*& Include          ZDEMO_TF_SEL_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  TRANSFER PARAMETER AND SELECT-OPTION TO STRING VALUE
*&---------------------------------------------------------------------*
FORM transfer_params_to_string.
*  TRY .
*      gv_where1 = cl_shdb_seltab=>combine_seltabs(
*                                            it_named_seltabs = VALUE #(
*                                                                        ( name = 'CP'  dref = REF #( s_kmid1[] ) )
*                                                                        ( name = 'OBJECT_SCHEME'  dref = REF #( pschmid1 ) )
*                                                                        ( name = 'SYSTEM'  dref = REF #( psagnid1 ) )
*                                                                      )
*                                                        ).
*    CATCH cx_shdb_exception INTO lx_shdb_exception.
*      CLEAR gv_where1.
*  ENDTRY.

  TRY .
      DATA(lv_condition1) = cl_shdb_seltab=>combine_seltabs(
                                            it_named_seltabs = VALUE #(
                                                                        ( name = 'CP'  dref = REF #( s_kmid1[]  ) )
                                                                      )
                                                        ).
    CATCH cx_shdb_exception INTO lx_shdb_exception.
      CLEAR lv_condition1.
  ENDTRY.

  IF lv_condition1 IS NOT INITIAL.
    gv_where1 = |OBJECT_SCHEME = '{ pschmid1 }'|.
    gv_where1 = | AND { gv_where1 } AND SYSTEM = '{ psagnid1 }'|.
    gv_where1 = |{ lv_condition1 } { gv_where1 } |.
  ELSE.
    gv_where1 = |OBJECT_SCHEME = '{ pschmid1 }' AND SYSTEM = '{ psagnid1 }'|.
  ENDIF.

  TRY .
      DATA(lv_condition2) = cl_shdb_seltab=>combine_seltabs(
                                            it_named_seltabs = VALUE #(
                                                                        ( name = 'CP'  dref = REF #( s_kmid2[]  ) )
                                                                      )
                                                        ).
    CATCH cx_shdb_exception INTO lx_shdb_exception.
      CLEAR lv_condition2.
  ENDTRY.

  IF lv_condition2 IS NOT INITIAL.
    gv_where2 = |OBJECT_SCHEME = '{ pschmid2 }'|.
    gv_where2 = | AND { gv_where2 } AND SYSTEM = '{ psagnid2 }'|.
    gv_where2 = |{ lv_condition2 } { gv_where2 } |.
  ELSE.
    gv_where2 = |OBJECT_SCHEME = '{ pschmid2 }' AND SYSTEM = '{ psagnid2 }'|.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form amfp_tf_sel
*&---------------------------------------------------------------------*
FORM amdp_tf_sel.
  DATA lx_sy_open_sql_data_error TYPE REF TO cx_sy_open_sql_data_error.
  TRY .
      SELECT *
        FROM zdemo_sel_opt(  sel_opt1 = @gv_where1,
                      sel_opt2 = @gv_where2 )
                      INTO TABLE @gt_output.

    CATCH cx_sy_open_sql_data_error INTO lx_sy_open_sql_data_error.
  ENDTRY.


  "Comment AMDP code above and active this to check more than 50k record option
*    gt_output = VALUE #( BASE gt_output for i = 1 then i + 1 until i = 60000  (
*         source_system = 'DIMCLNT100'
*         dim_cp = i
*         target_system = 'ZCCEP_PR1'
*         pr1_cp = 60000 - i ) ).

ENDFORM.

*&---------------------------------------------------------------------*
*& Form modify_screen
*&---------------------------------------------------------------------*
FORM modify_screen .

  "Active for Demo
*  LOOP AT SCREEN.
*    IF screen-group1 = 'MOD'.
*      screen-active = 0.
*    ENDIF.
*    MODIFY SCREEN.
*  ENDLOOP.

  IF rb_src = 'X'.
    CLEAR s_kmid2[].
    LOOP AT SCREEN.
      IF screen-group1 = 'TRG'.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.

  ELSEIF rb_trg = 'X'.
    CLEAR s_kmid1[].
    LOOP AT SCREEN.
      IF screen-group1 = 'SRC'.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.

  ENDIF.

  IF rb_cus = 'X'.
    LOOP AT SCREEN.
      IF screen-group1 = 'ABC'.
        pschmid1 = gc_customer_sch.
        pschmid2 = gc_customer_sch.
        schmid1 = TEXT-006.
        schmid2 = TEXT-006.
        screen-input = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.

  ELSEIF rb_cp = 'X'.
    LOOP AT SCREEN.
      IF screen-group1 = 'ABC'.
        pschmid1 = gc_contactp_sch.
        pschmid2 = gc_contactp_sch.
        schmid1 = TEXT-007.
        schmid2 = TEXT-007.
        screen-input = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.

  ELSEIF rb_ven = 'X'.
    LOOP AT SCREEN.
      IF screen-group1 = 'ABC'.
        pschmid1 = gc_vendor_sch.
        pschmid2 = gc_vendor_sch.
        schmid1 = TEXT-008.
        schmid2 = TEXT-008.
        screen-input = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form upload_file
*&---------------------------------------------------------------------*
FORM upload_file .
  gv_file = 'km400k.csv'.

* Open the file in output mode
  OPEN DATASET gv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc NE 0.
    MESSAGE 'Unable to create file' TYPE 'I'.
    EXIT.
  ENDIF.

  CONCATENATE 'Source System'
              'Source Object'
              'Target system'
              'Target Object'
     INTO gv_data
     SEPARATED BY ','.
  TRANSFER gv_data TO gv_file.

  LOOP AT gt_output INTO gw_output.
    CONCATENATE gw_output-source_system
                gw_output-dim_cp
                gw_output-target_system
                gw_output-pr1_cp
     INTO gv_data
     SEPARATED BY ','.
*TRANSFER moves the above fields from workarea to file  with comma
*delimited format
    TRANSFER gv_data TO gv_file.
    CLEAR: gw_output.
  ENDLOOP.
* close the file
  CLOSE DATASET gv_file.
  MESSAGE 'Excess Records Found(More than 50k)! Find your Key mapping file in ./km400k.csv Directory' TYPE 'I'.
*  IF lines( gt_output ) = lines( s_kmid1 ).
*      MESSAGE 'All key mappings found' TYPE 'S'.
*      ELSE.
*        MESSAGE 'Some key mappings missing' TYPE 'W'.
*    ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form cds_view1
*&---------------------------------------------------------------------*
FORM cds_view1.
*  SELECT * FROM z_cds_final( p_scheme_id1 = @pschmid1,
*                             p_sagency_id1 = @psagnid1,
*                             p_scheme_id2 = @pschmid2,
*                             p_sagency_id2 = @psagnid2 )
*    WHERE dim_cp IN @s_kmid1
*    INTO TABLE @gt_output.

    SELECT * FROM z_cds_final( p_scheme_id1 = @pschmid1,
                             p_sagency_id1 = @psagnid1,
                             p_scheme_id2 = @pschmid2,
                             p_sagency_id2 = @psagnid2 )
    WHERE dim_cp IN @s_kmid1
    INTO TABLE @gt_output1.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form cds_view2
*&---------------------------------------------------------------------*
FORM cds_view2.
*  SELECT * FROM z_cds_final( p_scheme_id1 = @pschmid1,
*                             p_sagency_id1 = @psagnid1,
*                             p_scheme_id2 = @pschmid2,
*                             p_sagency_id2 = @psagnid2 )
*    WHERE pr1_cp IN @s_kmid2
*    INTO TABLE @gt_output.

    SELECT * FROM z_cds_final( p_scheme_id1 = @pschmid1,
                             p_sagency_id1 = @psagnid1,
                             p_scheme_id2 = @pschmid2,
                             p_sagency_id2 = @psagnid2 )
    WHERE pr1_cp IN @s_kmid2
    INTO TABLE @gt_output1.

*    SELECT * FROM z_cds_final( p_scheme_id1 = @pschmid1,
*                             p_sagency_id1 = @psagnid1,
*                             p_scheme_id2 = @pschmid2,
*                             p_sagency_id2 = @psagnid2 )
*    INTO TABLE @gt_output1.
*
*    gt_output1 = FILTER #( gt_output1 USING KEY  ).

ENDFORM.

*&---------------------------------------------------------------------*
*& Form amdp_proc
*&---------------------------------------------------------------------*
FORM amdp_proc.
  DATA lx_amdp_error TYPE REF TO cx_amdp_error.
  TRY .
      CALL METHOD zcl_amdp_final=>get_data_amdp
        EXPORTING
          sel_opt1 = gv_where1
          sel_opt2 = gv_where2
        IMPORTING
          et_km    = gt_output.
    CATCH cx_amdp_error INTO lx_amdp_error.
      WRITE : lx_amdp_error->get_text( ).

  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form api
*&---------------------------------------------------------------------*
FORM api.
  RANGES: lr_kmid FOR ukmdb_keybnss0-key_value_id.
  IF s_kmid1 IS NOT INITIAL.
    lr_kmid[] = s_kmid1[].
  ELSE.
    lr_kmid[] = s_kmid2[].
  ENDIF.

  DATA(lv_otc) = COND char4( WHEN rb_cus = 'X' THEN gc_customer_otc
                         WHEN rb_cp  = 'X' THEN gc_contactp_otc
                         WHEN rb_ven = 'X' THEN gc_vendor_otc ).
  IF rb_cp = 'X'.
    LOOP AT lr_kmid.
*     Type code for Contact person ID is 1405
      gs_search_key-object_type_code = lv_otc. "MAKE THIS DYNAMIC
      gs_search_key-identifier_key-business_system_id = psagnid1. "'DIMCLNT100'.
*     Scheme code for Contact Person is 927
      gs_search_key-identifier_key-ident_defining_scheme_code = pschmid1.
*     The Contact Person field -PARNR must be sent after adding preceding zeros.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lr_kmid-low
        IMPORTING
          output = gs_parnr. "Make this dynamic?
      gs_search_key-identifier_key-id_value = gs_parnr.
      APPEND gs_search_key TO gt_search_keys.
      CLEAR : gs_search_key,gs_parnr.
    ENDLOOP.

  ELSEIF rb_cus = 'X'.
    LOOP AT lr_kmid.
*     Type code for Contact person ID is 1405
      gs_search_key-object_type_code = lv_otc. "MAKE THIS DYNAMIC
      gs_search_key-identifier_key-business_system_id = psagnid1. "'DIMCLNT100'.
*     Scheme code for Contact Person is 927
      gs_search_key-identifier_key-ident_defining_scheme_code = pschmid1.
*     The Contact Person field -PARNR must be sent after adding preceding zeros.
*    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*      EXPORTING
*        input  = lr_kmid-low
*      IMPORTING
*        output = gs_kunnr. "Make this dynamic?
      gs_search_key-identifier_key-id_value = lr_kmid-low."gs_kunnr.
      APPEND gs_search_key TO gt_search_keys.
      CLEAR : gs_search_key,gs_kunnr.
    ENDLOOP.

  ELSEIF rb_ven = 'X'.
    LOOP AT lr_kmid.
*     Type code for Contact person ID is 1405
      gs_search_key-object_type_code = lv_otc. "MAKE THIS DYNAMIC
      gs_search_key-identifier_key-business_system_id = psagnid1. "'DIMCLNT100'.
*     Scheme code for Contact Person is 927
      gs_search_key-identifier_key-ident_defining_scheme_code = pschmid1.
*     The Contact Person field -PARNR must be sent after adding preceding zeros.
*    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*      EXPORTING
*        input  = lr_kmid-low
*      IMPORTING
*        output = gs_parnr. "Make this dynamic?
      gs_search_key-identifier_key-id_value = lr_kmid-low."gs_lifnr.
      APPEND gs_search_key TO gt_search_keys.
      CLEAR : gs_search_key,gs_lifnr.
    ENDLOOP.

  ENDIF.
*  LOOP AT lr_kmid.
**     Type code for Contact person ID is 1405
*    gs_search_key-object_type_code = lv_otc. "MAKE THIS DYNAMIC
*    gs_search_key-identifier_key-business_system_id = psagnid1. "'DIMCLNT100'.
**     Scheme code for Contact Person is 927
*    gs_search_key-identifier_key-ident_defining_scheme_code = pschmid1.
**     The Contact Person field -PARNR must be sent after adding preceding zeros.
*    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*      EXPORTING
*        input  = lr_kmid-low
*      IMPORTING
*        output = gs_parnr. "Make this dynamic?
*    gs_search_key-identifier_key-id_value = gs_parnr.
*    APPEND gs_search_key TO gt_search_keys.
*    CLEAR : gs_search_key,gs_parnr.
*  ENDLOOP.

  DATA : lr_matching_api TYPE REF TO if_mdg_id_matching_api_bs.
  DATA : lv_x_error                  TYPE boolean.

  TRY.
      CALL METHOD cl_mdg_id_matching_api_bs=>get_instance
        EXPORTING
          iv_direct_db_insert       = abap_false
          iv_set_lcl_system_by_api  = abap_true
        IMPORTING
          er_if_mdg_id_matching_api = lr_matching_api.
    CATCH cx_mdg_id_matching_bs.
      lv_x_error = abap_true.
    CATCH cx_mdg_no_api_instance.
      lv_x_error = abap_true.
    CATCH cx_mdg_lcl_bus_sys_not_found.
      lv_x_error = abap_true.
  ENDTRY.

  IF gt_search_keys IS NOT INITIAL.
    TRY .
        CALL METHOD lr_matching_api->get_matching
          EXPORTING
            it_search_key       = gt_search_keys           " Multiple Object Keys inlcuding Object Type Code
*           is_search_key       =                              " Object Key inlcuding Object Type Code
            iv_target_system    = psagnid2                   " Key Name of Business System
*           iv_access_ctrl_reg_directly = abap_false                   " 'X' Get KM from ctrl. reg. directly
*           iv_do_not_access_ctrl_reg   = abap_false                   " 'X' Ignore customizing & do not access ctrl. reg.
          IMPORTING
            et_matching_objects = gt_matching_objects             " Identifier Set data of multiple pairs of mapped objects
*           es_matching_objects_easy    =                  " Identifier Set data of mapped objects
          .
      CATCH cx_mdg_missing_input_parameter. " Missing Input parameter in a method
      CATCH cx_mdg_missing_id_data.         " One or more ID data are missing
      CATCH cx_mdg_otc_idm_error.           " ID matching related OTC error
      CATCH cx_mdg_id_matching_bs.          " General ID matching messages
      CATCH cx_mdg_idsc_invalid.            " IDS code does not exist
      CATCH cx_mdg_no_ctrl_reg_defined.     " For OTC no central registry defined in KM
      CATCH cx_mdg_km_invalid_id_value.     " Invalid ID value

    ENDTRY.

  ENDIF.

  IF gt_matching_objects IS NOT INITIAL.

    gt_output = VALUE #( FOR gs_matching_objects IN gt_matching_objects WHERE ( no_matching_objects_found IS INITIAL )
                          FOR gs_map IN gs_matching_objects-matching_objects "where clause for system reference not inital?
                          FOR gs_map_obj IN gs_map-object_identifier
                        ( source_system = gs_matching_objects-search_key-identifier_key-business_system_id
                          dim_cp = gs_matching_objects-search_key-identifier_key-id_value
                          target_system = gs_map-business_system_id
                          pr1_cp = gs_map_obj-id_value
                          )
                       ).

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form psagnid1_f4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- PSAGNID
*&---------------------------------------------------------------------*
FORM psagnid_f4  CHANGING p_psagnid.
  DATA:
    lt_values TYPE STANDARD TABLE OF ukmdb_agcbnss0,
    lt_return TYPE STANDARD TABLE OF ddshretval
    .

  SELECT *                                              "#EC CI_NOWHERE
    FROM ukmdb_agcbnss0
    INTO TABLE lt_values.

  IF sy-subrc NE 0.
    RETURN.
  ENDIF.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'CCT_SAGENCY_ID'    " Name of field in VALUE_TAB
      value_org       = 'S'        " Value return: C: cell by cell, S: structured
    TABLES
      value_tab       = lt_values  " Table of values: entries cell by cell
      return_tab      = lt_return  " Return the selected value
    EXCEPTIONS
      parameter_error = 1          " Incorrect parameter
      no_values_found = 2          " No values found
      OTHERS          = 3.

  IF sy-subrc NE 0.
    RETURN.
  ENDIF.

  READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
  p_psagnid = ls_return-fieldval.

ENDFORM.
