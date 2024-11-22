class ZCL_MDG_MM_DQM_PROCEDURE_CALL definition
  public
  create public .

public section.

  class-methods CHECK_BUSINESS_SYSTEM
    importing
      !IV_MARA_DATA type MARA_DQ_STR
      !IV_EVAL_CONTEXT type EVAL_CONTEXT_DQ_STR
    exporting
      !EV_RESULT type BOOLEAN .
  class-methods CHECK_MANUF_PART
    importing
      !IV_MARA_DATA type MARA_DQ_STR
      !IV_EVAL_CONTEXT type EVAL_CONTEXT_DQ_STR
    exporting
      !EV_RESULT type BOOLEAN .
  class-methods CHECK_MSTAE_BUS_SYS
    importing
      !IS_MARA_DATA type MARA_DQ_STR
      !IS_EVAL_CONTEXT type EVAL_CONTEXT_DQ_STR
    exporting
      !EV_RESULT type BOOLEAN .
  class-methods CHECK_CLASS_ERSA
    importing
      !IV_MARA_DATA type MARA_DQ_STR
      !IV_EVAL_CONTEXT type EVAL_CONTEXT_DQ_STR
    exporting
      !EV_RESULT type BOOLEAN .
  class-methods CHECK_DESC_LANG
    importing
      !IV_MARA_DATA type MARA_DQ_STR
      !IV_EVAL_CONTEXT type EVAL_CONTEXT_DQ_STR
    exporting
      !EV_RESULT type BOOLEAN .
  class-methods CHECK_MATNR_PREFIX
    importing
      !IS_MARA_DATA type MARA_DQ_STR
      !IS_EVAL_CONTEXT type EVAL_CONTEXT_DQ_STR
    exporting
      !EV_RESULT type BOOLEAN .
  class-methods CHECK_NETWGHT_CHANGE
    importing
      !IS_MARA_DATA type MARA_DQ_STR
      !IS_EVAL_CONTEXT type EVAL_CONTEXT_DQ_STR
    exporting
      !EV_RESULT type BOOLEAN
    raising
      CX_MDG_BS_MAT_GEN .
  class-methods CHECK_EAN_UPC_W
    importing
      !IS_MARA_DATA type MARA_DQ_STR
      !IS_EVAL_CONTEXT type EVAL_CONTEXT_DQ_STR
    exporting
      !EV_RESULT type BOOLEAN .
  class-methods CHECK_EAN_UPC_E
    importing
      !IS_MARA_DATA type MARA_DQ_STR
      !IS_EVAL_CONTEXT type EVAL_CONTEXT_DQ_STR
    exporting
      !EV_RESULT type BOOLEAN .
  class-methods CALL_MM_DQM_VALIDATION_PROC
    importing
      !IV_MODEL type USMD_MODEL default 'MM'
      !IV_BR_METHOD type string"ZMDG_BR_METHOD
      !ID_CREQUEST type USMD_CREQUEST
      !IV_MSGTYP type SYMSGTY optional
      !IV_SHOW_MESG_FROM_PROC_CALL type BOOLEAN optional
    exporting
      !ET_MESSAGE type USMD_T_MESSAGE
    returning
      value(RV_BOOLEAN) type BOOLEAN .
  class-methods CONVERT_MATNR
    importing
      !INPUT type MATNR
    exporting
      value(OUTPUT) type MATNR .
  class-methods GET_MM_CR_TYPE
    importing
      !IV_EVAL_CONTEXT type EVAL_CONTEXT_DQ_STR
    returning
      value(RV_USMD_CREQUEST_TYPE) type USMD_CREQUEST_TYPE .
  class-methods GET_MM_CR_STEP
    returning
      value(RV_USMD_CREQUEST_APPSTEP) type USMD_CREQUEST_APPSTEP .
  class-methods GET_BR_MM_SCOPE
    importing
      !IV_EVAL_CONTEXT type EVAL_CONTEXT_DQ_STR
      !IV_MTART type MTART
      !IV_PRDHH type PRODH_D
    returning
      value(RV_BR_METHOD) type STRING .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA io_model TYPE REF TO if_usmd_model_ext .
