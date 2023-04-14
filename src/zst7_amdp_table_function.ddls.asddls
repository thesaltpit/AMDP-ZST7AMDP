@EndUserText.label: 'Table function example for AMDP'
//This definition is a table function with parameters
define table function ZST7_AMDP_TABLE_FUNCTION
returns {
  client : abap.clnt;    // Here client field is mandatory
  datetype : abap.char( 30 );
  dateval : abap.dats;  
  
}
implemented by method zst7_amdp_tabln_fn=>get_date_data;
