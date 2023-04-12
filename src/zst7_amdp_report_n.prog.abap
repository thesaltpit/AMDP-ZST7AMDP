*&---------------------------------------------------------------------*
*& Report zst7_amdp_report_n
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zst7_amdp_report_n.

DATA: lt_acchdr  TYPE STANDARD TABLE OF zst7acchdr_dftum,
      lt_accitm  TYPE STANDARD TABLE OF zst7accitm_dftum,
      lc_accdata TYPE REF TO zst7_accdata_amdp.

CREATE OBJECT lc_accdata.

CALL METHOD lc_accdata->get_accounting_data
  EXPORTING
    iv_bukrs  = '1710'
    iv_belnr  = '1190000014'
    iv_gjahr  = '2023'
  IMPORTING
    ev_acchdr = lt_acchdr
    ev_accitm = lt_accitm.

LOOP AT lt_acchdr INTO DATA(ls_acchdr_t).

ENDLOOP.

CALL METHOD zst7_accdata_amdp=>get_accounting_data
  EXPORTING
    iv_bukrs  = '1710'
    iv_belnr  = '1190000017'
    iv_gjahr  = '2023'
  IMPORTING
    ev_acchdr = lt_acchdr
    ev_accitm = lt_accitm.


LOOP AT lt_acchdr INTO DATA(ls_acchdr).

ENDLOOP.