ENDCLASS.



CLASS ZCL_MDG_MM_DQM_PROCEDURE_CALL IMPLEMENTATION.


  METHOD call_mm_dqm_validation_proc.

*    DATA:
*      lo_mat_validations TYPE REF TO zcl_mdg_mm_validations,
*      lo_mat_data        TYPE REF TO zcl_mdg_mm_data_process,
*      lo_context         TYPE REF TO if_usmd_app_context,
*      ls_message         TYPE usmd_s_message,
*      lv_cr_type         TYPE usmd_crequest_type,
*      lv_cr_step         TYPE usmd_crequest_appstep,
*      lt_mat_msg         TYPE zmdg_t_mm_messages.
*
*    FIELD-SYMBOLS:
*        <ls_mat_message> TYPE zmdg_s_mm_messages.
*
*    rv_boolean = abap_true.
*
** access context for current CR Type and CR Step
*    lo_context = cl_usmd_app_context=>get_context( ).
*
*    IF lo_context IS BOUND.
*      CALL METHOD lo_context->get_attributes(
*        IMPORTING
*          ev_crequest_type = lv_cr_type
*          ev_crequest_step = lv_cr_step ).
*
*      CHECK lv_cr_type IS NOT INITIAL.
*    ELSE.
*      CLEAR: ls_message.
*      CALL METHOD zcl_mdg_general_functions=>get_message
*        EXPORTING
*          iv_msgty   = usmd1_cs_msgty-error
*          iv_msgno   = '004'
*          iv_symsgid = zcl_mdg_general_functions=>gc_msg_class_br_mat
*        IMPORTING
*          es_message = ls_message.
*      MESSAGE e004(zmdg_mm_br_msg) INTO zcl_mdg_general_functions=>gv_error_message. " where-used functionality
*      APPEND ls_message TO et_message.
*      RETURN.
*    ENDIF.
*
** get instance of material validations
*    CALL METHOD zcl_mdg_mm_validations=>get_instance
*      RECEIVING
*        ro_mat_validations_instance = lo_mat_validations.
*
*    IF lo_mat_validations IS NOT BOUND.
*      CLEAR: ls_message.
*      CALL METHOD zcl_mdg_general_functions=>get_message
*        EXPORTING
*          iv_msgty   = usmd1_cs_msgty-error
*          iv_msgno   = '007'
*          iv_symsgid = zcl_mdg_general_functions=>gc_msg_class_br_mat
*        IMPORTING
*          es_message = ls_message.
*      APPEND ls_message TO et_message.
*      MESSAGE e007(zmdg_mm_br_msg) INTO zcl_mdg_general_functions=>gv_error_message. " where-used functionality
*      RETURN.
*    ENDIF.
*
** get instance of cached material data
*    CALL METHOD zcl_mdg_mm_data_process=>get_instance
*      EXPORTING
*        iv_cr_id                       = id_crequest                   "Added By Rahul Bhayani
*      RECEIVING
*        ro_mm_data_process             = lo_mat_data
*      EXCEPTIONS
*        instance_creation_failed       = 1
*        entity_data_all_read_error     = 2
*        app_context_get_failed         = 3
*        appcontext_attribute_get_error = 4
*        unexpected_error               = 5
*        model_get_failed               = 6
*        OTHERS                         = 7.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE 'X' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.
*
*    IF lo_mat_data IS NOT BOUND.
*      CLEAR: ls_message.
*      CALL METHOD zcl_mdg_general_functions=>get_message
*        EXPORTING
*          iv_msgty   = usmd1_cs_msgty-error
*          iv_msgno   = '008'
*          iv_symsgid = zcl_mdg_general_functions=>gc_msg_class_br_mat
*        IMPORTING
*          es_message = ls_message.
*      APPEND ls_message TO et_message.
*      MESSAGE e008(zmdg_mm_br_msg) INTO zcl_mdg_general_functions=>gv_error_message. " where-used functionality
*      RETURN.
*    ENDIF.
*
*    cl_usmd_model=>get_instance(
*                      EXPORTING
*                        i_usmd_model = iv_model
*                      IMPORTING
*                       eo_instance  = DATA(io_model)
*                       et_message   = et_message ).
*
*    CHECK io_model IS BOUND.
*
*    DATA(io_model_ext) = io_model->get_instance_ext( ).
*
*    CHECK io_model_ext IS BOUND.
*
** process validations for material
*    CALL METHOD lo_mat_validations->process_validations
*      EXPORTING
*        io_mat_data  = lo_mat_data
*        io_model     = io_model_ext
*        iv_cr_type   = lv_cr_type
*        iv_cr_step   = lv_cr_step
*        iv_br_method = iv_br_method
*      IMPORTING
*        et_message   = lt_mat_msg.
*
** Transfer Mat related messages to BAdi message table.
*************************************************************
*    "Code added
*    IF iv_msgtyp IS NOT INITIAL.
*      LOOP AT lt_mat_msg ASSIGNING <ls_mat_message> WHERE msgty = iv_msgtyp.
*        rv_boolean = abap_false.
*        CLEAR ls_message.
*        MOVE-CORRESPONDING <ls_mat_message> to ls_message.
*        APPEND ls_message TO et_message.
*      ENDLOOP.
*    ENDIF.
*
*    "Display message from DQM procedure call directly
*    IF iv_show_mesg_from_proc_call = abap_true.
*      zcl_mdg_zp_access_prdhry=>add_to_global_message(
*        EXPORTING
*          it_message      = CORRESPONDING #( lt_mat_msg )
*      ).
*      rv_boolean = abap_true. "in order to supress message popping from DQM
*    ENDIF.
*************************************************************

  ENDMETHOD.


  METHOD check_business_system.
