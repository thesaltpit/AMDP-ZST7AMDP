CLASS zst7_amdp_tabln_fn DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_date_data FOR TABLE FUNCTION zst7_amdp_table_function.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zst7_amdp_tabln_fn IMPLEMENTATION.

  METHOD get_date_data BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
                       OPTIONS READ-ONLY.

    RETURN
    SELECT '100' AS client, 'Today' AS datetype, to_varchar( now (  ), 'YYYYMMDD' ) as dateval FROM PUBLIC.dummy
    union all
    select '100' as client, '30 Days Before' as datetype, to_varchar( add_days( now(  ), -30 ), 'YYYYMMDD' ) as dateval FROM PUBLIC.dummy
    union all
    select '100' as client, '30 Days From Now' as datetype, to_varchar( add_days( now(  ), 30 ), 'YYYYMMDD' ) as dateval FROM PUBLIC.dummy;
  endmethod.

ENDCLASS.
