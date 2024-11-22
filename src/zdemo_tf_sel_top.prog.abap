*&---------------------------------------------------------------------*
*& Include          ZDEMO_TF_SEL_TOP
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ty_output,
         source_system TYPE ukm_e_cct_id_sa_id,
         dim_cp        TYPE char32,
         target_system TYPE ukm_e_cct_id_sa_id,
         pr1_cp        TYPE char32,
       END OF ty_output.

*temp mod
TYPES: BEGIN OF ty_output1,
         dim_cp        TYPE char32,
         pr1_cp        TYPE char32,
         source_system TYPE ukm_e_cct_id_sa_id,
         target_system TYPE ukm_e_cct_id_sa_id,
       END OF ty_output1.

DATA: gv_kmid   TYPE ukmdb_keybnss0-key_value_id,
      gv_where1 TYPE string,
      gv_where2 TYPE string,
      gv_file   TYPE rlgrap-filename,
      gw_output TYPE ty_output,
      gv_data   TYPE string.

DATA: gt_output  TYPE STANDARD TABLE OF ty_output.
*DATA: gt_output1  TYPE STANDARD TABLE OF ty_output1.
DATA: gt_output1  TYPE STANDARD TABLE OF ty_output1 WITH KEY dim_cp pr1_cp.
*DATA: gt_output1  TYPE TABLE OF ty_output1 WITH UNIQUE SORTED KEY PRIMARY_KEY COMPONENTS dim_cp pr1_cp.

CONSTANTS:
  gc_customer_otc TYPE c LENGTH 3 VALUE '159',
  gc_customer_sch TYPE c LENGTH 3 VALUE '918',
  gc_contactp_otc TYPE c LENGTH 4 VALUE '1405',
  gc_contactp_sch TYPE c LENGTH 3 VALUE '927',
  gc_vendor_otc   TYPE c LENGTH 3 VALUE '266',
  gc_vendor_sch   TYPE c LENGTH 3 VALUE '892'.

DATA:
  gt_search_keys      TYPE  mdg_t_object_key_bs,
  gs_search_key       TYPE  mdg_s_object_key_bs,
  gs_kunnr            TYPE kunnr,
  gs_parnr            TYPE parnr,
  gs_lifnr            TYPE lifnr,
  gt_matching_objects TYPE mdg_t_get_matching_easy_bs.


DATA: lx_shdb_exception TYPE REF TO cx_shdb_exception,
      out               TYPE REF TO if_demo_output.
