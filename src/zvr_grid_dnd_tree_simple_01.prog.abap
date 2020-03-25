***INCLUDE BCALV_EVENT_REC_DRAGDROP.
CLASS CL_EVENT_RECEIVER DEFINITION.

  PUBLIC SECTION.
    DATA: UCOMM TYPE SY-UCOMM.
    DATA: SELFIELD TYPE SLIS_SELFIELD.
*   toolbar
    METHODS HANDLE_TOOLBAR_SET
      FOR EVENT TOOLBAR OF CL_GUI_ALV_GRID
      IMPORTING E_OBJECT E_INTERACTIVE.
*   user command
    METHODS HANDLE_USER_COMMAND
      FOR EVENT USER_COMMAND OF CL_GUI_ALV_GRID
      IMPORTING E_UCOMM.
*   double click
    METHODS HANDLE_DOUBLE_CLICK
      FOR EVENT DOUBLE_CLICK OF CL_GUI_ALV_GRID
      IMPORTING E_ROW E_COLUMN.
*   context menue
    METHODS HANDLE_CONTEXT_MENU
      FOR EVENT CONTEXT_MENU_REQUEST OF CL_GUI_ALV_GRID
      IMPORTING E_OBJECT.
    METHODS HANDLE_ONDROP
      FOR EVENT ONDROP OF CL_GUI_ALV_GRID
      IMPORTING E_ROW
                E_COLUMN
                E_DRAGDROPOBJ.
  PRIVATE SECTION.
ENDCLASS.
*---------------------------------------------------------------------*
*       CLASS CL_EVENT_RECEIVER IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS CL_EVENT_RECEIVER IMPLEMENTATION.
*     handle user_command
  METHOD HANDLE_USER_COMMAND.
    CASE E_UCOMM.
      WHEN FCODE_DISP.
        PERFORM DISPLAY_DETAIL.
      WHEN FCODE_PLANE.
        PERFORM DISPLAY_SAPLANE.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.
* handle double_click
  METHOD HANDLE_DOUBLE_CLICK.
    PERFORM DISPLAY_SAPLANE.
  ENDMETHOD.
* handle toolbar
  METHOD HANDLE_TOOLBAR_SET.
*   create own Menubuttons and ToolbarButtons
*   append a separator to normal toolbar
    CLEAR GS_TOOLBAR.
    MOVE 3 TO GS_TOOLBAR-BUTN_TYPE.
    APPEND GS_TOOLBAR TO E_OBJECT->MT_TOOLBAR.
*   append detail button
    CLEAR GS_TOOLBAR.
    MOVE FCODE_DISP TO GS_TOOLBAR-FUNCTION.
    MOVE ICON_DETAIL TO GS_TOOLBAR-ICON.
    MOVE TEXT-005 TO GS_TOOLBAR-QUICKINFO.
    MOVE ' ' TO GS_TOOLBAR-DISABLED.
    APPEND GS_TOOLBAR TO E_OBJECT->MT_TOOLBAR.
*   append a separator to normal toolbar
    CLEAR GS_TOOLBAR.
    MOVE 3 TO GS_TOOLBAR-BUTN_TYPE.
    APPEND GS_TOOLBAR TO E_OBJECT->MT_TOOLBAR.
*   append new button
    CLEAR GS_TOOLBAR.
    MOVE FCODE_PLANE TO GS_TOOLBAR-FUNCTION.
    MOVE ICON_WS_PLANE TO GS_TOOLBAR-ICON.
    MOVE TEXT-002 TO GS_TOOLBAR-QUICKINFO.
    MOVE ' ' TO GS_TOOLBAR-DISABLED.
    APPEND GS_TOOLBAR TO E_OBJECT->MT_TOOLBAR.
  ENDMETHOD.
* context menue
  METHOD HANDLE_CONTEXT_MENU.
    CALL METHOD E_OBJECT->ADD_FUNCTION
       EXPORTING
         FCODE = FCODE_DISP
         TEXT  = TEXT-005.
    CALL METHOD E_OBJECT->ADD_FUNCTION
       EXPORTING
         FCODE = FCODE_PLANE
         TEXT  = TEXT-002.
  ENDMETHOD.
* Drag & Drop
  METHOD HANDLE_ONDROP.
*
  ENDMETHOD.
ENDCLASS.
*
DATA: EVENT_RECEIVER TYPE REF TO CL_EVENT_RECEIVER.
