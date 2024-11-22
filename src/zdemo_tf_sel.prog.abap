*&---------------------------------------------------------------------*
*& Report zdemo_tf_sel
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_tf_sel.

INCLUDE zdemo_tf_sel_top.
INCLUDE zdemo_tf_sel_sel.
INCLUDE zdemo_tf_sel_f01.

INITIALIZATION.
  lv_note1 = |Key Mappings less than 50k will be displayed here|.
  lv_note2 = |If more than 50k : Find your Key mapping file in ./km400k.csv Directory path|.

AT SELECTION-SCREEN OUTPUT.

  PERFORM modify_screen.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR psagnid1.

  PERFORM psagnid_f4 CHANGING psagnid1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR psagnid2.

  PERFORM psagnid_f4 CHANGING psagnid2.

START-OF-SELECTION.

  CASE 'X'.
    WHEN rb_cds.
      IF s_kmid1[] IS INITIAL.
        PERFORM cds_view2.
      ELSE.
        PERFORM cds_view1.
      ENDIF.
    WHEN rb_atf.
      PERFORM transfer_params_to_string.
      PERFORM amdp_tf_sel.
    WHEN rb_amd.
      PERFORM transfer_params_to_string.
      PERFORM amdp_proc.
    WHEN rb_api.
      PERFORM api.
  ENDCASE.

*  IF gt_output IS INITIAL.
*    MESSAGE 'No Key Mapping available' TYPE 'I'.
*  ELSEIF lines( gt_output ) < 50000.
*    out = cl_demo_output=>new( ).
*    out->display(
* EXPORTING
*   data    = gt_output ).
*  ELSE.
*    PERFORM upload_file.
*  ENDIF.

    IF gt_output1 IS INITIAL.
    MESSAGE 'No Key Mapping available' TYPE 'I'.
  ELSEIF lines( gt_output1 ) < 50000.
    out = cl_demo_output=>new( ).
    out->display(
 EXPORTING
   data    = gt_output1 ).
  ELSE.
    PERFORM upload_file.
  ENDIF.
