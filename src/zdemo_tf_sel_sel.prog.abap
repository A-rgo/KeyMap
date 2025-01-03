*&---------------------------------------------------------------------*
*& Include          ZDEMO_TF_SEL_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK c1 WITH FRAME TITLE TEXT-005.
  PARAMETERS: rb_cds RADIOBUTTON GROUP r3 MODIF ID mod DEFAULT 'X',
              rb_atf RADIOBUTTON GROUP r3 MODIF ID mod,
              rb_amd RADIOBUTTON GROUP r3 MODIF ID mod,
              rb_api RADIOBUTTON GROUP r3 MODIF ID mod.

SELECTION-SCREEN END OF BLOCK c1.

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-003.
  PARAMETERS: rb_cus RADIOBUTTON GROUP r1 USER-COMMAND xyz DEFAULT 'X',
              rb_cp  RADIOBUTTON GROUP r1,
              rb_ven RADIOBUTTON GROUP r1.

SELECTION-SCREEN END OF BLOCK a1.

SELECTION-SCREEN BEGIN OF BLOCK a2 WITH FRAME TITLE TEXT-004.
  PARAMETERS: rb_src RADIOBUTTON GROUP r2 USER-COMMAND zyx DEFAULT 'X',
              rb_trg RADIOBUTTON GROUP r2.

SELECTION-SCREEN END OF BLOCK a2.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT (31) schmid1.
    PARAMETERS:
      pschmid1 TYPE zcct_schm_id MODIF ID abc.
  SELECTION-SCREEN END OF LINE.
  PARAMETERS:
    psagnid1 TYPE zcct_schmagn_id DEFAULT 'DIMCLNT100' OBLIGATORY.
  SELECT-OPTIONS:
    s_kmid1  FOR gv_kmid MODIF ID src.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT (31) schmid2.
    PARAMETERS:
      pschmid2 TYPE zcct_schm_id MODIF ID abc.
  SELECTION-SCREEN END OF LINE.
  PARAMETERS:
    psagnid2 TYPE zcct_schmagn_id DEFAULT 'ZCCEP_PR1' OBLIGATORY.
  SELECT-OPTIONS:
    s_kmid2  FOR  gv_kmid MODIF ID trg.
SELECTION-SCREEN: END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT (50) lv_note1.
    SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT (83) lv_note2.
  SELECTION-SCREEN END OF LINE.
