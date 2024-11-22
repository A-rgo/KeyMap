*&---------------------------------------------------------------------*
*& Report ZUPLOAD_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zupload_test.
*----------------------------------------------------------------------*
*     Data Decalaration
*----------------------------------------------------------------------*
*DATA: gt_spfli  TYPE TABLE OF spfli,
*      gwa_spfli TYPE spfli.
*DATA: gv_file   TYPE rlgrap-filename.
*
**----------------------------------------------------------------------*
**     START-OF-SELECTION
**----------------------------------------------------------------------*
*PERFORM get_data.
*IF NOT gt_spfli[] IS INITIAL.
*  PERFORM save_file.
*ELSE.
*  MESSAGE 'No data found' TYPE 'I'.
*ENDIF.
**&---------------------------------------------------------------------*
**&      Form  get_data
**&---------------------------------------------------------------------*
*FORM get_data.
**Get data from table SPFLI
*  SELECT * FROM spfli
*         INTO TABLE gt_spfli.
*ENDFORM.                    " get_data
**&---------------------------------------------------------------------*
**&      Form  save_file
**&---------------------------------------------------------------------*
*FORM save_file.
*  DATA: lv_data TYPE string.
*
**Move complete path to filename
*  gv_file = 'spfli.txt'.
*
** Open the file in output mode
*  OPEN DATASET gv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
*  IF sy-subrc NE 0.
*    MESSAGE 'Unable to create file' TYPE 'I'.
*    EXIT.
*  ENDIF.
*
*  CONCATENATE 'carrid'
*              'connid'
*              'countryfr'
*              'cityfrom'
*              'airpfrom'
*              'countryto'
*              'cityto'
*              'airpto'
*              'arrtime'
*     INTO lv_data
*     SEPARATED BY ','.
*  TRANSFER lv_data to gv_file.
*
*  LOOP AT gt_spfli INTO gwa_spfli.
*    CONCATENATE gwa_spfli-carrid
*                gwa_spfli-connid
*                gwa_spfli-countryfr
*                gwa_spfli-cityfrom
*                gwa_spfli-airpfrom
*                gwa_spfli-countryto
*                gwa_spfli-cityto
*                gwa_spfli-airpto
*                gwa_spfli-arrtime
*     INTO lv_data
*     SEPARATED BY ','.
**TRANSFER moves the above fields from workarea to file  with comma
**delimited format
*    TRANSFER lv_data TO gv_file.
*    CLEAR: gwa_spfli.
*  ENDLOOP.
** close the file
*  CLOSE DATASET gv_file.
*
*ENDFORM.                    " save_file

TYPES: BEGIN OF ty_output,
         source_system TYPE ukm_e_cct_id_sa_id,
         dim_cp        TYPE char32,
         target_system TYPE ukm_e_cct_id_sa_id,
         pr1_cp        TYPE char32,
       END OF ty_output.

DATA gty_output TYPE STANDARD TABLE OF ty_output.

DATA out        TYPE REF TO if_demo_output.

out = cl_demo_output=>new( ).

DATA(gt_output) = VALUE #( BASE gty_output FOR i = 1 THEN i + 1 UNTIL i = 60000  (
        source_system = 'DIMCLNT100'
        dim_cp = i
        target_system = 'ZCCEP_PR1'
        pr1_cp = 60000 - i ) ).

*WRITE : 'hELLO'.

out->display(
EXPORTING
  data    = gt_output ).