*    DATA: lo_mat_data TYPE REF TO zcl_mdg_mm_data_process.
*    CASE iv_eval_context-rule_stage.
*      WHEN 'MDF'.
*        IF iv_mara_data-source_id IS NOT INITIAL AND iv_eval_context-changerequest_id IS NOT INITIAL.
*          CALL METHOD zcl_mdg_mm_data_process=>get_instance
*            EXPORTING
**             iv_matnr                       = lv_material
*              iv_cr_id                       = iv_eval_context-changerequest_id
*            RECEIVING
*              ro_mm_data_process             = lo_mat_data
*            EXCEPTIONS
*              instance_creation_failed       = 1
*              entity_data_all_read_error     = 2
*              app_context_get_failed         = 3
*              appcontext_attribute_get_error = 4
*              unexpected_error               = 5
*              model_get_failed               = 6
*              OTHERS                         = 7.
*          IF sy-subrc <> 0.
*            MESSAGE ID sy-msgid TYPE 'X' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*          ENDIF.
*        ELSE.
*          RETURN.
*        ENDIF.
*        IF lo_mat_data IS BOUND.
** Get Business Systems
*          CALL METHOD lo_mat_data->get_zbussys
*            IMPORTING
*              et_zbussys = DATA(lt_zbussys).
*          IF lt_zbussys IS NOT INITIAL.
*            IF line_exists( lt_zbussys[ zsysid = 'P19_077' ] ).
*              ev_result = abap_true.
*            ELSE.
*              ev_result = abap_false.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*    ENDCASE.

  ENDMETHOD.


  METHOD check_class_ersa.
