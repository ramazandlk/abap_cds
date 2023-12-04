FUNCTION zrd_fm_idoc.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_KUNNR) TYPE  KUNNR OPTIONAL
*"  EXPORTING
*"     VALUE(ES_EXPORT) TYPE  ZRD_S_EXPORT
*"----------------------------------------------------------------------
  DATA: lt_edidd TYPE TABLE OF edidd,
        lt_edidc TYPE TABLE OF edidc.

  IF iv_kunnr IS NOT INITIAL.

    SELECT name1,
           ort02,
           stras,
           ort01,
           regio,
           land1
       FROM kna1
      WHERE kunnr = @iv_kunnr
       INTO TABLE @DATA(lt_kunnr).

    es_export = VALUE #( lt_kunnr[ 1 ] OPTIONAL ).


    DATA(ls_edidc) = VALUE edidc( mestyp = 'ZRD_IDOC2'
                                  doctyp = 'ZRD_I_TY'
                                  rcvprn = 'S4HCLNT500'
                                  rcvprt = 'LS' ).
    APPEND INITIAL LINE TO lt_edidd ASSIGNING FIELD-SYMBOL(<fs_edidd>).
    <fs_edidd>-segnam = 'ZRD_IDOC2'.
    <fs_edidd>-sdata  = |{ es_export-name1 WIDTH = 35 ALIGN = LEFT }{ es_export-ort02 WIDTH = 35 ALIGN = LEFT }{ es_export-stras WIDTH = 35 ALIGN = LEFT }{ es_export-ort01 WIDTH = 35 ALIGN = LEFT }|
                           &&  |{ es_export-regio WIDTH = 3 ALIGN = LEFT }{ es_export-land1 WIDTH = 3 ALIGN = LEFT }|.

    CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
      EXPORTING
        master_idoc_control            = ls_edidc
      TABLES
        communication_idoc_control     = lt_edidc
        master_idoc_data               = lt_edidd
      EXCEPTIONS
        error_in_idoc_control          = 1
        error_writing_idoc_status      = 2
        error_in_idoc_data             = 3
        sending_logical_system_unknown = 4
        OTHERS                         = 5.

    IF sy-subrc EQ 0.
      CALL FUNCTION 'DB_COMMIT'.
      CALL FUNCTION 'DEQUEUE_ALL'.
      COMMIT WORK.
    ENDIF.



  ENDIF.

ENDFUNCTION.
