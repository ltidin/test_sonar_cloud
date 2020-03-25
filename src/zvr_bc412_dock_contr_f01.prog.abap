*&---------------------------------------------------------------------*
*& Include          ZVR_BC412_PICT_CONT_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form popup_to_confirm
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM popup_to_confirm .
  CLEAR gv_answer.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
*     TITLEBAR      = ' '
*     DIAGNOSE_OBJECT             = ' '
      text_question = 'Do you want to exit?'
      text_button_1 = 'Yes'(001)
*     ICON_BUTTON_1 =
      text_button_2 = 'No'(002)
*     ICON_BUTTON_2 = ' '
*     DEFAULT_BUTTON              = '1'
*     DISPLAY_CANCEL_BUTTON       = 'X'
*     USERDEFINED_F1_HELP         = ' '
*     START_COLUMN  = 25
*     START_ROW     = 6
*     POPUP_TYPE    =
*     IV_QUICKINFO_BUTTON_1       = ' '
*     IV_QUICKINFO_BUTTON_2       = ' '
    IMPORTING
      answer        = gv_answer
*   TABLES
*     PARAMETER     =
*   EXCEPTIONS
*     TEXT_NOT_FOUND              = 1
*     OTHERS        = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form FREE_CONTAINERS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM free_containers .

  go_picture->free( ).
  go_container->free( ).
  FREE: go_picture, go_container.

ENDFORM.