*    DATA: lo_mat_data TYPE REF TO zcl_mdg_mm_data_process.
*    CASE iv_eval_context-rule_stage.
*      WHEN 'MDF' OR 'MDQ'.
*        IF iv_mara_data-source_id IS NOT INITIAL AND iv_eval_context-changerequest_id IS NOT INITIAL.
*          CALL METHOD zcl_mdg_mm_data_process=>get_instance
*            EXPORTING
**             iv_matnr                       = lv_material
*              iv_cr_id                       = iv_eval_context-changerequest_id
*            RECEIVING
*              ro_mm_data_process             = lo_mat_data
*            EXCEPTIONS
*              instance_creation_failed       = 1
*              entity_data_all_read_error     = 2
*              app_context_get_failed         = 3
*              appcontext_attribute_get_error = 4
*              unexpected_error               = 5
*              model_get_failed               = 6
*              OTHERS                         = 7.
*          IF sy-subrc <> 0.
*            MESSAGE ID sy-msgid TYPE 'X' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*          ENDIF.
*        ELSE.
*          RETURN.
*        ENDIF.
*        IF lo_mat_data IS BOUND.
** Get Purchasing entity detail
*          CALL METHOD lo_mat_data->get_classasgn
**            exporting
**              it_key_value =                  " Key Value Table
*            IMPORTING
*              et_classasgn = DATA(lt_class)
**             es_classasgn =
*            .
*
*          IF lines( lt_class ) GT 1.
*            ev_result = abap_false.
*          ELSE.
*            ev_result = abap_true.
*          ENDIF.
*        ENDIF.
*    ENDCASE.
  ENDMETHOD.


  METHOD check_desc_lang.
*    DATA: lo_mat_data TYPE REF TO zcl_mdg_mm_data_process.
*    CASE iv_eval_context-rule_stage.
*      WHEN 'MDF' OR 'MDQ' OR 'MASS' OR 'CONS'.
*
*        IF iv_mara_data-source_id IS NOT INITIAL AND iv_eval_context-changerequest_id IS NOT INITIAL.
*          CALL METHOD zcl_mdg_mm_data_process=>get_instance
*            EXPORTING
**             iv_matnr                       = lv_material
*              iv_cr_id                       = iv_eval_context-changerequest_id
*            RECEIVING
*              ro_mm_data_process             = lo_mat_data
*            EXCEPTIONS
*              instance_creation_failed       = 1
*              entity_data_all_read_error     = 2
*              app_context_get_failed         = 3
*              appcontext_attribute_get_error = 4
*              unexpected_error               = 5
*              model_get_failed               = 6
*              OTHERS                         = 7.
*          IF sy-subrc <> 0.
*            MESSAGE ID sy-msgid TYPE 'X' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*          ENDIF.
*        ELSE.
*          RETURN.
*        ENDIF.
*        IF lo_mat_data IS BOUND.
** Get Description entity detail
*          CALL METHOD lo_mat_data->get_mattxt
**            exporting
**              it_key_value =                  " Key Value Table
*            IMPORTING
*              et_mattxt = DATA(lt_mattxt)                 " Table Type for material texts
**             es_mattxt =                  " Source/target Structure for PP Mapping: Material Text
*            .
*
*          IF line_exists( lt_mattxt[ langu = 'E' ] ).
*            ev_result = abap_true.
*          ELSE.
*            ev_result = abap_false.
*          ENDIF.
*        ENDIF.
*    ENDCASE.
  ENDMETHOD.


  method CHECK_EAN_UPC_E.
  endmethod.


  METHOD check_ean_upc_w.
