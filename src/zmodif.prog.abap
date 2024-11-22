*&---------------------------------------------------------------------*
*& Report ZMODIF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmodif.
*SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
*  PARAMETERS: rb_del  RADIOBUTTON GROUP r1 USER-COMMAND xyz DEFAULT 'X',
*              p4 AS CHECKBOX MODIF ID bl2,
*              p5 AS CHECKBOX MODIF ID bl2,
*              p6 AS CHECKBOX MODIF ID bl2,
*              p7 AS CHECKBOX MODIF ID bl2,
*              rb_del2 RADIOBUTTON GROUP r1,
*              rb_cor  RADIOBUTTON GROUP r1.
*SELECTION-SCREEN END OF BLOCK b1.
*
*AT SELECTION-SCREEN OUTPUT.
*  LOOP AT SCREEN INTO DATA(screen_wa).
*    IF RB_DEL <> 'X' AND
*       screen_wa-group1 = 'BL2'.
*      screen_wa-active = '0'.
*    ENDIF.
*    MODIFY SCREEN FROM screen_wa.
*  ENDLOOP.

TABLES: scarr.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
  PARAMETERS: rb_del  RADIOBUTTON GROUP r1 USER-COMMAND xyz DEFAULT 'X',
              p4      AS CHECKBOX MODIF ID bl2,
              p5      AS CHECKBOX MODIF ID bl2,
              p6      AS CHECKBOX MODIF ID bl2,
              p7      AS CHECKBOX MODIF ID bl2,
              rb_del2 RADIOBUTTON GROUP r1,
              rb_cor  RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
  PARAMETERS:
  p_date TYPE sy-datum MODIF ID mod OBLIGATORY.
  SELECT-OPTIONS:
  s_guid FOR scarr-carrid NO INTERVALS MODIF ID nod OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b2.

INITIALIZATION.
  IF rb_del IS NOT INITIAL AND p_date IS INITIAL.
    p_date = sy-datum.
  ENDIF.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'NOD' AND rb_del IS NOT INITIAL.
      screen-active = 0.
      MODIFY SCREEN.
      CONTINUE.


    ELSEIF screen-group1 = 'NOD' AND rb_del2 IS NOT INITIAL.
      CLEAR: P4, P5, P6, P7.
       screen-active = 0.
      MODIFY SCREEN.
      CONTINUE.

    ELSEIF screen-group1 = 'MOD' AND rb_cor IS NOT INITIAL.
      CLEAR: P4, P5, P6, P7.
      screen-active = 0.
      MODIFY SCREEN.
      CONTINUE.
    ENDIF.

  ENDLOOP.

START-OF-SELECTION.
  WRITE: p4, p5, p6, p7.
