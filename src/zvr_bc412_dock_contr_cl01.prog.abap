*&---------------------------------------------------------------------*
*& Include          ZVR_BC412_PICT_CONT_CL01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lclc_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_click FOR EVENT picture_click OF cl_gui_picture
        IMPORTING mouse_pos_x mouse_pos_y,
          on_double_click for EVENT CONTROL_DBLCLICK of cl_gui_picture
          IMPORTING mouse_pos_x mouse_pos_y.

ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_click.
    MESSAGE s000(zvr_bc412)  WITH mouse_pos_x mouse_pos_y.
  ENDMETHOD.

    METHOD on_double_click.
    MESSAGE s001(zvr_bc412)  WITH mouse_pos_x mouse_pos_y.
  ENDMETHOD.

ENDCLASS.