*    DATA: lo_mat_data TYPE REF TO zcl_mdg_mm_data_process.
*    DATA: lv_ean             TYPE string,
*          digits_to_consider TYPE i.
*    CASE is_eval_context-rule_stage.
*      WHEN 'MDF'.
*        IF is_mara_data-source_id IS NOT INITIAL AND is_eval_context-changerequest_id IS NOT INITIAL.
*          CALL METHOD zcl_mdg_mm_data_process=>get_instance
*            EXPORTING
**             iv_matnr                       = lv_material
*              iv_cr_id                       = is_eval_context-changerequest_id
*            RECEIVING
*              ro_mm_data_process             = lo_mat_data
*            EXCEPTIONS
*              instance_creation_failed       = 1
*              entity_data_all_read_error     = 2
*              app_context_get_failed         = 3
*              appcontext_attribute_get_error = 4
*              unexpected_error               = 5
*              model_get_failed               = 6
*              OTHERS                         = 7.
*          IF sy-subrc <> 0.
*            MESSAGE ID sy-msgid TYPE 'X' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*          ENDIF.
*        ELSE.
*          RETURN.
*        ENDIF.
*
*        IF lo_mat_data IS BOUND.
*
*          CALL METHOD io_mat_data->get_material
*            EXPORTING
*              it_key_value = it_key_value    " Key Value Table
*            IMPORTING
*              es_material  = DATA(ls_material).
*
*          CLEAR: digits_to_consider,
*                 lv_ean.
*
*          SELECT SINGLE * FROM tntp INTO @DATA(ls_tntp) WHERE numtp = @ls_material-numtp1.
*          IF sy-subrc = 0.
*            SELECT SINGLE * FROM nriv INTO @DATA(ls_nriv) WHERE object = @ls_tntp-nkobj AND nrrangenr = @ls_tntp-nmkrs.
*            IF sy-subrc = 0.
*              DATA(lv_thrshld) = ls_nriv-tonumber - 500.
*              IF lv_thrshld > 0.
*                digits_to_consider = strlen( ls_material-ean_mara ) - ls_tntp-prfza.
*
*                lv_ean = ls_material-ean_mara(digits_to_consider).
*                SHIFT ls_nriv-tonumber LEFT DELETING LEADING '0'.
*                ls_nriv-tonumber = ls_nriv-tonumber - 11.
*                CONDENSE ls_nriv-tonumber.
*
*                IF lv_ean > lv_thrshld AND lv_ean < ls_nriv-tonumber.
*                  et_message = VALUE #( BASE et_message (  msgid  = zcl_mdg_general_functions=>gc_msg_class_br_mat
*                                                       msgty  = 'W'
*                                                       msgno  = '064'
*                                                       ) ).
*                ENDIF.
*
*                IF lv_ean > ls_nriv-tonumber.
*                  et_message = VALUE #( BASE et_message (  msgid  = zcl_mdg_general_functions=>gc_msg_class_br_mat
*                                                       msgty  = iv_msg_ty
*                                                       msgno  = '065'
*                                                       ) ).
*                ENDIF.
*                "show error mesg
*              ENDIF.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*    ENDCASE.
  ENDMETHOD.


  METHOD check_manuf_part.
*    DATA: lo_mat_data TYPE REF TO zcl_mdg_mm_data_process.
*    CASE iv_eval_context-rule_stage.
*      WHEN 'MDF'.
*        IF iv_mara_data-source_id IS NOT INITIAL AND iv_eval_context-changerequest_id IS NOT INITIAL.
*          CALL METHOD zcl_mdg_mm_data_process=>get_instance
*            EXPORTING
**             iv_matnr                       = lv_material
*              iv_cr_id                       = iv_eval_context-changerequest_id
*            RECEIVING
*              ro_mm_data_process             = lo_mat_data
*            EXCEPTIONS
*              instance_creation_failed       = 1
*              entity_data_all_read_error     = 2
*              app_context_get_failed         = 3
*              appcontext_attribute_get_error = 4
*              unexpected_error               = 5
*              model_get_failed               = 6
*              OTHERS                         = 7.
*          IF sy-subrc <> 0.
*            MESSAGE ID sy-msgid TYPE 'X' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*          ENDIF.
*        ELSE.
*          RETURN.
*        ENDIF.
*        IF lo_mat_data IS BOUND.
** Get Purchasing entity detail
*          CALL METHOD lo_mat_data->get_marapurch
**            exporting
**              it_key_value =                  " Key Value Table
*            IMPORTING
**             et_marapurch =
*              es_marapurch = DATA(ls_purch).
*
*          DATA(lv_material) = iv_mara_data-source_id.
*
*          IF ls_purch-mfrpn IS NOT INITIAL AND lv_material IS NOT INITIAL.
*            SHIFT lv_material LEFT DELETING LEADING '0'.
*            SHIFT ls_purch-mfrpn LEFT DELETING LEADING '0'.
*            IF lv_material EQ ls_purch-mfrpn .
*              ev_result = abap_false.
*            ELSE.
*              ev_result = abap_true.
*            ENDIF.
*          ELSE.
*            ev_result = abap_true.
*          ENDIF.
*        ENDIF.
*    ENDCASE.
  ENDMETHOD.


  METHOD check_matnr_prefix.
