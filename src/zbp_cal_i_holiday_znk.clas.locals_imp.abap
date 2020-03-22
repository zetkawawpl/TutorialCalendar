CLASS lhc_HolidayRoot  DEFINITION INHERITING
  FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS det_create_and_change_texts
      FOR DETERMINATION HolidayRoot~det_create_and_change_texts
      IMPORTING keys FOR HolidayRoot.

    METHODS create_description
      IMPORTING
        i_holiday_id  TYPE zcal_holiday_id_znk
        i_description TYPE zcal_description_znk.

    METHODS update_description
      IMPORTING
        i_holiday_id  TYPE zcal_holiday_id_znk
        i_description TYPE zcal_description_znk.

ENDCLASS.

CLASS lhc_HolidayRoot IMPLEMENTATION.

  METHOD det_create_and_change_texts.

    READ ENTITIES OF zcal_i_holiday_znk
      ENTITY HolidayRoot
      FROM VALUE #( FOR <root_key> IN keys ( %key = <root_key> ) )
      RESULT DATA(public_holidays_table).


    LOOP AT public_holidays_table INTO DATA(public_holiday).
      READ ENTITIES OF zcal_i_holiday_znk
        ENTITY HolidayRoot BY \_HolidayTxt
        FROM VALUE #( ( %key = public_holiday-%key ) )
        RESULT DATA(description_table).
      IF line_exists( description_table[
                        spras      = sy-langu
                        holiday_id = public_holiday-holiday_id ] ).
        update_description(
          i_holiday_id  = public_holiday-holiday_id
          i_description = public_holiday-HolidayDescription ).

      ELSE.
        create_description(
          i_holiday_id  = public_holiday-holiday_id
          i_description = public_holiday-HolidayDescription ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD create_description.
    DATA:
      description_table TYPE TABLE FOR CREATE zcal_i_holiday_znk\_HolidayTxt,
      description       TYPE STRUCTURE FOR CREATE zcal_i_holiday_znk\_HolidayTxt.

    description-%key    = i_holiday_id.
    description-%target =
      VALUE #(
               ( holiday_id       = i_holiday_id
                 spras            = sy-langu
                 fcal_description = i_description
                 %control = VALUE
                            #( holiday_id       = cl_abap_behv=>flag_changed
                               spras            = cl_abap_behv=>flag_changed
                               fcal_description = cl_abap_behv=>flag_changed
                             )
               )
             ).

    APPEND description TO description_table.

    MODIFY ENTITIES OF zcal_i_holiday_znk IN LOCAL MODE
      ENTITY HolidayRoot CREATE BY \_HolidayTxt FROM description_table.
  ENDMETHOD.

  METHOD update_description.
    DATA:
      description_table TYPE TABLE FOR UPDATE zcal_i_holitxt_znk,
      description       TYPE STRUCTURE FOR UPDATE zcal_i_holitxt_znk.

    description-holiday_id       = i_holiday_id.
    description-spras            = sy-langu.
    description-fcal_description = i_description.

    description-%control-fcal_description = cl_abap_behv=>flag_changed.
    APPEND description TO description_table.

    MODIFY ENTITIES OF zcal_i_holiday_znk IN LOCAL MODE
      ENTITY HolidayText UPDATE FROM description_table.
  ENDMETHOD.

ENDCLASS.
