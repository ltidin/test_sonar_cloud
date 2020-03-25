*&---------------------------------------------------------------------*
*& Include          ZVR_BC412_PICT_CONT_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  DATA: lv_copy_ok_code TYPE sy-ucomm.
  lv_copy_ok_code = ok_code.
  CLEAR ok_code.

  CASE lv_copy_ok_code.
    WHEN 'STRETCH'.
      go_picture->set_display_mode(
        EXPORTING
          display_mode = cl_gui_picture=>display_mode_stretch                 " Display Mode
        EXCEPTIONS
          error        = 1                " Errors
          OTHERS       = 2
      ).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    WHEN 'NORMAL'.
      go_picture->set_display_mode(
  EXPORTING
    display_mode = cl_gui_picture=>display_mode_normal                 " Display Mode
  EXCEPTIONS
    error        = 1                " Errors
    OTHERS       = 2
).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    WHEN 'NORMAL_CENTER'.
      go_picture->set_display_mode(
  EXPORTING
    display_mode = cl_gui_picture=>display_mode_normal_center                 " Display Mode
  EXCEPTIONS
    error        = 1                " Errors
    OTHERS       = 2
).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    WHEN 'FIT'.
      go_picture->set_display_mode(
  EXPORTING
    display_mode = cl_gui_picture=>display_mode_fit                 " Display Mode
  EXCEPTIONS
    error        = 1                " Errors
    OTHERS       = 2
).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    WHEN 'FIT_CENTER'.
      go_picture->set_display_mode(
EXPORTING
display_mode = cl_gui_picture=>display_mode_fit_center                " Display Mode
EXCEPTIONS
error        = 1                " Errors
OTHERS       = 2
).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    WHEN 'MODE_INFO'.
      DATA: lv_text TYPE string.
      lv_text = go_picture->display_mode.
      CONCATENATE lv_text 'display mode.' INTO lv_text SEPARATED BY space.
      MESSAGE lv_text TYPE 'I'.


    WHEN 'BACK'.
      PERFORM popup_to_confirm.
      IF gv_answer = 1.
        PERFORM free_containers.
        LEAVE TO SCREEN 0.
      ENDIF.
    WHEN 'EXIT'.
      PERFORM popup_to_confirm.
      IF gv_answer = 1.
        PERFORM free_containers.
        LEAVE PROGRAM.
      ENDIF.
  ENDCASE.

ENDMODULE.