*    DATA: lv_matnr TYPE mdc_source_id.
*    CASE is_eval_context-rule_stage.
*      WHEN 'MDF' OR 'MASS'.
*        IF is_mara_data-source_id IS NOT INITIAL AND is_eval_context-changerequest_id IS NOT INITIAL.
*          lv_matnr = is_mara_data-source_id.
*          SHIFT lv_matnr LEFT DELETING LEADING '0'.
*
*          SELECT SINGLE prefix FROM  zmdg_c_mm_prefix INTO @DATA(lv_prefix)
*                               WHERE mtart  = @is_mara_data-mtart
*                               AND   prefix = @lv_matnr+0(2).
*          IF sy-subrc IS INITIAL.
*            ev_result = abap_true.
*          ELSE.
*            ev_result = abap_false.
*          ENDIF.
*        ENDIF.
*    ENDCASE.

  ENDMETHOD.


  METHOD check_mstae_bus_sys.
*    DATA: lo_mat_data TYPE REF TO zcl_mdg_mm_data_process.
*    CASE is_eval_context-rule_stage.
*      WHEN 'MDF'.
*        IF is_mara_data-source_id IS NOT INITIAL AND is_eval_context-changerequest_id IS NOT INITIAL.
*          CALL METHOD zcl_mdg_mm_data_process=>get_instance
*            EXPORTING
**             iv_matnr                       = lv_material
*              iv_cr_id                       = is_eval_context-changerequest_id
*            RECEIVING
*              ro_mm_data_process             = lo_mat_data
*            EXCEPTIONS
*              instance_creation_failed       = 1
*              entity_data_all_read_error     = 2
*              app_context_get_failed         = 3
*              appcontext_attribute_get_error = 4
*              unexpected_error               = 5
*              model_get_failed               = 6
*              OTHERS                         = 7.
*          IF sy-subrc <> 0.
*            MESSAGE ID sy-msgid TYPE 'X' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*          ENDIF.
*        ELSE.
*          RETURN.
*        ENDIF.
*        IF lo_mat_data IS BOUND.
** Get Business Systems
*          CALL METHOD lo_mat_data->get_zbussys
*            IMPORTING
*              et_zbussys = DATA(lt_zbussys).
*          IF is_mara_data-mstae EQ zcl_mdg_mm_data=>gc_status_90.
*            READ TABLE lt_zbussys TRANSPORTING NO FIELDS WITH KEY zzdeact = abap_false. "#EC CI_SORTSEQ
*            IF sy-subrc IS NOT INITIAL.
*              ev_result = abap_true.
*            ELSE.
*              ev_result = abap_false.
*            ENDIF.
*          ENDIF.
*          IF is_mara_data-mstae NE zcl_mdg_mm_data=>gc_status_90.
*            READ TABLE lt_zbussys TRANSPORTING NO FIELDS WITH KEY zzdeact = abap_false. "#EC CI_SORTSEQ
*            IF sy-subrc IS INITIAL.
*              ev_result = abap_true.
*            ELSE.
*              ev_result = abap_false.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*    ENDCASE.

  ENDMETHOD.


  METHOD check_netwght_change.
