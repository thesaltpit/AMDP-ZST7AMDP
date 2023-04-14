CLASS zst7_accdata_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
* Mandatory to define this interface for AMDP
    INTERFACES if_amdp_marker_hdb.

* Structure for BSEG
    TYPES: BEGIN OF lsty_zst7accitm_dftum,
             compcode    TYPE bukrs,
             docnumber   TYPE belnr_d,
             fiscyear    TYPE gjahr,
             linenumber  TYPE buzei,
             posting_key TYPE bschl,
             acc_type    TYPE koart,
             dbcrindc    TYPE shkzg,
             bussarea    TYPE gsber,
             taxcode     TYPE mwskz,
             amount      TYPE dmbtr,
             currkey     TYPE waers,
             taxamt      TYPE mwsts,
             vendor      TYPE lifnr,

           END OF lsty_zst7accitm_dftum.

* Define as table types
    TYPES: tt_acchdr    TYPE STANDARD TABLE OF zst7acchdr_dftum,
           tt_accitm    TYPE STANDARD TABLE OF zst7accitm_dftum,
           tt_lineitems TYPE STANDARD TABLE OF lsty_zst7accitm_dftum.

* Define this class method on your own
    CLASS-METHODS get_accounting_data
      IMPORTING
        VALUE(iv_bukrs)  TYPE zst7_bukrs
        VALUE(iv_belnr)  TYPE zst7_belnr
        VALUE(iv_gjahr)  TYPE zst7_gjahr
      EXPORTING
        VALUE(ev_acchdr) TYPE tt_acchdr
        VALUE(ev_accitm) TYPE tt_accitm.

* Defining the class method for line items
    CLASS-METHODS get_accounting_line_details
      IMPORTING
        VALUE(iiv_bukrs)    TYPE zst7_bukrs
        VALUE(iiv_belnr)    TYPE zst7_belnr
        VALUE(iiv_gjahr)    TYPE zst7_gjahr
      EXPORTING
        VALUE(et_lineitems) TYPE tt_lineitems.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zst7_accdata_amdp IMPLEMENTATION.

  METHOD get_accounting_line_details BY DATABASE PROCEDURE
                                     FOR HDB LANGUAGE SQLSCRIPT
                                     OPTIONS READ-ONLY
                                     USING zst7_accdata_amdp=>get_accounting_data zst7accitm_dftum.

* Calling one AMDP method withing another method
    CALL "ZST7_ACCDATA_AMDP=>GET_ACCOUNTING_DATA"( iv_bukrs => :iiv_bukrs,
                                                   iv_belnr => :iiv_belnr,
                                                   iv_gjahr => :iiv_gjahr,
                                                   ev_acchdr => :et_header,
                                                   ev_accitm => :et_items
                                                 );

    et_lineitems = select a.bukrs as compcode,
                          a.belnr as docnumber,
                          a.gjahr as fiscyear,
                          b.buzei as linenumber,
                          b.bschl as posting_key,
                          b.koart as acc_type,
                          b.shkzg as dbcrindc,
                          b.gsber as bussarea,
                          b.mwskz as taxcode,
                          b.dmbtr as amount,
                          b.waers as currkey,
                          b.mwsts as taxamt,
                          b.lifnr as vendor
                          FROM :et_header as a INNER JOIN zst7accitm_dftum as b
                          on  a.bukrs = b.bukrs
                          AND a.belnr = b.belnr
                          AND a.gjahr = b.gjahr;

  ENDMETHOD.


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
