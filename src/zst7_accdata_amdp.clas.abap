CLASS zst7_accdata_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
* Mandatory to define this interface for AMDP
    INTERFACES if_amdp_marker_hdb.

* Define as table types
    TYPES: tt_acchdr TYPE STANDARD TABLE OF zst7acchdr_dftum,
           tt_accitm TYPE STANDARD TABLE OF zst7accitm_dftum.

* Define this class method on your own
    CLASS-METHODS get_accounting_data
      IMPORTING
        VALUE(iv_bukrs)  TYPE zst7_bukrs
        VALUE(iv_belnr)  TYPE zst7_belnr
        VALUE(iv_gjahr)  TYPE zst7_gjahr
      EXPORTING
        VALUE(ev_acchdr) TYPE tt_acchdr
        VALUE(ev_accitm) TYPE tt_accitm.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zst7_accdata_amdp IMPLEMENTATION.

  METHOD get_accounting_data BY DATABASE PROCEDURE
                             FOR HDB LANGUAGE SQLSCRIPT
                             OPTIONS READ-ONLY
                             USING zst7acchdr_dftum
                                   zst7accitm_dftum.
* Define this class implementation on your own
* By using the parameters like BY DATABSE PROCEDURE, FOR HDB LANGUAGE SCRIPT
* etc we are making this method as a AMDP method

    ev_acchdr = SELECT *
                  FROM ZST7ACCHDR_DFTUM
                  WHERE bukrs = :iv_bukrs
                    AND belnr = :iv_belnr
                    AND gjahr = :iv_gjahr;

    ev_accitm = SELECT *
                  FROM zst7accitm_dftum
                  WHERE bukrs = :iv_bukrs
                    AND belnr = :iv_belnr
                    AND gjahr = :iv_gjahr;

  ENDMETHOD.

ENDCLASS.