*    DATA: lo_mat_data TYPE REF TO zcl_mdg_mm_data_process.
*    DATA: lt_sel   TYPE usmd_ts_sel,
*          lv_matnr TYPE matnr,
*          lt_data  TYPE usmd_ts_data_entity,
*          ls_data  TYPE usmd_sx_data_entity,
*          ls_sel   TYPE usmd_s_sel.
*    DATA:lv_attribute TYPE usmd_attribute.
*    DATA:lv_txt TYPE scrtext_l.
*    FIELD-SYMBOLS:<lt_mat_data> TYPE INDEX  TABLE,
*                  <lv_weight>   TYPE any,
*                  <ls_data>     TYPE any.
*    CASE is_eval_context-rule_stage.
*      WHEN 'MDF'.
*        IF is_mara_data-source_id IS NOT INITIAL AND is_eval_context-changerequest_id IS NOT INITIAL.
*          CALL METHOD zcl_mdg_mm_data_process=>get_instance
*            EXPORTING
**             iv_matnr                       = lv_material
*              iv_cr_id                       = is_eval_context-changerequest_id
*            RECEIVING
*              ro_mm_data_process             = lo_mat_data
*            EXCEPTIONS
*              instance_creation_failed       = 1
*              entity_data_all_read_error     = 2
*              app_context_get_failed         = 3
*              appcontext_attribute_get_error = 4
*              unexpected_error               = 5
*              model_get_failed               = 6
*              OTHERS                         = 7.
*          IF sy-subrc <> 0.
*            MESSAGE ID sy-msgid TYPE 'X' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*          ENDIF.
*        ELSE.
*          RETURN.
*        ENDIF.
*        IF lo_mat_data IS BOUND.
*          CALL METHOD lo_mat_data->get_material
**            EXPORTING
**              it_key_value = it_key_value    " Key Value Table
*            IMPORTING
*              es_material = DATA(ls_material).
*
*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*            EXPORTING
*              input  = ls_material-material
*            IMPORTING
*              output = lv_matnr.
*
*          lv_attribute = lo_mat_data->gc_attr_ntgew .
*
*          ls_sel-fieldname = if_mdg_bs_mat_gen_c=>gc_fieldname_material.
*          ls_sel-sign      = usmd0_cs_ra-sign_i.
*          ls_sel-option    = usmd0_cs_ra-option_eq.
*          ls_sel-low       = ls_material-material.
*          INSERT ls_sel INTO TABLE lt_sel.
*
****************************************************************************
*
*          io_model = cl_mdg_bs_mat_model=>get_model_instance( ).
*
*          IF io_model IS NOT BOUND.
*            RAISE EXCEPTION TYPE cx_mdg_bs_mat_gen.
*          ENDIF.
*
****************************************************************************
*
*          CALL METHOD io_model->read_entity_data_all
*            EXPORTING
*              i_fieldname    = if_mdg_bs_mat_gen_c=>gc_fieldname_material
*              if_active      = abap_true
*              it_sel         = lt_sel
*            IMPORTING
*              et_data_entity = lt_data.
*
*          READ TABLE lt_data INTO ls_data WITH KEY usmd_entity      = if_mdg_bs_mat_gen_c=>gc_fieldname_material
*                                                   usmd_entity_cont = space
*                                                   struct           = if_usmd_model_ext=>gc_struct_key_attr.
*
*          ASSIGN ls_data-r_t_data->* TO <lt_mat_data>.
*
*          LOOP AT <lt_mat_data> ASSIGNING <ls_data>.
*            ASSIGN COMPONENT lo_mat_data->gc_attr_ntgew OF STRUCTURE <ls_data> TO <lv_weight>.
*
*            IF <lv_weight> NE ls_material-ntgew.
*              ev_result = abap_false.
*            ELSE.
*              ev_result = abap_true.
*            ENDIF.
*          ENDLOOP.
*        ENDIF.
*    ENDCASE.
  ENDMETHOD.


  method CONVERT_MATNR.
*    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
*      EXPORTING
*        input              = input
*     IMPORTING
*       OUTPUT             = output
*     EXCEPTIONS
*       LENGTH_ERROR       = 1
*       OTHERS             = 2.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.

  endmethod.


  method get_br_mm_scope.

*    data(lv_cr_type) = get_mm_cr_type( iv_eval_context = iv_eval_context ).
*    data(lv_cr_step) = get_mm_cr_step( ).
*
*    select 'I' as sign, 'EQ' as option, method_name as low, ' ' as high
*            from zmdg_c_mm_rules
*           where ( cr_type = @lv_cr_type     or cr_type = @zcl_mdg_general_functions=>gc_wildcard_usd )
*             and ( cr_step = @lv_cr_step     or cr_step = @zcl_mdg_general_functions=>gc_wildcard_usd )
*             and ( mtart   = @iv_mtart       or mtart   = @zcl_mdg_general_functions=>gc_wildcard_usd )
*             and ( prdhh   = @iv_prdhh       or prdhh   = @zcl_mdg_general_functions=>gc_wildcard_usd )
*             and  br_type    = 'V'
*      into table @data(lt_br_method_names).
*
*    loop at lt_br_method_names into data(ls_br_method).
*      rv_br_method = rv_br_method && ` ` && ls_br_method-low.
*    endloop.


  endmethod.


method GET_MM_CR_STEP.
*****************************************************************************************
* Program Change History
*****************************************************************************************
* MOD-XXX       :
* Date          : 06-01-2022
* Change No     : 8200004936
* WRICEF-ID     :
* Defect-ID     :
* Transport     : DDMK902368
* Developer ID  : ( EXT_BHAYANIR ) Rahul Bhayani
* Release ID    : 01
* Developed For Custom Data Model : ZP - Product Hierarchy
**************************************************************************************

    rv_usmd_crequest_appstep = cond #( when cl_usmd_app_context=>get_context( ) is bound then cl_usmd_app_context=>get_context( )->mv_crequest_step  ).

**#FallBack API
*    if rv_usmd_crequest_appstep is initial.
*      data(lo_wf_service) = cl_usmd_wf_service=>get_instance( ).
*      if lo_wf_service is bound.
*        lo_wf_service->get_crequest_step( exporting id_crequest = get_cr_number( ) importing ed_step = rv_usmd_crequest_appstep ).
*      endif.
*    endif.

endmethod.


  method GET_MM_CR_TYPE.
    rv_usmd_crequest_type = cond #( when cl_usmd_app_context=>get_context( ) is bound then cl_usmd_app_context=>get_context( )->mv_crequest_type  ).

** #FallBack API Code
*    if rv_usmd_crequest_type is initial.
*      rv_usmd_crequest_type = read_crequest( iv_crequest = cond #( when iv_crequest is not initial then iv_crequest else get_cr_number( ) ) )-usmd_creq_type.
**    ls_process = cl_usmd2_cust_access_service=>get_process_by_crequest_type( iv_crequest_type = lv_crequest_type ).
*    endif.
*
** #Fallback API Code
*    if rv_usmd_crequest_type is initial.
*      call method cl_usmd_crequest_util=>get_cr_type_by_cr
*        exporting
*          i_crequest = cond #( when iv_crequest is not initial then iv_crequest else get_cr_number( ) )
*          io_model   = get_cr_usmd_model( )
*        receiving
*          e_cr_type  = rv_usmd_crequest_type.
*    endif.
*
** #FallBack API Code
*    if rv_usmd_crequest_type is initial.
*      data(lo_cr_api) = get_cr_api( iv_crequest = cond #( when iv_crequest is not initial then iv_crequest else get_cr_number( ) ) ).
*      if lo_cr_api is bound.
*        lo_cr_api->read_crequest( importing es_crequest = data(ls_crequest) ).
*        rv_usmd_crequest_type = ls_crequest-usmd_creq_type.
*      endif.
*    endif.
*
*
** #FallBack API Code
*    if rv_usmd_crequest_type is initial.
*      data(lo_gov) = get_gov_api( iv_crequest = cond #( when iv_crequest is not initial then iv_crequest else get_cr_number( ) ) ).
*      if lo_gov is bound.
*        try.
*            rv_usmd_crequest_type = lo_gov->get_crequest_attributes( iv_crequest_id =  cond #( when iv_crequest is not initial then iv_crequest else get_cr_number( ) ) )-usmd_creq_type.
*          catch cx_usmd_gov_api_core_error. " CX_USMD_CORE_DYNAMIC_CHECK
*          catch cx_usmd_gov_api.            " General Processing Error GOV_API
*        endtry.
*      endif.
*    endif.

*--------------------------------------------------------------------*
*While tesitng using Test Class since APIs are not Active we can check DB
*--------------------------------------------------------------------*
    if rv_usmd_crequest_type is initial.
      select single from usmd120c
                  fields usmd_creq_type
                   where usmd_crequest = @iv_eval_context-changerequest_id
                    into  @rv_usmd_crequest_type
                       .
    endif.

*    if rv_usmd_crequest_type is not initial.
*    gv_crequest_type = rv_usmd_crequest_type.
*    endif.

  endmethod.
ENDCLASS.
